---
title: "Tip of the day: Using the null-coalescing operator over the conditional operator"
slug: tip-of-the-day-using-the-null-coalescing-operator-over-the-conditional-operator
publishDate: 25 Jul 2011
description: "I’ve recently been refactoring a lot of code that used the conditional operator and looked something like this: int someValue =..."
tags:
  - { name: "C# 2", slug: c-2 }
  - { name: "C# 3", slug: c-3 }
  - { name: "C# 4", slug: c-4 }
  - { name: "refactoring", slug: refactoring }
---
I’ve recently been refactoring a lot of code that used the [conditional operator](http://msdn.microsoft.com/en-us/library/ty67wk28.aspx) and looked something like this:

```csharp
int someValue = myEntity.SomeNullableValue.HasValue
        ? myEntity.SomeNullableValue.Value
        : 0;
```

That might seem less verbose than the traditional alternative, which looks like this:

```csharp
int someValue = 0;
if (myEntity.SomeNullableValue.HasValue)
    someValue = myEntity.SomeNullableValue.Value;
```

…or other variations on that theme.

However, there is a better way of expressing this. That is to use the [null-coalescing operator](http://msdn.microsoft.com/en-us/library/ms173224.aspx).

Essentially, what is says is that the value on the left of the operator will be used, unless it is null in which case the value ont the right is used. You can also chain them together which effectively returns the first non-null value.

So now the code above looks a lot more manageable and understandable:

```csharp
int someValue = myEntity.SomeNullableValue ?? 0;
```
