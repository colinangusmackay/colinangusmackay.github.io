---
title: "Extensions Methods"
slug: method-extensions
publishDate: 18 Jun 2007
description: "There have been many times a class has needed to be extended, but the additional code just doesn't sit right on the class itself, or I don't have access to the class..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "Extension Methods", slug: extension-methods }
  - { name: "visual studio", slug: visual-studio }
---

I've been looking at more of the language enhancements in C# 3.0. In this post I'm going to look at Extensions.

There have been many times a class has needed to be extended, but the additional code just doesn't sit right on the class itself, or I don't have access to the class. In that case a utility or helper class is created to help carry out these tasks without impacting the main class the helper operates on. It may be because the method requires access to classes that would tightly couple the main class to others.

It is important to remember that the extension method, like any method on a helper or utility class, cannot access the private or protected members of the class it is helping.

For example, take the children's game Fizz-Buzz which seems to be undergoing a resurgence at the moment. The rules for the method are simple. The program counts from 1 to 100 replacing any value that is divisible by 3 with Fizz and any value that is divisible by 5 with Buzz. If a value happens to be divisible by both 3 and 5 then the output is FizzBuzz. For any other value the number is output.

First here is the version without the extensions:

```csharp
public static class FizzBuzzHelper
{
    public static string FizzBuzz(int number)
    {
        if ((number % 5) == 0)
        {
            if ((number % 3) == 0)
                return "FizzBuzz";
            return "Buzz";
        }
        if ((number % 3) == 0)
        {
            return "Fizz";
        }
        return number.ToString();
    }
}

class Program
{
    static void Main(string[] args)
    {
        for (int i = 1; i <= 100; i++)
        {
            Console.WriteLine(FizzBuzzHelper.FizzBuzz(i));
        }
        Console.ReadLine();
    }
}
```

And now the version with the extensions:

```csharp
public static class FizzBuzzHelper
{
    public static string FizzBuzz(this int number)
    {
        if ((number % 5) == 0)
        {
            if ((number % 3) == 0)
                return "FizzBuzz";
            return "Buzz";
        }
        if ((number % 3) == 0)
        {
            return "Fizz";
        }
        return number.ToString();
    }
}

class Program
{
    static void Main(string[] args)
    {
        for (int i = 1; i <= 100; i++)
        {
            Console.WriteLine(i.FizzBuzz());
        }
        Console.ReadLine();
    }
}
```

There aren't actually that many changes (and the example is somewhat trivial).

First, in the extension method, the `this` keyword is placed before the parameter. It indicates that the extension will go on the `int` (technically the `System.Int32`) class.

Second, when the extension method is called there is no reference to the utility class. It is simply called as it it were a method on the class (in this case `Int32`). Also, note that the parameter is not needed because it is implied by the object on which the extension method is applied.

Lutz Roeder's reflector is already conversant with extension methods so the compiler trickery cannot be seen in the C# view of the method. However, the IL reveals that deep down it is just making the call as before. The following is the extension version:

```csharp
L_0007: call string ConsoleApplication3.FizzBuzzHelper::FizzBuzz(int32)
L_000c: call void [mscorlib]System.Console::WriteLine(string)
```

And this is the old-style helper method call:

```csharp
L_0007: call string ConsoleApplication3.FizzBuzzHelper::FizzBuzz(int32)
L_000c: call void [mscorlib]System.Console::WriteLine(string)
```

They are identical. So, how does the compiler tell what it needs to be doing?

The method header for the regular helper method:

```csharp
.method public hidebysig static string FizzBuzz(int32 number) cil managed
{
```

The method header for the extension method:

```csharp
.method public hidebysig static string FizzBuzz(int32 number) cil managed { .custom instance void [System.Core]System.Runtime.CompilerServices.ExtensionAttribute::.ctor()
```

And that's it. C# just hides the need for the `ExtensionAttribute.` In VB the attribute needs to be explicitly declared on the method.

Intellisense also helps out with extensions. Each extension method appears in the intellisense on the object it is extending. To ensure that the developer is aware that it is an extension the icon in the list has a blue arrow and the tool tip is prefixed with “(extension)”

<img src="/assets/blog/2007-06-18-method-extensions-1.webp" width="699" height="525" alt="orcas-extensions-intellisense" />]

It is also possible to create extension methods that take more than one parameter. For example:

```csharp
public static class PasswordHashHelper
{
    public static byte[] HashPassword(this string password, byte[] salt)
    {
        // Implementation here
    }
}
```

It is important to note that the this modifier can only be placed on the first parameter. To do otherwise would generate the compiler error “Method '{method name}' has a parameter modifier 'this' which is not on the first parameter”
The above multi parameter extension method can then be used like this:

```csharp
byte[] hashedPassword = plainTextPassword.HashPassword(salt);
```

*NOTE: This entry was rescued from the Google Cache. The original date was Thursday, 15th March, 2007.*
