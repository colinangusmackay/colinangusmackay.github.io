---
title: "Mixins in .NET (again)"
slug: mixins-in-net-again
publishDate: 10 Aug 2008
description: "A while ago I wrote about Mixins in C# 3.0 , at the time I was saying that you can get some of the functionality, but not all, from some of the new language..."
tags:
  - { name: "C#", slug: c }
  - { name: "design patterns", slug: design-patterns }
---
<!-- ISSUE: link (http://www.remobjects.com/product/page.asp?id={E10F7F5C-AE94-4833-9E4B-2EDD5ED69768}): status 404 -->

A while ago I wrote about [Mixins in C# 3.0](/2008/02/24/mixins-in-c-30/), at the time I was saying that you can get some of the functionality, but not all, from some of the new language features in C#3.0. The solution is a bit of a fudge because the language doesn't support the concept. I've been looking at [Oxygene](http://www.remobjects.com/product/page.asp?id=%7BE10F7F5C-AE94-4833-9E4B-2EDD5ED69768%7D) recently and it has some language features that go a bit further than C# does and will support greater mixin-like functionality which it calls interface delegation.

Interface delegation is again a bit of a fudge, but not quite like C#. In this case the language supports this mixin-like functionality and the fudge happens in the compiler. Let's take the class hierarchy that I used the last time:

[Class Diagram](/assets/blog/2008-08-10-mixins-in-net-again-1.webp)

In Oxygene the Dog class looks like this:

```pascal
interface

type
  Dog = public class(Mammal, IRun, ISwim)
  private
      runInterfaceDelegate : RunMixin; implements IRun;
      swimInterfaceDelegate : SwimMixin; implements ISwim;
  protected
  public
  end;

implementation

end.
```

From this we can see that `Dog` inherits from `Mammal` and implements `IRun` and `ISwim`. The `IRun` interface has one method (`Run`), and the `ISwim` interface has only one method also (`Swim`). Of course, there could be as many methods and properties as you like.

The C# version of the Dog class, as produced by Reflector, looks like this:

```csharp
public class Dog : Mammal, IRun, ISwim
{
    // Fields
    private RunMixin runInterfaceDelegate;
    private SwimMixin swimInterfaceDelegate;

    // Methods
    void IRun.Run()
    {
        this.runInterfaceDelegate.Run();
    }

    void ISwim.Swim()
    {
        this.swimInterfaceDelegate.Swim();
    }
}
```

As you can see, there are two private fields holding a reference to the appropriate mixin, in each of the methods the responsibility for carrying out the action is delegated to the appropriate surrogate mixin object.

What you will also notice is that you still have to instantiate the surrogate mixin objects. Under normal circumstances that would be in the constructor. If it were a real mixin you wouldn't have the option as the mixin would be created at the same time as the object it is used with. In fact, the mixin would be *mixed in* as part of the object itself. So, perhaps interface delegates gives you slightly greater power than with a real mixin as you could reuse the surrogate mixin object. Then again, would you want to? I've not been able to think of a scenario where I would, but perhaps it could be useful.

I'd like to see interface delegates in C# at some point in the future (sooner rather than later). In fact, I'd like to see proper mixin functionality, but I reckon that will require changes to the CLR to support multiple inheritance. In the meantime, I think I'll have to write some sort of snippet in C# to quickly generate the code that Oxygene gives me in one line. Either that or start writing in Oxygene... Now, there's a thought!
