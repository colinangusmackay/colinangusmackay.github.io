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
<!-- TODO: convert this post's content to Markdown -->

Last year I wrote about the new languages features available in C# 3.0 (<a href="http://colinmackay.co.uk/blog/2007/06/18/anonymous-types/">Anonymous Types</a>, <a href="http://colinmackay.co.uk/blog/2007/06/18/method-extensions/">Extension Methods</a>, <a href="http://colinmackay.co.uk/blog/2007/06/18/automatic-properties/">Automatic Properties</a>, <a href="http://colinmackay.co.uk/blog/2007/06/18/a-start-on-linq/">A start on LINQ</a>, <a href="http://colinmackay.co.uk/blog/2007/06/18/object-initialisers-i/">Object Initialisers I</a>, <a href="http://colinmackay.co.uk/blog/2007/06/18/object-initialisers-ii/">Object Initialisers II</a>, &amp; <a href="http://colinmackay.co.uk/blog/2007/06/18/object-initialisers-iii/">Object Initialisers III</a>) and since then I've really got in to LINQ, especially LINQ to XML. The reason for that is that I hate XPath and I see LINQ to XML as a much easier way of querying XML files without faffing about with terse XPath strings. I would much rather have the ability to easily see what is going on with the query than have to figure out why my XPath isn't working for me.

However, LINQ to XML is more than just new funky querying mechanisms. There is a whole new set of classes to deal with XML that are much easier and more intuitive than the classes that were provided back with .NET 1.0, in my opinion.

The main two classes in the new way of doing XML are XElement and XAttribute. For example, to create a new element:
<pre class="code"><span style="color:#2b91af;">XElement </span>root = <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"root"</span>);</pre>
And to add an attribute to that element:

root.Add(<span style="color:blue;">new </span><span style="color:#2b91af;">XAttribute</span>(<span style="color:#a31515;">"AttributeName"</span>, <span style="color:#a31515;">"TheValue"</span>));

Which produces the result: &lt;root AttributeName="TheValue" /&gt;

If you look at the intellisense for XElement constructor you'll see that none of the 5 overloads takes a string. The nearest is an XName. This is because there is an implicit conversion happening between a string and an XName so that creating XElements does not have to be so arduous. It would be quite irritating to have to declare XElement objects like this:
<pre class="code"><span style="color:#2b91af;">XElement </span>root = <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#2b91af;">XName</span>.Get(<span style="color:#a31515;">"root"</span>));</pre>
At this point you'll find that all the VB developers will be gloating because VB9 contains a feature called XML Literals whereby the developer can just write XML directly into the source code file and VB will parse and compile it correctly. An incredibly handy feature I'm sure you'll agree. But, since I'm a C# developer that's what I'll stick with - especially considering that the majority of demos of LINQ to XML I've seen are VB based.

If you look closely at XName's Get method you'll see that there are two overrides, one for an expanded name, and the other for a local name and a namespace name. The expanded name is just a string of the name with the namespace embedded in the string inside curly braces, like this:
<pre class="code"><span style="color:#2b91af;">XName</span>.Get(<span style="color:#a31515;">"{mynamespace}root"</span>);</pre>
If you prefer you can use the other overloaded version and provide two strings. The equivalent XName in that case would be created like this:
<pre class="code"><span style="color:#2b91af;">XName</span>.Get(<span style="color:#a31515;">"root"</span>, <span style="color:#a31515;">"mynamespace"</span>);</pre>
Now, you are probably wondering why a static method is being used rather than a constructor. This is because the XML classes are clever enough to reuse existing XName objects. If you create a second XName object with the same characteristics as an existing XName object it will just reuse the existing XName. For example, the following code will output "True" to the console:
<pre class="code"><span style="color:#2b91af;">XName </span>name1 = <span style="color:#2b91af;">XName</span>.Get(<span style="color:#a31515;">"{ns}MyName"</span>);
<span style="color:#2b91af;">XName </span>name2 = <span style="color:#2b91af;">XName</span>.Get(<span style="color:#a31515;">"MyName"</span>, <span style="color:#a31515;">"ns"</span>);
<span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:blue;">object</span>.ReferenceEquals(name1, name2));</pre>
XName is immutable (it cannot change) so this is a perfectly acceptable thing to do.

The extended name notation also works if you are using strings while constructing your XElement. For example:
<pre class="code"><span style="color:#2b91af;">XElement </span>root = <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(<span style="color:#a31515;">"{mynamespace}root"</span>);</pre>
However, there is another way of applying namespaces in an XElement. You can use an XNamespace object and add it to the string. Like this:
<pre class="code"><span style="color:#2b91af;">XNamespace </span>ns = <span style="color:#2b91af;">XNamespace</span>.Get(<span style="color:#a31515;">"mynamespace"</span>);
<span style="color:#2b91af;">XElement </span>root = <span style="color:blue;">new </span><span style="color:#2b91af;">XElement</span>(ns + <span style="color:#a31515;">"root"</span>);</pre>
As you can probably tell the + operator has been overloaded so it can be used to add a namespace to a string to produce an XName.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:6d9cd3a4-3e05-4441-b842-4612cc4aaa1b" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/linq">linq</a>,<a rel="tag" href="http://technorati.com/tags/xml">xml</a>,<a rel="tag" href="http://technorati.com/tags/linq%20to%20xml">linq to xml</a>,<a rel="tag" href="http://technorati.com/tags/.net">.net</a>,<a rel="tag" href="http://technorati.com/tags/.net%203.5">.net 3.5</a>,<a rel="tag" href="http://technorati.com/tags/C#">C#</a></div>
