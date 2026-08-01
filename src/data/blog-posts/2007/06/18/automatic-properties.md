---
title: "Automatic Properties"
slug: automatic-properties
publishDate: 18 Jun 2007
description: "Continuing my look at the new features found in the C# 3.0 compiler I will look at Automatic Properties. public class Employee{ public string FirstName { get;..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "visual studio", slug: visual-studio }
---
<!-- TODO: convert this post's content to Markdown -->

Continuing my look at the new features found in the C# 3.0 compiler I will look at Automatic Properties.
<pre>public class Employee{    public string FirstName { get; set; }
    public string Surname { get; set; }
    public DateTime DateOfBirth { get; set; }
    public Employee Manager { get; set; }}</pre>
At first look this might seem more like a definition for an interface, but for the class keyword and the member visibility modifiers.

However, this is actually a new feature where by the compiler will automatically fill in the member fields. This is useful for situations where nothing needs to be done when getting or setting values from the member fields. It means they can be constructed much more quickly as there is no need for tedious creating of private member fields then the public properties. All that is needed is one simple construct.

It is also possible to reduce the visibility of the getter and setter independently. For example, in the above example you may wish to make <code>DateOfBirth</code> to be effectively read-only for all by the class that owns it. You can prefix the <code>set</code> keyword with the <code>private</code> visibility modifier.

But what is the compiler actually producing? The following is the output from <a href="http://www.aisto.com/roeder/dotnet/">Lutz Roeder's Reflector</a> for the DateOfBirth property:
<pre>[CompilerGenerated]
private DateTime &lt;&gt;k__AutomaticallyGeneratedPropertyField2;

public DateTime DateOfBirth
{
    [CompilerGenerated]
    get
    {
        return this.&lt;&gt;k__AutomaticallyGeneratedPropertyField2;
    }
    private [CompilerGenerated]
    set
    {
        this.&lt;&gt;k__AutomaticallyGeneratedPropertyField2 = value;
    }
}</pre>
In the code, only the  property is accessible. Attempting to use the compiler generated name produces a compiler error.

If the full name (as shown above) is used then the compiler will complain with three errors:
<table border="1" cellspacing="0" cellpadding="1" width="100%"><caption>Compiler errors</caption>
<tbody>
<tr>
<td><strong>#</strong></td>
<td><strong>Error</strong></td>
<td><strong>File</strong></td>
<td><strong>Row</strong></td>
<td><strong>Col</strong></td>
<td><strong>Project</strong></td>
</tr>
<tr>
<td>1</td>
<td>Identifier expected</td>
<td>ConsoleApplication2Employee.cs</td>
<td>20</td>
<td>18</td>
<td>ConsoleApplication2</td>
</tr>
<tr>
<td>2</td>
<td>Invalid expression term '&gt;'</td>
<td>ConsoleApplication2Employee.cs</td>
<td>20</td>
<td>19</td>
<td>ConsoleApplication2</td>
</tr>
<tr>
<td>3</td>
<td>; expected</td>
<td>ConsoleApplication2Employee.cs</td>
<td>20</td>
<td>20</td>
<td>ConsoleApplication2</td>
</tr>
</tbody>
</table>
<span style="font-family:Arial;">If the &lt;&gt; are removed the message changes to </span>
<table border="1" cellspacing="0" cellpadding="1" width="100%"><caption>Compiler errors</caption>
<tbody>
<tr>
<td><strong>#</strong></td>
<td><strong>Error</strong></td>
<td><strong>File</strong></td>
<td><strong>Row</strong></td>
<td><strong>Col</strong></td>
<td><strong>Project</strong></td>
</tr>
<tr>
<td>1</td>
<td><span style="font-family:Arial;">'ConsoleApplication2.Employee' does not contain a definition for 'k__AutomaticallyGeneratedPropertyField2' and no extension method 'k__AutomaticallyGeneratedPropertyField2' accepting a first argument of type 'ConsoleApplication2.Employee' could be found (are you missing a using directive or an assembly reference?)</span></td>
<td>ConsoleApplication2Employee.cs</td>
<td>20</td>
<td>18</td>
<td>ConsoleApplication2</td>
</tr>
</tbody>
</table>
So, why go to all this trouble? Surely it isn't just to save a few key strokes?

Part of the answer can be seen in a post I made in November 2005: <a href="http://blogs.wdevs.com/colinangusmackay/archive/2005/11/28/11376.aspx">Why make fields in a class private, why not just make them public?</a> and there was a follow up in June 2006 when I returned to <a href="http://blogs.wdevs.com/colinangusmackay/archive/2006/06/17/13561.aspx">The Public Fields Debate Again</a>.

In short, public fields and public properties, although they appear to look identical to the outside in C# are sytactically different once compiled. Automatic Properties are a way to address that. If you, at some point in the future, decide that you need the property to do more then the external interface of the object won't change, you just turn the automatic property into a normal property/field combination again.

<a rel="tag" href="http://technorati.com/tag/c%23"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23" alt=" " />c#</a> <a rel="tag" href="http://technorati.com/tag/c%23+3.0"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23+3.0" alt=" " />c# 3.0</a> <a rel="tag" href="http://technorati.com/tag/.NET+3.5"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=.NET+3.5" alt=" " />.NET 3.5</a> <a rel="tag" href="http://technorati.com/tag/Orcas"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=Orcas" alt=" " />Orcas</a> <a rel="tag" href="http://technorati.com/tag/visual+studio"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio" alt=" " />visual studio</a> <a rel="tag" href="http://technorati.com/tag/language+enhancements"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=language+enhancements" alt=" " />language enhancements</a> <a rel="tag" href="http://technorati.com/tag/automatic+properties"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=automatic+properties" alt=" " />automatic properties</a>

<em>NOTE: This post was rescued from the Google Cache. The original date was Tuesday, 13th March, 2007.</em>
