---
title: "Installing a web site on a new server"
slug: installing-a-web-site-on-a-new-server
publishDate: 08 Sep 2011
description: "Here are some blog posts that have been useful to me lately when I got caught out installing a website on a new server (I will eventually get that automated..."
tags:
  - { name: ".NET", slug: net }
  - { name: "asp.net", slug: asp-net }
  - { name: "Error", slug: error }
  - { name: "IIS", slug: iis }
  - { name: "IIS7", slug: iis7 }
  - { name: "x64", slug: x64 }
  - { name: "x86", slug: x86 }
---
<!-- TODO: convert this post's content to Markdown -->

Here are some blog posts that have been useful to me lately when I got caught out installing a website on a new server (I will eventually get that automated build and deploy process actually performing the deploy step successfully!!)

<a href="http://blog.benday.com/archive/2010/05/19/23278.aspx">The configuration section 'system.web.extensions' cannot be read because it is missing a section declaration</a>:
<p style="padding-left:30px;">While installing a website on a new Windows Server I came across this error. In short, it was because the App Pool was set up as a .NET 2.0 application rather than a 4.0. The blog post explains what was going on and how to fix it.</p>
<a href="http://weblogs.asp.net/hosamkamel/archive/2009/10/11/resolved-could-not-load-file-or-assembly-xxxxx-or-one-of-its-dependencies-an-attempt-was-made-to-load-a-program-with-an-incorrect-format.aspx">[Resolved] Could not load file or assembly 'XXXXX' or one of its dependencies. An attempt was made to load a program with an incorrect format</a>:
<p style="padding-left:30px;">Although this didn't help me in the end, it does suggest a solution. In my case, because of a third-party dependency that requires an x86 build, it couldn't be used. In time that dependency will be removed, in the meantime the following was more helpful to me...</p>
<a href="http://dailydotnettips.com/2011/07/03/could-not-load-file-or-assembly-presentationcore-or-one-of-its-dependencies-an-attempt-was-made-to-load-a-program-with-an-incorrect-format-a-solution/">Could not load file or assembly ‘PresentationCore’ or one of its dependencies. An attempt was made to load a program with an incorrect format. : A solution</a>:
<p style="padding-left:30px;">This post did give me the pointer I needed to the setting that had to be changed to get the web site working.</p>
