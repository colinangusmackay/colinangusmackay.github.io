---
title: "Using Contracts to discover Liskov Substitution Principle Violations in C#"
slug: using-contracts-to-discover-liskov-substitution-principle-violations-in-c
publishDate: 20 Apr 2014
description: "In his book Agile Principles, Patterns, and Practices in C# , Bob Martin talks about using pre- and post-conditions in Eiffel to detect Liskov Substitution..."
tags:
  - { name: "C#", slug: c }
  - { name: "contracts", slug: contracts }
  - { name: "liskov substitution principle", slug: liskov-substitution-principle }
  - { name: "lsp", slug: lsp }
  - { name: "solid", slug: solid }
  - { name: "unit testing", slug: unit-testing }
  - { name: "visual studio", slug: visual-studio }
---
In his book *Agile Principles, Patterns, and Practices in C#*, Bob Martin talks about using pre- and post-conditions in Eiffel to detect Liskov Substitution Principle violations. At the time he wrote that C# did not have an equivalent feature and he suggested ensuring that unit test coverage was used to ensure the same result. However, that does not ensure that checking for LSP violations are applied consistently. It is up to the developer writing the tests to ensure that they are and that any new derived classes get tested correctly. Contracts, these days, can be applied to the base class and they will automatically be applied to any derived class that is created.

### Getting started with Contracts

If you've already got Visual Studio set up to check contracts in code then you can skip this section. If you don't then read on.

1. Install the [Code Contracts for .NET](http://visualstudiogallery.msdn.microsoft.com/1ec7db13-3363-46c9-851f-1ce455f66970 "Code Contracts for .NET (Visual Studio plug in)") extension into Visual Studio.
2. Open Visual Studio and load the solution containing the projects you want to apply contracts to.
3. Open the properties for the project and you'll see a new tab in the project properties window called "Code Contracts"
4. Make sure that the "Perform Runtime Contract Checking" and "Perform Static Contract Checking" boxes are checked. For the moment the other options can be left at their default values. Only apply these to the debug build. It will slow down the application while it is running as each time a method with contract conditions is called it will be performing runtime checks.

![](/assets/blog/2014-04-20-using-contracts-to-discover-liskov-substitution-principle-violations-in-c-1.webp)

You are now ready to see code contract issues in Visual Studio.

For more information on code contracts head over to [Microsoft Research's page on Contracts](http://research.microsoft.com/en-us/projects/contracts/).

### Setting up the Contract

Using the Rectangle/Square example from Bob Martin's book Agile Principles, Patterns and Practices in C# here is the code with contracts added:

```csharp
public class Rectangle
{
    private int _width;
    private int _height;
    public virtual int Width
    {
        get { return _width; }
        set
        {
            Contract.Requires(value >= 0);
            Contract.Ensures(Width == value);
            Contract.Ensures(Height == Contract.OldValue(Height));
            _width = value;
        }
    }

    public virtual int Height
    {
        get { return _height; }
        set
        {
            Contract.Requires(value >= 0);
            Contract.Ensures(Height == value);
            Contract.Ensures(Width == Contract.OldValue(Width));
            _height = value;
        }
    }
    public int Area { get { return Width * Height; } }
}

public class Square : Rectangle
{
    public override int Width
    {
        get { return base.Width; }
        set
        {
            base.Width = value;
            base.Height = value;
        }
    }

    public override int Height
    {
        get { return base.Height; }
        set
        {
            base.Height = value;
            base.Width = value;
        }
    }
}
```

The Square class is in violation of the LSP because it changes the behaviour of the Width and Height setters. To any user of Rectangle that doesn't know about squares it is quite understandable that they'd assume that setting the Height left the Width alone and vice versa. So if they were given a square and they attempted to set the width and height to different values then they'd get a result from Area that was inconsistent with their expectation and if they set Height then queried Width they may be somewhat surprised at the result.

But there are now contracts in place on the Rectangle class and as such they are enforced on Square as well. "Contracts are inherited along the same subtyping relation that the type system enforces." (from he Code Contracts User Manual). This means that any class that has contracts will have those contracts enforced in any derived class as well.

While some contracts can be detected at compile time, others will still need to be activated through a unit test or will be detected at runtime. Be aware, if you've never used contracts before that the contract analysis can appear in the error and output windows a few seconds after the compiler has completed.

Consider this test:

```csharp
[Test]
public void TestSquare()
{
    var r = new Square();
    r.Width = 10;

    Assert.AreEqual(10, r.Height);
}
```

When the test runner gets to this test it will fail. Not because the underlying code is wrong (it will set Height to be equal to Width), but because the method violates the constraints of the base class.

![](/assets/blog/2014-04-20-using-contracts-to-discover-liskov-substitution-principle-violations-in-c-2.webp)

The contract says that when the base class changes the Width the Height remains the same and vice versa.

So, despite the fact that the unit tests were not explicitly testing for an LSP violation in Square, the contract system sprung up and highlighted the issue causing the test to fail.
