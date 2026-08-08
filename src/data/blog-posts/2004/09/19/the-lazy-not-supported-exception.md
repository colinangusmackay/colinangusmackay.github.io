---
title: "The Lazy NotSupportedException"
slug: the-lazy-not-supported-exception
publishDate: 19 Sep 2004
description: "I am currently building a class library that makes extensive use of abstract classes and interfaces, and like all good TDD (Test Driven Development) I am writing the tests up front..."
tags:
  - { name: "TDD", slug: tdd }
  - { name: "C#", slug: c }
  - { name: ".NET", slug: net }
---
I am currently building a class library that makes extensive use of abstract classes and interfaces, and like all good TDD (Test Driven Development) I am writing the tests up front. Now the problem with this is that I have many methods and properties in the abstract classes and everything from the interfaces that has no implementation yet.

In one case I have a derived class that has 30 methods that I have not overriden from the ABC (Abstract Base Class) yet, and that the ABC does not have any impelementation itself for most of these methods. So, the question is how do I mark these as not implemented and have a reasonable message returned in NUnit? It would be quite hard work going over a dozen or so classes, each with about 20 things that aren't implemented yet typing `throw new NotSupportedException("The method xxx() is not yet supported on class yyyy");` So, I have come up with a solution using some stuff from the `System.Diagnostics` and `System.Reflection` namespaces.


```csharp
protected void OperationNotSupported()
{
    // Work out where the code was that is not supported
    StackTrace st = new StackTrace(false);
    MethodBase calledMethod = st.GetFrame(1).GetMethod();
    string methodName = calledMethod.Name;
    string memberType = calledMethod.MemberType.ToString();

     // Work out what object has the unsupported functionality
    Type type = this.GetType();
    string typeName = type.FullName;

    // Generate the message and throw the exception.
    string msg = string.Format("The {0} {1} is not supported by {2}", 
        memberType, methodName, typeName);
    throw new NotSupportedException(msg);
}
```

Now the great thing about this is that the message returned in the exception will identify the caller of the above method without you having to dig into the stack trace, in other words the method for which the operation is not supported, but adjusted for the actual type of object. This method just needs to be placed in the base class, and all the base implementations (where before there was just a stub to identify the signature of the method or property for the derived classes to override) can just call this method.

So, if I have two classes, an ABC called `MyBaseClass` and concrete class called `MyDerivedClass`, I can create a `virtual` method in `MyBaseClass` called `OverrideMe()` where the method just calls `OperationNotSupported();`. If some code calls `OverrideMe()` on an instance of `MyDerivedClass` the exception that will be thrown will have the message "The Method OverrideMe is not supported by MyDerivedClass" even although it was the base class that threw the exception. See the following code for an example of what I mean.

```csharp
public abstract class MyBaseClass
{
    public virtual void OverrideMe()
    {
        OperationNotSupported();
    }
}

public class MyDerivedClass : MyBaseClass
{
}
```

Elsewhere you would have something like this:

```csharp
public void Main()
{
    MyDerivedClass instance = new MyDerivedClass();
    instance.OverrideMe(); // Throws NotSupportedException
}
```
