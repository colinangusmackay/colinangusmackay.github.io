---
title: "Code Review: FirstOrDefault()"
slug: code-review-firstordefault
publishDate: 09 Apr 2015
description: "I regularly review the code that I maintain. Recently, I've come across code like this fairly often: someCollection.FirstOrDefault().Id I cannot rightly..."
tags:
  - { name: "C#", slug: c }
  - { name: "Code Quality", slug: code-quality }
  - { name: "FirstOrDefault", slug: firstordefault }
  - { name: "LINQ", slug: linq }
---
I regularly review the code that I maintain. Recently, I've come across code like this fairly often:

```csharp
someCollection.FirstOrDefault().Id
```

I cannot rightly comprehend why anyone would do this.

`FirstOrDefault()` returns the first item in a sequence or the default value if it doesn’t exist (i.e. the sequence is empty). For a reference type (classes, basically) the default value is `null`. So using the value returned by `FirstOrDefault()` without a `null` check is only valid for when the sequence contains a value type (e.g. `int`, `decimal`, `DateTime`, `Guid`, etc.)

In the example above if `someCollection` is an empty list/array/collection/whatever then `FirstOrDefault()` will return `null` and the call to the `Id` property will fail.

Then you are left with a `NullReferenceException` on line xxx but you don’t know if it is `someCollection`, or the returned value from `FirstOrDefault()` which then wastes your time (or the time of someone else who is having to debug it).

So, if the sequence must always contain items then use `First()`, in the exceptional event that it is empty the call to `First()` will throw a more appropriate exception that will help you debug faster. If it is perfectly valid for the sequence to be empty then perform a `null` check and change the behaviour appropriately.
