---
title: "First(OrDefault) Vs. Single(OrDefault)"
slug: firstordefault-vs-singleordefault
publishDate: 07 Oct 2011
description: "There are two mechanisms (each with an …OrDefault variant) in LINQ for getting one item out of an enumeration. They are First and Single . There is a..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "LINQ", slug: linq }
---
<!-- TODO: convert this post's content to Markdown -->

<p>There are two mechanisms (each with an <code>…OrDefault</code> variant) in LINQ for getting one item out of an enumeration. They are <code>First</code> and <code>Single</code>. There is a difference between the two and you can produce code that functions incorrectly if the wrong one is used.</p> <p>So, what’s the main difference? They both sound like they’ll return just one item out from the enumeration. And, indeed, they do. </p> <p><code>First</code> will return the first item that it encounters that matches the predicate (if supplied). Whereas <code>Single</code> will return the one and only item that it encounters that matches the predicate (if supplied). If <code>Single</code> encounters a second item that matches the predicate then it throws an exception. If no predicate is supplied, it throws an exception simply if the enumeration has more that one item.</p> <p>Why would there be two things that do almost the same thing that are so subtly different? First exists so that you can get the first item regardless of how many items there may actually be. Single exists to get you the one and only item. Single is useful when your predicate operates on a primary key. For example:</p><pre>data.Single(d =&gt; d.PrimaryKey == idToMatch)</pre>
<p>The <code>…OrDefault</code> variants will return the default value for the type (for reference types that will be <code>null</code>) if there are no matches found. Otherwise, both <code>First</code> and <code>Single</code> throw an exception if no items are encountered.</p>
<p>Lets look at some code.</p>
<h3>First</h3><pre>string[] data = new[]{"Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
var first = data.First();</pre>
<p>In this case, <code>first</code> will contain the value of <code>"Zero"</code>. </p>
<p>If a predicate is added to the call to <code>First</code> then we can see what happens if there is no match. </p><pre>string[] data = new[]{"Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
var first = data.First(x =&gt; x.Length &gt; 10);</pre>
<p>In this case, there are no matches, and an <code>InvalidOperationException</code> is thrown with the message "Sequence contains no matching element"</p>
<p>The same thing will happen if the initial set of data is empty</p><pre>string[] empty = new string[0];
var first = empty.First();</pre>
<p>You can happily supply a predicate that may match more than one item in the enumeration </p>
<h3>Single</h3>
<p>For example</p><pre>string[] onlyOneItem = new string[]{"Only item"};
var single = onlyOneItem.Single();</pre>
<p>This will return the one and only item that matches.</p><pre>string[] data = new[]{"Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
var single = data.Single();</pre>
<p>This will thrown an exception. If result set contains more than one item an <code>InvalidOpertationException</code> will be thrown with a message of "Sequence contains more than one element"</p><pre>string[] empty = new string[0];
var single = empty.Single();</pre>
<p>This will throw exactly the same exception as it's <code>First</code> counterpart; an <code>InvalidOperationException</code> is thrown with the message "Sequence contains no matching element"</p>
<h3>…OrDefault</h3>
<p>This is where things get a little bit more interesting. This says that if the result set contains zero items null (for reference types) is returned. In the case of <code>First</code>, the result set can contain zero, one or many items and it won’t throw an exception. In the case of <code>Single</code> only result sets containing zero or one item will return while any more will result in an exception.</p>
<p>So… what about this scenario:</p><pre>string[] data = new[]{null, "Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
var first = data.FirstOrDefault();</pre>
<p>The first value of the set is genuinely <code>null</code>. How do you tell the difference between that and the result set being simply empty without throwing an exception?</p>
<p>You could just go back to using the <code>First</code> variant and catching the exception. Or you could (if your result set can be enumerated many times without issue, e.g. the underlying object is an Array or List) use <code>Any</code> to test if the set contains any data in advance. Like this: <pre>string[] data = new[]{null, "Zero", "One", "Two", "Three",
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"};
if (data.Any())
{
    var first = data.FirstOrDefault();
    // Do stuff with the value
}
</pre>
