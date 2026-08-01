---
title: "Tip of the Day #16: NaN (Not a Number)"
slug: tip-of-the-day-16-nan-not-a-number
publishDate: 12 Sep 2009
description: "The Issue If you want to detect if a double (System.Double) or float (System.Single) is ?not a number? or NaN you cannot use something like this: if (myDouble..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---
<!-- TODO: convert this post's content to Markdown -->

<h3>The Issue</h3>
If you want to detect if a double (System.Double) or float (System.Single) is ?not a number? or NaN you cannot use something like this:
<pre>if (myDouble == double.NaN)
{
   /* do something */
}</pre>
It will always be false.

Sounds crazy? Try this:
<pre>double myDouble = double.NaN;
Console.WriteLine("myDouble == double.NaN : {0}", myDouble == double.NaN);</pre>
The result is:

<strong>myDouble == double.NaN : False</strong>

You can see that myDouble was explicitly set the value of double.NaN, yet in the next line it is returning false.
<h3>The Solution</h3>
If you want to test for a floating point value being Not a Number you to use IsNan() which is a static method on System.Double and System.Single. Here is the first example re-written to use the static method. It will now work correctly:
<pre>if (double.IsNan(myDouble) { /* do something */ }</pre>
If we re-write our other example:
<pre>double myDouble = double.NaN;
Console.WriteLine("double.IsNaN(myDouble) : {0}", double.IsNaN(myDouble));</pre>
We get the expected result too:

<strong>double.IsNaN(myDouble) : True</strong>
<h3>The Reason</h3>
According to Wikipedia: <em>In </em><a href="http://en.wikipedia.org/wiki/Computing"><em>computing</em></a><em>, <strong><a href="http://en.wikipedia.org/wiki/NaN">NaN</a></strong>, which stands for <strong>N</strong>ot <strong>a</strong> <strong>N</strong>umber, is a value or symbol that is usually produced as the result of an operation on invalid input operands, especially in </em><a href="http://en.wikipedia.org/wiki/Floating_point"><em>floating-point</em></a><em> calculations. For example, most </em><a href="http://en.wikipedia.org/wiki/Floating_point_unit"><em>floating-point units</em></a><em> are unable to explicitly calculate the square root of negative numbers, and will instead indicate that the operation was invalid and return a NaN result. NaNs may also be used to represent missing values in computations.</em>

It goes on to say: <em>A NaN does not compare equal to any floating-point number or NaN, even if the latter has an identical representation. One can therefore test whether a variable has a NaN value by comparing it to itself, thus if x = x gives false then x is a NaN code.</em>

This is why (double.NaN == double.NaN) always results in false. And it is also how the .NET framework detects the NaN value in the IsNan() method.
<pre>public static bool IsNaN(double d)
{
     return (<a>d</a> != <a>d</a>);
}</pre>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:3609ff88-8c57-41ac-a86f-d2f45b1ff1f4" class="wlWriterEditableSmartContent" style="margin:0;display:inline;float:none;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/NaN">NaN</a>,<a rel="tag" href="http://technorati.com/tags/Not+a+Number">Not a Number</a>,<a rel="tag" href="http://technorati.com/tags/C%23">C#</a>,<a rel="tag" href="http://technorati.com/tags/.NET">.NET</a>,<a rel="tag" href="http://technorati.com/tags/floating+point+numbers">floating point numbers</a>,<a rel="tag" href="http://technorati.com/tags/float">float</a>,<a rel="tag" href="http://technorati.com/tags/double">double</a>,<a rel="tag" href="http://technorati.com/tags/System.Single">System.Single</a>,<a rel="tag" href="http://technorati.com/tags/System.Double">System.Double</a></div>
<img src="http://blog.colinmackay.net/aggbug/8988.aspx" alt="" width="1" height="1" />
