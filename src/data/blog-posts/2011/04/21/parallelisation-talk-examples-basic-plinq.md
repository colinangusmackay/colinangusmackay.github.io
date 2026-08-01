---
title: "Parallelisation Talk Examples – Basic PLINQ"
slug: parallelisation-talk-examples-basic-plinq
publishDate: 21 Apr 2011
description: "These are some code examples from my introductory talk on Parallelisation showing the difference between a standard sequential LINQ query and its parallel..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "LINQ", slug: linq }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "PLINQ", slug: plinq }
---
<!-- TODO: convert this post's content to Markdown -->

<p>These are some code examples from my introductory talk on Parallelisation showing the difference between a standard sequential LINQ query and its parallel equivalent.</p>  <p>The main differences between this and the previous two examples (<a title="Parallel.For Parallelisation Talk Example" href="http://colinmackay.co.uk/blog/2011/04/21/parallelisation-talk-examples-parallel-for/">Parallel.For</a> and <a title="Parallel.ForEach Parallelisation Talk Example" href="http://colinmackay.co.uk/blog/2011/04/21/parallelisation-talk-examples-parallel-foreach/">Parallel.ForEach</a>) is that LINQ (and PLINQ) is designed to return data back, so the LINQ expression uses a <code>Func&lt;TResult, T1, T2, T3…&gt;</code> instead of an <code>Action&lt;T1, T2, T3…&gt;</code>. Since the examples were simply outputting a string to the Console to indicate which item or index was being processed I’ve changed the code to return a string back to the LINQ expression. The results are then looped over and output to the console.</p>  <p>It is also important to remember that LINQ expressions are not evaluated until the data is called for. In the example below that is with the <code>.ToList()</code> method call, however it may also be as a result of <code>foreach</code> or any other method of iterating over the expression results.</p>  <h2>Code example 1: Sequential processing of data with LINQ</h2>  <pre>class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        IEnumerable&lt;int&gt; items = Enumerable.Range(0, 20);

<strong>        var results = items
            .Select(ProcessItem)
            .ToList();</strong>

        results.ForEach(Console.WriteLine);

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine(&quot;Finished. Took {0}&quot;, duration);

        Console.ReadLine();
    }

    private static string ProcessItem(int item)
    {
        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1100);
        Thread.Sleep(pause);

        return string.Format(&quot;Result of item {0}&quot;, item);
    }
}</pre>

<p>The output of the above code may look something like this:</p>

<p><a title="Basic LINQ by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5623342144/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="Basic LINQ" src="http://farm6.static.flickr.com/5023/5623342144_e8b1d111d4_z.jpg" width="640" height="458" /></a></p>

<p>As you can see this takes roughly of 20 seconds to process 20 items with each item taking about one second to process.</p>

<h2>Code Example 2: Parallel processing of data with PLINQ</h2>

<p>The <code>AsParallel</code> extension method can be found in the <code>System.Linq</code> namespace so no additional using statements are needed if you are already using LINQ.</p>

<pre>class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        IEnumerable&lt;int&gt; items = Enumerable.Range(0, 20);

        var results = items.AsParallel()
            .Select(ProcessItem)
            .ToList();

        results.ForEach(Console.WriteLine);

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine(&quot;Finished. Took {0}&quot;, duration);

        Console.ReadLine();
    }

    private static string ProcessItem(int item)
    {
        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1100);
        Thread.Sleep(pause);

        return string.Format(&quot;Result of item {0}&quot;, item);
    }
}</pre>

<p>The output of the above code may look something like this:</p>

<p><a title="Basic PLINQ by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5623342098/"><img style="background-image:none;border-bottom:0;border-left:0;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;border-top:0;margin-right:auto;border-right:0;padding-top:0;" border="0" alt="Basic PLINQ" src="http://farm6.static.flickr.com/5186/5623342098_fc076b98e8_z.jpg" width="640" height="458" /></a></p>

<p>The result of this code is that it takes roughly 5 second to process the 20 items. I have a 4 core processor so it would be in line with the expectation that the work is distributed across all 4 cores.</p>
