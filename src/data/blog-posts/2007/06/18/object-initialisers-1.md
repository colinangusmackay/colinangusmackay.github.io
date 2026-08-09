---
title: "Object Initialisers (1)"
slug: object-initialisers-1
publishDate: 18 Jun 2007
description: "Continuing with the language enhancements in C#3.0. This post presents the concept of object initailisation. Say you have a class with a default constructor..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
---

Continuing with the language enhancements in C#3.0. This post presents the concept of object initailisation.

Say you have a class with a default constructor and lots of properties and you want to be able in initialise the object in one line but the class doesn’t support it. What you can do is use object initailisers:

So, a series of calls like this in C# 2.0:

```csharp
Policy p = new InsurancePolicy();
p.Id = 123;
p.GrossPremium = 100;
p.IptAmount = 10;
```

Could now be written as this in C# 3.0:

```csharp
InsurancePolicy p = new InsurancePolicy
{
  Id = 123,
  GrossPremium = 100,
  IptAmount = 10
};
```

You’ve probably seen something similar already with respect to declaring attributes on an assembly, class or method. 

Again, like the other language features in C#3.0, this is just syntactic sugar. The compiler will output the calls in a similar way to the first (C# 2.0) example. 

At the moment I can’t see this feature being useful for classes that I build myself as I have control over the class's constructors and if needed then I can accommodate the parameters as appropriate. Also, the idea of having a single line of code with so many object initialisers in it would seem to me to be a potential source of some really ugly code.

That isn’t to say this isn’t useful for my own classes – it could be used as a way of reducing the need to provide many overloaded versions of the constructor. It would no longer be necessary to anticipate every permutation and combination of properties that are needed to initialise the object past a basic valid state. It could save quite a bit of time. However, caution would need to be exercised. Any constructor created would still need to ensure that the object was created into a valid state. Using object initialisers to initialise the object completely from scratch may not be appropriate.

Object initialisers are a tool. So long as the developer remembers to use the right tool for the right job then this new language feature can be used very effectively.

What object initialisers would be most useful for, as far as I can see, would be for existing classes where I don’t have control over their makeup. e.g. Framework classes, or classes from a third party.

*NOTE: This post was rescued from the Google Cache. The original date was Saturday 10th March, 2007.*

