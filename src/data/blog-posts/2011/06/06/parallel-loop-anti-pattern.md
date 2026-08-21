---
title: "Parallel Loop Anti-pattern"
slug: parallel-loop-anti-pattern
publishDate: 06 Jun 2011
description: "Here’s a quick parallel loop anti-pattern. In other words, don’t do this, it will only make you miserable. If you want to start tasks in a loop watch out for..."
tags:
  - { name: "Anti-pattern", slug: anti-pattern }
  - { name: "closure", slug: closure }
  - { name: "Parallel.For", slug: parallel-for }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "Task.Factory.StartNew", slug: task-factory-startnew }
---
Here’s a quick parallel loop anti-pattern. In other words, don’t do this, it will only make you miserable.

If you want to start tasks in a loop watch out for including the loop variable as a closure to the task body. For example:

```csharp
Task[] tasks = new Task[20];
for (int i = 0; i < 20; i++)
    tasks[i] = Task.Factory.StartNew(
        () => Console.WriteLine("The loop index is {0}", i));
Task.WaitAll(tasks);
```

What happens is that the variable `i` is updated in each loop iteration. So, the task uses the value of `i` as it is when the task runs. Since the task does not run in the loop (it may run at any time the task schedule sees fit to run the task) the value of `i` could have updated by the time the task actually runs.

In the example program above, my output showed that `i` was 20 for every single iteration. Incidentally, if you are using `i` for an indexer you’ll notice that 20 will be out of range for something with 20 elements (which uses indexes 0 to 19) which just adds to the misery.

If you have something like [ReSharper](http://www.jetbrains.com/resharper/) installed the it will warn you that you “Access to modified closure” and underline the uses of `i` that are affected.

So, if you must use run the body of a loop in parallel you are much better off using [`Parallel.For`](/2011/04/21/parallelisation-talk-examples-parallel-for/ "Parallel.For example") than trying the above.
