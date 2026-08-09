---
title: "A start on LINQ"
slug: a-start-on-linq
publishDate: 18 Jun 2007
description: "I was at the Microsoft MSDN Roadshow today and I got to see some of the latest technologies being demonstrated for the first time and I'm impressed. Daniel..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
  - { name: "visual studio", slug: visual-studio }
---

I was at the <a href="http://www.microsoft.com/" target="_blank" title="Microsoft">Microsoft</a> <a href="http://msdn.microsoft.com/" target="_blank" title="MSDN">MSDN</a> Roadshow today and I got to see some of the latest technologies being demonstrated for the first time and I'm impressed.

Daniel Moth's presentation on the Language Enhancements and LINQ was exceptional - It really made me want to be able to use that technology now.

What was interesting was that the new enhancements don't require a new version of the CLR to be installed. It still uses the Version 2.0 CLR. It works by adding additional stuff to the .NET Framework (this is .NET Framework 3.5) and through a new compiler (the C# 3.0 compiler). The C# 3.0 compiler produces IL that runs against CLR 2.0. In essence, the new language enhancements are compiler tricks, which is why the CLR doesn't need to be upgraded. Confused yet?

Now that the version numbers of the various components are diverging it is going to make things slightly more complex. So here is a handy cheat sheet:

|                   |             |             |          |             |             |
|-------------------|-------------|-------------|----------|-------------|-------------|
|                   | **2002**    | **2003**    | **2005** | **2006**    | **2007ish** \* |
| **Tool**          | VS.NET 2002 | VS.NET 2003 | VS 2005  | VS 2005 + Extension |  "Orcas" | 
| **Language (C#)** | v1.0        | v1.1        | v2.0     | v2.0        | v3.0        |
| **Framework**     | v1.0        | v1.1        | v2.0     | v3.0        | v3.5        |
| **Engine (CLR)**  | v1.0        | v1.1        | v2.0     | v2.0        | v2.0        |

The rest of Daniel's talk was incredibly densely packed with information. Suffice to say, at the moment, LINQ is going to provide some excellent and powerful features, however, it will also make it very easy to produce code that is very inefficient if wielded without understanding the consequences. The same can be said of just about any language construct, but LINQ does do a remarkable amount in the background.

After the session I was speaking with Daniel and we discussed the power of the feature and he said that, since C#3.0 produces IL2.0 it is possible to use existing tools, such as Lutz Roeder's Reflector, to see exactly what is happening under the hood. An examination of that will yield a better understanding of how LINQ code is compiler.

LINQ code looks similar to SQL. For example:

```csharp
var result =
    from p in Process.GetProcesses()
    where p.Threads.Count > 6
    orderby p.ProcessName descending
    select p
```

This allows the developer to write set based operations in C# a lot more easily than before. A rough equivalent in C# 2.0 to do the same thing would probably look something like this:

```csharp
List<Process> result = new List<Process>();
foreach(Process p in Process.GetProcesses)
{
    if (p.Threads.Count > 6)
        result.Add(p);
}
result.Sort(new DescendingProcessNameComparer());
```

NOTE: Assumes that `DescendingProcessNameComparer` is an existing comparer that compares two Process objects by their name in descending order.

C# 3.0 introduces the `var` keyword. This is unlike `var` in javascript or VB. It is not a variant type. It is strongly typed and the compiler will complain if it is used incorrectly. For example:

```csharp
var i = 5;
i = "five"; // This will produce a compiler error because i is an integer
```

In short this was only a fraction of what I learned from just one session - I'll continue the update as I can.

### 🔄 Follow up - 9th August 2026

\* It turns out that the following edition of Visual Studio, code names "Orcas" was in fact Visual Studio 2008.