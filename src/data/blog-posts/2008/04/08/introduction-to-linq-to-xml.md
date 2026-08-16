---
title: "Introduction to LINQ to XML"
slug: introduction-to-linq-to-xml
publishDate: 08 Apr 2008
description: "Last year I wrote about the new languages features available in C# 3.0 ( Anonymous Types , Extension Methods , Automatic Properties , A start on LINQ , Object..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
---
Last year I wrote about the new languages features available in C# 3.0 ([Anonymous Types](/2007/06/18/anonymous-types/), [Extension Methods](/2007/06/18/method-extensions/), [Automatic Properties](/2007/06/18/automatic-properties/), [A start on LINQ](/2007/06/18/a-start-on-linq/), [Object Initialisers I](/2007/06/18/object-initialisers-1/), [Object Initialisers II](/2007/06/18/object-initialisers-2/), & [Object Initialisers III](/2007/06/18/object-initialisers-3/)) and since then I've really got in to LINQ, especially LINQ to XML. The reason for that is that I hate XPath and I see LINQ to XML as a much easier way of querying XML files without faffing about with terse XPath strings. I would much rather have the ability to easily see what is going on with the query than have to figure out why my XPath isn't working for me.

However, LINQ to XML is more than just new funky querying mechanisms. There is a whole new set of classes to deal with XML that are much easier and more intuitive than the classes that were provided back with .NET 1.0, in my opinion.

The main two classes in the new way of doing XML are XElement and XAttribute. For example, to create a new element:

```csharp
XElement root = new XElement("root");
```

And to add an attribute to that element:
```csharp
root.Add(new XAttribute("AttributeName", "TheValue"));
```

Which produces the result: `<root AttributeName="TheValue" \>`

If you look at the intellisense for `XElement` constructor you'll see that none of the 5 overloads takes a string. The nearest is an `XName`. This is because there is an implicit conversion happening between a `string` and an `XName` so that creating `XElements` does not have to be so arduous. It would be quite irritating to have to declare `XElement` objects like this:

```csharp
XElement root = new XElement(XName.Get("root"));
```

At this point you'll find that all the VB developers will be gloating because VB9 contains a feature called XML Literals whereby the developer can just write XML directly into the source code file and VB will parse and compile it correctly. An incredibly handy feature I'm sure you'll agree. But, since I'm a C# developer that's what I'll stick with - especially considering that the majority of demos of LINQ to XML I've seen are VB based.

If you look closely at `XName`'s `Get` method you'll see that there are two overrides, one for an expanded name, and the other for a local name and a namespace name. The expanded name is just a string of the name with the namespace embedded in the string inside curly braces, like this:

```csharp
XName.Get("{mynamespace}root");
```

If you prefer you can use the other overloaded version and provide two strings. The equivalent `XName` in that case would be created like this:

```csharp
XName.Get("root", "mynamespace");
```

Now, you are probably wondering why a static method is being used rather than a constructor. This is because the XML classes are clever enough to reuse existing `XName` objects. If you create a second `XName` object with the same characteristics as an existing `XName` object it will just reuse the existing `XName`. For example, the following code will output "True" to the console:

```csharp
XName name1 = XName.Get("{ns}MyName");
XName name2 = XName.Get("MyName", "ns");
Console.WriteLine(object.ReferenceEquals(name1, name2));
```

`XName` is immutable (it cannot change) so this is a perfectly acceptable thing to do.

The extended name notation also works if you are using strings while constructing your XElement. For example:

```csharp
XElement root = new XElement("{mynamespace}root");
```

However, there is another way of applying namespaces in an `XElement`. You can use an `XNamespace` object and add it to the string. Like this:

```csharp
XNamespace ns = XNamespace.Get("mynamespace");
XElement root = new XElement(ns + "root");
```

As you can probably tell the `+` operator has been overloaded so it can be used to add a namespace to a string to produce an `XName`.
