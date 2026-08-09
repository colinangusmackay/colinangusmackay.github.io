---
title: "Object Initialisers (3)"
slug: object-initialisers-3
publishDate: 18 Jun 2007
description: "It seems that now I've got Lutz Roeder's Reflector on the case with Orcas the way object initialisers work slightly different to how I expected. As it was..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
---

It seems that now I've got Lutz Roeder's Reflector\* on the case with Orcas\*\* the way object initialisers work slightly different to how I expected.

As it was described to me as instantiating the object followed by the property calls. However, the compiler has taken some extra steps in there - no doubt on the grounds of safety.

First consider the following code:

```csharp
// Create Robert Burns, DoB 25/Jan/1759
Person robertBurns = new Person { FirstName = "Robert", Surname = "Burns", 
                                  DateOfBirth = new DateTime(1759, 1, 25) };
Console.WriteLine("{0}", robertBurns);
```

As I understood the feature, the compiler should have generated code that looked like this:

```csharp
Person robertBurns = new Person();
robertBurns.FirstName = "Robert";
robertBurns.Surname = "Burns";
robertBurns.DateOfBirth = new DateTime(1759, 1, 25);
```

However, Reflector reveals that what is actually being produced is this:

```csharp
    Person <>g__initLocal0 = new Person();
    <>g__initLocal0.FirstName = "Robert";
    <>g__initLocal0.Surname = "Burns";
    <>g__initLocal0.DateOfBirth = new DateTime(0x6df, 1, 0x19);
    Person robertBurns = <>g__initLocal0;
    Console.WriteLine("{0}", robertBurns);
```

This actually makes some sense. For example, if my new Person object was assigned to a property of something else, or passed in as a parameter to a method it wouldn't have the opportunity to assign values to the properties on the new object. So, it constructs it all in the background then assigns it to whatever needs it, whether that is a local variable, a property on some object a parameter in a method.

For example, if the above program is reduced to just one line of code:

```csharp
// Create Robert Burns, DoB 25/Jan/1759
Console.WriteLine("{0}", new Person { FirstName = "Robert", Surname = "Burns",
                                      DateOfBirth = new DateTime(1759, 1, 25) });
```

The compiled result will be:

```csharp
    Person <>g__initLocal0 = new Person();
    <>g__initLocal0.FirstName = "Robert";
    <>g__initLocal0.Surname = "Burns";
    <>g__initLocal0.DateOfBirth = new DateTime(0x6df, 1, 0x19);
    Console.WriteLine("{0}", <>g__initLocal0);
```

Related Posts: Object Intialisers [I](/2007/06/18/object-initialisers-1) and [II](/2007/06/18/object-initialisers-2)

NOTE: This page was rescued from the Google Cache. The original date was Tuesday, 13th March, 2007

### 🔄 Follow up - 9th August 2026

\* 
When this post was originally created Lutz Roeder's Reflector was free. Since then, RedGate bought it and now charge for it. If you want an equivalent free product that does the same thing then have a look at [dotPeek](https://www.jetbrains.com/decompiler/) from JetBrains.

\** A foot note about "Orcas". This was the code name of what was to become Visual Studio 2008.

