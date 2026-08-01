---
title: "Anonymous Types"
slug: anonymous-types
publishDate: 18 Jun 2007
description: "Anonymous Types are another new feature to the C# 3.0 compiler. To create one, just supply the new keyword without a class name, followed by the, also new,..."
tags:
  - { name: "Anonymous Types", slug: anonymous-types }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "visual studio", slug: visual-studio }
---
<!-- TODO: convert this post's content to Markdown -->

Anonymous Types are another new feature to the C# 3.0 compiler.

To create one, just supply the new keyword without a class name, followed by the, also new, object initialiser notation.

As the type name is not known it needs to be assigned to a variable declared with the local variable type inference, var, keyword.

For example:
<pre>var anonType = new { FirstName = "Colin", MiddleName = "Angus", Surname = "Mackay" };</pre>
It is possible to assign a new object to the variable, but it must be created with the object initialisers in exactly the same order. If, say, the following is attempted a compiler error will be generated:
<pre>anonType = new {Surname = "Rowling",  FirstName = "Joanna", MiddleName = "Kathleen" };</pre>
The corresponding compiler error is: Cannot implicitly convert type 'anonymous type [...ProjectsConsoleApplication4ConsoleApplication4PropertiesAssemblyInfo.cs]' to 'anonymous type [...ProjectsConsoleApplication4ConsoleApplication4PropertiesAssemblyInfo.cs]'

At the moment I'm not entirely sure where AssemblyInfo.cs comes in. If anyone knows the answer I'd love to know.

Back to the original example. What does this look like under the microscope of Lutz Roeder's Reflector?
<pre>var &lt;&gt;g__initLocal0 = new &lt;&gt;f__AnonymousType0();
&lt;&gt;g__initLocal0.FirstName = "Colin";
&lt;&gt;g__initLocal0.MiddleName = "Angus";
&lt;&gt;g__initLocal0.Surname = "Mackay";
var anonType = &lt;&gt;g__initLocal0;</pre>
But that isn't all that was generated. The compiler also generated the following internal class (Note: Some of the detail has been stripped for clarity)
<pre>internal sealed class &lt;&gt;f__AnonymousType0&lt;&lt;&gt;j__AnonymousTypeTypeParameter1,
    &lt;&gt;j__AnonymousTypeTypeParameter2, &lt;&gt;j__AnonymousTypeTypeParameter3&gt;
{
    // Fields
    private &lt;&gt;j__AnonymousTypeTypeParameter1 &lt;&gt;i__AnonymousTypeField4;
    private &lt;&gt;j__AnonymousTypeTypeParameter2 &lt;&gt;i__AnonymousTypeField5;
    private &lt;&gt;j__AnonymousTypeTypeParameter3 &lt;&gt;i__AnonymousTypeField6;

    public &lt;&gt;j__AnonymousTypeTypeParameter1 FirstName
    {
        get
        {
            return this.&lt;&gt;i__AnonymousTypeField4;
        }
        set
        {
            this.&lt;&gt;i__AnonymousTypeField4 = value;
        }
    }

    public &lt;&gt;j__AnonymousTypeTypeParameter2 MiddleName
    {
        get
        {
            return this.&lt;&gt;i__AnonymousTypeField5;
        }
        set
        {
            this.&lt;&gt;i__AnonymousTypeField5 = value;
        }
    }

    public &lt;&gt;j__AnonymousTypeTypeParameter3 Surname
    {
        get
        {
            return this.&lt;&gt;i__AnonymousTypeField6;
        }
        set
        {
            this.&lt;&gt;i__AnonymousTypeField6 = value;
        }
    }
}
</pre>
Because the developer has no access to the actual type name the an object created as an anonymous type cannot be passed around the program unless it is cast to an object, the base class of all things. It cannot, for obvious reasons, be cast back again. So at this point the only way of accessing the data stored within is via reflection, or with methods already present on object.

Anonymous types can be examined in the debugger quite easily and show us just like any other object.

<a title="Photo Sharing" href="http://www.flickr.com/photos/colinangusmackay/424568534/"><img src="http://farm1.static.flickr.com/164/424568534_751c426b04_o.jpg" alt="Debugging anonymous types in Orcas" width="699" height="599" /></a>

One especially neat feature of anonymous types is its ability to infer a name when none is given. For example:
<pre>DateTime dateOfBirth = new DateTime(1759, 1, 25);
var anonType = new { FirstName = "Robert", Surname = "Burns", dateOfBirth };</pre>
The dateOfBirth entry was not explicitly given a name on the anonymous type. However, the compiler inferred a name based on the variable name that was given. The anonymous type therefore looks like this: { FirstName = Robert, Surname = Burns, dateOfBirth = 25/01/1759 00:00:00 }

Naturally, some will dislike this as the anonymous type now has a mix of pascal and camel case for the properties it is exposing.

<a rel="tag" href="http://technorati.com/tag/anonymous+types"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=anonymous+types" alt=" " />anonymous types</a> <a rel="tag" href="http://technorati.com/tag/orcas"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=orcas" alt=" " />orcas</a> <a rel="tag" href="http://technorati.com/tag/visual+studio"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio" alt=" " />visual studio</a> <a rel="tag" href="http://technorati.com/tag/c%23"><img style="margin-left:.4em;vertical-align:middle;border:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23" alt=" " />c#</a>

NOTE: This post was rescued from the Google Cache. The orginal date was Saturday, 17th March, 2007
