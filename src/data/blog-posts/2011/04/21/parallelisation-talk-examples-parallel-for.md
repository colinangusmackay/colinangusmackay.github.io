---
title: "Parallelisation Talk examples - Parallel.For"
slug: parallelisation-talk-examples-parallel-for
publishDate: 21 Apr 2011
description: "This is some example code from my introductory talk on Parallelisation. Showing the difference between a standard sequential for loop and its parallel..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>This is some example code from my introductory talk on Parallelisation. Showing the difference between a standard sequential for loop and its parallel equivalent.</p>  <h2>Code example 1: Serial processing of a for loop</h2>  <pre>class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        for (int i = 0; i &lt; 20; i++)
            ProcessLoop(i);

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine(&quot;Finished. Took {0}&quot;, duration);
    }

    private static void ProcessLoop(long i)
    {
        Console.WriteLine(&quot;Processing index {0}&quot;, i);

        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1000);
        Thread.Sleep(pause);
    }
}</pre>

<p>The output of the above code may look something like this:</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="Sequential for example" src="http://static.colinmackay.co.uk/images/parallelisation/2011-04-21-Sequential-for-example-640.png" width="640" height="458" /></p>

<p>As you can see this takes just shy of 20 seconds to process 20 items.</p>

<h2>Code Example 2: Parallel processing of a for loop</h2>

<p>The <code>Parallel</code> class can be found in the <code>System.Threading.Tasks</code> namespace.</p>

<pre>class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        Parallel.For(0, 20,
            (i) =&gt; ProcessLoop(i));

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine(&quot;Finished. Took {0}&quot;, duration);

        Console.ReadLine();
    }

    private static void ProcessLoop(long i)
    {
        Console.WriteLine(&quot;Processing index {0}&quot;, i);

        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1000);
        Thread.Sleep(pause);
    }
}</pre>

<p>The output of the above code may look something like this:</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="Parallel.For Example" src="http://static.colinmackay.co.uk/images/parallelisation/2011-04-21-parallel-for-example-640.png" width="640" height="458" /></p>

<p>The result of this code is that it takes just shy of 5 second to process the 20 items. I have a 4 core processor so it would be in line with the expectation that the work is distributed across all 4 cores.</p>
