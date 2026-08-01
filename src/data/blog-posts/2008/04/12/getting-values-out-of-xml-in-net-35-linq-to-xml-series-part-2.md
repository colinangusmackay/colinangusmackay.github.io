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
<!-- TODO: convert this post's content to Markdown -->

In my <a href="http://blog.colinmackay.net/archive/2008/04/08/2194.aspx" target="_blank">last post</a> I gave a brief introduction to some of the new XML classes available in .NET 3.5. In this post I'll continue that introduction by explaining how to get information out of the XML.

First off, lets assume we have some XML that looks like this:
<pre class="code"><span style="color:#2b91af;">XElement </span>root = <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"root"</span>,
    <span style="color:blue;">new </span><span style="color:#2b91af;">XAttribute</span>(<span style="color:#a31515;">"Attribute"</span>, <span style="color:#a31515;">"TheValue"</span>),
    <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"FirstChild"</span>),
    <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"SecondChild"</span>, <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"Grandchild"</span>, <span style="color:#a31515;">"The content of the grandchild"</span>)));</pre>
or, if you prefer in XML format, like this:

&lt;root Attribute="TheValue"&gt;

&lt;FirstChild /&gt;

&lt;SecondChild&gt;

&lt;Grandchild&gt;The content of the grandchild&lt;/Grandchild&gt;

&lt;/SecondChild&gt;

&lt;/root&gt;

There are a number of ways to get the content of the grandchild element. For example:
<pre class="code"><span style="color:#2b91af;">Console</span>.WriteLine(root.Element(<span style="color:#a31515;">"SecondChild"</span>).Element(<span style="color:#a31515;">"Grandchild"</span>).Value);</pre>
Value returns a string which contains the content of the element specified. In the above case it will output:

The content of the grandchild

However, you need to watch out for when there are child elements of the thing you want the value of as their content is included when you get the value. For example, if the above XML is extended so that it looks like this:

&lt;root Attribute="TheValue"&gt;

&lt;FirstChild /&gt;

&lt;SecondChild&gt;

&lt;Grandchild&gt;The content of the grandchild

&lt;Great-grandchild&gt;GGC content&lt;/Great-grandchild&gt;

&lt;Grandchild&gt;

&lt;/SecondChild&gt;

&lt;/root&gt;

And the above line of C# is executed again, the result is now:

The content of the grandchildGGC content

As you can see the content of the element you want plus its child elements are now returned. This may not necessarily be what you want.

There is a second way to get the content from an element. That is to use a casting operator. You can cast the element to a number of types. In this case to a string. for example:
<pre class="code"><span style="color:#2b91af;">Console</span>.WriteLine((<span style="color:blue;">string</span>)root.Element(<span style="color:#a31515;">"SecondChild"</span>).Element(<span style="color:#a31515;">"Grandchild"</span>));</pre>
The result is the same as calling Value on the element.

Be careful here, because casting an element to a string will not have the same result as calling ToString() on an element. You can see that if you simply pass the element itself to writeline (which will then call ToString() for you). For example:
<pre class="code"><span style="color:#2b91af;">Console</span>.WriteLine(root.Element(<span style="color:#a31515;">"SecondChild"</span>).Element(<span style="color:#a31515;">"Grandchild"</span>));</pre>
<a href="http://11011.net/software/vspaste"></a>The result is:

&lt;Grandchild&gt;The content of the grandchild

&lt;Great-grandchild&gt;GGC content&lt;/Great-grandchild&gt;

&lt;/Grandchild&gt;

The process is similar if you are dealing with attribute. Using the above XML as an example, an attribute value can be retrieved like this:
<pre class="code"><span style="color:#2b91af;">Console</span>.WriteLine(root.Attribute(<span style="color:#a31515;">"Attribute"</span>).Value);</pre>
Or, using the cast operator to a string like this:
<pre class="code"><span style="color:#2b91af;">Console</span>.WriteLine((<span style="color:blue;">string</span>)root.Attribute(<span style="color:#a31515;">"Attribute"</span>));</pre>
<a href="http://11011.net/software/vspaste"></a>Both of the above pieces of code output the same thing: TheValue

If you were to call WriteLine on an XAttribute object you'll see that the ToString() method returns something slightly different. It returns this: Attribute="TheValue"

Lets say, for instance, that the Attribute had a value of 123.456, which is a valid number representation. I mentioned earlier about casting operators on XElement and XAttribute. Well, you can cast this to a double if you prefer to get the value in that type. There is no tedious converting in your own code as the framework can handle that for you. For example:
<pre class="code">(<span style="color:blue;">double</span>)root.Attribute(<span style="color:#a31515;">"Attribute"</span>)</pre>
That's it for this post. There will be more on XML and LINQ soon.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:18440b10-9d62-4d49-90c2-cb60af64f8e0" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/XML">XML</a>,<a rel="tag" href="http://technorati.com/tags/LINQ%20to%20xml">LINQ to xml</a>,<a rel="tag" href="http://technorati.com/tags/LINQ">LINQ</a>,<a rel="tag" href="http://technorati.com/tags/.NET">.NET</a>,<a rel="tag" href="http://technorati.com/tags/XElement">XElement</a>,<a rel="tag" href="http://technorati.com/tags/XAttribute">XAttribute</a></div>
