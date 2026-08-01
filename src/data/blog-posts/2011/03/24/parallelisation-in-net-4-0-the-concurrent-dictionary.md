---
title: "Parallelisation in .NET 4.0 - The concurrent dictionary"
slug: parallelisation-in-net-4-0-the-concurrent-dictionary
publishDate: 24 Mar 2011
description: "One thing that I was always conscious of when developing concurrent code was that shared state is very difficult to deal with. It still is difficult to deal..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "ConcurrentDictionary", slug: concurrentdictionary }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>One thing that I was always conscious of when developing concurrent code was that shared state is very difficult to deal with. It still is difficult to deal with, however the Parallel extensions have some things to help deal with shared information better and one of them is the subject of this post.</p>  <p>The ConcurrentDictionary has accessors and mutators that “try” and work over the data. If the operation fails then it returns false. If it works you get a true, naturally. To show this, I’ve written a small program that counts the words in <a href="http://www.gutenberg.org/ebooks/2591">Grimm’s Fairy Tales</a> (which I downloaded from the <a href="http://www.gutenberg.org/">Project Gutenberg</a> website) and displayed the top forty most used words.</p>  <p>Here is the program:</p>  
<div class="csharpcode">     
<pre class="alt">
<span class="lnum">   1:  </span><span class="kwrd">class</span> Program
<span class="lnum">   2:  </span>{
<span class="lnum">   3:  </span>    <span class="kwrd">private</span> <span class="kwrd">static</span> ConcurrentDictionary&lt;<span class="kwrd">string</span>, <span class="kwrd">int</span>&gt; wordCounts =
<span class="lnum">   4:  </span>        <span class="kwrd">new</span> ConcurrentDictionary&lt;<span class="kwrd">string</span>, <span class="kwrd">int</span>&gt;();
<span class="lnum">   5:  </span>&#160;
<span class="lnum">   6:  </span>    <span class="kwrd">static</span> <span class="kwrd">void</span> Main(<span class="kwrd">string</span>[] args)
<span class="lnum">   7:  </span>    {
<span class="lnum">   8:  </span>        <span class="kwrd">string</span>[] lines = File.ReadAllLines(<span class="str">&quot;grimms-fairy-tales.txt&quot;</span>);
<span class="lnum">   9:  </span>        Parallel.ForEach(lines, line =&gt; { ProcessLine(line); });
<span class="lnum">  10:  </span>&#160;
<span class="lnum">  11:  </span>        Console.WriteLine(<span class="str">&quot;There are {0} distinct words&quot;</span>, wordCounts.Count);
<span class="lnum">  12:  </span>        var topForty = wordCounts.OrderByDescending(kvp =&gt; kvp.Value).Take(40);
<span class="lnum">  13:  </span>        <span class="kwrd">foreach</span> (KeyValuePair&lt;<span class="kwrd">string</span>, <span class="kwrd">int</span>&gt; word <span class="kwrd">in</span> topForty)
<span class="lnum">  14:  </span>        {
<span class="lnum">  15:  </span>            Console.WriteLine(<span class="str">&quot;{0}: {1}&quot;</span>, word.Key, word.Value);
<span class="lnum">  16:  </span>        }
<span class="lnum">  17:  </span>        Console.ReadLine();
<span class="lnum">  18:  </span>    }
<span class="lnum">  19:  </span>&#160;
<span class="lnum">  20:  </span>    <span class="kwrd">private</span> <span class="kwrd">static</span> <span class="kwrd">void</span> ProcessLine(<span class="kwrd">string</span> line)
<span class="lnum">  21:  </span>    {
<span class="lnum">  22:  </span>        var words = line.Split(<span class="str">' '</span>)
<span class="lnum">  23:  </span>            .Select(w =&gt; w.Trim().ToLowerInvariant())
<span class="lnum">  24:  </span>            .Where(w =&gt; !<span class="kwrd">string</span>.IsNullOrEmpty(w));
<span class="lnum">  25:  </span>        <span class="kwrd">foreach</span> (<span class="kwrd">string</span> word <span class="kwrd">in</span> words)
<span class="lnum">  26:  </span>            CountWord(word);
<span class="lnum">  27:  </span>    }
<span class="lnum">  28:  </span>&#160;
<span class="lnum">  29:  </span>    <span class="kwrd">private</span> <span class="kwrd">static</span> <span class="kwrd">void</span> CountWord(<span class="kwrd">string</span> word)
<span class="lnum">  30:  </span>    {
<span class="lnum">  31:  </span>        <span class="kwrd">if</span> (!wordCounts.TryAdd(word, 1))
<span class="lnum">  32:  </span>            UpdateCount(word);
<span class="lnum">  33:  </span>    }
<span class="lnum">  34:  </span>&#160;
<span class="lnum">  35:  </span>    <span class="kwrd">private</span> <span class="kwrd">static</span> <span class="kwrd">void</span> UpdateCount(<span class="kwrd">string</span> word)
<span class="lnum">  36:  </span>    {
<span class="lnum">  37:  </span>        <span class="kwrd">int</span> <span class="kwrd">value</span> = wordCounts[word];
<span class="lnum">  38:  </span>        <span class="kwrd">if</span> (!wordCounts.TryUpdate(word, <span class="kwrd">value</span> + 1, <span class="kwrd">value</span>))
<span class="lnum">  39:  </span>        {
<span class="lnum">  40:  </span>            Console.WriteLine(<span class="str">&quot;Failed to count '{0}' (was {1}), trying again...&quot;</span>,
<span class="lnum">  41:  </span>                word, <span class="kwrd">value</span>);
<span class="lnum">  42:  </span>&#160;
<span class="lnum">  43:  </span>            UpdateCount(word);
<span class="lnum">  44:  </span>        }
<span class="lnum">  45:  </span>    }
<span class="lnum">  46:  </span>}</pre>
</div>
  


