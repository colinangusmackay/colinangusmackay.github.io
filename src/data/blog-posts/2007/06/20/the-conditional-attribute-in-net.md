---
title: "The Conditional attribute in .NET"
slug: the-conditional-attribute-in-net
publishDate: 20 Jun 2007
description: "One of the odd thoughts that shoot across my brain today was how does Debug.Assert() work? I mean there are not separate debug and release builds of the .NET..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Debugging", slug: debugging }
---
One of the odd thoughts that shoot across my brain today was how does `Debug.Assert()` work? I mean there are not separate debug and release builds of the .NET Framework so how does it know what sort of build it is?
A quick look in reflector\* revealed that `Debug.Assert` is defined as:

```csharp
[Conditional("DEBUG")]
public static void Assert(bool condition, string message)
{
    TraceInternal.Assert(condition, message);
}
```

Interesting... I don't recall having ever come across the [`[Conditional]`](http://msdn2.microsoft.com/en-us/library/system.diagnostics.conditionalattribute(VS.71).aspx) attribute before.

What this actually does is tell the compiler to only call the method when the supplied preprocessor symbol is defined. The method will still be compiled and will still exist in the assembly. So, in a debug build a program that looks like this:

```csharp
static void Main(string[] args)
{
    Debug.Assert(true, "This condition must be true");
}
```

will still look like that, but when compiled in release mode, will look like this:

```csharp
private static void Main(string[] args)
{
}
```

But what about more complex code. What happens if the method call includes calls to other methods? Like this:

```csharp
static void Main(string[] args)
{
    Debug.Assert(GetTheCondition(), GetTheMessage());
}
```

Those calls will also be removed by the compiler.

So be careful - If the calls made as parameters into a method such as Assert modify state then that won't happen in release mode. For example, if the whole program looks like this:

```csharp
class Program
{
    static int someState = 0;
    static string someOtherState = "123";

    static void Main(string[] args)
    {
        Debug.Assert(GetTheCondition(), GetTheMessage());
        Console.WriteLine("SomeState = {0}", someState);
        Console.WriteLine("SomeOtherState = {0}", someOtherState);
        Console.ReadLine();
    }

    private static string GetTheMessage()
    {
        someOtherState += "abc";
        return someOtherState;
    }

    private static bool GetTheCondition()
    {
        someState++;
        return (someState!=0);
    }
}
```

Then the output from a release build will be different from a debug build.
This is the debug output:

```
SomeState = 1
SomeOtherState = 123abc
```

And this is the release output:

```
SomeState = 0
SomeOtherState = 123
```

### 🔄 Follow up - 9th August 2026

\* 
When this post was originally created Lutz Roeder's Reflector was free. Since then, RedGate bought it and now charge for it. If you want an equivalent free product that does the same thing then have a look at [dotPeek](https://www.jetbrains.com/decompiler/) from JetBrains.