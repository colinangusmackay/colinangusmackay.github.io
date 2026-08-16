---
title: "Fizz-Buzz in LINQ"
slug: fizzbuzz-in-linq
publishDate: 16 Apr 2008
description: "This just occurred to me. It is somewhat pointless, but I thought it was interesting: static void Main( string [] args) { var result = from say in Enumerable..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
---

This just occurred to me. It is somewhat pointless, but I thought it was interesting:

```csharp
static void Main(string[] args)
{
    var result = from say in Enumerable.Range(1, 100)
                 select (say % 15 == 0)
                         ? "BuzzFizz"
                         : (say % 5 == 0)
                            ? "Buzz"
                            : (say % 3 == 0)
                               ? "Fizz"
                               : say.ToString();
    foreach (string say in result)
        Console.WriteLine(say);
}
```

Or, without the LINQ syntax, just the methods:

```csharp
static void Main(string[] args)
{
    var result = Enumerable.Range(1, 100)
      .Select(say => (say % 15 == 0)
                      ? "BuzzFizz"
                      : (say % 5 == 0)
                         ? "Buzz"
                         : (say % 3 == 0)
                            ? "Fizz"
                           : say.ToString();
    foreach (string say in result)
        Console.WriteLine(say);
}
```