<p>The ConcurrentDictionary is set up in line 3 &amp;4&#160; with the word as the key and the count as the value, but the important part is in the CountWord and UpdateCount methods (starting on line 29 and 35 respectively).</p>

<p>We start by attempting to add a word do the dictionary with a count of 1 (line 31). If that fails then we must have already added the word to the dictionary, in which case we will need to update the existing value (lines 37-44). In order to do that we need to get hold of the existing value (line 37). We can do that with a simple indexer using the word as the key, we then attempt to update the value (line 38). The reason I say we attempt to do that is that there are many threads operating on the same dictionary object and we the update may fail.</p>

<p>The TryUpdate method ensures that you are updating the correct thing as it asks you to pass in the original value and the new value. If someone got there before you (a race condition) the original value will be different to what is currently in the dictionary and the update will not happen. This ensures that the data is consistent.&#160; In our case, we simply try again.</p>

<p>The result of the application is as follows.</p>

<pre>Failed to count 'the' (was 298), trying again...
Failed to count 'the' (was 320), trying again...
Failed to count 'and' (was 337), trying again...
Failed to count 'of' (was 113), trying again...
Failed to count 'the' (was 979), trying again...
Failed to count 'the' (was 989), trying again...
Failed to count 'and' (was 698), trying again...
Failed to count 'well' (was 42), trying again...
Failed to count 'the' (was 4367), trying again...
Failed to count 'and' (was 3463), trying again...
Failed to count 'the' (was 4654), trying again...
Failed to count 'to' (was 1772), trying again...
Failed to count 'the' (was 4798), trying again...
Failed to count 'the' (was 4805), trying again...
Failed to count 'the' (was 4858), trying again...
Failed to count 'her' (was 508), trying again...
Failed to count 'and' (was 3693), trying again...
Failed to count 'and' (was 3705), trying again...
Failed to count 'and' (was 3719), trying again...
Failed to count 'the' (was 4909), trying again...
Failed to count 'she' (was 600), trying again...
Failed to count 'to' (was 1852), trying again...
Failed to count 'curdken' (was 3), trying again...
Failed to count 'the' (was 4665), trying again...
Failed to count 'which' (was 124), trying again...
Failed to count 'the' (was 5361), trying again...
Failed to count 'and' (was 4327), trying again...
Failed to count 'to' (was 2281), trying again...
Failed to count 'they' (was 709), trying again...
Failed to count 'they' (was 715), trying again...
Failed to count 'and' (was 4668), trying again...
Failed to count 'you' (was 906), trying again...
Failed to count 'of' (was 1402), trying again...
Failed to count 'the' (was 6708), trying again...
Failed to count 'and' (was 5149), trying again...
Failed to count 'snowdrop' (was 21), trying again...
Failed to count 'draw' (was 18), trying again...
Failed to count 'he' (was 1834), trying again...
There are 10369 distinct words
the: 7168
and: 5488
to: 2725
a: 1959
he: 1941
of: 1477
was: 1341
in: 1136
she: 1134
his: 1031
that: 1024
you: 981
it: 921
her: 886
but: 851
had: 829
they: 828
as: 770
i: 755
for: 740
with: 731
so: 693
not: 691
said: 678
when: 635
then: 630
at: 628
on: 576
will: 551
him: 544
all: 537
be: 523
have: 481
into: 478
is: 444
went: 432
came: 424
little: 381
one: 358
out: 349</pre>

<p>As you can see in this simple example, a race condition was encountered 38 times.</p>
