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

I want a way to extract all the post data out of my blog. To do that I’m building a little application to do that, mostly as an exercise to try out some new technologies. In this post I’m going to show a little of the [HTML Agility pack](https://html-agility-pack.net) which is the framework I’m using to extract the information out of a blog entry page.

### Creating an HtmlDocument

Where in the following code snippet, html is a string containing some HTML

```csharp
HtmlDocument doc = new HtmlDocument();
doc.LoadHtml(html);
```

However, the `HtmlDocument` class also has a Load method that is overloaded and can accept a `Stream`, `TextReader` or a `string` (representing a file path) in order to get the HTML. The one obvious thing that was missing was a version that took a URL although `HttpWebResponse` does contain a `ResponseStream` which you could pass in.

### Navigating the HTML Document

Once you have loaded in your HTML you will want to navigate it. To do that you need to get hold of `HtmlNode` that represents the document as a whole:

```csharp
HtmlNode docNode = doc.DocumentNode;
```

The `docNode` will then give you all the bits and pieces you need to navigate around the HTML. If you are also ready used to using the LINQ XML classes introduced in .NET 3.5 then you shouldn’t have too much trouble finding your way around here.

For example, here is a snippet of code that gets all the URLs out of the anchor tags:

```csharp
var linkUrls = docNode.SelectNodes("//a[@href]")
     .Select(node => node.Attributes["href"].Value);
```

The `linkUrls` variable is actually an `IEnumerable<string>` (if you are curious).

### 

### One thing that is particularly annoying

There is one thing that I find particularly annoying however. SelectNodes returns an `HtmlNodeCollection`, however, if the xpath in the `SelectNodes` method call results in no nodes being found then it returns a `null` instead of an empty collection. For me, it is perfectly valid to get an empty collection if the query returned no results. Because of this, I can’t simply write code like the section above. I actually have to check for null before continuing. That means the code in the previous section actually looks like this:

```csharp
HtmlNodeCollection nodes = docNode.SelectNodes("//a[@href]");
if (nodes != null)
{
    var linkUrls = nodes.Select(node => node.Attributes["href"].Value);
    // And what ever else we were doing.
}
```

### What next?

Well, as you can see the functionality is actually fairly easy to follow. I was initially dismayed at the lack of apparent documentation for it until I realised that the folks that have built the framework have done a great job of ensuring that it works very similarly to libraries already in the .NET framework itself so it is remarkably quick to get used to.
