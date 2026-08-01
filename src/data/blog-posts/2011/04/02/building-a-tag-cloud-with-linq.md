---
title: "Building a tag cloud with LINQ"
slug: building-a-tag-cloud-with-linq
publishDate: 02 Apr 2011
description: "I have a set of blog posts that I’m representing as a List of BlogPost objects. A BlogPost is class I created that represents everything to do with a blog..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Distinct", slug: distinct }
  - { name: "GroupBy", slug: groupby }
  - { name: "LINQ", slug: linq }
  - { name: "SelectMany", slug: selectmany }
---
<!-- TODO: convert this post's content to Markdown -->

I have a set of blog posts that I’m representing as a List of BlogPost objects. A BlogPost is class I created that represents everything to do with a blog post. In it there is a list of all the categories (or tags) that a blog post has.
<h3></h3>
<h3>SelectMany</h3>
If I want to build a tag cloud based on all the categories then I first need to know what the categories are. This is where a little bit of LINQ code such as this comes in handy:
<pre>List&lt;BlogPost&gt; posts = GetBlogPosts();
var categories = posts.SelectMany(p =&gt; p.Categories);</pre>

The SelectMany flattens out all the Category lists in the all the posts to produce one result that contains all the categories. So, lets say there are three blog posts with the following categories:
<table width="500" border="0" cellspacing="0" cellpadding="3">
<tbody>
<tr>
<td valign="top" width="167"><strong>Post One</strong></td>
<td valign="top" width="165"><strong>Post Two</strong></td>
<td valign="top" width="166"><strong>Post Three</strong></td>
</tr>
<tr>
<td valign="top" width="168">.NET</td>
<td valign="top" width="165">.NET</td>
<td valign="top" width="166">SQL Server</td>
</tr>
<tr>
<td valign="top" width="168">C#</td>
<td valign="top" width="165">C#</td>
<td valign="top" width="166">Stored Procedure</td>
</tr>
<tr>
<td valign="top" width="168">LINQ</td>
<td valign="top" width="165">ADO.NET</td>
<td valign="top" width="166"></td>
</tr>
<tr>
<td valign="top" width="168">SelectMany</td>
<td valign="top" width="165">Stored Procedure</td>
<td valign="top" width="166"></td>
</tr>
</tbody>
</table>
However, as it simply flattens the structure the end result is:
<ul>
	<li>.NET</li>
	<li>C#</li>
	<li>LINQ</li>
	<li>SelectMany</li>
	<li>.NET</li>
	<li>C#</li>
	<li>ADO.NET</li>
	<li>StoredProcedure</li>
	<li>SQL Server</li>
	<li>Stored Procedure</li>
</ul>
<h3>Distinct</h3>
If I simply want a list of all the categories, I could modify the code above to chain a Distinct call in.
<pre>List&lt;BlogPost&gt; posts = GetBlogPosts();
var categories = posts
    .SelectMany(p =&gt; p.Categories)
    .Distinct();</pre>

That results in a shorter list, like this:
<ul>
	<li>.NET</li>
	<li>C#</li>
	<li>LINQ</li>
	<li>SelectMany</li>
	<li>ADO.NET</li>
	<li>Stored Procedure</li>
	<li>SQL Server</li>
</ul>
<h3>GroupBy</h3>
However, what is needed is each item with a count of the number of times it is repeated. This is where GroupBy comes in. Here’s the code:

<pre>List&lt;BlogPost&gt; posts = GetBlogPosts();
var categoryGroups = posts
    .SelectMany(p =&gt; p.Categories)
    .GroupBy(c =&gt; c);
 
foreach (var group in categoryGroups)
{
    // Do stuff with each group.
    // group.Key is the name of the category
}
</pre>

The GroupBy clause (line 4) takes an expression that returns the thing being grouped by. Since the List contains strings representing the category, we will be grouping by itself, so the expression returns itself.

Since the categoryGroups is enumerable we can use the LINQ extension methods on it to find out how many times each category is mentioned by using the Count() extension method.

This means we can get a result like this:
<ul>
	<li>.NET : 2 posts</li>
	<li>C# : 2 posts</li>
	<li>LINQ : 1 post</li>
	<li>SelectMany : 1 post</li>
	<li>ADO.NET :1 post</li>
	<li>Stored Procedure : 2 posts</li>
	<li>SQL Server : 1 posts</li>
</ul>
