---
title: "Tip of the day: Quickly finding commented out code in C-like languages"
slug: tip-of-the-day-quickly-finding-commented-out-code-in-c-like-languages
publishDate: 17 Oct 2013
description: "This is a quick rough-and-ready way of finding commented out code in languages like C#, C++, javaScript and Java. It won't find all instances, but it will..."
tags: []
---
<!-- TODO: convert this post's content to Markdown -->

This is a quick rough-and-ready way of finding commented out code in languages like C#, C++, javaScript and Java. It won't find all instances, but it will probably find most.

Essentially, you can use a regular expression to search through the source code looking for a specific pattern.

The following works for Visual Studio for searching C#. The same expression would also likely work in other similar languages where the comment line starts with a double slash and ends in a semi-colon.

So for Visual Studio, press Ctrl+F to bring up the search bar, set the search option to be be "Regular Expression" and set it to look in the "Entire Solution" (or what ever extent you are searching) then enter the regular expression into the search box:
<pre><strong>^\s*//.*;\s*$</strong></pre>
[caption id="" align="aligncenter" width="280"]<img alt="Visual Studio 2012 Search Bar" src="http://static.colinmackay.co.uk/images/visual-studio/2013-10-17-visual-studio-2012-search-bar.png" width="280" height="90" /> Visual Studio 2012 Search Bar[/caption]

Then tell it to "Find all" and you'll be presented with a list of lines of code that appear to be commented out.
<h3>Caveats</h3>
It is not fully proof. It does not find code commented out in the style:
<pre>/*
* Commented = out.code.here();
*/</pre>
It also does not find commented out code on lines that do not end in a semi-colon such as namespace, class, method declarations and the like, nor on lines that simple contain scope operators (The { and } braces to define the scope of a namespace, class, method, etc.)

And although I've said C-like languages in the title, I don't recall that C ever had the double-slash comment style (although many languages based on it do, hence "C-like")

<strong>Update</strong>: Updated the regular expression to ignore white space at the start and end of the line.
