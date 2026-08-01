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
<!-- TODO: convert this post's content to Markdown -->

This is the 5th part in a series on LINQ to XML. In this instalment we will look at monitoring changes in XML data in the XML classes added to .NET 3.5.

The <strong>XObject</strong> class (from which <strong>XElement</strong> and <strong>XAttribute</strong>, among others) contains two events that are of interest to anyone wanting to know about changes to the XML data: <strong>Changing</strong> and <strong>Changed</strong>

The <strong>Changing</strong> event is triggered prior to a change being applied to the XML data. The <strong>Changed</strong> event is triggered after the change has been applied.

An example of adding the event handler would be something like this:
<pre class="code"><span style="color:#2b91af;">XElement </span>root = <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"root"</span>);
root.Changed += <span style="color:blue;">new </span><span style="color:#2b91af;">EventHandler</span>&lt;<span style="color:#2b91af;">XObjectChangeEventArgs</span>&gt;(root_Changed);</pre>
The above example will trigger for any change that happens in the node the event handler is applied to and any node downstream of it. As the example is applied to the root node this means the event will trigger for any change in the XML data.

The event handler is supplied an <strong>XObjectChangeEventArgs</strong> object which contains an <strong>ObjectChange</strong> property. This is an <strong>XObjectChange</strong> enum and it lets the code know what type of change happened.

The sender contains the actual object in the XML data that has changed.
<h1>Adding an element</h1>
Take the following example where an element is added to the XML data.
<pre class="code"><span style="color:#2b91af;">XElement </span>child = <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"ChildElement"</span>, <span style="color:#a31515;">"Original Value"</span>);
root.Add(child);</pre>
<a href="http://11011.net/software/vspaste"></a>

In this case the <strong>ObjectChanged</strong> is <strong>Add</strong> and the sender is the <strong>XElement</strong>: &lt;ChildElement&gt;Original Value&lt;/ChildElement&gt;

A similar scenario happens when adding an attribute. However, instead of the sender being an <strong>XElement</strong> it will be an <strong>XAttribute</strong>.
<pre class="code">child.Add(<span style="color:blue;">new </span><span style="color:#2b91af;">XAttribute</span>(<span style="color:#a31515;">"TheAttribute"</span>, <span style="color:#a31515;">"Some Value"</span>));</pre>
<a href="http://11011.net/software/vspaste"></a>
<h1>Changing an element value</h1>
If the value of the element is changed (the bit that currently says "Original Value") then we don't get one event fired. We get two events fired. For example:
<pre class="code">child.Value = <span style="color:#a31515;">"New Value"</span>;</pre>
<a href="http://11011.net/software/vspaste"></a>

The first event with <strong>ObjectChanged</strong> set to <strong>Remove</strong> and the sender set to "Orginal Value" (which is actually an <strong>XText</strong> object) and the second event with the <strong>ObjectChanged</strong> set to <strong>Add</strong> and the sender set to "New Value" (again, this is actually an <strong>XText</strong> object).
<h1>Changing an element name</h1>
If the name of the element is changed then the <strong>ObjectChanged</strong> property will be set to <strong>Name</strong> and the sender will be the <strong>XElement</strong> that has changed.
<pre class="code">child.Name = <span style="color:#a31515;">"JustTheChild"</span>;</pre>
<h1>Changing an attribute name</h1>
Unlike changing an element value, when the value of an attribute changes the <strong>ObjectChanged</strong> property will be <strong>Value</strong> and the sender will be the <strong>XAttribute</strong>.
<pre class="code">child.Attribute(<span style="color:#a31515;">"TheAttribute"</span>).Value = <span style="color:#a31515;">"New Attribute Value"</span>;</pre>
<a href="http://11011.net/software/vspaste"></a>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:43bd53b7-890e-41d1-aea0-9bf6a429e724" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/c#">c#</a>,<a rel="tag" href="http://technorati.com/tags/.net">.net</a>,<a rel="tag" href="http://technorati.com/tags/.net%203.5">.net 3.5</a>,<a rel="tag" href="http://technorati.com/tags/xml">xml</a></div>
