---
title: "Tip of the Day #21: Prefer the use of first-child CSS selector over last-child"
slug: tip-of-the-day-21-prefer-the-use-of-first-child-css-selector-over-last-child
publishDate: 14 Feb 2011
description: "I just got this fantastic tip from Jamie Boyd , a colleague of mine: The :first-child and :last-child selectors are super-useful for applying alternate styling..."
tags: []
---
<!-- TODO: convert this post's content to Markdown -->

<p>I just got this fantastic tip from Jamie Boyd , a colleague of mine:</p>  <blockquote>   <p>The <b>:first-child</b> and <b>:last-child</b> selectors are super-useful for applying alternate styling to items in lists and things like that (e.g. removing the margin from the last item in a container-spanning nav bar). But when it comes to browser support, they are not equal.</p>    <p><b>:last-child</b> is actually only supported in IE9+, whereas <b>:first-child</b> has had partial support since IE7 (where it works, but styles won?t update if dynamic content is added).</p>    <p>So if you can, use <b>:first-child</b> rather than <b>:last-child</b>.</p></blockquote><img src="http://blog.colinmackay.net/aggbug/18392.aspx" width="1" height="1" />
