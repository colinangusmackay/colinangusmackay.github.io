---
title: "A better tracing routine"
slug: a-better-tracing-routine
publishDate: 20 May 2014
description: "In .NET 4.5 three new attributes were introduced. They can be used to pass into a method the details of the caller and this can be used to create better trace..."
tags:
  - { name: ".NET", slug: net }
  - { name: ".NET 4.5", slug: net-4-5 }
  - { name: "C#", slug: c }
  - { name: "Debugging", slug: debugging }
  - { name: "Trace", slug: trace }
---
<!-- TODO: convert this post's content to Markdown -->

<p>In .NET 4.5 three new attributes were introduced. They can be used to pass into a method the details of the caller and this can be used to create better trace or logging messages. In the example below, it outputs tracing messages in a format that you can use in Visual Studio to automatically jump to the appropriate line of source code if you need it to.</p>  <p>The three new attributes are:</p>  <ul>   <li><a href="http://msdn.microsoft.com/en-us/library/system.runtime.compilerservices.callerfilepathattribute(v=vs.110).aspx">CallerFilePathAttribute</a> (string) </li>    <li><a href="http://msdn.microsoft.com/en-us/library/system.runtime.compilerservices.callerlinenumberattribute(v=vs.110).aspx">CallerLineNumberAttribute</a> (int) </li>    <li><a href="http://msdn.microsoft.com/en-us/library/system.runtime.compilerservices.callermembernameattribute(v=vs.110).aspx">CallerMemberNameAttribute</a> (string) </li> </ul>  <p>If you decorate the parameters of a method with the above attributes (respecting the types, in brackets afterwards) then the values will be injected in at compile time.</p>  <p>For example:</p>  <pre>public class Tracer
{
    public static void WriteLine(string message,
                            [CallerMemberName] string memberName = &quot;&quot;,
                            [CallerFilePath] string sourceFilePath = &quot;&quot;,
                            [CallerLineNumber] int sourceLineNumber = 0)
    {
        string fullMessage = string.Format(&quot;{1}({2},0): {0}{4}&gt;&gt; {3}&quot;, 
            memberName,sourceFilePath,sourceLineNumber, 
            message, Environment.NewLine);

        Console.WriteLine(&quot;{0}&quot;, fullMessage);
        Trace.WriteLine(fullMessage);
    }
}</pre>

<p>The above method can then be used to in preference to the built in <code>Trace.WriteLine</code> and it will output the details of where the message came from. The format that the full message is output in is also in a format where you can double click the line in the Visual Studio output window and it will take you to that line in the source.</p>

<p>Here is an example of the output:</p>

<pre>c:\dev\spike\Caller\Program.cs(13,0): Main
&gt;&gt; I'm Starting up.
c:\dev\spike\Caller\SomeOtherClass.cs(7,0): DoStuff
&gt;&gt; I'm doing stuff.</pre>

<p>The lines with the file path and line numbers on them can be double-clicked in the Visual Studio output window and you will be taken directly to the line of code it references.</p>

<p>What happens when you call Tracer.WriteLine is that the compiler injects literal values in place of the parameters.</p>

<p>So, if you write something like this:</p>

<pre>Tracer.WriteLine("I'm doing stuff.");</pre>
<p>Then the compiler will output this:</p>
<pre>Tracer.WriteLine("I'm doing stuff.", "DoStuff", "c:\\dev\\spike\\Caller\\SomeOtherClass.cs", 7);</pre>
