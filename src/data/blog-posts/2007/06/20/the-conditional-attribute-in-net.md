---
title: "The Conditional attribute in .NET"
slug: the-conditional-attribute-in-net
publishDate: 20 Jun 2007
description: "One of the odd thoughts that shoot across my brain today was how does Debug.Assert() work? I mean there are not separate debug and release builds of the .NET..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Debugging", slug: debugging }
---
<!-- TODO: convert this post's content to Markdown -->

One of the odd thoughts that shoot across my brain today was how does Debug.Assert() work? I mean there are not separate debug and release builds of the .NET Framework so how does it know what sort of build it is?

A quick look in reflector revealed that Debug.Assert is defined as:
<pre>[Conditional("DEBUG")]
public static void Assert(bool condition, string message)
{
    TraceInternal.Assert(condition, message);
}</pre>
Interesting... I don't recall having ever come across the <a href="http://msdn2.microsoft.com/en-us/library/system.diagnostics.conditionalattribute(VS.71).aspx">Conditional</a> attribute before.

What this actually does is tell the compiler to only call the method when the supplied preprocessor symbol is defined. The method will still be compiled and will still exist in the assembly. So, in a debug build a program that looks like this:
<pre>static void Main(string[] args)
{
    Debug.Assert(true, "This condition must be true");
}</pre>
will still look like that, but when compiled in release mode, will look like this:
<pre>private static void Main(string[] args)
{
}</pre>
But what about more complex code. What happens if the method call includes calls to other methods. Like this:
<pre>static void Main(string[] args)
{
    Debug.Assert(GetTheCondition(), GetTheMessage());
}</pre>
So be careful - If the calls made as parameters into a method such as Assert modify the state of the object then that won't happen in release mode. For example, if the whole program looks like this:
<pre>class Program
{
    static int someState = 0;
    static string someOtherState = "123";

    static void Main(string[] args)
    {
        Debug.Assert(GetTheCondition(), GetTheMessage());
        Console.WriteLine("SomeState = {0}", someState);
        Console.WriteLine("SomeOtherState = {0}", someOtherState);
        Console.ReadLine();
    }

    private static string GetTheMessage()
    {
        someOtherState += "abc";
        return someOtherState;
    }

    private static bool GetTheCondition()
    {
        someState++;
        return (someState!=0);
    }
}</pre>
Then the output from a release build will be different from a debug build.

This is the debug output:
<pre>SomeState = 1
SomeOtherState = 123abc</pre>
And this is the release output:
<pre>SomeState = 0
SomeOtherState = 123</pre>
Tags: <a rel="tag" href="http://technorati.com/tag/debug"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=debug" alt=" " />debug</a> <a rel="tag" href="http://technorati.com/tag/release"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=release" alt=" " />release</a> <a rel="tag" href="http://technorati.com/tag/visual+studio"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio" alt=" " />visual studio</a> <a rel="tag" href="http://technorati.com/tag/c%23"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23" alt=" " />c#</a> <a rel="tag" href="http://technorati.com/tag/ConditionalAttribute"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=ConditionalAttribute" alt=" " />ConditionalAttribute</a> <a rel="tag" href="http://technorati.com/tag/conditional+compilation"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=conditional+compilation" alt=" " />conditional compilation</a> <a rel="tag" href="http://technorati.com/tag/Assert"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=Assert" alt=" " />Assert</a> <a rel="tag" href="http://technorati.com/tag/microsoft"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=microsoft" alt=" " />microsoft</a> <a rel="tag" href="http://technorati.com/tag/compiler"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=compiler" alt=" " />compiler</a>
