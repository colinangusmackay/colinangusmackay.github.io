---
title: "The public fields debate again"
slug: the-public-fields-debate-again
publishDate: 21 Jun 2007
description: "Back in November last year I wrote about why you should make fields in a class private and not make them public . A recent post in Code Project shows that some..."
tags:
  - { name: "object oriented design", slug: object-oriented-design }
---
<!-- TODO: convert this post's content to Markdown -->

Back in November last year I wrote about <a title="Why make fields in a class private, why not just make them public?" href="http://colinmackay.co.uk/blog/2007/06/22/why-make-fields-in-a-class-private-why-not-just-make-them-public/">why you should make fields in a class private and not make them public</a>. A recent post in <a title="Code Project" href="http://www.codeproject.com/" target="_blank">Code Project</a> shows that some people still make fields public. I did concede on one argument though - If you have a struct with nothing but public fields then there was no need to make them private and create public properties to back them. But, I added....

As soon as you put any form of functionality in there (or even if you think that at some point in the future there will be some form of functionality in there) then make them private and create properties.

While accessing public fields and properties may look the same to a C# developer, a property is just syntactic sugar over the <code>get_</code> and <code>set_</code> methods. So if you make the transition to properties later on (for to add additional functionality - e.g. implementing a lazy look up on a getter, or setting a dirty flag on a setter) any assemblies that relied on public fields will fail because, to them, the public interface of the class is now different.

Therefore if you get in to the habit of creating properties backing your private fields always you'll never have to worry about how you are going to add in additional functionality later on when you realise the public interface changes.

<em>NOTE: This was rescued from the Google Cache. The original date was Saturday 17th June 2006.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/c%23"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23" alt=" " />c#</a> <a rel="tag" href="http://technorati.com/tag/syntactic+sugar"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=syntactic+sugar" alt=" " />syntactic sugar</a> <a rel="tag" href="http://technorati.com/tag/public+field"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=public+field" alt=" " />public field</a> <a rel="tag" href="http://technorati.com/tag/properties"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=properties" alt=" " />properties</a>

<hr />Original Comments:

There is nothing wrong with using public fields in an non-public accessable class.
<div class="postfoot">6/17/2006 5:52 PM | <a id="Comments_ascx_CommentList_ctl00_NameLink" title="PingBack/TrackBack" href="http://blogs.wdevs.com/leppie" target="_blank">leppie</a></div>
I dont think its wrong to have public fields in a lib as long as you dont plan on beeing binary compatible, since binary compatabillity breaks the day you change one of those fields to a property..
<div class="postfoot">6/18/2006 6:36 AM | <a id="Comments_ascx_CommentList_ctl01_NameLink" title="PingBack/TrackBack" target="_blank">Roger Johansson</a></div>
leppie - I'll accept that is also another place where it might be okay to use public fields.
<div class="postfoot">6/23/2006 9:53 PM | <a id="Comments_ascx_CommentList_ctl02_NameLink" title="PingBack/TrackBack" href="http://www.colinmackay.net/" target="_blank">Colin Angus Mackay</a></div>
