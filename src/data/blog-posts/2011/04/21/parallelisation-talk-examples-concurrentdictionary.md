---
title: "Parallelisation Talk Examples – ConcurrentDictionary"
slug: parallelisation-talk-examples-concurrentdictionary
publishDate: 21 Apr 2011
description: "The example used in the talk was one I had already blogged about. The original blog entry the example was based upon is here: Parallelisation in .NET 4.0 – The..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "ConcurrentDictionary", slug: concurrentdictionary }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>The example used in the talk was one I had already blogged about. The original blog entry the example was based upon is here: <a href="http://colinmackay.co.uk/blog/2011/03/24/parallelisation-in-net-4-0-the-concurrent-dictionary/">Parallelisation in .NET 4.0 – The ConcurrentDictionary</a>.</p>  <h3>Code Example</h3>  <pre>class Program
{
    private static ConcurrentDictionary&lt;string, int&gt; wordCounts =
        new ConcurrentDictionary&lt;string, int&gt;();

    static void Main(string[] args)
    {
        string[] lines = File.ReadAllLines(&quot;grimms-fairy-tales.txt&quot;);
        Parallel.ForEach(lines, ProcessLine);

        Console.WriteLine(&quot;There are {0} distinct words&quot;, wordCounts.Count);
        var topForty = wordCounts.OrderByDescending(kvp =&gt; kvp.Value).Take(40);
        foreach (KeyValuePair word in topForty)
        {
            Console.WriteLine(&quot;{0}: {1}&quot;, word.Key, word.Value);
        }
        Console.ReadLine();
    }

    private static void ProcessLine(string line)
    {
        var words = line.Split(' ')
            .Select(w =&gt; w.Trim().ToLowerInvariant())
            .Where(w =&gt; !string.IsNullOrEmpty(w));
        foreach (string word in words)
            CountWord(word);
    }

    private static void CountWord(string word)
    {
        if (!wordCounts.TryAdd(word, 1))
            UpdateCount(word);
    }

    private static void UpdateCount(string word)
    {
        int value = wordCounts[word];
        if (!wordCounts.TryUpdate(word, value + 1, value))
        {
            Console.WriteLine(&quot;Failed to count '{0}' (was {1}), trying again...&quot;,
                word, value);

            UpdateCount(word);
        }
    }
}</pre>

<h3></h3>

<h3>Downloads</h3>

<ul>
  <li>The text file used in the code example above: <a title="Grimm&#039;s Fairy Tales" href="http://bit.ly/eMv4dE">grimms-fairy-tales.txt (zipped)</a>. </li>

  <li>The Visual Studio 2010 Solution + files: <a title="ConcurrentDictionary Example Visual Studio Solution" href="http://bit.ly/gRxrb8">ConcurrentDictionaryExample.zip</a>

    <br />Note: This also contains the grimms-fairy-tales.txt file.

    <br />To use: Extract files then open ConcurrentDictionaryExample.sln</li>
</ul>
