---
title: "Why make fields in a class private, why not just make them public?"
slug: why-make-fields-in-a-class-private-why-not-make-them-public
publishDate: 28 Nov 2005
description: "Encapsulation is sometimes also known as information hiding. The idea is that an object hides the details of how it works from the outside world. However, some definitions of encapsulation suggest..."
tags:
  - { name: "OOP", slug: oop }
  - { name: ".NET", slug: net }
---

A recent question came up on forum about encapsulation. I guess it is something that I don't really think about any more as it comes naturally but it reminded me of how some of these concepts took a while to take hold when I was first taught them in university.

Encapsulation is sometimes also known as information hiding. The idea is that an object hides the details of how it works from the outside world. However, some definitions of encapsulation suggest that it is just putting the data and the methods that operate on that data together in one class (the capsule).

The question asked was "why make fields in a class private, why not just make them public?"

I now find very idea of making a field public incredulous. However, if I stretch my mind back about 10+ years or so I can vaguely remember asking similar questions and thinking how crazy it was making member variables private and having to access them through special functions. It isn't crazy at all.

So, what do you get from hiding fields behind the private or protected accessor?

The primary advantage is that it hides the internals of the class and shifts the dependency onto a well defined interface. By interface I mean a public method or property on the class rather than having the class inherit from an interface. Code that accesses the class will call on the public methods and properties and need know nothing about what is happening inside the class. This leaves great scope for future implementations of the class to vary what happens internally while maintaining the same external interface. Code that uses the class will then continue to operate without being modified. Put simply - It is a form of protection from future unknowns.

For example, say that a class represents an alarm clock which allows two separate alarms to be set. Internally, those alarms are represented as two separate fields. When the client code accesses the alarm clock class it uses a set of public methods and properties. This allows at at some point in the future the internal storage of the alarm times to be changed to use an array rather than two separate field instances. If the fields were public a lot of code outside the class may have to be updated also to accommodate the new structure of the class.

Even if there is not going to be any internal change to the class, the use of methods and properties to access the fields can provide other advantages.

For example, you might decide later that it would be better to leave the field uninitialised and then have your property initialise it when it is first used. This is called a lazy-lookup. If the field value can be constructed from the information the class already holds, but it is an expensive operation to do so, and the usage patterns show that the value is not often needed then why create it needlessly? So, the property checks the field, if the field is null it creates the value and stores it in the field and returns the new value. If the field already contains a value then it is the cached value that is returned.

Alternatively, you discover some time in the future that when you set the property that you need to carry out some other action (an analogy would be like a trigger in the database). So, since you have a property already, you can now put the extra functionality in without having to completely break your application.

Another example being that validation could be taken before the field is updated with the new value. This keeps the object in a consistent state. If you just exposed the field you would never know if some other object set the field to an invalid value and this is a potential source of bugs, especially the nasty sort that rear their head further on past the point that the bug was actually introduced. These are a real pain to track down and anyone having to maintain your code will not thank you for allowing that into the system.

An interesting advantage to using public properties backing private fields is that the developer can set breakpoints on the properties but not on the fields. That is very useful for debugging the application. Debugging trace statements can also be placed there

Finally, if a property is a simple field backer it can also be used to provide a read- or write- only access to the fields. This is particularly useful if the object is to be immutable, that is, it doesn't change once created.