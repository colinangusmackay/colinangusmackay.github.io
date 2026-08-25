---
title: "But why is the iterator operating in multiple-threads"
slug: but-why-is-the-iterator-operating-in-multiple-threads
publishDate: 12 Sep 2016
description: "Background Recently, I had a bit of a problem with NHibernate when I was converting some code into parallel tasks. (If you have no interest in NHibernate, then..."
tags:
  - { name: ".NET", slug: net }
  - { name: "Consumer-Producer Pattern", slug: consumer-producer-pattern }
  - { name: "DataFlow", slug: dataflow }
  - { name: "Parallel.ForEach", slug: parallel-foreach }
  - { name: "Task Parallel Library", slug: task-parallel-library }
  - { name: "Tasks", slug: tasks }
---
### Background

Recently, I had a bit of a problem with NHibernate when I was converting some code into parallel tasks. (If you have no interest in NHibernate, then don't worry - it is just background to the issue I was having when I spotted this gulf between my expectation and reality. NHibernate is incidental to this and I won't mention it much beyond this paragraph.) It turns out that `Parallel.ForEach` runs the iterator in multiple threads, not just the the action it performs on each item received from the iterator. NHibernate, being the source of the data was running inside the iterator and when I attached [NHibernate Profiler](https://www.hibernatingrhinos.com/products/nhprof) to see what it could turn up it very quickly began reporting that the NHibernate session was running in multiple-threads and that NHibernate was not designed to be thread safe.

### The Iterator Patten in .NET

In .NET the iterator pattern is exposed via an `IEnumerator` or [`IEnumerator<T>`](https://msdn.microsoft.com/en-us/library/78dfe2yb(v=vs.110).aspx) and there is some syntactic sugar so that you can create an iterator method using `yield return`. There is also syntactic sugar surrounding the consumption of iterators via `foreach`. This almost completely hides the complexities of `IEnumerator` implementations.

There are some limitations to this. The interface is inherently not thread safe as it does not provide for an atomic operation that retrieves an element and moves the internal pointer on to the next. You have to call `MoveNext()` followed by `Current` if it returned `true`. If the iterator needs thread-safety, it is the responsibility of the caller to provide it.

### But, then this happens...

Knowing this, I would have assumed (always a bad idea, but I'm only human) that `Parallel.ForEach()` operates over the iterator in a single thread, but farms out each loop to different threads, but I was wrong. Try the following code for yourself and see what happens:

```csharp
public class Program
{
    public static void Main(string[] args)
    {
        Parallel.ForEach(
            YieldedNumbers(),
            (n) => { Thread.Sleep(n); });
        Console.WriteLine("Done!");
        Console.ReadLine();
    }

    public static IEnumerable<int> YieldedNumbers()
    {
        Random rnd = new Random();
        int lastKnownThread = Thread.CurrentThread.ManagedThreadId;
        int detectedSwitches = 0;
        for (int i = 0; i < 1000; i++)
        {
            int currentThread = Thread.CurrentThread.ManagedThreadId;
            if (lastKnownThread != currentThread)
            {
                detectedSwitches++;
                Console.WriteLine(
                    $"{detectedSwitches}: Last known thread ({lastKnownThread}) is not the same as the current thread ({currentThread}).");
                lastKnownThread = currentThread;
            }
            yield return rnd.Next(10,150);
        }
    }
}
```

The `Action<int>` passed to the `Parallel.ForEach` simply simulates some work being done (and the times sent to the `Thread.Sleep()` are roughly analogous to the times of the tasks in the original project).

What I've done here also is detect when the thread changes and report that to the console. It happens roughly 15%-18% of the time on the runs I've made on my machine. Now that was surprising (not really, because NHibernate Profiler had already told me - but to have a very clean example of the same was). I can't blame any weirdness in third party libraries. It happens with some very basic .NET code in a console application.

### Possible Solutions

1. My first thought was to dump all the data retrieved from the iterator into a collection of some sort (e.g. an array or list), but the iterator was originally put in place because the volume of data was causing memory pressure. The app ran overnight and will process anything between a few hundred to a few hundred thousand customers and testing found that it significantly slowed down around the 7000 mark because of the size of the data, and fell over completely not far past that. So, the iterator that I created hides the fact that I now page the data, the calling code knows nothing about this paging and didn't have to be modified. So that solution was out of the question, we'd be back to the problem we had a while ago.
2. The data could be processed in batches and each fully retrieved batch be run in parallel one at at time. I did try that but it just made the calling code difficult to read and more complex than it needed to be. The reader has to be able to understand why there are batches, and the person writing the code has to remember that the data may not fit an exact number of batches and will have to process the final batch outside the loop which adds to the cognitive load on the reader/maintainer.

```csharp
public static void Main(string[] args)
{
    int batchSize = 97;
    List batch = new List<int>();
    foreach (int item in YieldedNumbers())
    {
        batch.Add(item);
        if (batch.Count >= batchSize)
            ProcessBatch(batch);
    }
    ProcessBatch(batch);

    Console.WriteLine("Done!");
    Console.ReadLine();
}

private static int batchCount = 0;
private static void ProcessBatch(List<int> batch)
{
    batchCount ++;
    Console.WriteLine($"Processing batch {batchCount} containing {batch.Count} items");
    Parallel.ForEach(batch, (n) => { Thread.Sleep(n); });
    batch.Clear();
}

// The YieldedNumbers() method is unchanged from before.
```

The iterator is always called from a single thread and therefore never complains on this set up.

3. Use the Microsoft [Data Flow](https://www.nuget.org/packages/Microsoft.Tpl.Dataflow/) for the Task Parallel library. Personally, I think this one is best because the pattern is clear and the complex bits can be moved away from the main algorithm. The only part I didn't like was the effort to set up the Producer/Consumer pattern using this library, but it handles all the bits I want to abstract away quite nicely... And that set up can be abstracted out later. Here's the basic algorithm.

```csharp
public static void Main(string[] args)
{
    var producerOptions = new DataflowBlockOptions { BoundedCapacity = 97 };
    var buffer = new BufferBlock<int>(producerOptions);
    var consumerOptions = new ExecutionDataflowBlockOptions
    {
        BoundedCapacity = Environment.ProcessorCount,
        MaxDegreeOfParallelism = Environment.ProcessorCount
    };
    var linkOptions = new DataflowLinkOptions { PropagateCompletion = true };
    var consumer = new ActionBlock<int>( n=> {  Thread.Sleep(n); }, consumerOptions);
    buffer.LinkTo(consumer, linkOptions);
    Produce(buffer);
    Task.WaitAll(consumer.Completion);

    Console.WriteLine("Done!");
    Console.ReadLine();
}

private static void Produce(ITargetBlock target)
{
    foreach (var n in YieldedNumbers())
    {
        // Normally, this will return immediately, but if the queue has
        // reached its limit then it will wait until the consumer has
        // processed items on the queue.
        Task.WaitAll(target.SendAsync(n));
    }
    // Set the target to the completed state to signal to the consumer
    // that no more data will be available.
    target.Complete();
}
```

I originally had the the `Produce()` method as an `async`/`await` method... But that didn't work, it seems that doing that the iterator shifts around threads again because when the code wakes up after the `await` it may be restarted on a new thread. So I put it back to a simple `Task.WaitAll()` and it kept it all on the same thread.

The producer options are set so that the queue size is limited, it stops pulling from the producer if the queue reaches capacity and thus it keeps the app running smoothly. The producer won't over produce.

The consumer options need to be set explicitly otherwise it acts on a single thread. Unlike other things in the TPL it won't necessarily optimise for the number of cores you have, you have to specify that, and a crude rule of thumb for getting that number is `Environment.ProcessorCount` (crude, because if you have hyper threading it can treat that as being multiple processor cores). However, it is good enough unless you really need to optimise things accurately.

Now, a lot of this can be abstracted away so that the calling code can just get on with what it needs without the distractions that this pattern introduces.

Most of this code can be extracted out to a class that extends `IEnumerable<T>`

```csharp
public static class IEnumerableExtensions
{
    public static void ConsumeInParallel<T>(this IEnumerable<T> source, Action<T> action, int queueLimit = int.MaxValue)
    {
        var producerOptions = new DataflowBlockOptions { BoundedCapacity = queueLimit };
        var buffer = new BufferBlock<T>(producerOptions);
        var consumerOptions = new ExecutionDataflowBlockOptions
        {
            BoundedCapacity = Environment.ProcessorCount,
            MaxDegreeOfParallelism = Environment.ProcessorCount
        };
        var linkOptions = new DataflowLinkOptions { PropagateCompletion = true };
        var consumer = new ActionBlock<T>(action, consumerOptions);
        buffer.LinkTo(consumer, linkOptions);
        Produce(source, buffer);
        Task.WaitAll(consumer.Completion);
    }

    private static void Produce<T>(IEnumerable<T> source, ITargetBlock<T> target)
    {
        foreach (var n in source)
            Task.WaitAll(target.SendAsync(n));
        target.Complete();
    }
}
```

With this, we can use any `IEnumerator<T>` as a source of data and it will happily process it. The `queueLimit` ensures that we don't end up with too much data waiting to be processed as we don't want memory pressures causing the app to become unstable.
The calling code now looks much neater:

```csharp
public static void Main(string[] args)
{
    YieldedNumbers().ConsumeInParallel(n=> {Thread.Sleep(n);}, 97);

    Console.WriteLine("Done!");
    Console.ReadLine();
}
```
