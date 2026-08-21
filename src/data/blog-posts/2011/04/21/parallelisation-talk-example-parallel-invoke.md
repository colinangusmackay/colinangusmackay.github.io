---
title: "Parallelisation Talk Example – Parallel.Invoke"
slug: parallelisation-talk-example-parallel-invoke
publishDate: 21 Apr 2011
description: "Parallel.Invoke is the most basic way to start many tasks as the same time. The method takes as many Action<…> based delegates as needed. The Task Parallel..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Parallel.Invoke. Task.Factory.StartNew", slug: parallel-invoke-task-factory-startnew }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "Task.WaitAll", slug: task-waitall }
---
`Parallel.Invoke` is the most basic way to start many tasks as the same time. The method takes as many `Action<…>` based delegates as needed. The Task Parallel Library takes care of the actual scheduling, degree of parallelism etc. `Parallel.Invoke` itself blocks until all the tasks have completed.

In this example there are two tasks that simply output numbers and letters to the console. One task takes slightly longer than the other. The output shows each task as it runs along with an indication of when it finishes, as well as the overall program finishes.

### Code Example One

```csharp
class Program
{
    static void Main(string[] args)
    {
        // Start two tasks in parallel
        Parallel.Invoke(TaskOne, TaskTwo);

        Console.WriteLine("Finished");
        Console.ReadLine();
    }

    // This task simple outputs the numbers 0 to 9
    private static void TaskOne()
    {
        for (int i = 0; i < 10; i++)
        {
            Console.WriteLine("TaskOne: {0}", i);
            Thread.Sleep(10);
        }
        Console.WriteLine("TaskOne Finished");
    }

    // This task simply outputs the letters A to K
    private static void TaskTwo()
    {
        for(char c = 'A'; c < 'K'; c++)
        {
            Console.WriteLine("TaskTwo: {0}", c);
            Thread.Sleep(5);
        }
        Console.WriteLine("TaskTwo Finished");
    }
}
```

### Example output

![Parallel.Invoke Example](/assets/blog/2011-04-21-parallelisation-talk-example-parallel-invoke-1.webp)

```
TaskOne: 0
TaskTwo: A
TaskOne: 1
TaskTwo: B
TaskTwo: C
TaskTwo: D
TaskOne: 2
TaskTwo: E
TaskOne: 3
TaskTwo: F
TaskTwo: G
TaskTwo: H
TaskOne: 4
TaskTwo: I
TaskTwo: J
TaskOne: 5
TaskTwo Finished
TaskOne: 6
TaskOne: 7
TaskOne: 8
TaskOne: 9
TaskOne Finished
Finished
```

### Code Example: Variation using Task.Factory.StartNew

The `Parallel.Invoke` method is equivalent setting up a number of tasks using `Task.Factory.StartNew(…)` then `Task.WaitAll(…)`.

The following code example shows the same code (`Main` method only) but using `Task.Factory.StartNew`:

```csharp
static void Main(string[] args)
{
    // Start two tasks in parallel
    Task t1 = Task.Factory.StartNew(TaskOne);
    Task t2 = Task.Factory.StartNew(TaskTwo);
    Task.WaitAll(t1, t2);

    Console.WriteLine("Finished");
    Console.ReadLine();
}
```
