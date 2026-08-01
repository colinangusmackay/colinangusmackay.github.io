---
title: "Tasks that create more work"
slug: tasks-that-create-more-work
publishDate: 01 Apr 2011
description: "I’m creating a program that parses a web page then follows the links and then parses the next set of web pages to eventually build a picture of an entire site...."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "ConcurrentDictionary", slug: concurrentdictionary }
  - { name: "ConcurrentQueue", slug: concurrentqueue }
  - { name: "Parallel.ForEach", slug: parallel-foreach }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "TaskCreationOptions", slug: taskcreationoptions }
  - { name: "Tasks", slug: tasks }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I’m creating a program that parses a web page then follows the links and then parses the next set of web pages to eventually build a picture of an entire site. This means that as the program runs more work is being generated and more tasks can be launched to process each new page as it is discovered.</p>  <p>My original solution was simply to create code like this:</p>  
<div class="csharpcode">   
  <pre class="alt">
  <span class="lnum">   1:  </span><span class="kwrd">private</span> <span class="kwrd">void</span> ProcessLink(<span class="kwrd">string</span> link)
  <span class="lnum">   2:  </span>{
  <span class="lnum">   3:  </span>    var page = GetPageInformation(link);
  <span class="lnum">   4:  </span>    var newLinks = GetNewLinks(page);
  <span class="lnum">   5:  </span>&#160;
  <span class="lnum">   6:  </span>    <span class="kwrd">foreach</span>(var newLink <span class="kwrd">in</span> newLinks)
  <span class="lnum">   7:  </span>    {
  <span class="lnum">   8:  </span>        Action action = () =&gt; {  ProcessLink(newLink); };
  <span class="lnum">   9:  </span>        Task.Factory.StartNew(action, TaskCreationOptions.AttachedToParent);
  <span class="lnum">  10:  </span>    }
  <span class="lnum">  11:  </span>}</pre>
</div>

<p>The premise is simple enough, build a list of new links from a page then for each of the new links start a new task. The new task is attached to the parent task (the task that is launching the new set of tasks)</p>

<p>However, it soon became apparent that this was quickly getting out of control and I had no idea what was still waiting to be processed, or that the same link was being queue up multiple times in many different threads and so on. I ended up putting in place so many mechanisms to prevent the code processing the same page over again in different threads that it was getting silly. For a small number of new tasks being launched, I’m sure that Task.Factory.StartNew() is perfectly suitable.</p>

<p>I eventually realised that I was heading down the wrong way and I needed to rethink my strategy altogether. I wanted to make the code parallelisable so that while I was waiting on one page I could be parsing and processing another page. So, I eventually refactored it to this:</p>

