---
title: "Object Initialisers III"
slug: object-initialisers-iii
publishDate: 18 Jun 2007
description: "It seems that now I've got Lutz Roeder's Reflector on the case with Orcas the way object initialisers work slightly different to how I expected. As it was..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
---
<!-- TODO: convert this post's content to Markdown -->


		<p>It seems that now I've got Lutz Roeder's Reflector on the case with Orcas the way object initialisers work slightly different to how I expected.</p>
<p>As it was described to me as instantiating the object followed by the property calls. However, the compiler has taken some extra steps in there - no doubt on the grounds of safety.</p>
<p>First consider the following code:</p>
<pre>// Create Robert Burns, DoB 25/Jan/1759
Person robertBurns = new Person { FirstName = "Robert", Surname = "Burns", <br />                                  DateOfBirth = new DateTime(1759, 1, 25) };
Console.WriteLine("{0}", robertBurns);
</pre>
<p>As I understood the feature, the compiler should have generated code that looked like this:</p>
<pre>Person robertBurns = new Person();
robertBurns.FirstName = "Robert";
robertBurns.Surname = "Burns";
robertBurns.DateOfBirth = new DateTime(1759, 1, 25);</pre>
<p>However, Reflector reveals that what is actually being produced is this:</p>
<pre>    Person &lt;&gt;g__initLocal0 = new Person();
    &lt;&gt;g__initLocal0.FirstName = "Robert";
    &lt;&gt;g__initLocal0.Surname = "Burns";
    &lt;&gt;g__initLocal0.DateOfBirth = new DateTime(0x6df, 1, 0x19);
    Person robertBurns = &lt;&gt;g__initLocal0;
    Console.WriteLine("{0}", robertBurns);
</pre>
<p>This actually makes some sense. For example, if my new Person object was assigned to a property of something else, or passed in as a parameter to a method it wouldn't have the opportunity to assign values to the properties on the new object. So, it constructs it all in the background then assigns it to whatever needs it, whether that is a local variable, a property on some object a parameter in a method.</p>
<p>For example, if the above program is reduced to just one line of code:</p>
<pre>// Create Robert Burns, DoB 25/Jan/1759
Console.WriteLine("{0}", new Person { FirstName = "Robert", Surname = "Burns",
                                      DateOfBirth = new DateTime(1759, 1, 25) });</pre>
<p>The compiled result will be:</p>
<pre>    Person &lt;&gt;g__initLocal0 = new Person();
    &lt;&gt;g__initLocal0.FirstName = "Robert";
    &lt;&gt;g__initLocal0.Surname = "Burns";
    &lt;&gt;g__initLocal0.DateOfBirth = new DateTime(0x6df, 1, 0x19);
    Console.WriteLine("{0}", &lt;&gt;g__initLocal0);
</pre>
<p>Related Posts: Object Intialisers <a href="http://blogs.wdevs.com/ColinAngusMackay/archive/2007/03/10/19635.aspx">I</a> and <a href="http://blogs.wdevs.com/ColinAngusMackay/archive/2007/03/11/19636.aspx">II</a></p>
<p><a rel="tag" href="http://technorati.com/tag/c%23"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23">c#</a> <a rel="tag" href="http://technorati.com/tag/c%23+3.0"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23+3.0">c# 3.0</a> <a rel="tag" href="http://technorati.com/tag/.NET+3.5"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=.NET+3.5">.NET 3.5</a> <a rel="tag" href="http://technorati.com/tag/Orcas"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=Orcas">Orcas</a> <a rel="tag" href="http://technorati.com/tag/visual+studio"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio">visual studio</a> <a rel="tag" href="http://technorati.com/tag/object+initialiser"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=object+initialiser">object initialiser</a> <a rel="tag" href="http://technorati.com/tag/object+initializer"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=object+initializer">object initializer</a> <a rel="tag" href="http://technorati.com/tag/language+enhancements"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=language+enhancements">language enhancements</a> </p>
<p>NOTE: This page was rescued from the Google Cache. The original date was Tuesday, 13th March, 2007</p>

	
