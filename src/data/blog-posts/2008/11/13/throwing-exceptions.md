---
title: "Throwing exceptions"
slug: throwing-exceptions
publishDate: 13 Nov 2008
description: "When reviewing some code today I noticed some code that catches an exception, does something with it and then explicitly throws it again. The code looked..."
tags:
  - { name: "C#", slug: c }
  - { name: "error handling", slug: error-handling }
---
<!-- TODO: convert this post's content to Markdown -->

When reviewing some code today I noticed some code that catches an exception, does something with it and then explicitly throws it again. The code looked something like this:
<blockquote>
<pre class="code"><span style="color:blue;">try
</span>{
    <span style="color:green;">// Do something that might cause an exception
</span>}
<span style="color:blue;">catch </span>(<span style="color:#2b91af;">Exception </span>ex)
{
    <span style="color:green;">// Some stuff
    </span><span style="color:blue;">throw </span>ex;
}</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

The problem with the above code is that when you throw the exception again the details about where the exception originated from are lost because the throw populates that part of the exception object. So the original details are replaced with the details about the current location in the code.

Consider the following program:
<blockquote>
<pre class="code"><span style="color:blue;">static void </span>Main(<span style="color:blue;">string</span>[] args)
{
    <span style="color:blue;">try
    </span>{
        A();
    }
    <span style="color:blue;">catch </span>(<span style="color:#2b91af;">Exception </span>ex)
    {
        <span style="color:#2b91af;">Console</span>.WriteLine(ex.Message);
        <span style="color:#2b91af;">Console</span>.WriteLine(ex.StackTrace);
    }
    <span style="color:#2b91af;">Console</span>.ReadLine();
}

<span style="color:blue;">private static void </span>A()
{
    B();
}

<span style="color:blue;">private static void </span>B()
{
    <span style="color:blue;">try
    </span>{
        C();
    }
    <span style="color:blue;">catch </span>(<span style="color:#2b91af;">Exception </span>ex)
    {
        <span style="color:green;">// I can do something
        </span><span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:#a31515;">"Method C() catches the exception and partly handles it"</span>);
        <span style="color:#2b91af;">Console</span>.WriteLine();
        <span style="color:blue;">throw </span>ex;
    }
}

<span style="color:blue;">private static void </span>C()
{
    D();
}

<span style="color:blue;">private static void </span>D()
{
    <span style="color:#2b91af;">Exception </span>ex = <span style="color:blue;">new </span><span style="color:#2b91af;">Exception</span>(<span style="color:#a31515;">"This exception is thrown in D"</span>);
    <span style="color:blue;">throw </span>ex;
}</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>The original exception is thrown by method D. The code in method B catches the exception and partly handles it, it then explicitly throws the original exception again. When the exception is finally caught in the Main method the call stack is truncated to method B. It can no longer see that method C and D were also called.

The output of the application is:
<blockquote>
<pre>Method C() catches the exception and partly handles it

This exception is thrown in D
   at ConsoleApplication1.Program.B() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 40
   at ConsoleApplication1.Program.A() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 26
   at ConsoleApplication1.Program.Main(String[] args) in d:DevelopmentConsoleA
pplication1ConsoleApplication1Program.cs:line 14</pre>
</blockquote>
As you can see, the stack trace only goes from the point of the second throw to the point that the exception is caught.

There are two correct solutions to this problem.
<h2>Solution 1: Wrapping the Exception</h2>
If you have additional information to add to the exception object you can create a brand new Exception and then put the original exception in as an inner exception like this:
<blockquote>
<pre class="code"><span style="color:blue;">try
</span>{
    <span style="color:green;">// Do something that might cause an exception
</span>}
<span style="color:blue;">catch</span>(<span style="color:#2b91af;">Exception </span>ex)
{
    <span style="color:green;">// Some stuff
    </span><span style="color:#2b91af;">Exception </span>moreDetailedEx = <span style="color:blue;">new </span><span style="color:#2b91af;">Exception</span>(<span style="color:#a31515;">"A message with more details"</span>, ex);
    <span style="color:blue;">throw </span>moreDetailedEx;
}</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

NOTE: Please use a specific exception class and not Exception this makes catching specific types of exception easier and more efficient as the compiler can put in place some optimisations for you over you catching the base Exception class and examining it. I’m using Exception here simply to make the example easier to read.

