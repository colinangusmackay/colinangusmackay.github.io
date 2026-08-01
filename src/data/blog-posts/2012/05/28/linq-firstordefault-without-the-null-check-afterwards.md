---
title: "LINQ: FirstOrDefault without the null check afterwards."
slug: linq-firstordefault-without-the-null-check-afterwards
publishDate: 28 May 2012
description: "So, I was considering a problem I had that called for a LINQ statement that contains a FirstOrDefault() call. If there was an object returned I wanted a string..."
tags:
  - { name: "FirstOrDefault", slug: firstordefault }
  - { name: "LINQ", slug: linq }
  - { name: "null-coalescing operator", slug: null-coalescing-operator }
  - { name: "Select", slug: select }
  - { name: "Where", slug: where }
---
<!-- TODO: convert this post's content to Markdown -->

So, I was considering a problem I had that called for a LINQ statement that contains a <code>FirstOrDefault()</code> call. If there was an object returned I wanted a string property from it. If not, then I wanted to use a <code>string.Empty</code>.

I've often just caputured the result of the LINQ statement, checked for <code>null</code>, and if I had an object I'd call the property.

e.g.
<pre>var number = numbers.FirstOrDefault();
string firstNumberCaption = string.Empty;
if (number != null)
    firstNumberCaption = number.Caption;
Console.WriteLine("The first number is {0}", firstNumberCaption);</pre>
However, that code is a bit convoluted, and it occurred to me that there would be a better way of doing this.
<h3>The pure LINQ way</h3>
What if I called Select before the <code>FirstOrDefault()</code> to get the value of the property that I wanted. That way I don't have to worry about implementing my check.
<pre>var firstNumber = numbers
    .Select(n =&gt; n.Caption)
    .FirstOrDefault();</pre>
And if I am desperate for the resulting string to be the empty string I can always append <code>?? string.Empty</code> onto the end, like this:
<pre>var firstNumber = numbers
    .Select(n =&gt; n.Caption)
    .FirstOrDefault() ?? string.Empty;</pre>
If you are not familiar with the <a title="Null-coalescing operator" href="http://msdn.microsoft.com/en-us/library/ms173224(v=vs.80).aspx" target="_blank">?? (null-coalescing) operator</a> you can find out more on MSDN.
<h3>Optimisation</h3>
My next concern was that perhaps it will convert every instance in the enumerable that was passed to LINQ before discarding them all but the first one. However, that doesn't happen. For example, the following code only outputs one thing:
<pre>var firstNumber = numbers
    .Select(n =&gt;
    {
        Console.WriteLine("Select {0} / {1}", n.Value, n.Caption);
        return n.Caption;
    })
    .FirstOrDefault() ?? string.Empty;</pre>
<h3>Filtering</h3>
I often put filters in my calls to <code>FirstOrDefault()</code>, and most of the time it is a filter on something other than what I'm returning in the <code>Select</code> part of the statement. Obviously, if we are performing the <code>Select</code> first, then the filter is not going to work if it is looking for data that is no longer there. In this case we just insert a <code>Where</code> statement just before the select to ensure that the filtering does happen.

So, for example, the first number in the sequence greater than 2:
<pre>var firstNumberCaption = numbers
    .Where(n =&gt; n.Value &gt; 2)
    .Select(n =&gt; n.Caption)
    .FirstOrDefault() ?? string.Empty;

Console.WriteLine("The first number is {0}", firstNumberCaption);</pre>
<h3>Full program</h3>
Here is the full program (using the last example) if you want to see everything that is going on.
<pre>using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication2
{
    class Number
    {
        public Number(int value, string caption)
        {
            Value = value;
            Caption = caption;
        }

        public int Value { get; set; }
        public string Caption { get; set; }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Number[] numbers =
                {
                    new Number(1, "One"),
                    new Number(2, "Two"),
                    new Number(3, "Three")
                };

            var firstNumberCaption = numbers
                .Where(n =&gt; n.Value &gt; 2)
                .Select(n =&gt; n.Caption)
                .FirstOrDefault() ?? string.Empty;

            Console.WriteLine("The first number is {0}", firstNumberCaption);

            Console.ReadLine();
        }
    }
}</pre>
