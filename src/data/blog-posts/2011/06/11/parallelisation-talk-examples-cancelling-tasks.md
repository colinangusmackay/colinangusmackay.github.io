---
title: "Parallelisation Talk examples - Cancelling Tasks"
slug: parallelisation-talk-examples-cancelling-tasks
publishDate: 11 Jun 2011
description: "This example showed what happens when tasks are cancelled. In this example, some tasks will be able to run to completion, others will be cancelled and other..."
tags:
  - { name: "AggregateException", slug: aggregateexception }
  - { name: "CancellationToken", slug: cancellationtoken }
  - { name: "CancellationTokenSource", slug: cancellationtokensource }
  - { name: "DDD", slug: ddd }
  - { name: "DDD South West", slug: ddd-south-west }
  - { name: "OperationCanceledException", slug: operationcanceledexception }
  - { name: "presentation", slug: presentation }
  - { name: "TaskCanceledException", slug: taskcanceledexception }
  - { name: "ThrowIfCancellationRequested", slug: throwifcancellationrequested }
---
<!-- TODO: convert this post's content to Markdown -->

<p>This example showed what happens when tasks are cancelled. In this example, some tasks will be able to run to completion, others will be cancelled and other won’t even get a chance to start because the cancellation token was signalled before the task gets a chance to start.</p>  <p>Here is the code for the cancellation example shown in the talk</p>  <pre>class Program
{
    static void Main(string[] args)
    {
        const int numTasks = 9;

        // Set up the cancellation source and get the token.
        CancellationTokenSource tokenSource = new CancellationTokenSource();
        CancellationToken token = tokenSource.Token;

        // Set up the tasks
        Task[] tasks = new Task[numTasks];
        for (int i = 0; i &lt; numTasks; i++)
            tasks[i] = Task.Factory.StartNew(() =&gt; PerformTask(token), token);

        // Now the tasks are all set up, show the state.
        // Most will be WaitingToRun, some will be Running
        foreach (Task t in tasks.OrderBy(t =&gt; t.Id))
            Console.WriteLine(&quot;Tasks {0} state: {1}&quot;, t.Id, t.Status);

        // Give some of the tasks a chance to do something.
        Thread.Sleep(1500);

        // Cancel the tasks
        Console.WriteLine(&quot;Cancelling tasks&quot;);
        tokenSource.Cancel();
        Console.WriteLine(&quot;Cancellation Signalled&quot;);

        try
        {
            // Wait for the tasks to cancel if they've not already completed
            Task.WaitAll(tasks);
        }
        catch (AggregateException aex)
        {
            aex.Handle(ex =&gt;
            {
                // Handle the cancelled tasks
                TaskCanceledException tcex = ex as TaskCanceledException;
                if (tcex != null)
                {
                    Console.WriteLine(&quot;Handling cancellation of task {0}&quot;, tcex.Task.Id);
                    return true;
                }

                // Not handling any other types of exception.
                return false;
            });
        }

        // Show the state of each of the tasks.
        // Some will be RanToCompletion, others will be Cancelled.
        foreach(Task t in tasks.OrderBy(t =&gt; t.Id))
            Console.WriteLine(&quot;Tasks {0} state: {1}&quot;, t.Id, t.Status);


        Console.WriteLine(&quot;Program End&quot;);
        Console.ReadLine();
    }

    static void PerformTask(CancellationToken token)
    {
        try
        {
            // The loop simulates work that can be cooperatively cancelled.
            Console.WriteLine(&quot;Task {0}: Starting&quot;, Task.CurrentId);
            for (int i = 0; i &lt; 4; i++)
            {
                // Check for the cancellation to be signalled
                token.ThrowIfCancellationRequested();

                // Write out a little bit showing the progress of the task
                Console.WriteLine(&quot;Task {0}: {1}/4 In progress&quot;, Task.CurrentId, i + 1);
                Thread.Sleep(500); // Simulate doing some work
            }
            // By getting here the task will RunToCompletion even if the
            // token has been signalled.
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
    }
}</pre>

<p>&#160;</p>

<p>Here is the output of the program (your results may vary):</p>

<pre>Task 1: Starting
Task 1: 1/4 In progress
Task 2: Starting
Task 2: 1/4 In progress
Tasks 1 state: Running
Task 3: Starting
Task 3: 1/4 In progress
Tasks 2 state: Running
Task 4: Starting
Task 4: 1/4 In progress
Tasks 3 state: Running
Tasks 4 state: Running
Tasks 5 state: WaitingToRun
Tasks 6 state: WaitingToRun
Tasks 7 state: WaitingToRun
Tasks 8 state: WaitingToRun
Tasks 9 state: WaitingToRun
Task 1: 2/4 In progress
Task 2: 2/4 In progress
Task 3: 2/4 In progress
Task 4: 2/4 In progress
Task 1: 3/4 In progress
Task 2: 3/4 In progress
Task 4: 3/4 In progress
Task 3: 3/4 In progress
Task 1: 4/4 In progress
Task 2: 4/4 In progress
Task 4: 4/4 In progress
Task 3: 4/4 In progress
Task 5: Starting
Task 5: 1/4 In progress</pre>

<p>To this point the tasks have been given a chance to operate normally. The tasks that have started are outputing to the console their progress. The main thread reports on the state of the tasks and shows tasks 1 to 4 are <code>Running</code> while the remainder are <code>WaitingToRun</code>. After a while the scheduler decides to start task 5.</p>

<p>Next the tasks are going to be cancelled.</p>

<pre>Cancelling tasks
Cancellation Signalled
Task 1: Finished
Task 2: Finished
Task 4: Finished
Task 3: Finished
Task 5: Cancelling</pre>

<p>When the cancellation token is signalled the tasks have to cooperate. Tasks 1 to 4 are too far gone and will run to completion. Task 5, which was only just started, cooperates with the cancellation request and writes that it is cancelling. No waiting tasks are started.</p>

<p>In the main thread, the control is blocked until all the tasks have either finished or cooperate with the cancellation request. Once the <code>WaitAll</code> unblocks the program handles any cancelled tasks in the catch block.</p>

<pre>Handling cancellation of task 9
Handling cancellation of task 8
Handling cancellation of task 7
Handling cancellation of task 6
Handling cancellation of task 5</pre>

<p>Tasks 6 to 9 never got a chance to start. Task 5 was started, but was cancelled. Therefore task 5's cancellation can be handled inside the task and outside it. Different clean up may be required in each place.</p>

<p>Finally, the program lists the end state (See also: <a href="http://colinmackay.co.uk/blog/2011/06/03/task-status-state-changes/">Task state transitions</a>) of each of the tasks:</p>

<pre>Tasks 1 state: RanToCompletion
Tasks 2 state: RanToCompletion
Tasks 3 state: RanToCompletion
Tasks 4 state: RanToCompletion
Tasks 5 state: Canceled
Tasks 6 state: Canceled
Tasks 7 state: Canceled
Tasks 8 state: Canceled
Tasks 9 state: Canceled
Program End</pre>

<p>When writing code to handle cancelled tasks, watch out for <a href="http://colinmackay.co.uk/blog/2011/06/03/cancelling-parallel-tasks/#2011-06-07-21-49-Gotcha">this gotcha</a> that can trip you up if you are not careful.</p>
