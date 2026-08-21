---
title: "Parallelisation Talk Examples – Basic PLINQ"
slug: parallelisation-talk-examples-basic-plinq
publishDate: 21 Apr 2011
description: "These are some code examples from my introductory talk on Parallelisation showing the difference between a standard sequential LINQ query and its parallel..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "LINQ", slug: linq }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "PLINQ", slug: plinq }
---
These are some code examples from my introductory talk on Parallelisation showing the difference between a standard sequential LINQ query and its parallel equivalent.

The main differences between this and the previous two examples ([Parallel.For](/2011/04/21/parallelisation-talk-examples-parallel-for/ "Parallel.For Parallelisation Talk Example") and [Parallel.ForEach](/2011/04/21/parallelisation-talk-examples-parallel-foreach/ "Parallel.ForEach Parallelisation Talk Example")) is that LINQ (and PLINQ) is designed to return data back, so the LINQ expression uses a `Func<TResult, T1, T2, T3…>` instead of an `Action<T1, T2, T3…>`. Since the examples were simply outputting a string to the Console to indicate which item or index was being processed I’ve changed the code to return a string back to the LINQ expression. The results are then looped over and output to the console.

It is also important to remember that LINQ expressions are not evaluated until the data is called for. In the example below that is with the `.ToList()` method call, however it may also be as a result of `foreach` or any other method of iterating over the expression results.

## Code example 1: Sequential processing of data with LINQ

```csharps
class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        IEnumerable<int> items = Enumerable.Range(0, 20);

        var results = items
            .Select(ProcessItem)
            .ToList();

        results.ForEach(Console.WriteLine);

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine("Finished. Took {0}", duration);

        Console.ReadLine();
    }

    private static string ProcessItem(int item)
    {
        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1100);
        Thread.Sleep(pause);

        return string.Format("Result of item {0}", item);
    }
}
```

The output of the above code may look something like this:

![Basic LINQ](/assets/blog/2011-04-21-parallelisation-talk-examples-basic-plinq-1.webp)

As you can see this takes roughly of 20 seconds to process 20 items with each item taking about one second to process.

## Code Example 2: Parallel processing of data with PLINQ

The `AsParallel` extension method can be found in the `System.Linq` namespace so no additional using statements are needed if you are already using LINQ.

```csharp
class Program
{
    private static Random rnd = new Random();

    static void Main(string[] args)
    {
        DateTime start = DateTime.UtcNow;

        IEnumerable<int> items = Enumerable.Range(0, 20);

        var results = items.AsParallel()
            .Select(ProcessItem)
            .ToList();

        results.ForEach(Console.WriteLine);

        DateTime end = DateTime.UtcNow;
        TimeSpan duration = end - start;

        Console.WriteLine("Finished. Took {0}", duration);

        Console.ReadLine();
    }

    private static string ProcessItem(int item)
    {
        // Simulate similar but slightly variable length processing
        int pause = rnd.Next(900, 1100);
        Thread.Sleep(pause);

        return string.Format("Result of item {0}", item);
    }
}
```

The output of the above code may look something like this:

![Basic PLINQ](/assets/blog/2011-04-21-parallelisation-talk-examples-basic-plinq-2.webp)

The result of this code is that it takes roughly 5 second to process the 20 items. I have a 4 core processor so it would be in line with the expectation that the work is distributed across all 4 cores.
