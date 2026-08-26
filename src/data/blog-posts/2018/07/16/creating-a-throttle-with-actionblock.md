---
title: "Creating a Throttle with ActionBlock"
slug: creating-a-throttle-with-actionblock
publishDate: 16 Jul 2018
description: "We have an application that needs to perform a repetitive task on many external services and record then aggregate the results. As the system has grown the..."
tags:
  - { name: "ActionBlock", slug: actionblock }
  - { name: "C#", slug: c }
  - { name: "C# 7", slug: c-7 }
  - { name: "MaxDegreeOfParallelism", slug: maxdegreeofparallelism }
  - { name: "Task Parallel Library", slug: task-parallel-library }
  - { name: "TPL", slug: tpl }
---
We have an application that needs to perform a repetitive task on many external services and record then aggregate the results. As the system has grown the number of external systems has increased which causes some issues as we originally just created a number of tasks and waited on them all completing. This overwhelmed various things as all these tasks were launched near simultaneously. We needed a way to throttle each task, so we used an `ActionBlock`, part of the Task Parallel Library's [System.Threading.Tasks.Dataflow](https://www.nuget.org/packages/System.Threading.Tasks.Dataflow/) package.

## Basic setup

I've created a little application that does some "work" (by sleeping for random periods of a few milliseconds). It looks like this:

```csharp
class Program
{
    private static byte[] work = new byte[100];
    static void Main(string[] args)
    {
        new Random().NextBytes(work);
        for (int i = 0; i < work.Length; i++)
        {
            DoStuff(i);
        }
        Console.WriteLine("All done!");
        Console.ReadLine();
    }

    static void DoStuff(int data)
    {
        int wait = work[data];
        Console.WriteLine($"{data:D3} : Work will take {wait}ms");
        Thread.Sleep(wait);
    }
}
```

Also available on GitHub: https://github.com/colinangusmackay/ActionBlockThrottle/tree/master/src/00.BasicSerialImplementation

This is the very basic application that I'll be parallelising.

## A simple ActionBlock

Here is the same program, but with the work wrapped in an `ActionBlock`. It is a bit more complex, and currently for little extra benefit as we're not done anything to parallelise it yet.

```csharp
class Program
{
    private static byte[] work = new byte[100];
    static async Task Main(string[] args)
    {
        new Random().NextBytes(work);

        // Define the throttle
        var throttle = new ActionBlock<int>(i=>DoStuff(i));
        
        // Create the work set.
        for (int i = 0; i < work.Length; i++)
        {
            throttle.Post(i);
        }

        // indicate that there is no more work 
        throttle.Complete();

        // Wait for the work to complete.
        await throttle.Completion;

        Console.WriteLine("All done!");
        Console.ReadLine();
    }

    static void DoStuff(int data)
    {
        int wait = work[data];
        Console.WriteLine($"{data:D3} : Work will take {wait}ms");
        Thread.Sleep(wait);
    }
}
```

Also available on GitHub: https://github.com/colinangusmackay/ActionBlockThrottle/tree/master/src/01.SimpleActionBlock

This does the same as the first version, by default an `ActionBlock` does not parallelise any of the processing of the work. All the work is still processed sequentially.

## The producer and consumer run in parallel

I said before this is for "little extra benefit". So I should explain what I mean by that. There is now some parallelisation between the producer and the consumer portions. The `for` loop that contains the `throttle.Post(...)` (the producer) is running in parallel with the calls to `DoStuff()` (the consumer). You can see this if you slow down the producer and introduce some `Console.WriteLine(...)` statements to see things in action.
This is some example output from that version of the code.

```
000 : Posting Work Item 0.
000 : Work will take 32ms
001 : Posting Work Item 1.
001 : Work will take 179ms
002 : Posting Work Item 2.
003 : Posting Work Item 3.
004 : Posting Work Item 4.
002 : Work will take 28ms
005 : Posting Work Item 5.
003 : Work will take 9ms
004 : Work will take 100ms
006 : Posting Work Item 6.
007 : Posting Work Item 7.
005 : Work will take 109ms
008 : Posting Work Item 8.
009 : Posting Work Item 9.
```

I slowed the producer by introducing a wait of 50ms between posting items. As you can see in the time it took to post 10 items (it is zero based) it had only processed 6 items, but the producer and consumer are running simultaneously, so it is not waiting until the producer has completed before it starts processing the items.

Available on GitHub: https://github.com/colinangusmackay/ActionBlockThrottle/blob/master/src/02.SimpleActionBlockShowingProducerConsumer

## Setting the Throttle

Finally, we get to the point that we can set some sort of throttle. In our use case we had a lot of work to do, most of which was actually waiting for external systems to respond, but if we threw everything in at once it would be overwhelmed.

Now we can set up some parallelism. The `ActionBlock` can take some options in the form of an `ExecutionDataflowBlockOptions` object. It has many options, but the one we're interested in is `MaxDegreeOfParallelism`. The creation of the action block now looks like this:

```csharp
ActionBlock<int> throttle = new ActionBlock<int>(
    action: i=>DoStuff(i),
    dataflowBlockOptions: new ExecutionDataflowBlockOptions
    {
        MaxDegreeOfParallelism = 3
    });
```

In our example, we're just going to set it to 3 for demonstration purposes, but you'll likely want to experiment to see where you get the best results.

In the example application, I also added a small counter (`tasksInProgress`) to keep a count of the number of active tasks and added it to the `Console.WriteLine(...)` in the `DoStuff(...)` method. The output looks like this:

```
000 : Posting Work Item 0.
000 : [TIP:1] Work will take 34ms
001 : Posting Work Item 1.
001 : [TIP:2] Work will take 216ms
002 : Posting Work Item 2.
002 : [TIP:2] Work will take 177ms
003 : Posting Work Item 3.
003 : [TIP:3] Work will take 183ms
004 : Posting Work Item 4.
005 : Posting Work Item 5.
006 : Posting Work Item 6.
007 : Posting Work Item 7.
008 : Posting Work Item 8.
004 : [TIP:3] Work will take 15ms
009 : Posting Work Item 9.
005 : [TIP:3] Work will take 57ms
006 : [TIP:3] Work will take 85ms
010 : Posting Work Item 10.
... etc...
```

You can see at the start the number of simultaneously running tasks builds up to the `MaxDegreeOfParallelism` value that was set. So long as the producer part is producing work items faster than the consumer can consume them, the tasks in progress (TIP) will stay at or close to the `MaxDegreeOfParallelism`.

Code available on GitHub: https://github.com/colinangusmackay/ActionBlockThrottle/tree/master/src/03.MaxDegreesOfParallelismAsAThrottle
