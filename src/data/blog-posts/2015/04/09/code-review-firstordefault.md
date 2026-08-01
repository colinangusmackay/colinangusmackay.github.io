---
title: "Code Review: FirstOrDefault()"
slug: code-review-firstordefault
publishDate: 09 Apr 2015
description: "I regularly review the code that I maintain. Recently, I've come across code like this fairly often: someCollection.FirstOrDefault().Id I cannot rightly..."
tags:
  - { name: "C#", slug: c }
  - { name: "Code Quality", slug: code-quality }
  - { name: "FirstOrDefault", slug: firstordefault }
  - { name: "LINQ", slug: linq }
---
<!-- TODO: convert this post's content to Markdown -->

I regularly review the code that I maintain. Recently, I've come across code like this fairly often:
<pre>someCollection.FirstOrDefault().Id</pre>
I cannot rightly comprehend why anyone would do this.

<code>FirstOrDefault()</code> returns the first item in a sequence or the default value if it doesn’t exist (i.e. the sequence is empty). For a reference type (classes, basically) the default value is <code>null</code>. So using the value returned by <code>FirstOrDefault()</code> without a <code>null</code> check is only valid for when the sequence contains a value type (e.g. <code>int</code>, <code>decimal</code>, <code>DateTime</code>, <code>Guid</code>, etc.)

In the example above if <code>someCollection</code> is an empty list/array/collection/whatever then <code>FirstOrDefault()</code> will return <code>null</code> and the call to the <code>Id</code> property will fail.

Then you are left with a <code>NullReferenceException</code> on line xxx but you don’t know if it is <code>someCollection</code>, or the returned value from <code>FirstOrDefault()</code> which then wastes your time (or the time of someone else who is having to debug it).

So, if the sequence must always contain items then use <code>First()</code>, in the exceptional event that it is empty the call to <code>First()</code> will throw a more appropriate exception that will help you debug faster. If it is perfectly valid for the sequence to be empty then perform a <code>null</code> check and change the behaviour appropriately.
