---
title: "A bad workman blames his tools"
slug: a-bad-workman-blames-his-tools
publishDate: 23 Jun 2007
description: "I wish that some people, when asking questions on a forum, would look inwards for a moment and reflect whether they really understand what they are talking..."
tags:
  - { name: "learning", slug: learning }
---
<!-- TODO: convert this post's content to Markdown -->

I wish that some people, when asking questions on a forum, would look inwards for a moment and reflect whether they really understand what they are talking about before making unfounded bold statments such as:
<blockquote style="margin-right:0;">.NET is only one problem after another problem <a title="Photo Sharing" href="http://www.flickr.com/photos/colinangusmackay/600666057/"><img src="http://farm2.static.flickr.com/1076/600666057_36444bedf2_o.gif" border="0" alt="smiley_mad" width="16" height="16" /></a> <a title="Photo Sharing" href="http://www.flickr.com/photos/colinangusmackay/600666057/"><img src="http://farm2.static.flickr.com/1076/600666057_36444bedf2_o.gif" border="0" alt="smiley_mad" width="16" height="16" /></a> <a title="Photo Sharing" href="http://www.flickr.com/photos/colinangusmackay/600666057/"><img src="http://farm2.static.flickr.com/1076/600666057_36444bedf2_o.gif" border="0" alt="smiley_mad" width="16" height="16" /></a></blockquote>
<p dir="ltr">One such poster on <a title="Code Project" href="http://www.codeproject.com/" target="_blank">Code Project</a> made a statement like that, then provided his code that was talking 2 minutes to run and that was unacceptable. He was blaming <a title="Microsoft" href="http://www.microsoft.com/" target="_blank">Microsoft</a> and the .NET Framework but from one look at his code it was obvious where the problem was - and it wasn't with <a title="Microsoft" href="http://www.microsoft.com/" target="_blank">Microsoft</a> or the .NET Framework.</p>
<p dir="ltr">He wanted to update a column on a table. In fact he wanted to update that column on every row in the table. So, he pulled across 100,000 rows in to his .NET application then proceeds to loop over each returned row performing an UPDATE statement. So, in total he sent 100,001 commands to SQL Server. His complaint was magnified because he was expecting to have situations where 1,000,000 rows would need to be updated and that would take much longer. (20 minutes by the method he was employing)</p>
<p dir="ltr">Was the .NET application doing anything fancy as part of the update? No, it was simply copying the value from one column to another.</p>
<p dir="ltr">All his .NET code could be reduced to sending just one single piece of SQL to the database to do all the work. A simple UPDATE statement would do everything and take less than a second to execute - most likely even for a million rows.</p>
<p dir="ltr">But, did the poster seem to accept that perhaps it was his code or his misunderstanding of how the database could be leveraged that was at fault. No! He was insistant, with lots of angry faces, that it was <a title="Microsoft" href="http://www.microsoft.com/" target="_blank">Microsoft</a>'s fault for not getting the .NET framework right.</p>
<p dir="ltr"><em>NOTE: This was rescued from the Google Cache. The original date was Wednesday, 5th April, 2006.</em></p>
Tags: <a rel="tag" href="http://technorati.com/tag/microsoft."><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=microsoft." alt=" " />microsoft.</a> <a rel="tag" href="http://technorati.com/tag/net"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=net" alt=" " />net</a> <a rel="tag" href="http://technorati.com/tag/dababase"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=dababase" alt=" " />dababase</a> <a rel="tag" href="http://technorati.com/tag/sql"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql" alt=" " />sql</a> <a rel="tag" href="http://technorati.com/tag/sql+server"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+server" alt=" " />sql server</a> <a rel="tag" href="http://technorati.com/tag/code+project"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=code+project" alt=" " />code project</a> <a rel="tag" href="http://technorati.com/tag/performance"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=performance" alt=" " />performance</a>

<hr />Original comments:

Good Lord!
Did you reply to him with the obvious?
Maybe his next step will be to use a cursor within a single SQL statement and then blame the database!

ACK!
<div class="postfoot">4/5/2006 9:23 PM | <a id="Comments_ascx_CommentList_ctl00_NameLink" title="PingBack/TrackBack" href="http://blogs.wdevs.com/dpl" target="_blank">LJ</a></div>
I told him how to get better performance, and I did point out that it wasn't <a title="Microsoft" href="http://www.microsoft.com/" target="_blank">Microsoft</a>'s fault. It was his poor code.
<div class="postfoot">4/5/2006 9:27 PM | <a id="Comments_ascx_CommentList_ctl01_NameLink" title="PingBack/TrackBack" href="http://blogs.wdevs.com/ColinAngusMackay/" target="_blank">Colin Angus Mackay</a></div>
Don't worry as his 386 workstation, with 4Mb of RAM and a dial-up modem will always ensure he is slow!

I'd have politely pointed out that his code "sucks", what was wrong, what could be done to fix it then told him to get another career.

You should have linked to the CodeProject thread that shows this plonker in action!!!
<div class="postfoot">4/5/2006 9:52 PM | <a id="Comments_ascx_CommentList_ctl02_NameLink" title="PingBack/TrackBack" href="http://blog.roundtripsolutions.com/" target="_blank">John A Thomson</a></div>
I find this a lot with rookies. Although, development these days requires you know a number of disciplines. SQL, ASP.NET, VB.NET/C#, HTML, T-SQL. Fast machines normally hide an inefficient programmer. That is why you need a jack-of-all-trades. Great blog.
<div class="postfoot">4/19/2006 2:13 PM | <a id="Comments_ascx_CommentList_ctl03_NameLink" title="PingBack/TrackBack" href="http://www.hpcons.com/" target="_blank">Calvin</a></div>
Oh yeah I know a few of them.
<div class="postfoot">5/7/2006 3:37 PM | <a id="Comments_ascx_CommentList_ctl04_NameLink" title="PingBack/TrackBack" target="_blank">Derek Smyth</a></div>
