---
title: "Monitoring change in XML data (LINQ to XML series - Part 5)"
slug: monitoring-change-in-xml-data-linq-to-xml-series-part-5
publishDate: 19 Jul 2008
description: "This is the 5th part in a series on LINQ to XML. In this instalment we will look at monitoring changes in XML data in the XML classes added to .NET 3.5. The..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
---
This is the 5th part in a series on LINQ to XML. In this instalment we will look at monitoring changes in XML data in the XML classes added to .NET 3.5.

For the previous instalments see [part 1](/2008/04/08/introduction-to-linq-to-xml), [part 2](/2008/04/12/getting-values-out-of-xml-in-net-35-linq-to-xml-series-part-2), [part 3](/2008/05/18/navigating-xml-linq-to-xml-series-part-3), and [part 4](/2008/06/22/navigating-xml-linq-to-xml-series-part-4)

The `XObject` class (from which `XElement` and `XAttribute`, among others) contains two events that are of interest to anyone wanting to know about changes to the XML data: `Changing` and `Changed`

The `Changing` event is triggered prior to a change being applied to the XML data. The `Changed` event is triggered after the change has been applied.
An example of adding the event handler would be something like this:

```csharp
XElement root = new XElement("root");
root.Changed += new EventHandler<XObjectChangeEventArgs>(root_Changed);
```

The above example will trigger for any change that happens in the node the event handler is applied to and any node downstream of it. As the example is applied to the root node this means the event will trigger for any change in the XML data.

The event handler is supplied an `XObjectChangeEventArgs` object which contains an `ObjectChange` property. This is an `XObjectChange` enum and it lets the code know what type of change happened.

The sender contains the actual object in the XML data that has changed.

## Adding an element

Take the following example where an element is added to the XML data.

```csharp
XElement child = new XElement("ChildElement", "Original Value");
root.Add(child);
```

In this case the `ObjectChanged` is `Add` and the sender is the `XElement`: `<ChildElement>Original Value</ChildElement>`

A similar scenario happens when adding an attribute. However, instead of the sender being an `XElement` it will be an `XAttribute`.

```csharp
child.Add(new XAttribute("TheAttribute", "Some Value"));
```

## Changing an element value

If the value of the element is changed (the bit that currently says "Original Value") then we don't get one event fired. We get two events fired. For example:

```csharp
child.Value = "New Value";
```

The first event with `ObjectChanged` set to `Remove` and the sender set to "Original Value" (which is actually an `XText` object) and the second event with the `ObjectChanged` set to `Add` and the sender set to "New Value" (again, this is actually an `XText` object).

## Changing an element name

If the name of the element is changed then the `ObjectChanged` property will be set to `Name` and the sender will be the `XElement` that has changed.

```csharp
child.Name = "JustTheChild";
```

## Changing an attribute name

Unlike changing an element value, when the value of an attribute changes the `ObjectChanged` property will be `Value` and the sender will be the `XAttribute`.

```csharp
child.Attribute("TheAttribute").Value = "New Attribute Value";
```
