---
title: "First(OrDefault) Vs. Single(OrDefault)"
slug: firstordefault-vs-singleordefault
publishDate: 07 Oct 2011
description: "There are two mechanisms (each with an …OrDefault variant) in LINQ for getting one item out of an enumeration. They are First and Single . There is a..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "LINQ", slug: linq }
---
There are two mechanisms (each with an `…OrDefault` variant) in LINQ for getting one item out of an enumeration. They are `First` and `Single`. There is a difference between the two and you can produce code that functions incorrectly if the wrong one is used.

So, what’s the main difference? They both sound like they’ll return just one item out from the enumeration. And, indeed, they do.

`First` will return the first item that it encounters that matches the predicate (if supplied). Whereas `Single` will return the one and only item that it encounters that matches the predicate (if supplied). If `Single` encounters a second item that matches the predicate then it throws an exception. If no predicate is supplied, it throws an exception simply if the enumeration has more that one item.

Why would there be two things that do almost the same thing that are so subtly different? First exists so that you can get the first item regardless of how many items there may actually be. Single exists to get you the one and only item. Single is useful when your predicate operates on a primary key. For example:

```csharp
data.Single(d => d.PrimaryKey == idToMatch)
```

The `…OrDefault` variants will return the default value for the type (for reference types that will be `null`) if there are no matches found. Otherwise, both `First` and `Single` throw an exception if no items are encountered.

Lets look at some code.

### First

```csharp
string[] data = new[]{"Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
var first = data.First();
```

In this case, `first` will contain the value of `"Zero"`.

If a predicate is added to the call to `First` then we can see what happens if there is no match.

```csharp
string[] data = new[]{"Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
var first = data.First(x => x.Length > 10);
```

In this case, there are no matches, and an `InvalidOperationException` is thrown with the message "Sequence contains no matching element"

The same thing will happen if the initial set of data is empty

```csharps
string[] empty = new string[0];
var first = empty.First();
```

You can happily supply a predicate that may match more than one item in the enumeration

### Single

For example

```csharp
string[] onlyOneItem = new string[]{"Only item"};
var single = onlyOneItem.Single();
```

This will return the one and only item that matches.

```csharp
string[] data = new[]{"Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
var single = data.Single();
```

This will thrown an exception. If result set contains more than one item an `InvalidOperationException` will be thrown with a message of "Sequence contains more than one element"

```csharp
string[] empty = new string[0];
var single = empty.Single();
```

This will throw exactly the same exception as it's `First` counterpart; an `InvalidOperationException` is thrown with the message "Sequence contains no matching element"

### …OrDefault

This is where things get a little bit more interesting. This says that if the result set contains zero items null (for reference types) is returned. In the case of `First`, the result set can contain zero, one or many items and it won’t throw an exception. In the case of `Single` only result sets containing zero or one item will return while any more will result in an exception.

So… what about this scenario:

```csharp
string[] data = new[]{null, "Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
var first = data.FirstOrDefault();
```

The first value of the set is genuinely `null`. How do you tell the difference between that and the result set being simply empty without throwing an exception?

You could just go back to using the `First` variant and catching the exception. Or you could (if your result set can be enumerated many times without issue, e.g. the underlying object is an Array or List) use `Any` to test if the set contains any data in advance. Like this:

```csharp
string[] data = new[]{null, "Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
if (data.Any())
{
    var first = data.FirstOrDefault();
    // Do stuff with the value
}
```
