---
title: "Mixins in C# 3.0"
slug: mixins-in-c-30
publishDate: 24 Feb 2008
description: "This is something I've been mulling around in my head for a few days now. \"Out of the box\" C# 3.0 does not support mixins, but I think you can get some of the..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "Extension Methods", slug: extension-methods }
  - { name: "mixin", slug: mixin }
  - { name: "object oriented design", slug: object-oriented-design }
---
This is something I've been mulling around in my head for a few days now. "Out of the box" C# 3.0 does not support mixins, but I think you can get some of the abilities of a mixin with what is there already.

Firstly I should probably explain what a mixin is. A mixin is a class that provides some specific functionality that is to be inherited by a derived class, but it does not have a specialisation (kind-of) relationship with the derived class.

The example that I have is of a class hierarchy representing different types of animal.The base class is Animal, derived from that is Avian and Mammal. Derived from Avian is Parrot, Penguin and Chicken. Derived from Mammal is Dog, Cat, Whale and Bat.

![Class Diagram 1](/assets/blog/2008-02-24-mixins-in-c-30-1.webp)

These animals all have various methods of locomotion. Some can swim, some can run and others can fly. However, as you can see there is no obvious relationship through the base class. It might seem at first glance while designing the class hierarchy that an avian should be able to fly. It is, after all, the first thing that springs to mind when thinking about how birds get from one place to another. But what about flightless birds such as the Dodo? Similarly, don't all mammals run? No, there are many that live in the sea.

As you can see, adding methods for flight on the Avian base class or running on the Mammal base class don't work in all cases. This is where mixins come into play.

Mixins can, in this example, provide the functionality for flight, running or swimming, or any other form of locomotion by having the appropriate class inherit the functionality. However, C# does not permit multiple inheritance. You can inherit from one base class only in C#.

But, you can implement multiple interfaces. At this point you are probably thinking "Ah-hah! But interfaces don't have any functionality". True, you won't get too far if you just use some interfaces on the classes. But it is the first step.

![Class Diagram 2](/assets/blog/2008-02-24-mixins-in-c-30-2.webp)

With C# 3.0 came the introduction of Extension Methods and they can be applied, not only to classes but, also, to interfaces. Extension Methods provide additional functionality on an existing class without modifying the class. (You can [read more about Extension Methods here](/2007/06/18/method-extensions/ "Extension Methods in C# 3")). It then becomes possible to create a static helper class for specific functionality that defines the extension methods. Because the classes implement the interface (even if the actual interface doesn't contain any methods or properties to implement) it will pick up all the extension methods also.

```csharp
public  static  class SwimMixin
{
    public static void Swim(this ISwim target)
    {
        // Perform Swim functionality on the target
    }
}
```

This provides very limited mixin functionality. The imitation mixin cannot hold any data of its own which means that so long as the imitation mixin can get away without adding attribute information of its own then it is still useful.

If you need to have the mixin hold its own data then I can, at present, see a number of potential solutions to this problem. Unfortunately no solution is terribly elegant, nor are they problem free.

The first is to use a lookup keyed on weak references to the actual instantiated class with the result of the lookup returning the data needed for the Mixin. The reason for the weak reference is to ensure that the instances of the class get cleared out and are not retained by the imitation mixin. Remember the imitation mixin is built out of a static class so it won't go out of scope and get cleared up by the garbage collector and everything it holds will stay around as long as the application is running. The main problem with this approach is that as the number of actual instantiated classes increases the lookups get larger and will naturally slow down. Also, some mechanism for clearing out the keys and data that are no longer required has to be implemented as the actual objects are garbage collected.

The second is to use the interface that the extension method is using to provide a method that can be used by the imitation mixin to access its data. This would mean that the actual  instance of the class would have to hold onto some additional data on behalf of the imitation mixin, which negates part of its usefulness.

The third is to create a base class for that all classes that may wish to use a mixin inherit from. This base class can contain "instance" data, in a hashtable keyed on the mixin type (for instance) on behalf of the mixin itself. This would, unfortunately, mean that the data is exposed and render encapsulation useless. It also causes a small hit each time a mixin method needs access to its "instance" data. Naturally, if you are inheriting from an existing framework class you won't have the option of putting in a base class to hold the mixin data.

![Class Diagram 3](/assets/blog/2008-02-24-mixins-in-c-30-3.webp)

It isn't too hard to see that it may be possible in the future to have mixin behaviour built directly into the language as we are already part of the way there. In the meantime some limited functionality is available which can be extended to include instance data for the mixin itself with some extra work, but it isn't without its problems.

### 🔄 Follow up notes - 16th August 2026

Some of the images in this post were created before dark mode was common and the blog theme was much lighter. You might find the images easier to see in light mode.
