---
title: "Tip of the Day #18: Dealing with data rounding issues"
slug: tip-of-the-day-18-dealing-with-data-rounding-issues
publishDate: 01 Sep 2010
description: "If you have data coming in from a database, web service or other source external to your application and it contains, say for example, price information then..."
tags:
  - { name: "Code Quality", slug: code-quality }
  - { name: "software development practices", slug: software-development-practices }
---
<!-- TODO: convert this post's content to Markdown -->

If you have data coming in from a database, web service or other source external to your application and it contains, say for example, price information then do not round it. Don?t attempt to apply any form of formatting to it regardless of how much the client insists that the data will be in this form (e.g. all prices at go live will be in round pounds).

Yes, having whole rounded pounds, without having to display the pennies, on the front end looks nice and pretty. However, the display of whole rounded pounds on the front end is a rendering issue and should always be left to the code that is rendering the user interface. The rounding should never take place close to the point that the information is extracted from its source.

Why? Because eventually the client will want things displayed differently, to put prices with pennies in it, and you have to display those pennies. Now you don?t have to just update the rendering code to display the pounds and pence, but you also have to track down where that rounding occurs and stop it from happening in the first place.

But that?s not all. If you round data, effectively truncating it, early then subsequent calculations will be wrong. In fact, rounding isn?t just like truncating the data. Truncating is just removing precision. Rounding can change the value. That can cause even more havoc later on.

So, why round that early anyway, especially if the data is arriving in a certain way in the first place? Well, I can only guess that perhaps because back before anything went live, in the test system they weren't. So, just to make the test system look like the eventual live system the prices were rounded the moment they arrived in the application just to be sure they were in round pounds.

The lesson, clients change their minds and business logic should always operate on the cleanest data, unsullied by rendering constraints wherever possible. This means that calculations based on that data will remain correct, even if other factors change.

<img src="http://blog.colinmackay.net/aggbug/14599.aspx" alt="" width="1" height="1" />
