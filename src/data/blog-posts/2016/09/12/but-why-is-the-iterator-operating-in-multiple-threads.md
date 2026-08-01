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
<!-- TODO: convert this post's content to Markdown -->

<h3>Background</h3>
Recently, I had a bit of a problem with NHibernate when I was converting some code into parallel tasks. (If you have no interest in NHibernate, then don't worry - it is just background to the issue I was having when I spotted this gulf between my expectation and reality. NHibernate is incidental to this and I won't mention it much beyond this paragraph.) It turns out that <code>Parallel.ForEach</code> runs the iterator in multiple threads, not just the the action it performs on each item received from the iterator. NHibernate, being the source of the data was running inside the iterator and when I attached <a href="https://www.hibernatingrhinos.com/products/nhprof" target="_blank">NHibernate Profiler</a> to see what it could turn up it very quickly began reporting that the NHibernate session was running in multiple-threads and that NHibernate was not designed to be thread safe.
<h3>The Iterator Patten in .NET</h3>
In .NET the iterator pattern is exposed via an <code>IEnumerator</code> or <code><a href="https://msdn.microsoft.com/en-us/library/78dfe2yb(v=vs.110).aspx" target="_blank">IEnumerator&lt;T&gt;</a></code> and there is some syntactic sugar so that you can create an iterator method using <code>yield return</code>. There is also syntactic sugar surrounding the consumption of iterators via <code>foreach</code>. This almost completely hides the complexities of <code>IEnumerator</code> implementations.

