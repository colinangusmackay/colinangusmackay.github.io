---
title: "Mental Block"
slug: mental-block
publishDate: 21 Jun 2007
description: "Today, I seem to be having a mental block while writing some unit tests. I keep writing Assert.AreSame() instead of Assert.AreEqual() and then wondering why..."
tags:
  - { name: "Assert", slug: assert }
  - { name: "unit testing", slug: unit-testing }
---
<!-- TODO: convert this post's content to Markdown -->

Today, I seem to be having a mental block while writing some unit tests. I keep writing <code>Assert.AreSame()</code> instead of <code>Assert.AreEqual()</code> and then wondering why tests are failing with bizarre message like “Expected 2, Actual 2”

Just in case anyone else has a day like this I’m going to explain the difference (although mainly as a bit of therapy for myself)

The <code>AreSame()</code> method checks that the expected and the actual reference the exact same “physical” object.

The <code>AreEqual()</code> method checks that the expected and the actual are equal to one another, even if they are not “physically” the same object.

<em>NOTE: This was rescued from the Google Cache. The original was dated Friday, 21st July, 2006.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/unit+test"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=unit+test" alt=" " />unit test</a> <a rel="tag" href="http://technorati.com/tag/assert"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=assert" alt=" " />assert</a> <a rel="tag" href="http://technorati.com/tag/mental+block"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=mental+block" alt=" " />mental block</a>
