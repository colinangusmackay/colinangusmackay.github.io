---
title: "Tip of the day #13 (String Equality)"
slug: tip-of-the-day-13-string-equality
publishDate: 12 Jul 2009
description: "When comparing two strings in a case insensitive manner, use: myFirstString.Equals(mySecondString, StringComparison.InvariantCultureIgnoreCase) or, if cultural..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---
<!-- TODO: convert this post's content to Markdown -->

When comparing two strings in a case insensitive manner, use:
<pre>myFirstString.Equals(mySecondString, StringComparison.InvariantCultureIgnoreCase)</pre>
or, if cultural rules are to be ignored completely* then use:
<pre>myFirstString.Equals(mySecondString, StringComparison.OrdinalIgnoreCase)</pre>
over:
<pre>myFirstString.ToLower() == mySecondString.ToLower()</pre>
<small>* The invariant culture is actually a non-region specific English language culture. The ordinal comparison is faster than any culture specific comparison as it uses a much simpler comparison algorithm.</small>

<img src="http://blog.colinmackay.net/aggbug/8228.aspx" alt="" width="1" height="1" />
