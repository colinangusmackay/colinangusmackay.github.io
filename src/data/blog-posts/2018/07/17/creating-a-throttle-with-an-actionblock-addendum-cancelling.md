---
title: "Creating a Throttle with an ActionBlock - Addendum (Cancelling)"
slug: creating-a-throttle-with-an-actionblock-addendum-cancelling
publishDate: 17 Jul 2018
description: "In my previous post I described how to create a throttle with an action block so you wouldn't have too many tasks running simultaneously. But what if you want..."
tags:
  - { name: "ActionBlock", slug: actionblock }
  - { name: "C#", slug: c }
  - { name: "C# 7", slug: c-7 }
  - { name: "Task Parallel Library", slug: task-parallel-library }
  - { name: "TPL", slug: tpl }
---
<!-- TODO: convert this post's content to Markdown -->

<a href="https://colinmackay.scot/2018/07/16/creating-a-throttle-with-actionblock/" title="Creating a throttle with an ActionBlock">In my previous post</a> I described how to create a throttle with an action block so you wouldn't have too many tasks running simultaneously. But what if you want to cancel the tasks? 

In our use case, we have a hard-limit of 2 minutes to complete the work (or as much as possible). A typical run will take about 30-40 seconds. Sometimes due to network issues or database issues we can't complete everything in that time, so we have to stop what we're doing and come back later - and hopefully things will be better and we can complete our run.

So, we need to tell the <code>ActionBlock</code> to stop processing tasks. To do this we pass it a <code>CancellationToken</code>. When we've finished posting work items to the <code>ActionBlock</code> we tell the <code>CancellationTokenSource</code> to cancel after a set time. We also check the cancellation token from within our task for the cancelled state an exit at appropriately safe points.

<pre>
// Before setting up the ActionBlock create a CancellationTokenSource
CancellationTokenSource cts = new CancellationTokenSource();

// Set up the ActionBlock with the CancellationToken passed in the options
ActionBlock&lt;int&gt; throttle = new ActionBlock&lt;int&gt;(
    action: i=&gt;DoStuff(i),
    dataflowBlockOptions: new ExecutionDataflowBlockOptions
    {
        MaxDegreeOfParallelism = 3,
        CancellationToken = cts.Token
    });

// ...Other code  to post work items to the action block...

// After posting the work items, set the timeout in ms.
cts.CancelAfter(2000);

// Wrap the await up to catch the cancellation
Task completionTask = throttle.Completion;
try
{
    await completionTask;
}
catch (TaskCanceledException e)
{
    Console.WriteLine(e);
}
</pre>

<small>The code is available on GitHub: https://github.com/colinangusmackay/ActionBlockThrottle/tree/master/src/04.CancellingTasksInTheActionBlock</small>

<h2>Things to watch for</h2>

If you start your timer (When you set <code>cts.CancelAfter(...)</code>) before you've posted your work items, it is possible for the cancellation to trigger before you've posted all your work items, in which case you should check the cancellation token as you're posting your work items, otherwise you will be wasting time posting work items that will never be processed.
