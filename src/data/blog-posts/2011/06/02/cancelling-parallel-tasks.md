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
<!-- TODO: convert this post's content to Markdown -->

<p><em><strong>UPDATE (7-June-2011):</strong> The post as it originally appeared had a bug in the code, the catch block in the task caught the wrong exception type. See the </em><a href="#2011-06-07-21-49-Gotcha"><em>Gotcha</em></a><em> section at the end for an explanation on why there are two types of exception for this.</em></p>  <p>I think, to date, I’ve mentioned most of the task lifecycle, but I’ve not talked about cancelling tasks yet. So here goes.</p>  <p>You can cancel tasks for what ever reason by passing in a cancellation token to the task. The task must be cooperative insomuch as it must watch the cancellation token to detect if a cancellation has been signalled then it can clean up and exit.</p>  <h3>The basic program</h3>  <p>So, the little example program to demonstrate this is this:</p>  <pre>class Program
{
    static void Main(string[] args)
    {
        const int numTasks = 9;
        Task[] tasks = new Task[numTasks];
        for (int i = 0; i &lt; 10; i++)
            tasks[i] = Task.Factory.StartNew(PerformTask);

        Task.WaitAll(tasks);

        foreach(Task t in tasks)
            Console.WriteLine(&quot;Tasks {0} state: {1}&quot;, t.Id, t.Status);

        Console.WriteLine(&quot;Program End&quot;);
        Console.ReadLine();
    }

    static void PerformTask()
    {
        Console.WriteLine(&quot;Task {0}: Starting&quot;, Task.CurrentId);
        for (int i = 0; i &lt; 3; i++)
        {
            Console.WriteLine(&quot;Task {0}: {1}/3 In progress&quot;, Task.CurrentId, i+1);
            Thread.Sleep(500); // Simulate doing some work
        }
        Console.WriteLine(&quot;Task {0}: Finished&quot;, Task.CurrentId);
    }
}</pre>

<p>So far this doesn't do much. It starts 9 tasks and each runs to completion. Each task’s end state is <code>RanToCompletion</code>.</p>

<h3>Setting up the CancellationToken</h3>

<p>Now, if we introduce the cancellation token to the task we can cancel the task at some point during its execution. The <code>Main</code> method then gets changed to this:</p>

<pre>static void Main(string[] args)
{
    const int numTasks = 9;

    CancellationTokenSource tokenSource = new CancellationTokenSource();
    CancellationToken token = tokenSource.Token;

    Task[] tasks = new Task[numTasks];
    for (int i = 0; i &lt; numTasks; i++)
        tasks[i] = Task.Factory.StartNew(() =&gt; PerformTask(token), token);

    Thread.Sleep(1500);
    Console.WriteLine(&quot;Cancelling tasks&quot;);
    tokenSource.Cancel();
    Console.WriteLine(&quot;Cancellation Signalled&quot;);

    Task.WaitAll(tasks);

    foreach(Task t in tasks)
        Console.WriteLine(&quot;Tasks {0} state: {1}&quot;, t.Id, t.Status);


    Console.WriteLine(&quot;Program End&quot;);
    Console.ReadLine();
}</pre>

<p>The <code>PerformTask</code> method now takes a <code>CancellationToken</code> (but doesn’t yet do anything with it)</p>

<p>If this code is run, the <code>Task.WaitAll</code> method call will throw an <code>AggregateException</code> with a number of <code>TaskCanceledException</code> objects. </p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" src="http://static.colinmackay.co.uk/images/parallelisation/2011-06-03-Cancellation-A-task-was-cancelled-640.png" width="640" height="492" /></p>

<h3>Handling cancelled tasks</h3>

<p>You therefore have to surround your <code>WaitAll</code> method with a <code>try</code>/<code>catch</code> block and look out for <code>TaskCanceledException</code> objects and handle them as you need (see also: <a href="http://colinmackay.co.uk/blog/2011/05/17/handling-aggregateexceptions/">handling AggregateException exceptions</a>). In my example I’m just going to output the fact to the console. The <code>try</code>/<code>catch</code> block looks like this:</p>

<pre>try
{
    Task.WaitAll(tasks);
}
catch (AggregateException aex)
{
    aex.Handle(ex =&gt;
    {
        TaskCanceledException tcex = ex as TaskCanceledException;
        if (tcex != null)
        {
            Console.WriteLine(&quot;Handling cancellation of task {0}&quot;, tcex.Task.Id);
            return true;
        }
        return false;
    });
}</pre>

