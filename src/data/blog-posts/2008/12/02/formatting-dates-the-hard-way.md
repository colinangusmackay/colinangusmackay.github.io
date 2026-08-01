---
title: "Formatting dates the hard way"
slug: formatting-dates-the-hard-way
publishDate: 02 Dec 2008
description: "I was doing a bit of a code review and I spotted this in the code base. string [] splitOptions = new string [1] { dayEarlier.Date.Year.ToString() }; string []..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---
<!-- TODO: convert this post's content to Markdown -->

I was doing a bit of a code review and I spotted this in the code base.
<pre class="code"><span style="color:blue;">string</span>[] splitOptions = <span style="color:blue;">new string</span>[1] { dayEarlier.Date.Year.ToString() };
<span style="color:blue;">string</span>[] earlyDates = dayEarlier.Date.GetDateTimeFormats();
<span style="color:blue;">string</span>[] earlySplit = earlyDates[67].Split(splitOptions,
<span style="color:#2b91af;">    StringSplitOptions</span>.RemoveEmptyEntries);
earlySplit[0] = earlySplit[0].Replace(<span style="color:#a31515;">","</span>, <span style="color:blue;">string</span>.Empty);</pre>
Essentially the code gets the date in a specific format. However, it does it in the oddest most convoluted way I’ve ever seen.  Just to explain, here is the code again but this time I've added some comments:
<pre class="code"><span style="color:green;">// dayEarlier is a business object with a property called Date that returns a DateTime.
// splitOptions will contain the year in an 1-element string array.
</span><span style="color:blue;">string</span>[] splitOptions = <span style="color:blue;">new string</span>[1] { dayEarlier.Date.Year.ToString() };

<span style="color:green;">// earlyDates will contain the dayEarlier Date in umpteen different formats.
</span><span style="color:blue;">string</span>[] earlyDates = dayEarlier.Date.GetDateTimeFormats();

<span style="color:green;">// earlySplit will contain the 68th (!) formatted date (out of 89 that get generated).
// Element 0 in this array will contain the bit upto the year, element 1 will contain
// the bit after the year. The year itself is discarded.
</span><span style="color:blue;">string</span>[] earlySplit = earlyDates[67].Split(splitOptions,
<span style="color:#2b91af;">    StringSplitOptions</span>.RemoveEmptyEntries);

<span style="color:green;">// The first element (element 0) of earlySplit is then modified to remove the comma.
</span>earlySplit[0] = earlySplit[0].Replace(<span style="color:#a31515;">","</span>, <span style="color:blue;">string</span>.Empty);</pre>
In short, what is actually being looked for is the day name, day of the month and the month. That’s it. And that, apparently, isn’t even in the 89 permutations of the date that .NET generated in the second line of code. To add to the potential problems with this, I've not seen any documentation that states that the permutations given by this method will stay the same.

All this code could easily be re-written simply as:
<pre class="code">dayEarlier.Date.ToString(<span style="color:#a31515;">"ddd dd MMM"</span>);</pre>
And the bonus here is that we are not generating 88 completely useless permutations, nor are we generating the permutation that is simply the closest match that we still have to futz around with. We are generating the date in exactly the format that we want. (Current culture permitting)
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:90079063-ee8a-4bc4-90e5-77dda0da8699" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/C#">C#</a>,<a rel="tag" href="http://technorati.com/tags/DateTime">DateTime</a>,<a rel="tag" href="http://technorati.com/tags/ToString">ToString</a>,<a rel="tag" href="http://technorati.com/tags/date%20format">date format</a>,<a rel="tag" href="http://technorati.com/tags/.NET">.NET</a></div>