There are some limitations to this. The interface is inherently not thread safe as it does not provide for an atomic operation that retrieves an element and moves the internal pointer on to the next. You have to call <code>MoveNext()</code> followed by <code>Current</code> if it returned <code>true</code>. If the iterator needs thread-safety, it is the responsibility of the caller to provide it.
<h3>But, then this happens...</h3>
Knowing this, I would have assumed (always a bad idea, but I'm only human) that <code>Parallel.ForEach()</code> operates over the iterator in a single thread, but farms out each loop to different threads, but I was wrong. Try the following code for yourself and see what happens:
<pre>public class Program
{
    public static void Main(string[] args)
    {
        Parallel.ForEach(
            YieldedNumbers(),
            (n) =&gt; { Thread.Sleep(n); });
        Console.WriteLine("Done!");
        Console.ReadLine();
    }

    public static IEnumerable&lt;int&gt; YieldedNumbers()
    {
        Random rnd = new Random();
        int lastKnownThread = Thread.CurrentThread.ManagedThreadId;
        int detectedSwitches = 0;
        for (int i = 0; i &lt; 1000; i++)
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
</pre>
The <code>Action&lt;int&gt;</code> passed to the <code>Parallel.ForEach</code> simply simulates some work being done (and the times sent to the <code>Thread.Sleep()</code> are roughly analogous to the times of the tasks in the original project).

What I've done here also is detect when the thread changes and report that to the console. It happens roughly 15%-18% of the time on the runs I've made on my machine. Now that was surprising (not really, because NHibernate Profiler had already told me - but to have a very clean example of the same was). I can't blame any weirdness in third party libraries. It happens with some very basic .NET code in a console application.
<h3>Possible Solutions</h3>
<strong>1.</strong> My first thought was to dump all the data retrieved from the iterator into a collection of some sort (e.g. an array or list), but the iterator was originally put in place because the volume of data was causing memory pressure. The app ran overnight and will process anything between a few hundred to a few hundred thousand customers and testing found that it significantly slowed down around the 7000 mark because of the size of the data, and fell over completely not far past that. So, the iterator that I created hides the fact that I now page the data, the calling code knows nothing about this paging and didn't have to be modified. So that solution was out of the question, we'd be back to the problem we had a while ago.

<strong>2.</strong>The data could be processed in batches and each fully retrieved batch be run in parallel one at at time. I did try that but it just made the calling code difficult to read and more complex than it needed to be. The reader has to be able to understand why there are batches, and the person writing the code has to remember that the data may not fit an exact number of batches and will have to process the final batch outside the loop which adds to the cognitive load on the reader/maintainer.
<pre>public static void Main(string[] args)
{
    int batchSize = 97;
    List batch = new List&lt;int&gt;();
    foreach (int item in YieldedNumbers())
    {
        batch.Add(item);
        if (batch.Count &gt;= batchSize)
            ProcessBatch(batch);
    }
    ProcessBatch(batch);

    Console.WriteLine("Done!");
    Console.ReadLine();
}

private static int batchCount = 0;
private static void ProcessBatch(List&lt;int&gt; batch)
{
    batchCount ++;
    Console.WriteLine($"Processing batch {batchCount} containing {batch.Count} items");
    Parallel.ForEach(batch, (n) =&gt; { Thread.Sleep(n); });
    batch.Clear();
}

// The YieldedNumbers() method is unchanged from before.
</pre>
The iterator is always called from a single thread and therefore never complains on this set up.

<strong>3.</strong> Use the Microsoft <a href="https://www.nuget.org/packages/Microsoft.Tpl.Dataflow/" target="_blank">Data Flow</a> for the Task Parallel library. Personally, I think this one is best because the pattern is clear and the complex bits can be moved away from the main algorithm. The only part I didn't like was the effort to set up the Producer/Consumer pattern using this library, but it handles all the bits I want to abstract away quite nicely... And that set up can be abstracted out later. Here's the basic algorithm.
<pre>public static void Main(string[] args)
{
    var producerOptions = new DataflowBlockOptions { BoundedCapacity = 97 };
    var buffer = new BufferBlock&lt;int&gt;(producerOptions);
    var consumerOptions = new ExecutionDataflowBlockOptions
    {
        BoundedCapacity = Environment.ProcessorCount,
        MaxDegreeOfParallelism = Environment.ProcessorCount
    };
    var linkOptions = new DataflowLinkOptions { PropagateCompletion = true };
    var consumer = new ActionBlock&lt;int&gt;( n=&gt; {  Thread.Sleep(n); }, consumerOptions);
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
</pre>
I originally had the the <code>Produce()</code> method as an <code>async</code>/<code>await</code> method... But that didn't work, it seems that doing that the iterator shifts around threads again because when the code wakes up after the <code>await</code> it may be restarted on a new thread. So I put it back to a simple <code>Task.WaitAll()</code> and it kept it all on the same thread.

The producer options are set so that the queue size is limited, it stops pulling from the producer if the queue reaches capacity and thus it keeps the app running smoothly. The producer won't over produce.

The consumer options need to be set explicitly otherwise it acts on a single thread. Unlike other things in the TPL it won't necessarily optimise for the number of cores you have, you have to specify that, and a crude rule of thumb for getting that number is <code>Environment.ProcessorCount</code> (crude, because if you have hyper threading it can treat that as being multiple processor cores). However, it is good enough unless you really need to optimise things accurately.

Now, a lot of this can be abstracted away so that the calling code can just get on with what it needs without the distractions that this pattern introduces.

Most of this code can be extracted out to a class that extends <code>IEnumerable&lt;T&gt;</code>
<pre>public static class IEnumerableExtensions
{
    public static void ConsumeInParallel&lt;T&gt;(this IEnumerable&lt;T&gt; source, Action&lt;T&gt; action, int queueLimit = int.MaxValue)
    {
        var producerOptions = new DataflowBlockOptions { BoundedCapacity = queueLimit };
        var buffer = new BufferBlock&lt;T&gt;(producerOptions);
        var consumerOptions = new ExecutionDataflowBlockOptions
        {
            BoundedCapacity = Environment.ProcessorCount,
            MaxDegreeOfParallelism = Environment.ProcessorCount
        };
        var linkOptions = new DataflowLinkOptions { PropagateCompletion = true };
        var consumer = new ActionBlock&lt;T&gt;(action, consumerOptions);
        buffer.LinkTo(consumer, linkOptions);
        Produce(source, buffer);
        Task.WaitAll(consumer.Completion);
    }

    private static void Produce&lt;T&gt;(IEnumerable&lt;T&gt; source, ITargetBlock&lt;T&gt; target)
    {
        foreach (var n in source)
            Task.WaitAll(target.SendAsync(n));
        target.Complete();
    }
}
</pre>
With this, we can use any <code>IEnumerator&lt;T&gt;</code> as a source of data and it will happily process it. The <code>queueLimit</code> ensures that we don't end up with too much data waiting to be processed as we don't want memory pressures causing the app to become unstable.

The calling code now looks much neater:
<pre>public static void Main(string[] args)
{
    YieldedNumbers().ConsumeInParallel(n=&gt; {Thread.Sleep(n);}, 97);

    Console.WriteLine("Done!");
    Console.ReadLine();
}
</pre>
