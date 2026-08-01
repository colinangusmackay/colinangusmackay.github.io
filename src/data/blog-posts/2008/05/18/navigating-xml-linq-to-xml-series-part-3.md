---
title: "Navigating XML (LINQ to XML series - Part 3)"
slug: navigating-xml-linq-to-xml-series-part-3
publishDate: 18 May 2008
description: "In my last two posts ( part 1 and part 2 ) I've been introducing you to the the new XML classes in .NET 3.5. In this post I'll continue that and show you some..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
---
<!-- TODO: convert this post's content to Markdown -->

In my last two posts (<a href="http://blog.colinmackay.net/archive/2008/04/08/2194.aspx" target="_blank">part 1</a> and <a href="http://blog.colinmackay.net/archive/2008/04/12/2203.aspx" target="_blank">part 2</a>) I've been introducing you to the the new XML classes in .NET 3.5. In this post I'll continue that and show you some of the ways to navigate through XML.

First of all, lets start with a simple hierarchy of XML elements:
<pre class="code"><span style="color:#2b91af;">XElement </span>root = <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"FirstGeneration"</span>,
                    <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"SecondGeneration"</span>,
                        <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"ThirdGeneration"</span>,
                            <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"FourthGeneration"</span>))));</pre>
<a href="http://11011.net/software/vspaste"></a>Which looks like this when rendered as XML:

&lt;FirstGeneration&gt;

&lt;SecondGeneration&gt;

&lt;ThirdGeneration&gt;

&lt;FourthGeneration /&gt;

&lt;/ThirdGeneration&gt;

&lt;/SecondGeneration&gt;

&lt;/FirstGeneration&gt;

Also in the last post I used Element to get a specific element from the current element. For example:
<pre class="code"><span style="color:#2b91af;">XElement </span>child = root.Element(<span style="color:#a31515;">"SecondGeneration"</span>);</pre>
<h1>Elements</h1>
If root (or FirstGeneration) only had one child element called "SecondGeneration" then everything is fine, you get what you asked for. However, if it contains multiple children all called "SecondGeneration" then you will only get the first element called "SecondGeneration".

For example, if you add the following to the code above:
<pre class="code">root.Add(<span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"SecondGeneration"</span>,<span style="color:#a31515;">"2"</span>));
root.Add(<span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"SecondGeneration"</span>,<span style="color:#a31515;">"3"</span>));</pre>
You will get a piece of XML that looks like this:

&lt;FirstGeneration&gt;

&lt;SecondGeneration&gt;

&lt;ThirdGeneration&gt;

&lt;FourthGeneration /&gt;

&lt;/ThirdGeneration&gt;

&lt;/SecondGeneration&gt;

&lt;SecondGeneration&gt;2&lt;/SecondGeneration&gt;

&lt;SecondGeneration&gt;3&lt;/SecondGeneration&gt;

&lt;/FirstGeneration&gt;

If you want to get all those additional children called "SecondGeneration" you will need to use the Elements (note the plural) method. For example:
<pre class="code"><span style="color:#2b91af;">IEnumerable</span>&lt;<span style="color:#2b91af;">XElement</span>&gt; children = root.Elements(<span style="color:#a31515;">"SecondGeneration"</span>);</pre>
<a href="http://11011.net/software/vspaste"></a>

You'll also note that we don't get a collection returned but an enumerable. This give us the opportunity to exploit many of the new extension methods. But I'll leave them for another post. For the moment, we just need to know that it make it easy for us to enumerate over the data using a foreach loop. For example:
<pre class="code"><span style="color:blue;">foreach </span>(<span style="color:#2b91af;">XElement </span>child <span style="color:blue;">in </span>children)
{
    <span style="color:#2b91af;">Console</span>.WriteLine(child);
    <span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:blue;">new string</span>(<span style="color:#a31515;">'-'</span>, 50));
}</pre>
<a href="http://11011.net/software/vspaste"></a><a href="http://11011.net/software/vspaste"></a>

This will write out:

&lt;SecondGeneration&gt;

&lt;ThirdGeneration&gt;

&lt;FourthGeneration /&gt;

&lt;/ThirdGeneration&gt;

&lt;/SecondGeneration&gt;

--------------------------------------------------

&lt;SecondGeneration&gt;2&lt;/SecondGeneration&gt;

--------------------------------------------------

&lt;SecondGeneration&gt;3&lt;/SecondGeneration&gt;

--------------------------------------------------
<h1>Parent</h1>
Using the same root object as above, we can see how to navigate back up the XML tree using Parent.
<pre class="code"><span style="color:#2b91af;">XElement </span>grandchild = root.Element(<span style="color:#a31515;">"SecondGeneration"</span>).Element(<span style="color:#a31515;">"ThirdGeneration"</span>);
<span style="color:#2b91af;">Console</span>.WriteLine(grandchild.Parent);</pre>
The result of the code will be that the SecondGeneration element is printed.

&nbsp;
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:04717698-edb0-4b6d-a718-33355a226512" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/c#">c#</a>,<a rel="tag" href="http://technorati.com/tags/.net">.net</a>,<a rel="tag" href="http://technorati.com/tags/.net%203.5">.net 3.5</a>,<a rel="tag" href="http://technorati.com/tags/xml">xml</a></div>
