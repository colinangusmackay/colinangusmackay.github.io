---
title: "Cancelling parallel tasks"
slug: cancelling-parallel-tasks
publishDate: 02 Jun 2011
description: "UPDATE (7-June-2011): The post as it originally appeared had a bug in the code, the catch block in the task caught the wrong exception type. See the Gotcha..."
tags:
  - { name: "AggregateException", slug: aggregateexception }
  - { name: "CancellationToken", slug: cancellationtoken }
  - { name: "CancellationTokenSource", slug: cancellationtokensource }
  - { name: "IsCancellationRequested", slug: iscancellationrequested }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "TaskCanceledException", slug: taskcanceledexception }
  - { name: "ThrowIfCancellationRequested", slug: throwifcancellationrequested }
---
***UPDATE (7-June-2011):** The post as it originally appeared had a bug in the code, the catch block in the task caught the wrong exception type. See the* [*Gotcha*](#2011-06-07-21-49-Gotcha) *section at the end for an explanation on why there are two types of exception for this.*

I think, to date, I’ve mentioned most of the task lifecycle, but I’ve not talked about cancelling tasks yet. So here goes.

You can cancel tasks for what ever reason by passing in a cancellation token to the task. The task must be cooperative insomuch as it must watch the cancellation token to detect if a cancellation has been signalled then it can clean up and exit.

### The basic program

So, the little example program to demonstrate this is this:

```csharp
class Program
{
    static void Main(string[] args)
    {
        const int numTasks = 9;
        Task[] tasks = new Task[numTasks];
        for (int i = 0; i < 10; i++)
            tasks[i] = Task.Factory.StartNew(PerformTask);

        Task.WaitAll(tasks);

        foreach(Task t in tasks)
            Console.WriteLine("Tasks {0} state: {1}", t.Id, t.Status);

        Console.WriteLine("Program End");
        Console.ReadLine();
    }

    static void PerformTask()
    {
        Console.WriteLine("Task {0}: Starting", Task.CurrentId);
        for (int i = 0; i < 3; i++)
        {
            Console.WriteLine("Task {0}: {1}/3 In progress", Task.CurrentId, i+1);
            Thread.Sleep(500); // Simulate doing some work
        }
        Console.WriteLine("Task {0}: Finished", Task.CurrentId);
    }
}
```

So far this doesn't do much. It starts 9 tasks and each runs to completion. Each task’s end state is `RanToCompletion`.

### Setting up the CancellationToken

Now, if we introduce the cancellation token to the task we can cancel the task at some point during its execution. The `Main` method then gets changed to this:

```csharp
static void Main(string[] args)
{
    const int numTasks = 9;

    CancellationTokenSource tokenSource = new CancellationTokenSource();
    CancellationToken token = tokenSource.Token;

    Task[] tasks = new Task[numTasks];
    for (int i = 0; i < numTasks; i++)
        tasks[i] = Task.Factory.StartNew(() => PerformTask(token), token);

    Thread.Sleep(1500);
    Console.WriteLine("Cancelling tasks");
    tokenSource.Cancel();
    Console.WriteLine("Cancellation Signalled");

    Task.WaitAll(tasks);

    foreach(Task t in tasks)
        Console.WriteLine("Tasks {0} state: {1}", t.Id, t.Status);


    Console.WriteLine("Program End");
    Console.ReadLine();
}
```

The `PerformTask` method now takes a `CancellationToken` (but doesn’t yet do anything with it)

If this code is run, the `Task.WaitAll` method call will throw an `AggregateException` with a number of `TaskCanceledException` objects.

<img src="/assets/blog/2011-06-02-cancelling-parallel-tasks-1.webp" style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" data-border="0" width="640" height="492" />

### Handling cancelled tasks

You therefore have to surround your `WaitAll` method with a `try`/`catch` block and look out for `TaskCanceledException` objects and handle them as you need (see also: [handling AggregateException exceptions](/2011/05/17/handling-aggregateexceptions/)). In my example I’m just going to output the fact to the console. The `try`/`catch` block looks like this:

```csharp
try
{
    Task.WaitAll(tasks);
}
catch (AggregateException aex)
{
    aex.Handle(ex =>
    {
        TaskCanceledException tcex = ex as TaskCanceledException;
        if (tcex != null)
        {
            Console.WriteLine("Handling cancellation of task {0}", tcex.Task.Id);
            return true;
        }
        return false;
    });
}
```

The tasks that were in progress at the time the cancel was signalled complete as normal. Cancelling the tasks will not stop any currently running task.

### Responding to a cancellation request: IsCancellationRequested

If the tasks are sufficiently short running allowing them to complete may be perfectly acceptable.

However, if a task is long running or it is safe to cancel them then you can allow your task to cooperate and respond to the token being signalled to cancel.

The `CancellationToken` object has a property you can check called `IsCancellationRequested`. For example:

```csharp
static void PerformTask(CancellationToken token)
{
    Console.WriteLine("Task {0}: Starting", Task.CurrentId);
    for (int i = 0; i < 4; i++)
    {
        if (token.IsCancellationRequested)
        {
            Console.WriteLine("Task {0}: Cancelling", Task.CurrentId);
            return;
        }
        Console.WriteLine("Task {0}: {1}/3 In progress", Task.CurrentId, i+1);
        Thread.Sleep(500); // Simulate doing some work
    }
    Console.WriteLine("Task {0}: Finished", Task.CurrentId);
}
```

If you simply exit from your task, like the above example, then the `Status` of the task will be `RanToCompletion` as if the task completed normally. If you do not need to know whether a task actually completed or was cancelled then this may be completely acceptable.

### Responding to a cancellation request: ThrowIfCancellationRequested

If you need to perform clean up or the calling code needs to know that a task has been cancelled then using the `CancellationToken`’s `ThrowIfCancellationRequested()` method may be a better choice.

If you do need to perform clean up inside your task, ensure that the `OperationCanceledException` is thrown again so that the calling code knows that the task was cancelled.

```csharp
static void PerformTask(CancellationToken token)
{
    try
    {
        Console.WriteLine("Task {0}: Starting", Task.CurrentId);
        for (int i = 0; i < 4; i++)
        {
            token.ThrowIfCancellationRequested();
            Console.WriteLine("Task {0}: {1}/3 In progress", Task.CurrentId, i + 1);
            Thread.Sleep(500); // Simulate doing some work
        }
        Console.WriteLine("Task {0}: Finished", Task.CurrentId);
    }
    catch (OperationCanceledException)
    {
        // Any clean up code goes here.
        Console.WriteLine("Task {0}: Cancelling", Task.CurrentId);
        throw; // To ensure that the calling code knows the task was cancelled.
    }
    catch(Exception)
    {
        // Clean up other stuff
        throw; // If the calling code also needs to know.
    }
}
```

Remember that if you allow other exceptions to escape your task then the task’s status will be Faulted.

### <span id="2011-06-07-21-49-Gotcha"></span> Gotcha!

*This section was added on 7-June-2011.*

One thing to watch out for is that the exception you get inside the task is different from the exception you get inside the `AggregateException` outside the task. Normally, you’d expect that the exception is passed through and becomes one of the `InnerExceptions` in the aggregate exceptions.

It you want to keep the code consistent and only deal with one exception type for cancelled tasks you can simple deal with the `OperationCanceledException` throughout (both inside and outside the tasks) as that is the base class. Outside the task the exception object is actually a `TaskCanceledException`.

The advantage of referencing the more specific `TaskCanceledException` outside the task is that the exception object also contains a reference to the `Task` that was cancelled. Inside the task the exception that `ThrowIfCancellationRequested` throws is an `OperationCanceledException` (which doesn’t contain the `Task` object, however you are inside the task at this point)

The other point to note is that outside the task, the `TaskCanceledException` object in the `AggregateException` object doesn’t contain much of the information you’d expect to find in an `Exception` object (such as a Stack Trace).
