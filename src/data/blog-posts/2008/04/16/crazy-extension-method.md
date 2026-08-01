---
title: "Crazy Extension Method"
slug: crazy-extension-method
publishDate: 16 Apr 2008
description: "Here is an example of a crazy extension method that alters the semantics of method calling. First the extension method: public static class MyExtensions {..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "error handling", slug: error-handling }
  - { name: "Extension Methods", slug: extension-methods }
---
<!-- TODO: convert this post's content to Markdown -->

Here is an example of a crazy extension method that alters the semantics of method calling.

First the extension method:
<pre class="code"><span style="color:blue;">public static class </span><span style="color:#2b91af;">MyExtensions
</span>{
    <span style="color:blue;">public static bool </span>IsNullOrEmpty(<span style="color:blue;">this string </span>target)
    {
        <span style="color:blue;">return string</span>.IsNullOrEmpty(target);
    }
}</pre>
<a href="http://11011.net/software/vspaste"></a>

Instead of calling the static method IsNullOrEmpty() on string, we are turning it around to allow it to be called on a string type like an instance method. However, as you can probably tell, it may be called when the reference to the string is null. Normally this would result in an exception to say that you are attempting to call a method on a null value. However, this is an extension method and it actually works with nulls! This is probably not the best idea in the world, to be diplomatic about it.

Here is some calling code:
<pre class="code"><span style="color:blue;">string </span>a = <span style="color:blue;">null</span>;
<span style="color:#2b91af;">Console</span>.WriteLine(a.IsNullOrEmpty());</pre>
Normally, an exception will be thrown if IsNullOrEmpty() is a real method. However, it isn't in this case and the application happily writes "True" to the console.

&nbsp;
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:019eafdf-7119-4151-a171-58dc725b6478" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/extension%20method">extension method</a>,<a rel="tag" href="http://technorati.com/tags/exception">exception</a>,<a rel="tag" href="http://technorati.com/tags/weird">weird</a>,<a rel="tag" href="http://technorati.com/tags/c#">c#</a></div>
