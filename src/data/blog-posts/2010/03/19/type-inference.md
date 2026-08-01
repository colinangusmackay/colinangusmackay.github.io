---
title: "Type Inference"
slug: type-inference
publishDate: 19 Mar 2010
description: "Type Inference is a neat feature where the C# compiler can work out itself what type a reference to an object is. While this can be used for the developer to..."
tags:
  - { name: "C# 3", slug: c-3 }
---
<!-- TODO: convert this post's content to Markdown -->

<strong>Type Inference</strong> is a neat feature where the C# compiler can work out itself what type a reference to an object is. While this can be used for the developer to be lazy it is most useful when you are dealing with the exceptionally long type names that LINQ expressions can generate. It is also a requirement when dealing with anonymous types, because there simply is no type name that you can use.

For example:
<pre>var aString = “ABC”;
Type st = aString.GetType(); // System.String;

var aNumber = 123.45M;
Type nt = aNumber.GetType(); // System.Decimal

var aDate = DateTime.Now;
Type dt = aDate.GetType(); // System.DateTime</pre>
In each of the above examples the compiler works out from what is on the right side of the equals sign the type of the reference (or value) on the left hand side.

What is important is that the compiler has something it can work with. In other words, you <em>must</em> assign <em>something</em>.
<pre>var aString; // Illegal – Can’t infer type

// Computer says "no":
// Implicitly-typed local variables must be initialized</pre>
Also, because the variable is strongly typed from the get-go each time you assign something to it, it must be of the same type.
<pre>var aDate = DateTime.Now;
aDate = 123; // Illegal – Can’t change type

// Computer says "no":
// Cannot implicitly convert type 'int' to 'System.DateTime'</pre>
