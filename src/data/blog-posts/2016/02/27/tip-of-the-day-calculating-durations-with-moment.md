---
title: "Tip of the Day: Calculating durations with Moment"
slug: tip-of-the-day-calculating-durations-with-moment
publishDate: 27 Feb 2016
description: "Moment has quite a nice fluent interface for some operations, others just need a little more thought. For example, I wanted the duration of something and I had..."
tags:
  - { name: "javascript", slug: javascript }
  - { name: "moment.js", slug: moment-js }
  - { name: "node.js", slug: node-js }
---
<!-- TODO: convert this post's content to Markdown -->

Moment has quite a nice fluent interface for some operations, others just need a little more thought.

For example, I wanted the duration of something and I had recorded the start and end time. I thought something like this, finding the <a href="http://momentjs.com/docs/#/displaying/difference/" target="_blank">difference</a> between two dates and converting it to a duration, would work:
<pre><del>var duration = endTime.diff(startTime).duration().asSeconds();</del></pre>
However, that doesn't work.

What you have to do is find the difference, then pass that into the duration function, like this:
<pre>var duration = moment.duration(endTime.diff(startTime)).asSeconds();</pre>
And now I get what I wanted.
