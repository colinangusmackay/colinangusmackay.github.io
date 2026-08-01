---
title: "Changing the default Assembly/Namespace on an MVC appliction"
slug: changing-the-default-assembly-on-an-mvc-appliction
publishDate: 08 Jul 2015
description: "TL;DR When getting an error message like this: Compiler Error Message: CS0246: The type or namespace name 'UI' could not be found (are you missing a using..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "Debugging", slug: debugging }
  - { name: "namespaces", slug: namespaces }
  - { name: "ReSharper", slug: resharper }
  - { name: "web.config", slug: web-config }
---
<!-- TODO: convert this post's content to Markdown -->

<h3>TL;DR</h3>

When getting an error message like this:
<pre>Compiler Error Message: CS0246: The type or namespace name 'UI' could not be found (are you missing a using directive or an assembly reference?)</pre>
when compiling Razor views after changing the namespace names in your project, check the web.config file in each of the view folders for a line that looks like this:
<pre>&lt;add namespace="UI" /&gt;</pre>
And update it to the correct namespace, e.g.
<pre>&lt;add namespace="‹CompanyName›.‹ProjectName›.UI" /&gt;</pre>

<h3>Full story</h3>

I guess this is something I've not done before, so it caught me out a little.

I've recently created a new project and to reduce the file paths I omitted information that is already implied by the parent directory.

So, what I ended up with is a folder called <code>‹Company Name›/‹ProjectName›</code> and in it a solution with a number of projects named <code>UI</code> or <code>Core</code> and so on. I then added a couple of areas and ran up the application to see that the initial build would work. All okay... Great!

I now have a source code repository that looks like this:
<pre>
/src
  /‹CompanyName›
    /‹ProjectName›
      /UI
      /Core
</pre>

<blockquote>
In previous projects I'd have the source set out like this:

<pre>
/src
  /‹CompanyName›.‹ProjectName›.UI
  /‹CompanyName›.‹ProjectName›.Core
</pre>

While this is nice and flat, it does mean that when you add in thing like C# project files you get lots of duplication in the paths that are created. e.g. <code>/src/‹CompanyName›.‹ProjectName›.Core/‹CompanyName›.‹ProjectName›.Core.csproj</code>
</blockquote>

Next up I realised that the namespaces were out as they were defaulting to the name of the C# project file name. So I went into the project settings and changed the default namespace and assembly name so that they'd be fully qualified (just in case we ever take a third party tool with similar names, so we need to ensure they don't clash in the actual code). I also went around the few code files that had been created so far and ensured their namespaces were consistent. (ReSharper is good at doing this, so you just have to press Alt-Enter on the namespace and it will correct it for you)

I ran the application again and it immediately failed when trying to compile a Razor view with the following error message:

<pre>Compiler Error Message: CS0246: The type or namespace name 'UI' could not be found (are you missing a using directive or an assembly reference?)</pre>

Looking at the compiler output I could see where it was happening:

<pre>
Line 25:     using System.Web.Mvc.Html;
Line 26:     using System.Web.Routing;
Line 27:     using UI;
Line 28:     
Line 29: 
</pre>

However, it took me a little investigation to figure out where that was coming from.

Each <code>Views</code> folder in the application has something like this in it:

<pre>
&lt;system.web.webPages.razor&gt;
    &lt;host factoryType="System.Web.Mvc.MvcWebRazorHostFactory, System.Web.Mvc, Version=5.1.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35" /&gt;
    &lt;pages pageBaseType="System.Web.Mvc.WebViewPage"&gt;
      &lt;namespaces&gt;
        &lt;add namespace="System.Web.Mvc" /&gt;
        &lt;add namespace="System.Web.Mvc.Ajax" /&gt;
        &lt;add namespace="System.Web.Mvc.Html" /&gt;
        &lt;add namespace="System.Web.Routing" /&gt;
        &lt;add namespace="UI" /&gt;
      &lt;/namespaces&gt;
    &lt;/pages&gt;
  &lt;/system.web.webPages.razor&gt;
</pre>

There was my old "UI" namespace that had been replaced. It was these settings that were generating the <code>using</code> statements in the Razor precompiled source.

The solution was simple, replace that "UI" namespace with the fully qualified version.

<pre>
        &lt;add namespace="‹CompanyName›.‹ProjectName›.UI" /&gt;
</pre>

And now the application works!
