---
title: "Tip of the day: Splitting a string when encountering whitespace"
slug: tip-of-the-day-splitting-a-string-when-encountering-whitespace
publishDate: 08 Jun 2011
description: "In .NET the string class has a Split method that splits the string at the separator character(s) that you specify. However, if you want to split the string at..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---
<!-- TODO: convert this post's content to Markdown -->

<p>In .NET the <code>string</code> class has a <code>Split</code> method that splits the string at the separator character(s) that you specify. However, if you want to split the string at any instance of whitespace you don’t have to create a <code>Split</code> call that enumerates all those different types of whitespace... and there are actually quite a lot! Instead you can just call <code>Split</code> without any parameters and it will split at whitespace regardless of the type.</p>  <p>For example, the following program, in which I hope I've managed to use all the different types of whitespace in Unicode, will produce the output below:</p>  <pre>static void Main(string[] args)
{
  string source = &quot;Anu0020inspiredrcalligrapherncanu1680createu180epagesu2000ofu2001&quot;+
    &quot;beautytusingu2002sticku2003ink,u2004quill,u2005brush,u2006pick-axe,u2007buzzu2008&quot;+
    &quot;saw,u2009oru200aevenu202fstrawberryu205fjam.&quot;+
    Environment.NewLine+
    &quot;Theu3000quicku2028brownu2029foxu0009jumpsu000aoveru000btheu000clazyu000ddog.&quot;+
    Environment.NewLine+
    &quot;Whitespaceu0085Foru00a0the win!&quot;;

  string[] words = source.Split();

  foreach(string word in words)
  {
    Console.WriteLine(word);
  }
}</pre>

<p>Produces this output:</p>

<pre>An
inspired
calligrapher
can
create
pages
of
beauty
using
stick
ink,
quill,
brush,
pick-axe,
buzz
saw,
or
even
strawberry
jam.

The
quick
brown
fox
jumps
over
the
lazy
dog.

Whitespace
For
the
win!</pre>
