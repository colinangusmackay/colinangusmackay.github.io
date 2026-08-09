---
title: "Automatic Properties"
slug: automatic-properties
publishDate: 18 Jun 2007
description: "Continuing my look at the new features found in the C# 3.0 compiler I will look at Automatic Properties. public class Employee{ public string FirstName { get;..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "visual studio", slug: visual-studio }
---

Continuing my look at the new features found in the C# 3.0 compiler I will look at Automatic Properties.

```csharp
public class Employee
{
    public string FirstName { get; set; }
    public string Surname { get; set; }
    public DateTime DateOfBirth { get; set; }
    public Employee Manager { get; set; }
}
```

At first look this might seem more like a definition for an interface, but for the class keyword and the member visibility modifiers.
However, this is actually a new feature where by the compiler will automatically fill in the member fields. This is useful for situations where nothing needs to be done when getting or setting values from the member fields. It means they can be constructed much more quickly as there is no need for tedious creating of private member fields then the public properties. All that is needed is one simple construct.
It is also possible to reduce the visibility of the getter and setter independently. For example, in the above example you may wish to make `DateOfBirth` to be effectively read-only for all by the class that owns it. You can prefix the `set` keyword with the `private` visibility modifier.
But what is the compiler actually producing? The following is the output from [Lutz Roeder's Reflector](https://www.red-gate.com/products/reflector/) for the DateOfBirth property:

```csharp
[CompilerGenerated]
private DateTime <>k__AutomaticallyGeneratedPropertyField2;

public DateTime DateOfBirth
{
    [CompilerGenerated]
    get
    {
        return this.<>k__AutomaticallyGeneratedPropertyField2;
    }
    private [CompilerGenerated]
    set
    {
        this.<>k__AutomaticallyGeneratedPropertyField2 = value;
    }
}
```

In the code, only the  property is accessible. Attempting to use the compiler generated name produces a compiler error.
If the full name (as shown above) is used then the compiler will complain with three errors:

|  |  |  |  |  |  |
|----|----|----|----|----|----|
| **\#** | **Error** | **File** | **Row** | **Col** | **Project** |
| 1 | Identifier expected | ConsoleApplication2Employee.cs | 20 | 18 | ConsoleApplication2 |
| 2 | Invalid expression term '\>' | ConsoleApplication2Employee.cs | 20 | 19 | ConsoleApplication2 |
| 3 | ; expected | ConsoleApplication2Employee.cs | 20 | 20 | ConsoleApplication2 |

Compiler errors {border="1" cellspacing="0" cellpadding="1" width="100%"}

If the \<\> are removed the message changes to:

|  |  |  |  |  |  |
|----|----|----|----|----|----|
| **\#** | **Error** | **File** | **Row** | **Col** | **Project** |
| 1 | <span style="font-family:Arial;">'ConsoleApplication2.Employee' does not contain a definition for 'k\_\_AutomaticallyGeneratedPropertyField2' and no extension method 'k\_\_AutomaticallyGeneratedPropertyField2' accepting a first argument of type 'ConsoleApplication2.Employee' could be found (are you missing a using directive or an assembly reference?)</span> | ConsoleApplication2Employee.cs | 20 | 18 | ConsoleApplication2 |

So, why go to all this trouble? Surely it isn't just to save a few key strokes?

Part of the answer can be seen in a post I made in November 2005: [Why make fields in a class private, why not just make them public?](/2005/11/28/why-make-fields-in-a-class-private-why-not-make-them-public) and there was a follow up in June 2006 when I returned to [The Public Fields Debate Again](/2006/06/17/the-public-fields-debate-again).

In short, public fields and public properties, although they appear to look identical to the outside in C# are sytactically different once compiled. Automatic Properties are a way to address that. If you, at some point in the future, decide that you need the property to do more then the external interface of the object won't change, you just turn the automatic property into a normal property/field combination again.


*NOTE: This post was rescued from the Google Cache. The original date was Tuesday, 13th March, 2007.*

### 🔄 Follow up - 9th August 2026

When this post was originally created Refector was free, since then RedGate bought it and now charge for it. If you want an equivalent free product that does the same thing then have a look at [dotPeek](https://www.jetbrains.com/decompiler/) from JetBrains.