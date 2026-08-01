---
title: "Tip of the day: IE Quirks Mode Vs. Standards Mode"
slug: tip-of-the-day-ie-quirks-mode-vs-standards-mode
publishDate: 24 Jun 2011
description: "If you are setting the DOCTYPE declaration in an HTML page to define the standard your page complies with ensure that you don't put anything before that..."
tags:
  - { name: "HTML", slug: html }
  - { name: "Internet Explorer", slug: internet-explorer }
  - { name: "Standards", slug: standards }
---
<!-- TODO: convert this post's content to Markdown -->

If you are setting the DOCTYPE declaration in an HTML page to define the standard your page complies with ensure that you don't put anything before that DOCTYPE declaration.

Some browsers will ignore comments and such like before the DOCTYPE declaration but IE doesn't and if there is a comment it will then ignore the DOCTYPE which then puts your browser into Quirks Mode (and that can screw up the rendering of your page)

So, if I put this at the top of the document:
<pre>&lt;!-- This will trigger IE into quirks mode --&gt;
&lt;!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "<a href="http://www.w3.org/TR/html4/strict.dtd">http://www.w3.org/TR/html4/strict.dtd</a>"&gt;</pre>
Then quirks mode will be rendered.

However, if I put the comment after the DOCTYPE everthing is fine, like this:
<pre>&lt;!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"&gt;
&lt;!-- This won't trigger IE into quirks mode as the DOCTYPE is first --&gt;</pre>
