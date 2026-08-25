---
title: "Round Robin class"
slug: round-robin-class
publishDate: 24 Sep 2016
description: "We recently had need of a round robin functionality and since there is no round robin class built into .NET I needed to build my own class. It is a fairly..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 6", slug: c-6 }
  - { name: "round robin", slug: round-robin }
---
We recently had need of a round robin functionality and since there is no round robin class built into .NET I needed to build my own class.

It is a fairly simple algorithm, each call returns the next item in the sequence. When the end of the sequence is reached go back to the beginning and start over.

In our case, we also needed it to be thread safe as we were calling it from tasks that are running in parallel.

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

namespace Xander.RoundRobin
{
    public class RoundRobin<T>
    {
        private readonly T[] _items;
        private readonly object _syncLock = new object();

        private int _currentIndex = -1;

        public RoundRobin(IEnumerable<T> sequence)
        {
            _items = sequence.ToArray();
            if (_items.Length == 0)
                throw new ArgumentException("Sequence contains no elements.", nameof(sequence));
        }

        public T GetNextItem()
        {
            lock (this._syncLock)
            {
                _currentIndex++;
                if (_currentIndex >= _items.Length)
                    _currentIndex = 0;
                return _items[_currentIndex];
            }
        }
    }
}
```

To use the class you can create it like this:

```csharp
var rr = new RoundRobin<int>(items);
```

(Replacing `int` with the type you need)
And to retrieve the next item in the sequence, call

```csharp
var item = rr.GetNextItem();
```

I've got a few ideas for features to add as well, so I've put [this code on GitHub](https://github.com/colinangusmackay/RoundRobin) and I'll be creating a NuGet package when I've got the time.
