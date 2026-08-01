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
<!-- TODO: convert this post's content to Markdown -->

This is something I've been mulling around in my head for a few days now. "Out of the box" C# 3.0 does not support mixins, but I think you can get some of the abilities of a mixin with what is there already.

Firstly I should probably explain what a mixin is. A mixin is a class that provides some specific functionality that is to be inherited by a derived class, but it does not have a specialisation (kind-of) relationship with the derived class.

The example that I have is of a class hierarchy representing different types of animal.The base class is Animal, derived from that is Avian and Mammal. Derived from Avian is Parrot, Penguin and Chicken. Derived from Mammal is Dog, Cat, Whale and Bat.

<div style="text-align:center;"><img src="http://static.colinmackay.co.uk/images/mixin/2008-02-24-Class-Diagram-1.png" alt="Class-Diagram-1" width="568" height="357" /></div>

These animals all have various methods of locomotion. Some can swim, some can run and others can fly. However, as you can see there is no obvious relationship through the base class. It might seem at first glance while designing the class hierarchy that an avian should be able to fly. It is, after all, the first thing that springs to mind when thinking about how birds get from one place to another. But what about flightless birds such as the Dodo? Similarly, don't all mammals run? No, there are many that live in the sea.

As you can see, adding methods for flight on the Avian base class or running on the Mammal base class don't work in all cases. This is where mixins come into play.

Mixins can, in this example, provide the functionality for flight, running or swimming, or any other form of locomotion by having the appropriate class inherit the functionality. However, C# does not permit multiple inheritance. You can inherit from one base class only in C#.

But, you can implement multiple interfaces. At this point you are probably thinking "Ah-hah! But interfaces don't have any functionality". True, you won't get too far if you just use some interfaces on the classes. But it is the first step.

<div style="text-align:center;"><img src="http://static.colinmackay.co.uk/images/mixin/2008-02-24-Class-Diagram-2.png" alt="Class-Diagram-2" width="560" height="405" /></div>

With C# 3.0 came the introduction of Extension Methods and they can be applied, not only to classes but, also, to interfaces. Extension Methods provide additional functionality on an existing class without modifying the class. (You can <a title="Extension Methods in C# 3" href="http://colinmackay.co.uk/blog/2007/06/18/method-extensions/">read more about Extension Methods here</a>). It then becomes possible to create a static helper class for specific functionality that defines the extension methods. Because the classes implement the interface (even if the actual interface doesn't contain any methods or properties to implement) it will pick up all the extension methods also.
<pre class="csharpcode"><span class="kwrd">public</span><span class="kwrd"> </span> <span class="kwrd">static</span><span class="kwrd"> </span> <span class="kwrd">class</span> SwimMixin
{
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">void</span> Swim(<span class="kwrd">this</span> ISwim target)
    {
        <span class="rem">// Perform Swim functionality on the target</span>
    }
}</pre>
This provides very limited mixin functionality. The imitation mixin cannot hold any data of its own which means that so long as the imitation mixin can get away without adding attribute information of its own then it is still useful.

If you need to have the mixin hold its own data then I can, at present, see a number of potential solutions to this problem. Unfortunately no solution is terribly elegant, nor are they problem free.

The first is to use a lookup keyed on weak references to the actual instantiated class with the result of the lookup returning the data needed for the Mixin. The reason for the weak reference is to ensure that the instances of the class get cleared out and are not retained by the imitation mixin. Remember the imitation mixin is built out of a static class so it won't go out of scope and get cleared up by the garbage collector and everything it holds will stay around as long as the application is running. The main problem with this approach is that as the number of actual instantiated classes increases the lookups get larger and will naturally slow down. Also, some mechanism for clearing out the keys and data that are no longer required has to be implemented as the actual objects are garbage collected.

The second is to use the interface that the extension method is using to provide a method that can be used by the imitation mixin to access its data. This would mean that the actual  instance of the class would have to hold onto some additional data on behalf of the imitation mixin, which negates part of its usefulness.

The third is to create a base class for that all classes that may wish to use a mixin inherit from. This base class can contain "instance" data, in a hashtable keyed on the mixin type (for instance) on behalf of the mixin itself. This would, unfortunately, mean that the data is exposed and render encapsulation useless. It also causes a small hit each time a mixin method needs access to its "instance" data. Naturally, if you are inheriting from an existing framework class you won't have the option of putting in a base class to hold the mixin data.

<div style="text-align:center;"><img src="http://static.colinmackay.co.uk/images/mixin/2008-02-24-Class-Diagram-3.png" alt="Class-Diagram-3" width="164" height="187" /></div>

It isn't too hard to see that it may be possible in the future to have mixin behaviour built directly into the language as we are already part of the way there. In the meantime some limited functionality is available which can be extended to include instance data for the mixin itself with some extra work, but it isn't without its problems.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:bdc65016-4ea7-4999-acfa-570ddd1bb47d" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/C#">C#</a>,<a rel="tag" href="http://technorati.com/tags/C#%203.0">C# 3.0</a>,<a rel="tag" href="http://technorati.com/tags/mixin">mixin</a>,<a rel="tag" href="http://technorati.com/tags/object%20orientation">object orientation</a>,<a rel="tag" href="http://technorati.com/tags/oop">oop</a></div>

