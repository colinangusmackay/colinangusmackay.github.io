---
title: "Parallel Tasks and the HttpContext"
slug: parallel-tasks-and-the-httpcontext
publishDate: 24 May 2011
description: "A few days ago I spotted a question on StackOverflow by someone trying to use a parallel loop in an ASP.NET application. It may have been an ASP.NET MVC..."
tags:
  - { name: ".NET", slug: net }
  - { name: "asp.net", slug: asp-net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "C#", slug: c }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>A few days ago I spotted a question on StackOverflow by someone trying to use a parallel loop in an ASP.NET application. It may have been an ASP.NET MVC application (I don’t recall) but the issue is the same.</p>  <p>This person had some code in a parallel task that was using the <code>HttpContext</code> object. I would be hesitant to use that object in the first instance as I don’t know how thread safe it is. I suspect that since it holds a lot of information about the state of a request/response that it would be quite dangerous to access an instance in many threads. </p>  <p>His main issue what that he was getting a <code>null</code> back from <code>HttpContext.Current</code> inside the parallel tasks.</p>  <p>ASP.NET is already multithreaded. It abstracts most of that away so that when you are writing against it you only really ever see the request you are currently dealing with. Many other requests are happening around you, but the framework does its best to shield you from that so that you can write code cleanly. It is also its downfall in some cases.</p>  <p>If you don’t realise what the framework is doing for you then you could very easily fall into a number of traps when you get to the edges of that abstraction. So, when someone uses <code>HttpContext.Current</code> inside parallel tasks not realising that there must already by multiple requests being handled, and therefore there must be multiple simultaneous <code>HttpContext</code> objects floating around masquerading as the <code>Current</code> context. It can become very difficult to track down bugs if you know what the constraints of what <code>Current</code> means in this... erm... context.</p>  <p>Ultimately, <code>HttpContext.Current</code> is only available on the thread that you started with in ASP.NET. If you create new threads then it is no longer available unless you explicitly set it yourself.</p>