So, if we change our program above to create a new exception and wrap the old one in it it will now look like this:
<blockquote>
<pre class="code"><span style="color:blue;">static void </span>Main(<span style="color:blue;">string</span>[] args)
{
    <span style="color:blue;">try
    </span>{
        A();
    }
    <span style="color:blue;">catch </span>(<span style="color:#2b91af;">Exception </span>ex)
    {
        <span style="color:#2b91af;">Console</span>.WriteLine(ex.InnerException.Message);
        <span style="color:#2b91af;">Console</span>.WriteLine(ex.InnerException.StackTrace);
        <span style="color:#2b91af;">Console</span>.WriteLine();
        <span style="color:#2b91af;">Console</span>.WriteLine(ex.Message);
        <span style="color:#2b91af;">Console</span>.WriteLine(ex.StackTrace);
    }
    <span style="color:#2b91af;">Console</span>.ReadLine();
}

<span style="color:blue;">private static void </span>A()
{
    B();
}

<span style="color:blue;">private static void </span>B()
{
    <span style="color:blue;">try
    </span>{
        C();
    }
    <span style="color:blue;">catch </span>(<span style="color:#2b91af;">Exception </span>ex)
    {
        <span style="color:green;">// I can do something
        </span><span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:#a31515;">"Method C() catches the exception and partly handles it"</span>);
        <span style="color:#2b91af;">Console</span>.WriteLine();
        <span style="color:#2b91af;">Exception </span>newEx = <span style="color:blue;">new </span><span style="color:#2b91af;">Exception</span>(<span style="color:#a31515;">"This exception is thrown in B"</span>, ex);
        <span style="color:blue;">throw </span>newEx;
    }
}

<span style="color:blue;">private static void </span>C()
{
    D();
}

<span style="color:blue;">private static void </span>D()
{
    <span style="color:#2b91af;">Exception </span>ex = <span style="color:blue;">new </span><span style="color:#2b91af;">Exception</span>(<span style="color:#a31515;">"This exception is thrown in D"</span>);
    <span style="color:blue;">throw </span>ex;
}</pre>
</blockquote>
I've added some extra bits to the Main method to show the InnerException details too. The output of the program now looks like this:
<blockquote>
<pre>Method C() catches the exception and partly handles it

This exception is thrown in D
   at ConsoleApplication1.Program.D() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 56
   at ConsoleApplication1.Program.C() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 50
   at ConsoleApplication1.Program.B() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 36

This exception is thrown in B
   at ConsoleApplication1.Program.B() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 44
   at ConsoleApplication1.Program.A() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 29
   at ConsoleApplication1.Program.Main(String[] args) in d:DevelopmentConsoleA
pplication1ConsoleApplication1Program.cs:line 14</pre>
</blockquote>
As you can now see all the information is available. It can now be seen the patch from the final point the exception was caught to the point it was originally thrown.
<h2>Solution 2: Re-throwing the Exception</h2>
If you do not have any additional information to add to the exception you can simply use the throw keyword on its own and it will keep the existing exception object without altering it. For example:
<blockquote>
<pre class="code"><span style="color:blue;">try
</span>{
    <span style="color:green;">// Do something that might cause an exception
</span>}
<span style="color:blue;">catch </span>(<span style="color:#2b91af;">Exception </span>ex)
{
    <span style="color:green;">// Some stuff
    </span><span style="color:blue;">throw</span>;
}</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

Changing our program above to use the throw statement on its own will mean the program now looks like this:
<blockquote>
<pre class="code"><span style="color:blue;">static void </span>Main(<span style="color:blue;">string</span>[] args)
{
    <span style="color:blue;">try
    </span>{
        A();
    }
    <span style="color:blue;">catch </span>(<span style="color:#2b91af;">Exception </span>ex)
    {
        <span style="color:#2b91af;">Console</span>.WriteLine(ex.Message);
        <span style="color:#2b91af;">Console</span>.WriteLine(ex.StackTrace);
    }
    <span style="color:#2b91af;">Console</span>.ReadLine();
}

<span style="color:blue;">private static void </span>A()
{
    B();
}

