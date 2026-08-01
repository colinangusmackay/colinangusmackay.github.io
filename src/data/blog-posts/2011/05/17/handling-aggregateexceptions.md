---
title: "Handling AggregateExceptions"
slug: handling-aggregateexceptions
publishDate: 17 May 2011
description: "I’ve written a couple of posts ( see also ) about how the AggregateException plays its part in exception handling in parallel systems. However, it has another..."
tags:
  - { name: "AggregateException", slug: aggregateexception }
  - { name: "error handling", slug: error-handling }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I’ve written a couple of posts <sup>(<a href="#2011-05-17-16-01-See-Also">see also</a>)</sup> about how the <code>AggregateException</code> plays its part in exception handling in parallel systems. However, it has another trick up its sleeve when it comes to handling exceptions.</p>  <p><code>AggregateException</code> has a <code>Handle</code> method that takes a delegate of <code>Func&lt;Exception, bool&gt;</code> i.e. It takes an <code>Exception</code> as a parameter and returns a <code>bool</code>. The return value indicates whether the function handled the exception or not.</p>  <p>Here is an example program that shows what how it works.</p>  <pre>class Program
{
    static void Main(string[] args)
    {
        try
        {
            DoWork();
        }
        catch(AggregateException aex)
        {
            Console.WriteLine(&quot;Handle Remaining Exceptions&quot;);
            foreach(Exception ex in aex.InnerExceptions)
            {
                Console.WriteLine(&quot;{0}: {1}&quot;, ex.GetType().Name, ex.Message);
            }
        }

        Console.ReadLine();
    }

    private static void DoWork()
    {
        const int numTasks = 20;
        Task[] tasks = new Task[numTasks];
        for (int i = 0; i &lt; numTasks; i++)
            tasks[i] = Task.Factory.StartNew(PerformTask);

        Thread.Sleep(2500);

        try
        {
            Task.WaitAll(tasks);
        }
        catch(AggregateException aex)
        {
            Console.WriteLine(&quot;AggregateException.Handle...&quot;);
            aex.Handle(ex =&gt; HandleException(ex));
            Console.WriteLine(&quot;Finished handling exceptions.&quot;); // This never shows
        }
    }

    public static bool HandleException(Exception ex)
    {
        if (ex is OddException)
        {
            Console.WriteLine(&quot;Handling: {0}&quot;, ex.Message);
            return true;
        }

        Console.WriteLine(&quot;Not handling: {0}&quot;, ex.Message);
        return false;
    }

    public static void PerformTask()
    {
        int? id = Task.CurrentId;
        Console.WriteLine(&quot;Performing Task {0}&quot;, id);

        if (id.Value % 13 == 0)
            throw new TriskaidekaException(&quot;Mwaaahaahaahaahaaaaaaaa!&quot;);

        if (id.Value % 2 == 1)
            throw new OddException(&quot;The task (&quot;+id+&quot;) is distinctly odd.&quot;);
    }
}</pre>

<p>The program starts 20 tasks (<code>DoWork</code>). Each task (<code>PerformTask</code>) simply outputs a line to the console to say what it’s id is and then throws an exception depending on some condition. There are two types of exception that it can throw.</p>

<p>Back in the main thread (<code>DoWork</code>) a <code>Sleep</code> statement gives the tasks a chance to get going (and hopefully complete). During this time, the tasks get the opportunity to output the following.</p>

<pre>Performing Task 1
Performing Task 2
Performing Task 4
Performing Task 3
Performing Task 5
Performing Task 8
Performing Task 9
Performing Task 10
Performing Task 12
Performing Task 13
Performing Task 6
Performing Task 14
Performing Task 7
Performing Task 16
Performing Task 17
Performing Task 18
Performing Task 15
Performing Task 11
Performing Task 19
Performing Task 20</pre>

<p>Then the <code>Task.WaitAll</code> statement is called which will potentially throw an <code>AggregateException</code> (in fact it will with 10 <code>InnerExceptions</code>).</p>

<p>Since the <code>Task.WaitAll</code> call is wrapped in a try/catch the <code>AggregateException</code> is caught. We output a message to say the exceptions are being handled. The <code>AggregateException.Handle</code> method calls the method given (<code>HandleException</code>) once for each of the <code>InnerExceptions</code>.</p>

<pre>AggregateException.Handle...</pre>

<p>The <code>HandleException</code> method either handles the exception (in which case it returns <code>true</code>) or it doesn’t (so returning <code>false</code>). In each case it also writes to the console to say what it has done. That console output looks like this:</p>

<pre>Handling: The task (19) is distinctly odd.
Handling: The task (17) is distinctly odd.
Handling: The task (15) is distinctly odd.
Not handling: Mwaaahaahaahaahaaaaaaaa!
Handling: The task (11) is distinctly odd.
Handling: The task (9) is distinctly odd.
Handling: The task (7) is distinctly odd.
Handling: The task (5) is distinctly odd.
Handling: The task (3) is distinctly odd.
Handling: The task (1) is distinctly odd.</pre>

<p>The <code>AggregateException.Handle</code> method then checks to see if any of the exceptions remain unhandled. If there are still unhandled exceptions then it rethrows. Since there is one remaining exception that is unhandled the line of code after the call to <code>Handle</code> is never called.</p>

<p>The try/catch block in the Main method catches <code>AggregateException</code> and just loops over the remaining exceptions to show what was left unhandled.</p>

<pre>Handle Remaining Exceptions
TriskaidekaException: Mwaaahaahaahaahaaaaaaaa!</pre>

<h3><a id="2011-05-17-16-01-See-Also" name="2011-05-17-16-01-See-Also"></a>See also</h3>

<ul>
  <li><a title="Or why the AggregateException isn&#039;t thrown until WaitAll" href="http://colinmackay.co.uk/blog/2011/05/16/tasks-that-throw-exceptions/">Tasks that throw exceptions</a> </li>

  <li><a title="Introduction to the Aggregate Exception" href="http://colinmackay.co.uk/blog/2011/02/14/parallelisation-in-net-40-part-2-throwing-exceptions/">Parallelisation in .NET 4 – Throwing Exceptions</a> </li>
</ul>