<p>The tasks that were in progress at the time the cancel was signalled complete as normal. Cancelling the tasks will not stop any currently running task.</p>

<h3>Responding to a cancellation request: IsCancellationRequested</h3>

<p>If the tasks are sufficiently short running allowing them to complete may be perfectly acceptable. </p>

<p>However, if a task is long running or it is safe to cancel them then you can allow your task to cooperate and respond to the token being signalled to cancel.</p>

<p>The <code>CancellationToken</code> object has a property you can check called <code>IsCancellationRequested</code>. For example:</p>

<pre>static void PerformTask(CancellationToken token)
{
    Console.WriteLine(&quot;Task {0}: Starting&quot;, Task.CurrentId);
    for (int i = 0; i &lt; 4; i++)
    {
        if (token.IsCancellationRequested)
        {
            Console.WriteLine(&quot;Task {0}: Cancelling&quot;, Task.CurrentId);
            return;
        }
        Console.WriteLine(&quot;Task {0}: {1}/3 In progress&quot;, Task.CurrentId, i+1);
        Thread.Sleep(500); // Simulate doing some work
    }
    Console.WriteLine(&quot;Task {0}: Finished&quot;, Task.CurrentId);
}</pre>

<p>If you simply exit from your task, like the above example, then the <code>Status</code> of the task will be <code>RanToCompletion</code> as if the task completed normally. If you do not need to know whether a task actually completed or was cancelled then this may be completely acceptable.</p>

<h3>Responding to a cancellation request: ThrowIfCancellationRequested</h3>

<p>If you need to perform clean up or the calling code needs to know that a task has been cancelled then using the <code>CancellationToken</code>’s <code>ThrowIfCancellationRequested()</code> method may be a better choice.</p>

<p>If you do need to perform clean up inside your task, ensure that the <code>OperationCanceledExcption</code> is thrown again so that the calling code knows that the task was cancelled.</p>

<pre>static void PerformTask(CancellationToken token)
{
    try
    {
        Console.WriteLine(&quot;Task {0}: Starting&quot;, Task.CurrentId);
        for (int i = 0; i &lt; 4; i++)
        {
            token.ThrowIfCancellationRequested();
            Console.WriteLine(&quot;Task {0}: {1}/3 In progress&quot;, Task.CurrentId, i + 1);
            Thread.Sleep(500); // Simulate doing some work
        }
        Console.WriteLine(&quot;Task {0}: Finished&quot;, Task.CurrentId);
    }
    catch (OperationCanceledException)
    {
        // Any clean up code goes here.
        Console.WriteLine(&quot;Task {0}: Cancelling&quot;, Task.CurrentId);
        throw; // To ensure that the calling code knows the task was cancelled.
    }
    catch(Exception)
    {
        // Clean up other stuff
        throw; // If the calling code also needs to know.
    }
}</pre>

<p>Remember that if you allow other exceptions to escape your task then the task’s status will be Faulted.</p>

<h3>
  <p><a id="2011-06-07-21-49-Gotcha" name="2011-06-07-21-49-Gotcha"></a></p>
Gotcha!</h3>

<p style="margin:5px;width:200px;float:right;border:1px solid #9e7c7c;background-color:#FFFFFF;padding:5px;"><em><font color="#9e7c7c">This section was added on 7-June-2011.</font></em></p>

<p>One thing to watch out for is that the exception you get inside the task is different from the exception you get inside the <code>AggregateException</code> outside the task. Normally, you’d expect that the exception is passed through and becomes one of the <code>InnerExceptions</code> in the aggregate exceptions.</p>

<p>It you want to keep the code consistent and only deal with one exception type for cancelled tasks you can simple deal with the <code>OperationCanceledException</code> throughout (both inside and outside the tasks) as that is the base class. Outside the task the exception object is actually a <code>TaskCanceledException</code>.</p>

<p>The advantage of referencing the more specific <code>TaskCanceledException</code> outside the task is that the exception object also contains a reference to the <code>Task</code> that was cancelled. Inside the task the exception that <code>ThrowIfCancellationRequested</code> throws is an <code>OperationCanceledException</code> (which doesn’t contain the <code>Task</code> object, however you are inside the task at this point)</p>

<p>The other point to note is that outside the task, the <code>TaskCanceledException</code> object in the <code>AggregateException</code> object doesn’t contain much of the information you’d expect to find in an <code>Exception</code> object (such as a Stack Trace).</p>
