---
title: "Navigating XML (LINQ to XML series - Part 3)"
slug: navigating-xml-linq-to-xml-series-part-3
publishDate: 18 May 2008
description: "In my last two posts I've been introducing you to the the new XML classes in .NET 3.5. In this post I'll continue that and show you some..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
---
In my last two posts ([part 1](/2008/04/08/introduction-to-linq-to-xml) and [part 2](/2008/04/12/getting-values-out-of-xml-in-net-35-linq-to-xml-series-part-2)) I've been introducing you to the the new XML classes in .NET 3.5. In this post I'll continue that and show you some of the ways to navigate through XML.
First of all, lets start with a simple hierarchy of XML elements:

```csharp
XElement root = new XElement("FirstGeneration",
                    new XElement("SecondGeneration",
                        new XElement("ThirdGeneration",
                            new XElement("FourthGeneration"))));
```

Which looks like this when rendered as XML:

```xml
<FirstGeneration>
  <SecondGeneration>
    <ThirdGeneration>
      <FourthGeneration />
    </ThirdGeneration>
  </SecondGeneration>
</FirstGeneration>
```

Also in the last post I used Element to get a specific element from the current element. For example:

```csharp
XElement child = root.Element("SecondGeneration");
```

## Elements

If root (or FirstGeneration) only had one child element called "SecondGeneration" then everything is fine, you get what you asked for. However, if it contains multiple children all called "SecondGeneration" then you will only get the first element called "SecondGeneration".
For example, if you add the following to the code above:

```csharp
root.Add(new XElement("SecondGeneration","2"));
root.Add(new XElement("SecondGeneration","3"));
```

You will get a piece of XML that looks like this:

```xml
<FirstGeneration>
  <SecondGeneration>
    <ThirdGeneration>
      <FourthGeneration />
    </ThirdGeneration>
  </SecondGeneration>
  <SecondGeneration>2</SecondGeneration>
  <SecondGeneration>3</SecondGeneration>
</FirstGeneration>
```

If you want to get all those additional children called "SecondGeneration" you will need to use the Elements (note the plural) method. For example:

```csharp
IEnumerable<XElement> children = root.Elements("SecondGeneration");
```

You'll also note that we don't get a collection returned but an enumerable. This give us the opportunity to exploit many of the new extension methods. But I'll leave them for another post. For the moment, we just need to know that it make it easy for us to enumerate over the data using a foreach loop. For example:

```csharp
foreach (XElement child in children)
{
    Console.WriteLine(child);
    Console.WriteLine(new string('-', 50));
}
```

This will write out:

```xml
<SecondGeneration>
  <ThirdGeneration>
    <FourthGeneration />
  </ThirdGeneration>
</SecondGeneration>
--------------------------------------------------
<SecondGeneration>2</SecondGeneration>
--------------------------------------------------
<SecondGeneration>3</SecondGeneration>
--------------------------------------------------
```

## Parent

Using the same root object as above, we can see how to navigate back up the XML tree using Parent.

```csharp
XElement grandchild = root.Element("SecondGeneration").Element("ThirdGeneration");
Console.WriteLine(grandchild.Parent);
```

The result of the code will be that the SecondGeneration element is printed.
