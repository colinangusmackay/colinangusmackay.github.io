---
title: "Tip of the Day #8 (string performance)"
slug: tip-of-the-day-8-string-performance
publishDate: 04 Aug 2008
description: "Concatenating strings in .NET can be very easy. There is the overloaded + operator that makes stringA + stringB + stringC statements very easy to write. But,..."
tags:
  - { name: ".NET", slug: net }
---
<!-- TODO: convert this post's content to Markdown -->

Concatenating strings in .NET can be very easy. There is the overloaded + operator that makes <strong>stringA + stringB + stringC</strong> statements very easy to write. But, it isn't very performant. The reason is that strings are immutable, and concatenating strings in this way causes lots of short-lived objects to be created and thrown away, which in turn causes the garbage collector to run frequently.

There are two better ways in .NET to concatenate strings. One is to use the <strong>string.Concat()</strong> method. The other is to use the <strong>StringBuilder</strong> class. They both perform better than adding strings together, but you still have to know when to use each.

According to this article on "<a href="http://www.codeproject.com/KB/cs/stringperf.aspx" target="_blank">Performance considerations for strings in C#</a>" <strong>string.Concat()</strong> is good up to 600 strings. But, only if you have 600 strings to concatenate in a single statement. <strong>StringBuilder</strong> is better if you have more than 600 strings to concatenate, but you can do so over multiple statements. In reality, I think the benefits of appending strings over multiple statements with <strong>StringBuilder</strong> will work out better even with much less than 600 strings because to get the performance out of <strong>string.Concat()</strong> you'll have to perform some form of setup operation to line all those strings up - and that will take time.

So, today's tip is don't use the plus operator to combine strings except in quick / throw-away applications. Use <strong>string.Concat()</strong> or <strong>StringBuilder</strong> instead.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:f0529d1c-f618-4773-828b-706583c2de62" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/string">string</a>,<a rel="tag" href="http://technorati.com/tags/concatenation">concatenation</a>,<a rel="tag" href="http://technorati.com/tags/concat">concat</a>,<a rel="tag" href="http://technorati.com/tags/stringbuilder">stringbuilder</a></div>
