---
title: "Follow up on hiring a software developer"
slug: follow-up-on-hiring-a-software-developer
publishDate: 19 Dec 2007
description: "A while ago I wrote about finding it difficult to hire good software developers . We have now hired someone and it took us 3 months from the first interview to..."
tags:
  - { name: "hiring", slug: hiring }
---
<!-- TODO: convert this post's content to Markdown -->

A while ago I wrote about finding it <a title="Why is it so hard to hire good software developers?" href="http://colinmackay.co.uk/blog/2007/08/19/why-is-it-so-hard-to-hire-good-software-developers/">difficult to hire good software developers</a>. We have now hired someone and it took us 3 months from the first interview to the last. We changed our strategy a couple of times throughout the process.

First we were told we had to go through the internal HR system which puts adverts out in job centres* across the UK. I don't know why as we don't do relocation so why not just stick to the local job centres. We also went to a recruitment agent after persuading HR that we really needed their services. For all the flak that recruitment agents get all I can say is that at the very least they gave us CVs that were of high enough quality to warrant an interview. All the CVs from the job centre were useless. Half of them didn't even have any IT experience on them at all, let alone any evidence of software development work.

As we started to interview it seems obvious to us that the vast majority of senior software developers have stagnated. I did that once and it cost me 3 months unemployment - I am never doing that again.

We would ask these "senior" guys basic questions about OO (such as "What is encapsulation?") and we'd get back blank stares from most of them. Okay, they've done work with SQL Server so some basic questions about indexes and joins (and I mean very basic like "What is the advantage of having an index?" or "Can you name any of the types of join SQL Server supports?").

After a while we realised that the people we interviewed always perked up a bit and became more enthusiastic when we started talking about SQL Server. We got more right answers, more confidence and more enthusiasm in that area. So we changed the order of the questions around putting the SQL Server questions up front to give people a bit more confidence in themselves rather that just ask questions on skills in the order in which they were listed on their CV.

We also gave them a little programming problem. It was based on the Fizz-Buzz (or Buzz-Fizz) game that Scott Hanselman mentioned in one of his <a href="http://www.hanselminutes.com" target="_blank">Hanselminutes</a> on <a href="http://www.hanselminutes.com/default.aspx?showID=69" target="_blank">Hiring and Interviewing Engineers</a>. I wrote the program, then I introduced a bug. We would give the candidate the paper with the program on it and the output that the program made with the error in the output highlighted. We would then ask the candidate to first of all tell us where the bug was and secondly to suggest a solution. I was shocked at the number of people that could not even point out the bug.

What was interesting was the the guy we eventually hired only looked at the code for about 5 seconds and pointed out the exact line and why it wasn't working. When we asked for a possible solution we got an answer straight away. Given the speed of the answer we asked a third question (never before asked).

Before I get to that third question here's a little background. When I developed the question I put it round the development team for comments and just to see how fast our existing developers could solve the problem to get some kind of bench mark on the time needed for the question. I got a number of different correct responses for the way to solve the problem (even from our DBA who hadn't programmed in C# before).

So, the third question asked was "Can you think of any other ways in which to fix the bug?" and very quickly our candidate came up with two further solutions.

I've skipped ahead slightly in the story, so I'll go back a bit. We were still having problems with senior developers not being able to answer basic questions. And when they did get as far as the practical test, they failed that shockingly badly too. Although, most of them failed because they did not read the specification and therefore did not do what was asked of them.

So, we changed out tactics slightly. We decided that as we had a fixed budget in which to hire someone, we would look for a graduate and use the extra money for training. We started getting in CVs for recent graduates. These were more difficult because a graduate doesn't have so much experience. So we looked for things that showed commitment and an interest in technology. It didn't matter to us that the only language they might have used was Java as we could train them.

But when it came to the interviews these guys really shone out more that the supposedly senior guys. They could answer all the basic questions. They were willing to admit when we'd reached the limit of their knowledge. (Either that, or they hadn't learned to BS their way through answers)

When it came to the practical test, they showed some real promise, even if they did get the occasional thing wrong. Compare that with our earlier experiences where one "senior" guy had spent two hours in front of the PC and had written two lines of code in that time.

In the end we interviewed about 4 guys who had recently graduated and this was going to be their first or second software development job. And we hired one of them. If we'd gone for that strategy to start with I think we would have taken a lot less time and we wouldn't have been so frustrated with the whole process.

The one thing we did not consider during the whole process was dropping our standards. I think we would have regretted it if we had. What we discovered was shocking. That is something I'll cover in another post.

<strong>Some advice</strong>

As I mentioned, a lot of the senior developers we interviewed had somehow stagnated. They weren't interested in software development other than as a 9-5 job. One even said in answer to a question "I've not been on a training course about that yet"! We only ask questions about stuff they've put on their CV. If they don't have ASP.NET, for instance, but they've spent time doing windows applications we'll ask them about Windows applications and we'll skip ASP.NET. If we then need them to do an ASP.NET application we are confident that any developer worth their salt can pick it up in a short time. But, if they don't have the fundamentals then I can't see how they would cope.

So, if you are happy to go with the flow and just learn what your company needs you to learn rather than keep your marketable skill set up then feel free. Just don't expect me to consider paying you the big bucks only to send you on lots of training courses for basic things like OO, C# and SQL Server.

