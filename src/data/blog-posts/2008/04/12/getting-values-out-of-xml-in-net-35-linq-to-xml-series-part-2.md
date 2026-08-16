---
title: "Getting values out of XML in .NET 3.5 (LINQ to XML series part 2)"
slug: getting-values-out-of-xml-in-net-35-linq-to-xml-series-part-2
publishDate: 12 Apr 2008
description: "In my last post I gave a brief introduction to some of the new XML classes available in .NET 3.5. In this post I'll continue that introduction by explaining..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
---
In my [last post](/2008/04/08/introduction-to-linq-to-xml) I gave a brief introduction to some of the new XML classes available in .NET 3.5. In this post I'll continue that introduction by explaining how to get information out of the XML.
First off, lets assume we have some XML that looks like this:

```csharp
XElement root = new XElement("root",
    new XAttribute("Attribute", "TheValue"),
    new XElement("FirstChild"),
    new XElement("SecondChild", new XElement("Grandchild", "The content of the grandchild")));
```

or, if you prefer in XML format, like this:

```xml
<root Attribute="TheValue">
  <FirstChild />
  <SecondChild>
    <Grandchild>The content of the grandchild</Grandchild>
  </SecondChild>
</root>
```

There are a number of ways to get the content of the grandchild element. For example:

```csharp
Console.WriteLine(root.Element("SecondChild").Element("Grandchild").Value);
```

Value returns a string which contains the content of the element specified. In the above case it will output: `The content of the grandchild`

However, you need to watch out for when there are child elements of the thing you want the value of as their content is included when you get the value. For example, if the above XML is extended so that it looks like this:

```xml
<root Attribute="TheValue"\>
  <FirstChild />
  <SecondChild>
    <Grandchild>The content of the grandchild
      <Great-grandchild>GGC content</Great-grandchild>
    <Grandchild>
  </SecondChild>
</root>
```

And the above line of C# is executed again, the result is now: `The content of the grandchildGGC content`

As you can see the content of the element you want plus its child elements are now returned. This may not necessarily be what you want.

There is a second way to get the content from an element. That is to use a casting operator. You can cast the element to a number of types. In this case to a string. for example:

```csharp
Console.WriteLine((string)root.Element("SecondChild").Element("Grandchild"));
```

The result is the same as calling Value on the element.

Be careful here, because casting an element to a string will not have the same result as calling ToString() on an element. You can see that if you simply pass the element itself to `WriteLine` (which will then call `.ToString()` for you). For example:

```csharp
Console.WriteLine(root.Element("SecondChild").Element("Grandchild"));
```

The result is:
```xml
<Grandchild>The content of the grandchild
  <Great-grandchild>GGC content</Great-grandchild>
</Grandchild>
```

The process is similar if you are dealing with attribute. Using the above XML as an example, an attribute value can be retrieved like this:

```csharp
Console.WriteLine(root.Attribute("Attribute").Value);
```

Or, using the cast operator to a string like this:

```csharp
Console.WriteLine((string)root.Attribute("Attribute"));
```

Both of the above pieces of code output the same thing: `TheValue`

If you were to call `WriteLine` on an `XAttribute` object you'll see that the `.ToString()` method returns something slightly different. It returns this: `Attribute="TheValue"`

Lets say, for instance, that the Attribute had a value of `123.456`, which is a valid number representation. I mentioned earlier about casting operators on `XElement` and `XAttribute`. Well, you can cast this to a `double` if you prefer to get the value in that type. There is no tedious converting in your own code as the framework can handle that for you. For example:

```csharp
(double)root.Attribute("Attribute")
```

That's it for this post. There will be more on XML and LINQ soon.
