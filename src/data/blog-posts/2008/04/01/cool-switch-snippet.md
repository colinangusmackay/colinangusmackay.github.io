---
title: "Cool switch snippet"
slug: cool-switch-snippet
publishDate: 01 Apr 2008
description: "I was watching one of the MSDN Screencasts today and Mike Taulty put in a switch statement that pre-populated itself with valid values for each of the case..."
tags:
  - { name: "visual studio", slug: visual-studio }
  - { name: "Visual Studio 2005", slug: visual-studio-2005 }
  - { name: "Visual Studio 2008", slug: visual-studio-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

I was watching one of the <a href="http://www.microsoft.com/uk/msdn/screencasts/" target="_blank">MSDN Screencasts</a> today and <a href="http://mtaulty.com/communityserver/blogs/mike_taultys_blog/default.aspx" target="_blank">Mike Taulty</a> put in a switch statement that pre-populated itself with valid values for each of the case statements within the switch. I hadn't seen this before so I investigated further (in other words, I emailed Mike and asked him what he did). It turns out this is a feature that has been in since Visual Studio 2005 and I'd only just noticed.

Essentially, if you are switching on an enumerator the snippet will expand with all the case statements created for you as you can see by the animation below. To access this, follow these steps
<ul>
	<li>Type "switch", the intellisense will show the word "switch" with the torn document icon, indicating it is a snippet.</li>
	<li>Press the tab key twice to expand the snippet, this will also highlight the text "switch_on".</li>
	<li>Change the "switch_on" text to the name of the variable on which you want to switch.</li>
	<li>Press return twice, this will further expand the switch statement filling in all the cases from the enumerator.</li>
</ul>
For an example, see the animation below:

<a title="switch snippet by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/2380162881/"><img src="http://farm3.static.flickr.com/2092/2380162881_8345ea9358_o.gif" alt="switch snippet" width="800" height="600" /></a>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:d805cb9f-bb9b-4a1e-8d06-30d97fa5a0f9" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/switch">switch</a>,<a rel="tag" href="http://technorati.com/tags/snippet">snippet</a>,<a rel="tag" href="http://technorati.com/tags/visual%20studio">visual studio</a></div>
&nbsp;

&nbsp;
