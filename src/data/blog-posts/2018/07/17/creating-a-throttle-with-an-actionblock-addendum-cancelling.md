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
[In my previous post](/2018/07/16/creating-a-throttle-with-actionblock/ "Creating a throttle with an ActionBlock") I described how to create a throttle with an action block so you wouldn't have too many tasks running simultaneously. But what if you want to cancel the tasks?

In our use case, we have a hard-limit of 2 minutes to complete the work (or as much as possible). A typical run will take about 30-40 seconds. Sometimes due to network issues or database issues we can't complete everything in that time, so we have to stop what we're doing and come back later - and hopefully things will be better and we can complete our run.

So, we need to tell the `ActionBlock` to stop processing tasks. To do this we pass it a `CancellationToken`. When we've finished posting work items to the `ActionBlock` we tell the `CancellationTokenSource` to cancel after a set time. We also check the cancellation token from within our task for the cancelled state an exit at appropriately safe points.

```csharp
// Before setting up the ActionBlock create a CancellationTokenSource
CancellationTokenSource cts = new CancellationTokenSource();

// Set up the ActionBlock with the CancellationToken passed in the options
ActionBlock<int> throttle = new ActionBlock<int>(
    action: i=>DoStuff(i),
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
```

The code is available on GitHub: https://github.com/colinangusmackay/ActionBlockThrottle/tree/master/src/04.CancellingTasksInTheActionBlock

## Things to watch for

If you start your timer (When you set `cts.CancelAfter(...)`) before you've posted your work items, it is possible for the cancellation to trigger before you've posted all your work items, in which case you should check the cancellation token as you're posting your work items, otherwise you will be wasting time posting work items that will never be processed.
