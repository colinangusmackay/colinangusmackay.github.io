---
title: "Parallelisation Talk Examples – Parallel.ForEach"
slug: parallelisation-talk-examples-parallel-foreach
publishDate: 21 Apr 2011
description: "These are some code examples from my introductory talk on Parallelisation. Showing the difference between a standard sequential foreach loop and its parallel..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Parallel.ForEach", slug: parallel-foreach }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---
These are some code examples from my introductory talk on Parallelisation. Showing the difference between a standard sequential foreach loop and its parallel equivalent.

## Code example 1: Serial processing of a foreach loop

```csharp
class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        IEnumerable items = Enumerable.Range(0,20);

        foreach(int item in items)
            ProcessLoop(item);

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine("Finished. Took {0}", duration);

        Console.ReadLine();
    }

    private static void ProcessLoop(int item)
    {
        Console.WriteLine("Processing item {0}", item);

        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1100);
        Thread.Sleep(pause);
    }
}
```

The output of the above code may look something like this:

![Sequential foreach Example](/assets/blog/2011-04-21-parallelisation-talk-examples-parallel-foreach-1.webp)

As you can see this takes roughly of 20 seconds to process 20 items with each item taking about one second to process.

## Code Example 2: Parallel processing of a foreach loop

The `Parallel` class can be found in the `System.Threading.Tasks` namespace.

```csharp
class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        IEnumerable items = Enumerable.Range(0,20);

        Parallel.ForEach(items,
            (item) => ProcessLoop(item));

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine("Finished. Took {0}", duration);

        Console.ReadLine();
    }

    private static void ProcessLoop(int item)
    {
        Console.WriteLine("Processing item {0}", item);

        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1100);
        Thread.Sleep(pause);
    }
}
```

The output of the above code may look something like this:

![Parallel.ForEach](/assets/blog/2011-04-21-parallelisation-talk-examples-parallel-foreach-2.webp)

The result of this code is that it takes roughly 5 second to process the 20 items. I have a 4 core processor so it would be in line with the expectation that the work is distributed across all 4 cores.
