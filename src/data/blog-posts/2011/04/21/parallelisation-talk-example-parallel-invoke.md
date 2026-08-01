---
title: "Parallelisation Talk Example – Parallel.Invoke"
slug: parallelisation-talk-example-parallel-invoke
publishDate: 21 Apr 2011
description: "Parallel.Invoke is the most basic way to start many tasks as the same time. The method takes as many Action<…> based delegates as needed. The Task Parallel..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Parallel.Invoke. Task.Factory.StartNew", slug: parallel-invoke-task-factory-startnew }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "Task.WaitAll", slug: task-waitall }
---
<!-- TODO: convert this post's content to Markdown -->

<p><code>Parallel.Invoke</code> is the most basic way to start many tasks as the same time. The method takes as many <code>Action&lt;…&gt;</code> based delegates as needed. The Task Parallel Library takes care of the actual scheduling, degree of parallelism etc. <code>Parallel.Invoke</code> itself blocks until all the tasks have completed.</p>  <p>In this example there are two tasks that simply output numbers and letters to the console. One task takes slightly longer than the other. The output shows each task as it runs along with an indication of when it finishes, as well as the overall program finishes.</p>  <h3>Code Example One</h3>  <pre>class Program
{
    static void Main(string[] args)
    {
        // Start two tasks in parallel
        Parallel.Invoke(TaskOne, TaskTwo);

        Console.WriteLine(&quot;Finished&quot;);
        Console.ReadLine();
    }

    // This task simple outputs the numbers 0 to 9
    private static void TaskOne()
    {
        for (int i = 0; i &lt; 10; i++)
        {
            Console.WriteLine(&quot;TaskOne: {0}&quot;, i);
            Thread.Sleep(10);
        }
        Console.WriteLine(&quot;TaskOne Finished&quot;);
    }

    // This task simply outputs the letters A to K
    private static void TaskTwo()
    {
        for(char c = 'A'; c &lt; 'K'; c++)
        {
            Console.WriteLine(&quot;TaskTwo: {0}&quot;, c);
            Thread.Sleep(5);
        }
        Console.WriteLine(&quot;TaskTwo Finished&quot;);
    }
}</pre>

<h3>Example output</h3>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="Parallel.Invoke Example" src="http://static.colinmackay.co.uk/images/parallelisation/2011-04-21-parallel-invoke-example-640.png" width="640" height="458" /></p>

<pre>TaskOne: 0
TaskTwo: A
TaskOne: 1
TaskTwo: B
TaskTwo: C
TaskTwo: D
TaskOne: 2
TaskTwo: E
TaskOne: 3
TaskTwo: F
TaskTwo: G
TaskTwo: H
TaskOne: 4
TaskTwo: I
TaskTwo: J
TaskOne: 5
TaskTwo Finished
TaskOne: 6
TaskOne: 7
TaskOne: 8
TaskOne: 9
TaskOne Finished
Finished</pre>

<h3>Code Example: Variation using Task.Factory.StartNew</h3>

<p>The <code>Parallel.Invoke</code> method is equivalent setting up a number of tasks using <code>Task.Factory.StartNew(…)</code> then <code>Task.WaitAll(…)</code>.</p>

<p>The following code example shows the same code (<code>Main</code> method only) but using <code>Task.Factory.StartNew</code>:</p>

<pre>static void Main(string[] args)
{
    // Start two tasks in parallel
    Task t1 = Task.Factory.StartNew(TaskOne);
    Task t2 = Task.Factory.StartNew(TaskTwo);
    Task.WaitAll(t1, t2);

    Console.WriteLine(&quot;Finished&quot;);
    Console.ReadLine();
}</pre>
