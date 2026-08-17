---
title: "Tip of the day - String Equality"
slug: tip-of-the-day-13-string-equality
publishDate: 12 Jul 2009
description: "When comparing two strings in a case insensitive manner, use: myFirstString.Equals(mySecondString, StringComparison.InvariantCultureIgnoreCase) or, if cultural..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---

When comparing two strings in a case insensitive manner, use:

```csharp
myFirstString.Equals(mySecondString, StringComparison.InvariantCultureIgnoreCase)
```

or, if cultural rules are to be ignored completely\* then use:

```csharp
myFirstString.Equals(mySecondString, StringComparison.OrdinalIgnoreCase)
```

over:

```csharp
myFirstString.ToLower() == mySecondString.ToLower()
```

\* The invariant culture is actually a non-region specific English language culture. The ordinal comparison is faster than any culture specific comparison as it uses a much simpler comparison algorithm.
