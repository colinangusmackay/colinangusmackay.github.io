---
title: "Method hiding or overriding - or the difference between new and virtual"
slug: method-hiding-or-overriding-or-the-difference-between-new-and-virtual
publishDate: 10 Oct 2008
description: "When developing applications it is very important to understand the difference between method hiding and method overriding. By default C# methods are..."
tags:
  - { name: "C#", slug: c }
  - { name: "object oriented design", slug: object-oriented-design }
---

When developing applications it is very important to understand the difference between method hiding and method overriding.
By default C# methods are non-virtual. If you are a Java developer this may come as a surprise. This means that in C# if you want a method to be extensible you must explicitly declare it as virtual if you want to override it.

So, what is overriding? Wikipedia has a succinct definition. [Method overriding](http://en.wikipedia.org/wiki/Method_overriding_(programming)) is a language feature that allows a [subclass](http://en.wikipedia.org/wiki/Subclass_(computer_science)) \[aka derived class\] to provide a specific implementation of a [method](http://en.wikipedia.org/wiki/Method_(computer_science)) that is already provided by ... its \[[superclass](http://en.wikipedia.org/wiki/Superclass_(computer_science))\] \[aka base class\]. The implementation in the subclass overrides (replaces) the implementation in the superclass.

The important thing to remember about overriding is that the method that is doing the overriding is related to the method in the base class.

Method hiding, by contrast, does not have a relationship between the methods in the base class and derived class. The method in the derived class hides the method in the base class.

I wouldn't personally recommend method hiding as a strategy for developing code. In my opinion, if you feel the need to hide the method on the base class then you are most likely doing something wrong. I haven't come across any scenarios where method hiding couldn't be better implemented by other means, even as simple as just naming the method on the derived class to something else.

Let's look at some code to show you what I mean. First off we are going to use this class structure (it's my favourite when showing off inheritance, and you may have seen variations of it already on my blog).

![](/assets/blog/2008-10-10-method-hiding-or-overriding-or-the-difference-between-new-and-virtual-1.webp)

Let's say that the Dog class has a method call `Bark()`

``` csharp
public class Dog: Mammal
{
    public void Bark()
    {
        Console.WriteLine("Woof!");
    }
}
```


So far, so good. We can call it like this:

``` csharp
static void Main(string[] args)
{
    Dog d = new Dog();
    d.Bark();
    Console.ReadLine();
}
```

And the output of the program is as you'd expect. "Woof!" is written to the console.

Now, Chihuahuas are nippy wee things and they tend to "yip" rather than "woof" so what we'll do is create a `Bark()` method in Chihuahua class that writes out "Yip!" instead.

``` csharp
public class Chihuahua : Dog
{
    public void Bark()
    {
        Console.WriteLine("Yip!");
    }
}
```

What happens here is that the C# compiler will display a warning to indicate that it has found a situation that it can guess at the intended functionality, but it really wants to to be explicit.

[Warning Message](/assets/blog/2008-10-10-method-hiding-or-overriding-or-the-difference-between-new-and-virtual-2.webp)

`'Animals.Chihuahua.Bark()' hides inherited member 'Animals.Dog.Bark()'. Use the new keyword if hiding was intended.`

By inserting the new keyword between the public and the void in the method declaration we can get rid of this warning. We are being explicit and telling the compiler that we know what we are doing. So, what are the implications of method hiding? Consider the following bit of code:

``` csharp
static void Main(string[] args)
{
    Dog d = new Chihuahua();
    d.Bark();
    Console.ReadLine();
}
```

Well, if you have a `Dog` reference that actually refers to an instance of the `Chihuahua` class then when you call bark it will still say "Woof!" That goes against many people's expectations. This is because you've actually drawn that line in the sand and are saying that the `Bark()` method on `Chihuahua` is unrelated. If you hold a reference to a `Dog` then you may not be expected to know about the existence of a `Chihuahua` so if your calling code suddenly got the functionality of the `Bark()` method in the `Chihuahua` class then it might break. The CLR cannot make that decision for you. If you do know about your `Dog` reference actually being a `Chihuahua` then you must cast it before using it. However, that means you are likely to have to litter your code with conditional statements based on the actual type of the object and that defeats the power of having an object oriented language.

What you should have done is make the `Bark()` method `virtual` then `override` it in the derived version like this:

``` csharp
public class Dog : Mammal
{
    public virtual void Bark()
    {
        Console.WriteLine("Woof!");
    }
}

public class Chihuahua : Dog
{
    public override void Bark()
    {
        Console.WriteLine("Yip!");
    }
}
```

This way when you have a `Chihuahua` object then the correct `Bark()` method is called regardless of the type of the reference so long as the reference type can see a `Bark()` method on that hierarchy

The way I see it is that there is no reason to have to draw that line in the sand and use the new keyword in the context of method hiding. If you feel the need to do that then your two realistic options are either to consider whether what you really want to do is make the base `virtual` and then `override` in the derived class, or whether you need to think of a better name for the method in the derived class. If the methods are related (like the `Bark()` example above) then method overriding is what you need. If they are not related then make that explicit by giving the method in the derived class a different name.
