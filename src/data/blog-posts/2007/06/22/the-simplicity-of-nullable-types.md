---
title: "The simplicity of nullable types"
slug: the-simplicity-of-nullable-types
publishDate: 22 Jun 2007
description: "I just discovered nullable types. Wow! They are really simple and such a powerful feature. Just see for yourself.... If you have an int or a DateTime or any..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 2", slug: c-2 }
---
I just discovered nullable types. Wow! They are really simple and such a powerful feature. Just see for yourself....

If you have an `int` or a `DateTime` or any other value type you'll already know that you cannot assign `null` to them. But in C#2.0 you can.

You can define a nullable `int` by adding a question mark to the end of the type like this:

```csharp
int? a = null;
```

However, you'll want the new code to operate with old code which hasn't yet been upgraded to use nullable types, so there is a new binary operator to help. The `??` (I've no idea how your meant to pronounce that. I just say "Double question mark")

So, if you want to assign `a` (above) to a regular `int` you can do the following:

```csharp
int b = a ?? -1;
```

If `a` is non-`null` then `b` is assigned the same value as `a`. If a is `null` then `b` is assigned the value on the right side of the `??`. So, just like the old days where you'd make up a value to represent `null` for an integer (I normally used `int.MinValue`)

*NOTE: This was rescued from the google cache. The original date was Friday, 9th June, 2006.*
