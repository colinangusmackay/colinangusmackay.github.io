---
title: "Using semaphores to restrict access to resources"
slug: using-semaphores-to-restrict-access-to-resources
publishDate: 30 Mar 2011
description: "I’m in the process of building a small data extraction application. It uses the new Parallel Extensions in .NET 4 in order to more efficiently extract data..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "Release", slug: release }
  - { name: "Semaphore", slug: semaphore }
  - { name: "synchronisation", slug: synchronisation }
  - { name: "WaitOne", slug: waitone }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I’m in the process of building a small data extraction application. It uses the new Parallel Extensions in .NET 4 in order to more efficiently extract data from a web service. While some threads are blocked waiting on the web service to respond, other threads are working away processing the results of the previous call.</p>  <p>Initially when I set this up I didn’t throttle the calls to the web service. I let everything through. However, in this environment I quickly discovered that I was having to re-try calls a lot because the original call for some data was timing out. When I looked in <a href="http://www.fiddler2.com/fiddler2/" target="_blank">Fiddler</a> to see what was going on I discovered that as I ran the application I was getting over a screen full of started requests that were not finishing or just taking a very long time to complete. I was overloading the server and it couldn’t cope with the volume of requests.</p>  <p>With this in mind I added in some code to the class that initiated the web service calls in order to ensure that it didn’t call the web service too frequently. This is where the semaphores come in to play. </p>  <p>Semaphores are a type of synchronisation mechanism that allow you to limit access to some segment of code. No more than a specified number of threads may enter the segment of code at any one time. If more threads attempt to enter that segment of code than are permitted then any new thread arriving will be forced to wait until access is granted.</p>  <p>I’ll show you what I mean:</p>  

<div class="csharpcode">   
<pre class="alt">
<span class="lnum">   1:  </span><span class="kwrd">public</span> <span class="kwrd">class</span> WebServiceHelper
<span class="lnum">   2:  </span>{
<span class="lnum">   3:  </span>    <span class="kwrd">private</span> <span class="kwrd">static</span> Semaphore pool = <span class="kwrd">new</span> Semaphore(3, 3);
<span class="lnum">   4:  </span>&#160;
<span class="lnum">   5:  </span>    <span class="kwrd">public</span> ResultsData GetData(RequestData request)
<span class="lnum">   6:  </span>    {
<span class="lnum">   7:  </span>        <span class="kwrd">try</span>
<span class="lnum">   8:  </span>        {
<span class="lnum">   9:  </span>            pool.WaitOne();
<span class="lnum">  10:  </span>            <span class="kwrd">return</span> GetDataImpl(request);
<span class="lnum">  11:  </span>        }
<span class="lnum">  12:  </span>        <span class="kwrd">finally</span>
<span class="lnum">  13:  </span>        {
<span class="lnum">  14:  </span>            pool.Release();
<span class="lnum">  15:  </span>        }
<span class="lnum">  16:  </span>    }
<span class="lnum">  17:  </span>&#160;
<span class="lnum">  18:  </span>    <span class="kwrd">private</span> ResultsData GetDataImpl(RequestData request)
<span class="lnum">  19:  </span>    {
<span class="lnum">  20:  </span>        <span class="rem">// Do stuff here</span>
<span class="lnum">  21:  </span>    }
<span class="lnum">  22:  </span>&#160;
<span class="lnum">  23:  </span>}</pre>
</div>

<p>This is just a fragment of the class in order to show just the important bits.</p>

<p>In line 3 we set up the Semaphore as a static, so that all instances of the class can have access to it. It doesn’t need to be a static if you are going to reuse the same instance of the class in many places, but for the purposes of this example I’m using a static.</p>

<p>The Semaphore is initialised with an initial count of 3 (first parameter) which means that there are three resources available currently, and a maximum count&#160; also of 3 (second parameter) which means we can have a maximum of three resources in use at any one time.

<p>In the GetData method (lines 5-16) I wrap the call that does the actual work in a try-finally block. If any exceptions are thrown here is not the place to handle them. The only thing this method should be concerned with is ensuring the resources are properly synchronised. In line 9 we wait for a resource to become available (the first three calls will not block because we’ve started off with three available) but after that calls may block if necessary. On line 10 we call the method that does the actual work we are interested in (this prevents cluttering up one method with the details of the work needing done and the synchronisation code). In the finally block (lines 12 to 15)&#160; we ensure that the resource is released regardless of the ultimate outcome. It doesn’t matter if an exception was thrown or if it was successful we always release the resource back at the end of the operation.</p>

<p>WaitOne (line 9) does have overloads that accept a time to wait either as a TimeSpan or integer representing milliseconds. This means that you can ensure you are not blocking infinitely if an error occurs and the resource is never released.</p>

<p>That just about sums it up. I now have an application that I can parallelise yet ensure that I don’t overload the web server at the same time.</p>

<p>I should also point out that using Semaphores (or any kind of locking or synchronisation method) does reduce the parallelisability of the application, but they can be useful to ensure safe access to data or resources. However, there are also other techniques which help reduce the need for these synchronisation schemes.</p>
