---
title: "Tip of the day: Splitting a string when encountering whitespace"
slug: tip-of-the-day-splitting-a-string-when-encountering-whitespace
publishDate: 08 Jun 2011
description: "In .NET the string class has a Split method that splits the string at the separator character(s) that you specify. However, if you want to split the string at..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---
In .NET the `string` class has a `Split` method that splits the string at the separator character(s) that you specify. However, if you want to split the string at any instance of whitespace you don’t have to create a `Split` call that enumerates all those different types of whitespace... and there are actually quite a lot! Instead you can just call `Split` without any parameters and it will split at whitespace regardless of the type.

For example, the following program, in which I hope I've managed to use all the different types of whitespace in Unicode, will produce the output below:

```csharp
static void Main(string[] args)
{
  string source =
    "An\u0020inspired\rcalligraphe\r\ncan\u1680create\u180epages\u2000of"+
    "\u2001beauty\tusing\u2002stick\u2003ink,\u2004quill,\u2005brush,"+
    "\u2006pick-axe,\u2007buzz\u2008saw,\u2009or\u200aeven\u202fstrawberry"+
    "\u205fjam."+
    Environment.NewLine+
    "The\u3000quick\u2028brown\u2029fox\u0009jumps\u000aover\u000bthe\u000c"+
    "lazy\u000ddog."+
    Environment.NewLine+
    "Whitespace\u0085For\u00a0the win!";

  string[] words = source.Split();

  foreach(string word in words)
  {
    Console.WriteLine(word);
  }
}
```

Produces this output:

```
An
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
win!
```
