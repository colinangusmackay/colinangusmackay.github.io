---
title: "Parallelisation Talk Examples – Parallel.ForEach"
slug: parallelisation-talk-examples-parallel-foreach
publishDate: 21 Apr 2011
description: "These are some code examples from my introductory talk on Parallelisation. Showing the difference between a standard sequential foreach loop and its parallel..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Parallel.ForEach", slug: parallel-foreach }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>These are some code examples from my introductory talk on Parallelisation. Showing the difference between a standard sequential foreach loop and its parallel equivalent.</p>  <h2>Code example 1: Serial processing of a foreach loop</h2>  <pre>class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        IEnumerable items = Enumerable.Range(0,20);

<strong>        foreach(int item in items)
            ProcessLoop(item);</strong>

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine(&quot;Finished. Took {0}&quot;, duration);

        Console.ReadLine();
    }

    private static void ProcessLoop(int item)
    {
        Console.WriteLine(&quot;Processing item {0}&quot;, item);

        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1100);
        Thread.Sleep(pause);
    }
}</pre>

<p>The output of the above code may look something like this:</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="Sequential foreach Example" src="http://static.colinmackay.co.uk/images/parallelisation/2011-04-21-Sequential-foreach-example-640.png" width="640" height="458" /></p>

<p>As you can see this takes roughly of 20 seconds to process 20 items with each item taking about one second to process.</p>

<h2>Code Example 2: Parallel processing of a foreach loop</h2>

<p>The <code>Parallel</code> class can be found in the <code>System.Threading.Tasks</code> namespace.</p>

<pre>class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        IEnumerable items = Enumerable.Range(0,20);

<strong>        Parallel.ForEach(items,
            (item) =&gt; ProcessLoop(item));</strong>

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine(&quot;Finished. Took {0}&quot;, duration);

        Console.ReadLine();
    }

    private static void ProcessLoop(int item)
    {
        Console.WriteLine(&quot;Processing item {0}&quot;, item);

        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1100);
        Thread.Sleep(pause);
    }
}</pre>

<p>The output of the above code may look something like this:</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="Parallel.ForEach Example" src="http://static.colinmackay.co.uk/images/parallelisation/2011-04-21-parallel-foreach-example-640.png" width="640" height="458" /></p>

<p>The result of this code is that it takes roughly 5 second to process the 20 items. I have a 4 core processor so it would be in line with the expectation that the work is distributed across all 4 cores.</p>