&nbsp;
<div id="scid:5737277B-5D6D-4f48-ABFC-DD9C333F4C5D:506ce110-c6dc-47c7-90ab-9b3091d9587f" class="wlWriterSmartContent" style="display:inline;float:right;margin:0;padding:0 0 10px 10px;">
<div id="d62fecb9-d2ef-43bb-8bd1-70d2207897e7" style="margin:0;padding:0;display:inline;">
<div><a href="http://video.msn.com/video.aspx?vid=e1291874-84ee-4d9f-bc14-7d2d04c009ea&amp;ifs=true&amp;fr=shared&amp;from=writer" target="_new"><img src="http://blog.colinmackay.net/images/blog_colinmackay_net/WindowsLiveWriter/f6374be75ef8_13149/videoef198a6b6cf0.jpg" alt="" /></a></div>
</div>
</div>
But, if you do want to get out of that rut then here is some advice to you:
<ul>
	<li>Find a local user group and attend their meetings. You get to meet experts. You can talk to them and increase your understanding. If you are in Scotland there are a number of user groups already:
<ul>
	<li><a href="http://www.scottishdevelopers.com/" target="_blank">Scottish Developers</a></li>
	<li><a href="http://www.northeastscotland.net/DNN4/" target="_blank">North East Scotland .NET User Group</a></li>
	<li><a href="http://agilescotland.blogspot.com/" target="_blank">Agile Scotland</a></li>
	<li><a href="http://www.sqlserverfaq.com/" target="_blank">SQL Server User Group</a></li>
	<li><a href="http://www.bcs.org/" target="_blank">British Computer Society</a>, with branches in <a href="http://www.edinburgh.bcs.org/" target="_blank">Edinburgh</a>, <a href="http://www.glasgow.bcs.org/index.htm" target="_blank">Glasgow</a>, <a href="http://www.tayside.bcs.org/" target="_blank">Tayside</a>, <a href="http://aberdeen.bcs.org/" target="_blank">Aberdeen</a> and <a href="http://www.bcs.org/server.php?show=conWebDoc.1282" target="_blank">Inverness</a>.</li>
	<li><a href="http://ukjugs.org/display/main/Home" target="_blank">Java User Group Scotland</a></li>
	<li>And probably more that I don't know about (If you know of any please let me know and I'll add it to the list) The video to the right was created to show how active user groups are in the UK as a whole.</li>
</ul>
</li>
	<li>Read stuff - And not just when you discover that you need it. Subscribe to a relevant software development magazine. Many companies will pay for that for you as they see it as an inexpensive form of training. Just read articles about software development to broaden your horizons. If you take a train or a bus to and from work this is an excellent time to do this.</li>
	<li>Listen to stuff - There are some excellent podcasts out there that you can listen to while driving. <a href="http://www.dotnetrocks.com/" target="_blank">DotNetRocks</a> and <a href="http://www.hanselminutes.com" target="_blank">Hanselminutes</a> are two of my favourites. Scott Hanselman even has a show on how to <a href="http://www.hanselminutes.com/default.aspx?showID=90" target="_blank">be a better developer in 6 months</a>.</li>
</ul>
You don't have to spend a lot of time or money picking new stuff up. A user group meeting or two per month. That really doesn't cost a lot. Some user groups charge, some don't. If they do it is a modest amount to cover the cost of the venue and maybe some food and drink. In terms of time it is about 5 hours per month. It might be a wee bit more if you socialise after but that brings additional benefits. If you socialise people get to know you and if there is a job going it is great to have some contacts already.

Listening to podcasts in the car is practically free. You can get MP3 players hooked up to in-car stereos now and if not many will have CD players that can play MP3 or WMA files (The Toyota Yaris certainly does) so that only costs you the price of a blank CD for every 15 hours (roughly) of podcasts. In terms of time it only takes a few minutes to download and burn the files to a disk or transfer them to your MP3 player. In terms of time listening to them it is also free because it was dead time anyway. So that's an additional bonus - you've turned some dead time into something useful.

&nbsp;

Other posts on a similar theme:
<ul>
	<li><a href="http://colinmackay.co.uk/blog/2007/08/19/why-is-it-so-hard-to-hire-good-software-developers/">Why is it so hard to hire good software developers?</a></li>
	<li><a href="http://colinmackay.co.uk/blog/2007/08/20/more-on-hiring-developers/">More on hiring developers</a></li>
	<li><a href="http://colinmackay.co.uk/blog/2007/09/06/what-are-developer-forums-for/">What are developer forums for?</a></li>
</ul>
&nbsp;

* If you are from outside the UK, the job centre is part of the government's department for work and pensions (DWP) and it is tasked with dealing with out of work people and helping them back into work.

&nbsp;
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:4e128d5e-7a08-4302-b1d6-614494e338d1" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/recruitment">recruitment</a>,<a rel="tag" href="http://technorati.com/tags/r%c3%a9sum%c3%a9">résumé</a>,<a rel="tag" href="http://technorati.com/tags/CV">CV</a>,<a rel="tag" href="http://technorati.com/tags/software%20development">software development</a>,<a rel="tag" href="http://technorati.com/tags/interview">interview</a>,<a rel="tag" href="http://technorati.com/tags/jobs">jobs</a></div>
