---
title: "Task status state changes"
slug: task-status-state-changes
publishDate: 03 Jun 2011
description: "Over the course of the last couple of months I’ve blogged a lot about the Task Parallel Library and mentioned a number of statuses that a task can have, but..."
tags:
  - { name: "AggregateException", slug: aggregateexception }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "TaskCanceledException", slug: taskcanceledexception }
  - { name: "Tasks", slug: tasks }
---
Over the course of the last couple of months I’ve blogged a lot about the Task Parallel Library and mentioned a number of statuses that a task can have, but nowhere is a nice handy-dandy chart to show what those statuses are and how the transition from one to another. The green status show the normal line that most tasks will take. The purple and red show alternative paths that may be taken.

![](/assets/blog/2011-06-03-task-status-state-changes-1.webp)

When a task is first created it status is `Created` – however you will almost never see this. This status only exists when you create a task using its constructor. Most of the time you would create tasks with `Task.Factory.StartNew(…)`

When you start a task the status will be `WaitingToRun` until such time as the task scheduler can actually run the task. For some tasks the transition will be almost instant, for others it will mean a wait while other tasks complete.

From `WaitingToRun` a task can transition to either `Running` or `Cancelled`. The latter transition happens if the cancellation token is signalled before the task gets a chance to start.

Once a task is running there are three possible exits for it. The normal exit is for the status to transition to `RanToCompletion` which means that the task completed without incident. The other two exits require exception handling in the calling code.

If an error happens that the task cannot (or does not) handle internally then it will transition to `Faulted` (see [Tasks that throw exceptions](/2011/05/16/tasks-that-throw-exceptions/)). The `AggregateException` will contain details of all the exceptions in `Faulted` tasks as part of its `InnerExceptions` collection.

If the tasks are cancelled, any task that has not already completed will transition immediately to `Cancelled`. An `AggregateException` will contain details of all tasks that were cancelled (whether they had a chance to run or not) with `TaskCanceledException` inner exceptions. The exception to this is any task that was running already when the cancellation token was signalled and either ran to completion normally, or did not respond correctly to the cancellation request (see [Cancelling parallel tasks](/2011/06/03/cancelling-parallel-tasks/)).
