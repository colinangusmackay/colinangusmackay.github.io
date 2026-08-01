---
title: "Lambda cheat sheet"
slug: lambda-cheat-sheet
publishDate: 17 Mar 2010
description: "A while ago I wrote about all the new language features of C# 3.0 and it occurred to me that I'd left out a chunk about Lambdas. With LINQ being such an..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C# 3", slug: c-3 }
---
<!-- TODO: convert this post's content to Markdown -->

A while ago I wrote about all the new language features of C# 3.0 and it occurred to me that I'd left out a chunk about Lambdas. With LINQ being such an important part of C#3.0 that seems like a terrible omission, so I'm going to make up for it now.

The easiest way to think about a lambda is that it is a short form of anonymous methods that were introduced in C#2. However, you can also use lambdas to create expression trees (I'll come to those in more detail in another post, for the moment, I'll be concentrate on using lambdas for creating anonymous methods).

<strong>Basic Structure</strong>

A lambda that looks like this
<pre>(i) =&gt; 123 + i
^^^ ^^ ^^^^^^^
(1) (2)  (3)</pre>
is compiled to an anonymous method
<pre>delegate (int i) { return 123+i; }
         ^^^^^^^   ^^^^^^^^^^^^^
           (1)          (3)</pre>
The first part of the lambda (1), in the brackets, declares the parameters. The brackets are, incidentally, optional if there is only one parameter. The type is inferred so you don't have to explicitly declare it as you would have to do with an anonymous method. However, if the compiler cannot infer the parameter type then you will have to declare it explicitly:
<pre>(int i) =&gt; 123 + i</pre>
<pre></pre>
The second part (2) is pronounced "goes to" and does not really have an equivalent with an anonymous method, although you could argue that it is the equivalent of the <em>delegate</em> keyword.

The third part (3) is the expression or statement. In a lambda expression the return is implicit so it does not need to be declared. It can also contain a number of statements enclosed in separated by semi-colon, but in that case it cannot be used to create expression trees and you must explicitly have a return statement if there is something being returned.
<pre>delegate void DisplayAdditionDelegate(int i, int j);

DisplayAdditionDelegate add = (i, j) =&gt;
    { Console.WriteLine("{0} + {1} = {2}", i, j, i+j); };
add(2, 5);
// Output is: 2 + 5 = 7</pre>
<strong>Framework assistance</strong>

The .NET Framework provides a number of predefined generic delegate types that can be used with lambdas in order that is is easy to refer to them and pass them around.

Each of these contains a generic list of parameter types and finally the return type, or if there are no parameters just the return type.

The delegates with a return type are defined as:
<pre>public delegate TResult Func&lt;TResult&gt;()
public delegate TResult Func&lt;T, TResult&gt;(T arg)
public delegate TResult Func&lt;T1, T2, TResult&gt;(T1 arg1, T2 arg2)
public delegate TResult Func&lt;T1, T2, T3, TResult&gt;(T1 arg1, T2 arg2, T3 arg3)
public delegate TResult Func&lt;T1, T2, T3, T4, TResult&gt;(T1 arg1, T2 arg2, T3 arg3, T4 arg4)</pre>
The delegates without a return type are defined as:
<pre>public delegate void Action&lt;T&gt;(T obj)
public delegate void Action&lt;T1, T2&gt;(T arg1, T2 arg2)
public delegate void Action&lt;T1, T2, T3&gt;(T arg1, T2 arg2, T3 arg3)
public delegate void Action&lt;T1, T2, T3, T4&gt;(T arg1, T2 arg2, T3 arg3, T4 arg4)</pre>
You can then uses these delegates to represent an appropriate method without having to create a custom delegate type - for most purposes they are quite sufficient.

<strong>Outer variables</strong>

Outer variables are variables that the lambda can use that are defined in the method that defines the lambda.
<pre>int j = 25;
Func&lt;int, int&gt; function = i =&gt; 100 + i + j;
j = 75;
int result = function(50);
// result == 225</pre>
As you can see in the above example the value of j is not evaluated at the point the lambda is declared, but at the point it is invoked. The lambda is able to keep a reference to j even although it was declared in a different scope. The same is true if the lambda is eventually invoked from a different scope block altogether. For example, if it has been passed out of the method in which it is declared.

The lambda can also change the value of the outer variable. For example:
<pre>int j = 6;
Func&lt;int, int&gt; function = i =&gt; { j = j * j; return 100 + i + j; };
int result = function(50);
// result == 186
// j == 36</pre>
