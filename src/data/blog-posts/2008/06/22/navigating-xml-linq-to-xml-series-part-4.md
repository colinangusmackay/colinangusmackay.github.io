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
<!-- TODO: convert this post's content to Markdown -->

In my last few posts on LINQ to XML (<a href="http://blog.colinmackay.net/archive/2008/04/08/2194.aspx" target="_blank">part 1</a>, <a href="http://blog.colinmackay.net/archive/2008/04/12/2203.aspx" target="_blank">part 2</a> and <a href="http://blog.colinmackay.net/archive/2008/05/18/2376.aspx" target="_blank">part 3</a>) I've shown you a starter on navigating around XML data. In this post I'll continue to show you how to navigate through XML data by showing you how to navigate around sibling elements.

First consider this code:
<pre class="code"><span style="color:#2b91af;">XElement </span>root = <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"root"</span>,
    <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"FirstChild"</span>),
    <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"SecondChild"</span>),
    <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"ThirdChild"</span>),
    <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"FouthChild"</span>),
    <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"FifthChild"</span>));</pre>
<a href="http://11011.net/software/vspaste"></a>

Which produces the following XML structure:

&lt;root&gt;

&lt;FirstChild /&gt;

&lt;SecondChild /&gt;

&lt;ThirdChild /&gt;

&lt;FouthChild /&gt;

&lt;FifthChild /&gt;

&lt;/root&gt;

We can access the <strong>ThirdChild</strong> with this code:
<pre class="code"><span style="color:#2b91af;">XElement </span>child = root.Element(<span style="color:#a31515;">"ThirdChild"</span>);</pre>
<a href="http://11011.net/software/vspaste"></a>

From that point, we can also get access to its siblings.

To access the siblings that occur before the element we have a reference to then we can use <strong>ElementsBeforeSelf</strong>. As with <strong>Elements</strong> this returns an <strong>IEnumerable&lt;XElement&gt;</strong> object which allows us to iterate over the result, like this:
<pre class="code"><span style="color:#2b91af;">IEnumerable</span>&lt;<span style="color:#2b91af;">XElement</span>&gt; elements = child.ElementsBeforeSelf();

<span style="color:blue;">foreach </span>(<span style="color:#2b91af;">XElement </span>element <span style="color:blue;">in </span>elements)
    <span style="color:#2b91af;">Console</span>.WriteLine(element);</pre>
<a href="http://11011.net/software/vspaste"></a>

The result is:

&lt;FirstChild /&gt;

&lt;SecondChild /&gt;

Conversely, we can get the siblings that come after the element we have a reference to with <strong>ElementsAfterSelf</strong>. Like this:
<pre class="code"><span style="color:#2b91af;">IEnumerable</span>&lt;<span style="color:#2b91af;">XElement</span>&gt; elements = child.ElementsAfterSelf();</pre>
The result in this case will be:

&lt;FouthChild /&gt;

&lt;FifthChild /&gt;
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:6c154488-abff-4ac5-813b-32aa49c0a47b" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/c#">c#</a>,<a rel="tag" href="http://technorati.com/tags/.net">.net</a>,<a rel="tag" href="http://technorati.com/tags/.net%203.5">.net 3.5</a>,<a rel="tag" href="http://technorati.com/tags/xml">xml</a></div>
