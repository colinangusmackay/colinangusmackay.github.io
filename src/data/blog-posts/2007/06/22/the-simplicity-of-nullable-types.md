---
title: "The simplicity of nullable types"
slug: the-simplicity-of-nullable-types
publishDate: 22 Jun 2007
description: "I just discovered nullable types. Wow! They are really simple and such a powerful feature. Just see for yourself.... If you have an int or a DateTime or any..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 2", slug: c-2 }
---
<!-- TODO: convert this post's content to Markdown -->


		<p>I just discovered nullable types. Wow! They are really simple and such a powerful feature. Just see for yourself....</p>
<p>If you have an <code>int</code> or a <code>DateTime</code> or any other value type you'll already know that you cannot assign <code>null</code> to them. But in C#2.0 you can.</p>
<p>You can define a nullable <code>int</code> by adding a question mark to the end of the type like this:</p>
<pre>int? a = null;</pre>
<p>However, you'll want the new code to operate with old code which hasn't yet been upgraded to use nullable types, so there is a new binary operator to help. The <code>??</code> (I've no idea how your meant to pronounce that. I just say "Double question mark")</p>
<p>So, if you want to assign <code>a</code> (above) to a regular <code>int</code> you can do the following:</p>
<pre>int b = a ?? -1;</pre>
<p>If <code>a</code> is non-<code>null</code> then <code>b</code> is assigned the same value as <code>a</code>. If a is <code>null</code> then <code>b</code> is assigned the value on the right side of the <code>??</code>. So, just like the old days where you'd make up a value to represent <code>null</code> for an integer (I normally used <code>int.MinValue</code>)</p>
<p><em>NOTE: This was rescued from the google cache. The original date was Friday, 9th June, 2006.</em></p>
<p>Tags: <a href="http://technorati.com/tag/nullable+type" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=nullable+type" alt=" ">nullable type</a> <a href="http://technorati.com/tag/nullable" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=nullable" alt=" ">nullable</a> <a href="http://technorati.com/tag/c%23" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23" alt=" ">c#</a> <a href="http://technorati.com/tag/value+type" rel="tag"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=value+type" alt=" ">value type</a> </p>

	
