---
title: "Tip-of-the-day: Columns in CSS"
slug: tip-of-the-day-columns-in-css
publishDate: 17 Jan 2012
description: "The CSS Multi-column layout module is a Candidate Recommendation that allows CSS to specify various aspects of column layout for page flow. It has some..."
tags:
  - { name: "CSS", slug: css }
  - { name: "HTML", slug: html }
---
The [CSS Multi-column layout module](http://www.w3.org/TR/css3-multicol/) is a Candidate Recommendation that allows CSS to specify various aspects of column layout for page flow. It has some implementations in [Chrome](http://www.google.com/chrome "Google Chrome") and [FireFox](http://www.getfirefox.net/) but it does not work in [IE](http://windows.microsoft.com/en-GB/windows7/products/features/internet-explorer-8 "Microsoft Internet Explorer") yet. (I’ve not tested it on other browsers). Because of this you have to specify the Webkit and Mozilla extensions in the CSS. e.g.

```css
div.example
{
  column-width: 300px;
  -moz-column-width: 300px;
  -webkit-column-width: 300px;
}
```

To show you what it can do, I've created some small simple examples using [a list of cities](/examples/2012/css/multi-column-layout/list-columns.html), [a poem](/examples/2012/css/multi-column-layout/poem-paragraph-columns.html) and [some prose](/examples/2012/css/multi-column-layout/prose-paragraph-columns.html). (You are encouraged to look at the page source too)

![](/assets/blog/2012-01-17-tip-of-the-day-columns-in-css-1.webp)
