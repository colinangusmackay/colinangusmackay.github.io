---
title: "Tip of the day: Setting a default stylesheet for Chrome"
slug: tip-of-the-day-setting-a-default-stylesheet-for-chrome
publishDate: 29 Mar 2013
description: "I often type up HTML documents in a text editor and view them directly in my browser to review then. However I don't like the default style, I don't find it is..."
tags:
  - { name: "Chrome", slug: chrome }
  - { name: "CSS", slug: css }
  - { name: "stylesheet", slug: stylesheet }
---
<!-- TODO: convert this post's content to Markdown -->

I often type up HTML documents in a text editor and view them directly in my browser to review then. However I don't like the default style, I don't find it is very readable. It is too plain and dull. What I really want is to provide a style sheet that make the document styled more to my taste, yet I don't want to have to litter my HTML files with uncessesary mark up linking to stylesheets.

Luckily Chrome has a custom.css file, which is empty by default, which you can use to provide your own CSS that is used when rendering documents and no other style information is available.

On windows this Custom.css file is located at: <code>C:\Users\<em>&lt;username&gt;</em>\AppData\Local\Google\Chrome\User Data\Default\User StyleSheets\Custom.css</code>

I've created my own style sheet, which can be found as a Gist on GitHub: <a href="https://gist.github.com/colinangusmackay/5273896">Custom.css</a>.

This is great. My plain HTML documents that I use for writing up blog posts and the like now look a lot better and without me having to put in references to CSS. It also means that the file can contain just the HTML body (no <code>&lt;head&gt;</code> or <code>&lt;html&gt;</code> tags) so I can lazily perform a <em>Ctrl+A</em>, <em>Ctrl+C</em> on the document and then drop it in to my blog.

There is one slight problem with all of this... Depending on how far you go with the styling, a little light play with fonts is okay, but some things like setting borders, margins, colours and widths can mess up existing sites because they don't expect the base style sheet to contain those elements. But then again, maybe that's a good thing if you are a front end web developer. It ensures that you don't make assumptions that may not be valid.