<div class="csharpcode">
  <pre class="alt"><span class="lnum">   1:  </span><span class="kwrd">public</span> <span class="kwrd">class</span> SiteScraper
  <span class="lnum">   2:  </span>{
  <span class="lnum">   3:  </span>    <span class="kwrd">private</span> ConcurrentDictionary&lt;<span class="kwrd">string</span>, ScraperResults&gt; completedWork = 
  <span class="lnum">   4:  </span>        <span class="kwrd">new</span> ConcurrentDictionary&lt;<span class="kwrd">string</span>, ScraperResults&gt;();
  <span class="lnum">   5:  </span>&#160;
  <span class="lnum">   6:  </span>    <span class="kwrd">private</span> List&lt;<span class="kwrd">string</span>&gt; currentWork;
  <span class="lnum">   7:  </span>&#160;
  <span class="lnum">   8:  </span>    <span class="kwrd">private</span> ConcurrentQueue&lt;<span class="kwrd">string</span>&gt; futureWorkQueue = 
  <span class="lnum">   9:  </span>        <span class="kwrd">new</span> ConcurrentQueue&lt;<span class="kwrd">string</span>&gt;();
  <span class="lnum">  10:  </span>&#160;
  <span class="lnum">  11:  </span>    <span class="kwrd">public</span> <span class="kwrd">void</span> GetSiteInformation(<span class="kwrd">string</span> startingUrl)
  <span class="lnum">  12:  </span>    {
  <span class="lnum">  13:  </span>        currentWork = <span class="kwrd">new</span> List&lt;<span class="kwrd">string</span>();
  <span class="lnum">  14:  </span>        currentWork.Add(startingUrl.ToLowerInvariant());
  <span class="lnum">  15:  </span>&#160;
  <span class="lnum">  16:  </span>        <span class="kwrd">while</span>(currentWork.Any())
  <span class="lnum">  17:  </span>        {
  <span class="lnum">  18:  </span>            Parallel.ForEach(currentWorkQueue, item =&gt; GetPageInformation(item));
  <span class="lnum">  19:  </span>            BuildWorkQueue();
  <span class="lnum">  20:  </span>        }
  <span class="lnum">  21:  </span>    }
  <span class="lnum">  22:  </span>&#160;
  <span class="lnum">  23:  </span>    <span class="kwrd">private</span> <span class="kwrd">void</span> BuildWorkQueue()
  <span class="lnum">  24:  </span>    {
  <span class="lnum">  25:  </span>        currentWork = <span class="kwrd">new</span> List&lt;<span class="kwrd">string</span>&gt;(futureWorkQueue
  <span class="lnum">  26:  </span>            .Select(link =&gt; link.ToLowerInvariant()).Distinct()
  <span class="lnum">  27:  </span>            .Where(link =&gt; IsLinkToBeProcessed(link)));
  <span class="lnum">  28:  </span>&#160;
  <span class="lnum">  29:  </span>        futureWorkQueue = <span class="kwrd">new</span> ConcurrentQueue&lt;<span class="kwrd">string</span>&gt;();
  <span class="lnum">  30:  </span>    }
  <span class="lnum">  31:  </span>&#160;
  <span class="lnum">  32:  </span>    <span class="kwrd">private</span> <span class="kwrd">void</span> GetPageInformation(<span class="kwrd">string</span> url)
  <span class="lnum">  33:  </span>    {
  <span class="lnum">  34:  </span>        <span class="rem">// Do stuff</span>
  <span class="lnum">  35:  </span>        ProcessNewLinks(newLinks)
  <span class="lnum">  36:  </span>    }
  <span class="lnum">  37:  </span>&#160;
  <span class="lnum">  38:  </span>    <span class="kwrd">private</span> <span class="kwrd">void</span> ProcessNewLinks(IEnumerable&lt;<span class="kwrd">string</span>&gt; newLinks)
  <span class="lnum">  39:  </span>    {
  <span class="lnum">  40:  </span>        <span class="kwrd">foreach</span> (<span class="kwrd">string</span> url <span class="kwrd">in</span> newLinks.Where(l =&gt; IsLinkToBeProcessed(l)))
  <span class="lnum">  41:  </span>        {
  <span class="lnum">  42:  </span>            futureWorkQueue.Enqueue(url);
  <span class="lnum">  43:  </span>        }
  <span class="lnum">  44:  </span>    }
  <span class="lnum">  45:  </span>&#160;
  <span class="lnum">  46:  </span>&#160;
  <span class="lnum">  47:  </span>    <span class="rem">// Other bits</span>
  <span class="lnum">  48:  </span>&#160;
  <span class="lnum">  49:  </span>}</pre>
</div>

<p>There is still some code to ensure duplicates are removed and not processed, but it become much easier to debug and know what has been processed and what is still to be processed than it was before.</p>

<p>The method GetSiteInformation (lines 11-21) handles the main part of the parallelisation. This is the key to this particular algorithm.</p>

<p>Before discussing what that does, I just want to explain the three collections set up as fields on the class (lines 3 to 9). The completedWork is a dictionary keyed on the url containing an object graph representing the bits of the page we are interested in. The currentWork (line 6) is a list of the current urls that are being processed. Finally, the futureWorkQueue contains a queue of all the new links that are discovered, which will feed into the next iteration.</p>

<p>The GetSiteInformation class creates the initial list of currentWork and processes it using Parallel.ForEach (line 18). On the first iteration only one item will be processed, but it should result in many new links to be processed. A call to BuildWorkQueue builds the new work queue for the next iteration which is controlled by the while loop (lines 16-20). When BuildWorkQueue creates no new items for the workQueue then the work is complete and the while loop exits.</p>

<p>BuildWorkQueue is called when all the existing work is completed. It then builds the new set of urls to be processed. The futureWorkQueue is the collection that was populated when the links get processed (see later). All the links are forced into lower case (while this may not be advisable for all websites, for my case it is sufficient), only distinct elements are processed as the futureWorkQueue could quite easily have been filled with duplicates and finally a check is made to ensure that the link has not already been processed (lines 25-27).</p>

<p>During the processing of a specific URL (lines 32-36 – mostly not shown) new links may be generated. Each of these will be be added to the futureWorkQueue (lines 40-43). Before enqueuing any link a check is made to ensure it has not already been processed.</p>

<p>There are other bits of the class that are not shown. For example the IsLinkToBeProcessed method (which checks the domain, whether it has been processed already and so on) and the code that populates the completedWork.</p>

<p>In this version of the code it is much easier to see what has been completed and what is still to do (or at least, what has been found to do).</p>
