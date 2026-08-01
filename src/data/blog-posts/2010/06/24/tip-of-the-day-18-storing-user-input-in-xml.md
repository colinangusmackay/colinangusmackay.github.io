---
title: "Tip of the Day #18: Storing User Input in XML"
slug: tip-of-the-day-18-storing-user-input-in-xml
publishDate: 24 Jun 2010
description: "If you are going to dump user generate input into XML please remember to escape appropriately. For example, the ampersand symbol has special meaning in XML and..."
tags:
  - { name: ".NET", slug: net }
---
<!-- TODO: convert this post's content to Markdown -->

If you are going to dump user generate input into XML please remember to escape appropriately. For example, the ampersand symbol has special meaning in XML and you must escape it. e.g. &amp; becomes &amp;amp;
