---
title: "Parallelisation Talk Examples – ConcurrentDictionary"
slug: parallelisation-talk-examples-concurrentdictionary
publishDate: 21 Apr 2011
description: "The example used in the talk was one I had already blogged about. The original blog entry the example was based upon is here: Parallelisation in .NET 4.0 – The..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "ConcurrentDictionary", slug: concurrentdictionary }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
---

The example used in the talk was one I had already blogged about. The original blog entry the example was based upon is here: [Parallelisation in .NET 4.0 – The ConcurrentDictionary](/2011/03/24/parallelisation-in-net-4-0-the-concurrent-dictionary/).

### Code Example

```csharp
class Program
{
    private static ConcurrentDictionary<string, int> wordCounts =
        new ConcurrentDictionary<string, int>();

    static void Main(string[] args)
    {
        string[] lines = File.ReadAllLines("grimms-fairy-tales.txt");
        Parallel.ForEach(lines, ProcessLine);

        Console.WriteLine("There are {0} distinct words", wordCounts.Count);
        var topForty = wordCounts.OrderByDescending(kvp => kvp.Value).Take(40);
        foreach (KeyValuePair word in topForty)
        {
            Console.WriteLine("{0}: {1}", word.Key, word.Value);
        }
        Console.ReadLine();
    }

    private static void ProcessLine(string line)
    {
        var words = line.Split(' ')
            .Select(w => w.Trim().ToLowerInvariant())
            .Where(w => !string.IsNullOrEmpty(w));
        foreach (string word in words)
            CountWord(word);
    }

    private static void CountWord(string word)
    {
        if (!wordCounts.TryAdd(word, 1))
            UpdateCount(word);
    }

    private static void UpdateCount(string word)
    {
        int value = wordCounts[word];
        if (!wordCounts.TryUpdate(word, value + 1, value))
        {
            Console.WriteLine("Failed to count '{0}' (was {1}), trying again...",
                word, value);

            UpdateCount(word);
        }
    }
}
```
