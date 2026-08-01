---
title: "Parallelisation Talk Example – ConcurrentBag"
slug: parallelisation-talk-example-concurrentbag
publishDate: 21 Apr 2011
description: "This example shows a ConcurrentBag being populated and it being accessed while another task is still populating the bag. The ConcurrentBag class can be found..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "ConcurrentBag", slug: concurrentbag }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>This example shows a <code>ConcurrentBag</code> being populated and it being accessed while another task is still populating the bag.</p>  <p>The <code>ConcurrentBag</code> class can be found in the <code>System.Collections.Concurrent</code> namespace</p>  <p>In this example, the <code>ConcurrentBag</code> is populated in task that is running in the background. After a brief pause in order to allow the background task time to put some items in the bag, main thread starts outputting the contents of the bag.</p>  <p>When the code starts to iterate over the bag, a snapshot is taken so that the enumeration is not tripped up by additional items being added or removed from the bag elsewhere. You can see this effect as only 13 items are output, yet immediately afterwards the bag has 20 items (in this example, if you run the code yourself you may get different results)</p>  <h3>Code Example</h3>  <pre>class Program
{
    private static ConcurrentBag&lt;string&gt; bag = new ConcurrentBag&lt;string&gt;();
    static void Main(string[] args)
    {
        // Start a task to run in the background.
        Task.Factory.StartNew(PopulateBag);

        // Wait a wee bit so that the bag can get populated
        // with some items before we attempt to output them.
        Thread.Sleep(25);

        // Display the contents of the bag
        int count = 0;
        foreach (string item in bag)
        {
            count++;
            Console.WriteLine(item);
        }

        // Show the difference between the count of items
        // displayed and the current state of the bag
        Console.WriteLine(&quot;{0} items were output&quot;, count);
        Console.WriteLine(&quot;The bag contains {0} items&quot;, bag.Count);

        Console.ReadLine();
    }

    public static void PopulateBag()
    {
        for (int i = 0; i &lt; 200; i++ )
        {
            bag.Add(string.Format(&quot;This is item {0}&quot;, i));

            // Wait a bit to simulate other processing.
            Thread.Sleep(1);
        }

        // Show the final size of the bag.
        Console.WriteLine(&quot;Finished populating the bag with {0} items.&quot;, bag.Count);
    }
}</pre>

<h3>Typical output</h3>

<p><a title="ConcurrentBag Example by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5625315155/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="ConcurrentBag Example" src="http://farm6.static.flickr.com/5147/5625315155_289a0ee7f9_z.jpg" width="640" height="458" /></a></p>

<pre>This is item 12
This is item 11
This is item 10
This is item 9
This is item 8
This is item 7
This is item 6
This is item 5
This is item 4
This is item 3
This is item 2
This is item 1
This is item 0
13 items were output
The bag contains 20 items
Finished populating the bag with 200 items.</pre>
