---
title: "Anonymous Types"
slug: anonymous-types
publishDate: 18 Jun 2007
description: "Anonymous Types are another new feature to the C# 3.0 compiler. To create one, just supply the new keyword without a class name, followed by the, also new,..."
tags:
  - { name: "Anonymous Types", slug: anonymous-types }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "visual studio", slug: visual-studio }
---

Anonymous Types are another new feature to the C# 3.0 compiler.

To create one, just supply the new keyword without a class name, followed by the, also new, object initialiser notation.

As the type name is not known it needs to be assigned to a variable declared with the local variable type inference, var, keyword.

For example:

```csharp
var anonType = new { FirstName = "Colin", MiddleName = "Angus", Surname = "Mackay" };
```

It is possible to assign a new object to the variable, but it must be created with the object initialisers in exactly the same order. If, say, the following is attempted a compiler error will be generated:

```csharp
anonType = new {Surname = "Rowling",  FirstName = "Joanna", MiddleName = "Kathleen" };
```

The corresponding compiler error is: Cannot implicitly convert type 'anonymous type \[...ProjectsConsoleApplication4ConsoleApplication4PropertiesAssemblyInfo.cs\]' to 'anonymous type \[...ProjectsConsoleApplication4ConsoleApplication4PropertiesAssemblyInfo.cs\]'
At the moment I'm not entirely sure where AssemblyInfo.cs comes in. If anyone knows the answer I'd love to know.
Back to the original example. What does this look like under the microscope of Lutz Roeder's Reflector?

```csharp
var <>g__initLocal0 = new <>f__AnonymousType0();
<>g__initLocal0.FirstName = "Colin";
<>g__initLocal0.MiddleName = "Angus";
<>g__initLocal0.Surname = "Mackay";
var anonType = <>g__initLocal0;
```

But that isn't all that was generated. The compiler also generated the following internal class (Note: Some of the detail has been stripped for clarity)

```csharp
internal sealed class <>f__AnonymousType0<<>j__AnonymousTypeTypeParameter1,
    <>j__AnonymousTypeTypeParameter2, <>j__AnonymousTypeTypeParameter3>
{
    // Fields
    private <>j__AnonymousTypeTypeParameter1 <>i__AnonymousTypeField4;
    private <>j__AnonymousTypeTypeParameter2 <>i__AnonymousTypeField5;
    private <>j__AnonymousTypeTypeParameter3 <>i__AnonymousTypeField6;

    public <>j__AnonymousTypeTypeParameter1 FirstName
    {
        get
        {
            return this.<>i__AnonymousTypeField4;
        }
        set
        {
            this.<>i__AnonymousTypeField4 = value;
        }
    }

    public <>j__AnonymousTypeTypeParameter2 MiddleName
    {
        get
        {
            return this.<>i__AnonymousTypeField5;
        }
        set
        {
            this.<>i__AnonymousTypeField5 = value;
        }
    }

    public <>j__AnonymousTypeTypeParameter3 Surname
    {
        get
        {
            return this.<>i__AnonymousTypeField6;
        }
        set
        {
            this.<>i__AnonymousTypeField6 = value;
        }
    }
}
```

Because the developer has no access to the actual type name the an object created as an anonymous type cannot be passed around the program unless it is cast to an object, the base class of all things. It cannot, for obvious reasons, be cast back again. So at this point the only way of accessing the data stored within is via reflection, or with methods already present on object.

Anonymous types can be examined in the debugger quite easily and show us just like any other object.

<img src="/assets/blog/2007-06-18-anonymous-types-1.webp" width="699" height="599" alt="Debugging anonymous types in Orcas" />

One especially neat feature of anonymous types is its ability to infer a name when none is given. For example:

```csharp
DateTime dateOfBirth = new DateTime(1759, 1, 25);
var anonType = new { FirstName = "Robert", Surname = "Burns", dateOfBirth };
```

The dateOfBirth entry was not explicitly given a name on the anonymous type. However, the compiler inferred a name based on the variable name that was given. The anonymous type therefore looks like this: { FirstName = Robert, Surname = Burns, dateOfBirth = 25/01/1759 00:00:00 }

Naturally, some will dislike this as the anonymous type now has a mix of pascal and camel case for the properties it is exposing.
