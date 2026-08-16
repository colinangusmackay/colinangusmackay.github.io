---
title: "Navigating XML (LINQ to XML series - part 4)"
slug: navigating-xml-linq-to-xml-series-part-4
publishDate: 22 Jun 2008
description: "In my last few posts on LINQ to XML ( part 1 , part 2 and part 3 ) I've shown you a starter on navigating around XML data. In this post I'll continue to show..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
---
In my last few posts on LINQ to XML ([part 1](/2008/04/08/introduction-to-linq-to-xml), [part 2](/2008/04/12/getting-values-out-of-xml-in-net-35-linq-to-xml-series-part-2) and [part 3](/2008/05/18/navigating-xml-linq-to-xml-series-part-3)) I've shown you a starter on navigating around XML data. In this post I'll continue to show you how to navigate through XML data by showing you how to navigate around sibling elements.

First consider this code:
```csharp
XElement root = new XElement("root",
    new XElement("FirstChild"),
    new XElement("SecondChild"),
    new XElement("ThirdChild"),
    new XElement("FouthChild"),
    new XElement("FifthChild"));
```

Which produces the following XML structure:

```xml
<root>
  <FirstChild />
  <SecondChild />
  <ThirdChild />
  <FouthChild />
  <FifthChild />
</root>
```

We can access the **ThirdChild** with this code:

```csharp
XElement child = root.Element("ThirdChild");
```

From that point, we can also get access to its siblings.

To access the siblings that occur before the element we have a reference to then we can use **ElementsBeforeSelf**. As with **Elements** this returns an **IEnumerable\<XElement\>** object which allows us to iterate over the result, like this:

```csharp
IEnumerable<XElement> elements = child.ElementsBeforeSelf();

foreach (XElement element in elements)
    Console.WriteLine(element);
```

The result is:

```xml
<FirstChild />
<SecondChild />
```

Conversely, we can get the siblings that come after the element we have a reference to with **ElementsAfterSelf**. Like this:

```csharp
IEnumerable<XElement> elements = child.ElementsAfterSelf();
```

The result in this case will be:

```xml
<FouthChild />
<FifthChild />
```
