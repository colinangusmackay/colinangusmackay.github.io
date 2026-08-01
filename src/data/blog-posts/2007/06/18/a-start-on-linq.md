---
title: "A start on LINQ"
slug: a-start-on-linq
publishDate: 18 Jun 2007
description: "I was at the Microsoft MSDN Roadshow today and I got to see some of the latest technologies being demonstrated for the first time and I'm impressed. Daniel..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
  - { name: "visual studio", slug: visual-studio }
---
<!-- TODO: convert this post's content to Markdown -->

I was at the <a title="Microsoft" href="http://www.microsoft.com/" target="_blank">Microsoft</a> <a title="MSDN" href="http://msdn.microsoft.com/" target="_blank">MSDN</a> Roadshow today and I got to see some of the latest technologies being demonstrated for the first time and I'm impressed.

Daniel Moth's presentation on the Language Enhancements and LINQ was exceptional - It really made me want to be able to use that technology now.

What was interesting was that the new enhancements don't require a new version of the CLR to be installed. It still uses the Version 2.0 CLR. It works by adding additional stuff to the .NET Framework (this is .NET Framework 3.5) and through a new compiler (the C# 3.0 compiler). The C# 3.0 compiler produces IL that runs against CLR 2.0. In essence, the new language enhancements are compiler tricks, which is why the CLR doesn't need to be upgraded. Confused yet?

Now that the version numbers of the various components are diverging it is going to make things slightly more complex. So here is a handy cheat sheet:
<table border="1" cellspacing="0" width="100%">
<tbody>
<tr>
<td></td>
<td><strong>2002</strong></td>
<td><strong>2003</strong></td>
<td><strong>2005</strong></td>
<td><strong>2006</strong></td>
<td><strong>2007ish</strong></td>
</tr>
<tr>
<td><strong>Tool</strong></td>
<td align="left">VS.NET 2002</td>
<td align="left">VS.NET 2003</td>
<td align="left">VS 2005</td>
<td align="left">VS 2005
+ Extension</td>
<td align="left">"Orcas"</td>
</tr>
<tr>
<td><strong>Language (C#)</strong></td>
<td align="left">v1.0</td>
<td align="left">v1.1</td>
<td align="left">v2.0</td>
<td align="left">v2.0</td>
<td align="left">v3.0</td>
</tr>
<tr>
<td><strong>Framework</strong></td>
<td align="left">v1.0</td>
<td align="left">v1.1</td>
<td align="left">v2.0</td>
<td align="left">v3.0</td>
<td align="left">v3.5</td>
</tr>
<tr>
<td><strong>Engine (CLR)</strong></td>
<td align="left">v1.0</td>
<td align="left">v1.1</td>
<td align="left">v2.0</td>
<td align="left">v2.0</td>
<td align="left">v2.0</td>
</tr>
</tbody>
</table>
The rest of Daniel's talk was incredibly densely packed with information. Suffice to say, at the moment, LINQ is going to provide some excellent and powerful features, however, it will also make it very easy to produce code that is very inefficient if wielded without understanding the consequences. The same can be said of just about any language construct, but LINQ does do a remarkable amount in the background.

After the session I was speaking with Daniel and we discussed the power of the feature and he said that, since C#3.0 produces IL2.0 it is possible to use existing tools, such as Lutz Roeder's Reflector, to see exactly what is happening under the hood. An examination of that will yield a better understanding of how LINQ code is compiler.

LINQ code looks similar to SQL. For example:
<pre>var result =
    from p in Process.GetProcesses()
    where p.Threads.Count &gt; 6
    orderby p.ProcessName descending
    select p</pre>
This allows the developer to write set based operations in C# a lot more easily than before. A rough equivalent in C# 2.0 to do the same thing would probably look something like this:
<pre>List&lt;Process&gt; result = new List&lt;Process&gt;();
foreach(Process p in Process.GetProcesses)
{
    if (p.Threads.Count &gt; 6)
        result.Add(p);
}
result.Sort(new DescendingProcessNameComparer());
</pre>
<small>* NOTE: Assumes that DescendingProcessNameComparer is an existing comparer that compares two Process objects by their name in descending order.</small>

C# 3.0 introduces the <code>var</code> keyword. This is unlike <code>var</code> in javascript or VB. It is not a variant type. It is strongly typed and the compiler will complain if it is used incorrectly. For example:
<pre>var i = 5;
i = "five"; // This will produce a compiler error because i is an integer
</pre>
In short this was only a fraction of what I learned from just one session - I'll continue the update as I can.

Tags: <a rel="tag" href="http://technorati.com/tag/microsoft"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=microsoft" alt=" " />microsoft</a> <a rel="tag" href="http://technorati.com/tag/linq"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=linq" alt=" " />linq</a> <a rel="tag" href="http://technorati.com/tag/reflector"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=reflector" alt=" " />reflector</a> <a rel="tag" href="http://technorati.com/tag/c%23"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23" alt=" " />c#</a> <a rel="tag" href="http://technorati.com/tag/.NET"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=.NET" alt=" " />.NET</a> <a rel="tag" href="http://technorati.com/tag/Orcas"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=Orcas" alt=" " />Orcas</a> <a rel="tag" href="http://technorati.com/tag/clr"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=clr" alt=" " />clr</a> <a rel="tag" href="http://technorati.com/tag/visual+studio"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio" alt=" " />visual studio</a>

<em>NOTE: This post was rescued from the Google Cache. The original date was Monday, 5th March 2007.</em>

<hr />Original comments:

Glad you enjoyed it Colin :-)

Be sure to check out the written version of my talk on my blog!
<div class="postfoot">3/6/2007 11:34 AM | <a id="Comments_ascx_CommentList_ctl00_NameLink" title="http://www.danielmoth.com/Blog/2007/02/linq-resources.html" href="http://www.danielmoth.com/Blog/2007/02/linq-resources.html" target="_blank">Daniel Moth</a></div>
