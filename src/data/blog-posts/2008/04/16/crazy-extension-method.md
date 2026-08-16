---
title: "Crazy Extension Method"
slug: crazy-extension-method
publishDate: 16 Apr 2008
description: "Here is an example of a crazy extension method that alters the semantics of method calling. First the extension method: public static class MyExtensions {..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "error handling", slug: error-handling }
  - { name: "Extension Methods", slug: extension-methods }
---

Here is an example of a crazy extension method that alters the semantics of method calling.

First the extension method:

```csharp
public static class MyExtensions
{
    public static bool IsNullOrEmpty(this string target)
    {
        return string.IsNullOrEmpty(target);
    }
}
```

Instead of calling the static method `IsNullOrEmpty()` on string, we are turning it around to allow it to be called on a string type like an instance method. However, as you can probably tell, it may be called when the reference to the string is null. Normally this would result in an exception to say that you are attempting to call a method on a null value. However, this is an extension method and it actually works with nulls! This is probably not the best idea in the world, to be diplomatic about it.

Here is some calling code:

```csharp
string a = null;
Console.WriteLine(a.IsNullOrEmpty());
```

Normally, an exception will be thrown if IsNullOrEmpty() is a real method. However, it isn't in this case and the application happily writes "True" to the console.
 