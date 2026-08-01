---
title: "Tip of the Day #12 (Hard coded values)"
slug: tip-of-the-day-12-hard-coded-values
publishDate: 11 Jul 2009
description: "Don’t hard code VAT or other values that can change, even if they don’t change all that often. Additionally, if you really must hard coded values in a program..."
tags:
  - { name: "Code Quality", slug: code-quality }
---
<!-- TODO: convert this post's content to Markdown -->

Don’t hard code VAT or other values that can change, even if they don’t change all that often. Additionally, if you really must hard coded values in a program then make it a named constant rather than a literal value so that it can be tracked down by name. That will make it easier on the person having to maintain the program.
