---
title: "Parsing OS Grid References"
slug: parsing-os-grid-references
publishDate: 04 Dec 2007
description: "If you have ever been to an agile coding session you may have come across the concept of the coding kata . It is an exercise designed to improve coding skill..."
tags:
  - { name: "learning", slug: learning }
  - { name: "Spatial", slug: spatial }
---
<!-- TODO: convert this post's content to Markdown -->

If you have ever been to an agile coding session you may have come across the concept of the <a href="http://codekata.pragprog.com/2007/01/code_kata_backg.html#more" target="_blank">coding kata</a>. It is an exercise designed to improve coding skill by making you more aware of the different ways of building the same solution. It also tends to lend itself extremely well to TDD.

I was just looking at ways of converting OS National Grid References from their alphanumeric form to a purely numeric form and it occurred to me that it might make an excellent project for a coding kata.

So, what's the deal with OS National Grid References. Well, they consist of two letters followed by a number of digits. For example NT2474. NT relates to a square 100km along each side. The first two digits represent eastings within that square, and the second two represent northings within the square. The complete reference gives you a square that is one kilometre along each side. Of course, you can modify this to produce larger or smaller squares. NT, NT27, NT245746. As The actual coordinate the grid reference resolves to is the south west corner of the square. Also, there are optional spaces between parts, so NT245746 could be written as NT 245 746.

There is a more <a href="http://www.ordnancesurvey.co.uk/oswebsite/gps/information/coordinatesystemsinfo/guidetonationalgrid/page1.html" target="_blank">detailed guide to the national grid</a> on the Ordnance Survey website.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:71bd1d71-aa9b-41a0-bc91-1bc9a3f2eda1" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/ordnance%20Survey">ordnance Survey</a>,<a rel="tag" href="http://technorati.com/tags/coding%20kata">coding kata</a>,<a rel="tag" href="http://technorati.com/tags/national%20grid%20reference">national grid reference</a></div>
