---
title: "A quick intro to the HTML Agility Pack"
slug: a-quick-intro-to-the-html-agility-pack
publishDate: 22 Mar 2011
description: "I want a way to extract all the post data out of my blog. To do that I’m building a little application to do that, mostly as an exercise to try out some new..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "HTML Agility Pack", slug: html-agility-pack }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I want a way to extract all the post data out of my blog. To do that I’m building a little application to do that, mostly as an exercise to try out some new technologies. In this post I’m going to show a little of the <a title="HTML Agility Pack" href="http://htmlagilitypack.codeplex.com/">HTML Agility pack</a> which is the framework I’m using to extract the information out of a blog entry page.</p>  <h3>Creating an HtmlDocument</h3>  <p>Where in the following code snippet, html is a string containing some HTML</p>  <pre>HtmlDocument doc = new HtmlDocument();
doc.LoadHtml(html);</pre>

<p>However, the <code>HtmlDocument</code> class also has a Load method that is overloaded and can accept a <code>Stream</code>, <code>TextReader</code> or a <code>string</code> (representing a file path) in order to get the HTML. The one obvious thing that was missing was a version that took a URL although <code>HttpWebResponse</code> does contain a <code>ResponseStream</code> which you could pass in.</p>

<h3>Navigating the HTML Document</h3>

<p>Once you have loaded in your HTML you will want to navigate it. To do that you need to get hold of <code>HtmlNode</code> that represents the document as a whole:</p>

<pre>HtmlNode docNode = doc.DocumentNode;</pre>

<p>The <code>docNode</code> will then give you all the bits and pieces you need to navigate around the HTML. If you are also ready used to using the LINQ XML classes introduced in .NET 3.5 then you shouldn’t have too much trouble finding your way around here.</p>

<p>For example, here is a snippet of code that gets all the URLs out of the anchor tags:</p>

<pre>var linkUrls = docNode.SelectNodes(&quot;//a[@href]&quot;)
     .Select(node =&gt; node.Attributes[&quot;href&quot;].Value);</pre>

<p>The <code>linkUrls</code> variable is actually an <code>IEnumerable&lt;string&gt;</code> (if you are curious).</p>

<h3></h3>

<h3>One thing that is particularly annoying</h3>

<p>There is one thing that I find particularly annoying however. SelectNodes returns an <code>HtmlNodeCollection</code>, however, if the xpath in the <code>SelectNodes</code> method call results in no nodes being found then it returns a <code>null</code> instead of an empty collection. For me, it is perfectly valid to get an empty collection if the query returned no results. Because of this, I can’t simply write code like the section above. I actually have to check for null before continuing. That means the code in the previous section actually looks like this:</p>

<pre>HtmlNodeCollection nodes = docNode.SelectNodes(&quot;//a[@href]&quot;);
if (nodes != null)
{
    var linkUrls = nodes.Select(node =&gt; node.Attributes[&quot;href&quot;].Value);
    // And what ever else we were doing.
}</pre>

<h3>What next?</h3>

<p>Well, as you can see the functionality is actually fairly easy to follow. I was initially dismayed at the lack of apparent documentation for it until I realised that the folks that have built the framework have done a great job of ensuring that it works very similarly to libraries already in the .NET framework itself so it is remarkably quick to get used to.</p>