<span style="color:blue;">private static void </span>B()
{
    <span style="color:blue;">try
    </span>{
        C();
    }
    <span style="color:blue;">catch </span>(<span style="color:#2b91af;">Exception </span>ex)
    {
        <span style="color:green;">// I can do something
        </span><span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:#a31515;">"Method C() catches the exception and partly handles it"</span>);
        <span style="color:#2b91af;">Console</span>.WriteLine();
        <span style="color:blue;">throw</span>;
    }
}

<span style="color:blue;">private static void </span>C()
{
    D();
}

<span style="color:blue;">private static void </span>D()
{
    <span style="color:#2b91af;">Exception </span>ex = <span style="color:blue;">new </span><span style="color:#2b91af;">Exception</span>(<span style="color:#a31515;">"This exception is thrown in D"</span>);
    <span style="color:blue;">throw </span>ex;
}</pre>
</blockquote>
And the output now looks like this:
<blockquote>
<pre>Method C() catches the exception and partly handles it

This exception is thrown in D
   at ConsoleApplication1.Program.D() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 52
   at ConsoleApplication1.Program.C() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 46
   at ConsoleApplication1.Program.B() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 40
   at ConsoleApplication1.Program.A() in d:DevelopmentConsoleApplication1Cons
oleApplication1Program.cs:line 26
   at ConsoleApplication1.Program.Main(String[] args) in d:DevelopmentConsoleA
pplication1ConsoleApplication1Program.cs:line 14</pre>
</blockquote>
As you can see the stack trace now shows you the entire route between the point the exception was caught and when it was thrown. We can also see from the message that the method C still caught and partly handled the exception.

Using the throw keyword like this actually translates to the CIL (MSIL) rethrow command. When you use throw with an Exception object it translates to the CIL throw command.

When the exception is thrown in D the CIL looks like this:
<blockquote>
<pre>.method private hidebysig static void <strong>D</strong>() cil managed
{
    .maxstack 2
    .locals init (
        [0] class [mscorlib]System.Exception <strong>ex</strong>)
    L_0000: <a>nop</a>
    L_0001: <a>ldstr</a> "This exception is thrown in D"
    L_0006: <a>newobj</a> instance void [mscorlib]System.Exception::.ctor(string)
    L_000b: <a>stloc.0</a>
    L_000c: <a>ldloc.0</a>
<strong>    L_000d: </strong><a><strong>throw</strong></a>
}</pre>
</blockquote>
The key above is L_000d where it throws the exception.

Compare that to method B:
<blockquote>
<pre>.method private hidebysig static void <strong>B</strong>() cil managed
{
    .maxstack 1
    .locals init (
        [0] class [mscorlib]System.Exception <strong>ex</strong>)
    L_0000: <a>nop</a>
    L_0001: <a>nop</a>
    L_0002: <a>call</a> void ConsoleApplication1.Program::C()
    L_0007: <a>nop</a>
    L_0008: <a>nop</a>
    L_0009: <a>leave.s</a> L_0020
    L_000b: <a>stloc.0</a>
    L_000c: <a>nop</a>
    L_000d: <a>ldstr</a> "Method C() catches the exception and partly handles it"
    L_0012: <a>call</a> void [mscorlib]System.Console::WriteLine(string)
    L_0017: <a>nop</a>
    L_0018: <a>call</a> void [mscorlib]System.Console::WriteLine()
    L_001d: <a>nop</a>
<strong>    L_001e: </strong><a><strong>rethrow</strong></a>
    L_0020: <a>nop</a>
    L_0021: <a>ret</a>
    .try L_0001 to L_000b catch [mscorlib]System.Exception handler L_000b to L_0020
}</pre>
</blockquote>
In the above CIL code the key is L_001e where it rethrows the exception. This is where the CIL is much more explicit than C#. In C# the throw keyword is overloaded and functions differently depending on whether it receives an exception object or not.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:153ab00b-8523-4572-881c-3b3214b4d318" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/C#">C#</a>,<a rel="tag" href="http://technorati.com/tags/throw">throw</a>,<a rel="tag" href="http://technorati.com/tags/excpetion">excpetion</a>,<a rel="tag" href="http://technorati.com/tags/rethrow">rethrow</a>,<a rel="tag" href="http://technorati.com/tags/stack%20trace">stack trace</a>,<a rel="tag" href="http://technorati.com/tags/cil">cil</a></div>
