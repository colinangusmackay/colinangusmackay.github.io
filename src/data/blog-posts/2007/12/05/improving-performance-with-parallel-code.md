---
title: "Improving performance with parallel code"
slug: improving-performance-with-parallel-code
publishDate: 05 Dec 2007
description: "While waiting for my car to get serviced today I finally managed to catch up on reading some articles in MSDN Magazine. One of them, on optimising managed code..."
tags:
  - { name: ".NET", slug: net }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

While waiting for my car to get serviced today I finally managed to catch up on reading some articles in MSDN Magazine. One of them, on <a href="http://msdn.microsoft.com/msdnmag/issues/07/10/Futures/default.aspx" target="_blank">optimising managed code for multi-core machines</a>, really caught my attention.

The article was about a new technology from Microsoft called Parallel Extensions to .NET Framework 3.5 (<a href="http://www.microsoft.com/downloads/details.aspx?FamilyID=e848dc1d-5be3-4941-8705-024bc7f180ba&amp;displaylang=en" target="_blank">download</a>) which is currently released as a Community Technology Preview (CTP) at the moment. The blurb on the Microsoft site says "Parallel Extensions to the .NET Framework is a managed programming model for data parallelism, task parallelism, and coordination on parallel hardware unified by a common work scheduler."

What I was most excited about was the ease with which it becomes possible to make an algorithm take advantage of multiple cores without all that tedious mucking about with threadpools. From what I gather the extensions are able to optimise the parallelism across the available cores. A looping construct can be set up across many cores and each thread is internally given a queue of work to do. If a thread finishes before others it can take up the slack by taking some work from another thread's work queue.

Obviously, if an algorithm never lent itself well to parallelism in the first place these extensions won't help much. Also the developer is still going to have to deal with concurrent access to shared resources so it is not a panacea. Those caveats aside these extensions to the .NET will make the job of using multi-core machines to their best much easier.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:e81f5d66-58e0-4f81-8951-f7d311553577" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/.NET%203.5">.NET 3.5</a>,<a rel="tag" href="http://technorati.com/tags/parallel%20extensions">parallel extensions</a>,<a rel="tag" href="http://technorati.com/tags/microsoft">microsoft</a>,<a rel="tag" href="http://technorati.com/tags/microsoft%20research">microsoft research</a>,<a rel="tag" href="http://technorati.com/tags/concurrency">concurrency</a>,<a rel="tag" href="http://technorati.com/tags/ctp">ctp</a></div>
