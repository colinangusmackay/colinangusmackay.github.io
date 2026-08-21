---
title: "Why should you be returning an IEnumerable"
slug: why-should-you-be-returning-an-ienumerable
publishDate: 19 Jul 2011
description: "I've seen in many places where a method returns a List<T> (or IList<T> ) when it appears that it may not actually really be required, or even desirable when..."
tags:
  - { name: "C# 3", slug: c-3 }
  - { name: "C# 4", slug: c-4 }
  - { name: "Code Quality", slug: code-quality }
  - { name: "IEnumerable", slug: ienumerable }
  - { name: "LINQ", slug: linq }
  - { name: "refactoring", slug: refactoring }
---
I've seen in many places where a method returns a `List<T>` (or `IList<T>`) when it appears that it may not actually really be required, or even desirable when all things are considered.

A `List` is mutable, you can change the state of the `List`. You can add things to the `List`, you can remove things from the `List`, you can change the items the `List` contains. This means that everything that has a reference to the `List` instantly sees the changes, either because an element has changed or elements have been added or removed. If you are working in a multi-threaded environment, which will be increasingly common as time goes on, you will get issues with thread safety if the `List` is used inside other threads and one or more threads starts changing the List.

Return values should, unless you have a specific use case in mind already, be returning an `IEnumerable<T>` which is not mutable. If the underlying type is still a `List` (or `Array` or any of a myriad of other types that implement `IEnumerable<T>`) you can still cast it. Also, some LINQ expressions will self optimise if the underlying type is one which better supports what LINQ is doing. (Remember that LINQ expressions always take an `IEnumerable<T>` or `IQueryable<T>` anyway so you can do what you like regardless of what the underlying type is).

If you ensure that your return values are `IEnumerable<T>` to begin with yet further down the line you realise you need to return an `Array` or `List<T>` from the method it is easy to start doing that. This is because everything accepting the return value from the method will still be expecting an `IEnumerable<T>` which `List<T>` and `Array` implement. If, however, you started with a `List<T>` and move to returning an `IEnumerable<T>` then because so much code will have the expectation of a `List<T>` without actually needing it you will have a lot of refactoring to do just to update the reference types.

Have I convinced you yet? If not, think about this. How often are you inserting items into a collection of objects after the initial creation routine? How often do you remove items from a collection after the initial creation routine? How often do you need to access a specific item by index within a collection after the initial creation routine? My guess is almost never. There are some occasions, but not actually that many.

It took me a while to get my head around always using an `IEnumerable<T>`, until I realised that I almost never require to do the things in the above paragraph. I almost always just need to loop over a collection of objects, or filter a collection of objects to produce a smaller set. Both of those things can be done with just an `IEnumerable<T>` and LINQ.

But, what if I need a count of the objects in the `List<T>`, that would be inefficient with an `IEnumerable<T>` and LINQ? Well, do you really need a count? Oftentimes I just need to know if there are any objects at all in the collection, I don't care how many object there actually are, in which case the LINQ extension method `Any()` can be used. If you do need a count LINQ is clever enough to work out that the underlying type may expose a `Count` property and it calls that (anything that implements `ICollection<T>` such as arrays, lists, dictionaries, sets, and so on) so it is not iterating over all the objects counting them up each time.

Remember, there is nothing necessarily wrong with putting a `ToArray()` to `ToList()` before returning as a reference to an `IEnumerable<T>` something to which a LINQ expression has been applied. That removes the issues that deferred execution can bring (e.g. unexpected surprises when it suddenly evaluates during the first iteration but breaks in the process) or repeatedly applying the filter in the `Where()` method or the transformation in the `Select()` method.

Just because an object is of a specific type, doesn't mean you have to return that specific type.

For example, consider the services you actually need on the collection that you are returning, remembering how much LINQ gives you. The following diagram shows what each of the interfaces expect to be implemented what a number of the common collection types implement themselves.

![](/assets/blog/2011-07-19-why-should-you-be-returning-an-ienumerable-1.webp)

Incidentally, the reason some of the interfaces on the [`Array`](http://msdn.microsoft.com/en-us/library/system.array.aspx) class are in a different colour is that these interfaces are added by the runtime. So if you have a `string[]` it will expose `IEnumerable<string>`.

I'd suggest that as a general rule `IEnumerable<T>` should be the return type when you have anything that implements it as the return type from the method, unless something from an `ICollection<T>` or `IList<T>` (or any other type of collection) as absolutely desperately in needed and not just because some existing code expects, say, an `IList<T>` (even although it is using no more services from it that it would had it been an `IEnumerable<T>`).

The mutability that implementations of `ICollection<T>` and `IList<T>` give will prove problematic in the long term. If you have a large team with members that don’t fully understand what is going on (and this is quite common given the general level developer documentation) they are likely to change the contents of the collection without understanding its implications. In some situations this may fine, in others it may be disastrous.

Finally, if you absolutely do need to return a more specific collection type then instead of returning a reference to the concrete class, return a reference to the lowest interface that you need. For example, if you have a `List<T>` and you need to add further items to it, but not at specific locations in the list, then `ICollection<T>` will be the most suitable return type.
