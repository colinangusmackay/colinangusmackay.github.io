---
title: "Tip-of-the-day: Columns in CSS"
slug: tip-of-the-day-columns-in-css
publishDate: 17 Jan 2012
description: "The CSS Multi-column layout module is a Candidate Recommendation that allows CSS to specify various aspects of column layout for page flow. It has some..."
tags:
  - { name: "CSS", slug: css }
  - { name: "HTML", slug: html }
---
<!-- TODO: convert this post's content to Markdown -->

<p>The <a href="http://www.w3.org/TR/css3-multicol/" target="_blank">CSS Multi-column layout module</a> is a Candidate Recommendation that allows CSS to specify various aspects of column layout for page flow. It has some implementations in <a title="Google Chrome" href="http://www.google.com/chrome">Chrome</a> and <a href="http://www.getfirefox.net/">FireFox</a> but it does not work in <a title="Microsoft Internet Explorer" href="http://windows.microsoft.com/en-GB/windows7/products/features/internet-explorer-8">IE</a> yet. (I’ve not tested it on other browsers). Because of this you have to specify the Webkit and Mozilla extensions in the CSS. e.g.</p>  <pre>div.example
{
  column-width: 300px;
  -moz-column-width: 300px;
  -webkit-column-width: 300px;
}</pre>

<p>To show you what it can do, I've created some small simple examples using <a href="http://static.colinmackay.co.uk/examples/2012/css/multi-column-layout/list-columns.html" target="_blank">a list of cities</a>, <a href="http://static.colinmackay.co.uk/examples/2012/css/multi-column-layout/paragraph-columns.html" target="_blank">a poem</a> and <a href="http://static.colinmackay.co.uk/examples/2012/css/multi-column-layout/paragraph2-columns.html" target="_blank">some prose</a>. (The links open in new windows. You are encouraged to look at the page source too)</p>

<p><img style="display:inline;margin-left:0;margin-right:0;" title="Without Columns" alt="Without Columns" src="http://static.colinmackay.co.uk/images/css/2012-01-17-css-multi-column-layout-not-applied-240.png" />&#160;<img title="With Columns" alt="With Columns" src="http://static.colinmackay.co.uk/images/css/2012-01-17-css-multi-column-layout-applied-240.png" /></p>
