---
title: "Rant: I'm so frustrated I can't even think of a title!!!"
slug: rant-im-so-frustrated-i-cant-even-think-of-a-title
publishDate: 22 Sep 2007
description: "My copy of IT Now, the magazine of the British Computer Society arrived earlier this week. I've only just got around to reading it. Their careers section got..."
tags:
  - { name: "hiring", slug: hiring }
---
<!-- TODO: convert this post's content to Markdown -->


		 
<p>My copy of IT Now, the magazine of the <a href="http://www.bcs.org/">British Computer Society</a> arrived earlier this week. I've only just got around to reading it. Their <a href="http://www.bcs.org/server.php?show=nav.5672">careers</a> section got me thinking. There is a link to <a href="http://www.jobstats.co.uk/">http://www.jobstats.co.uk</a> in there and I had a little look around. According to that site roughly 10% of all IT jobs are for C# while 7.5% are for VB (any flavour). Staggeringly 1% of jobs still require VB6! </p>
<p>For C# developers the UK average is £39K. On the face of it, you could say that it is lop sided because it includes the salaries in the south east of England. However, you also have to remember that the figures will include graduate salaries from across the rest of the UK also.</p>
<p>If you want to drill in to Scotland and Glasgow the rates naturally come down. £33K seems to be the average. After all the interviewing we've been doing recently I've come to the conclusion that average means the ability to push buttons on wizards and copy and paste code snippets and then spend hours wondering why it doesn't work. Average means not being able to read a simple 3 table ER diagram with some relationships. Average means not understanding a UML static class diagram with a base class and two derived classes on it.</p>
<p>In April this year, <a href="http://www.bcs.org/server.php?show=ConWebDoc.11215">an article was published on the BCS website</a> that stated that "Employers are finding it increasingly difficult to find job candidates with the right IT skills, putting the candidate in a strong position." We are finding exactly that. We are getting quite a few candidates that are just in to get a second offer to play two companies off each other. However, after two months, we've not found anyone suitable enough to put an offer out to. I can't help but think that there are some companies that are taking on board people that really don't have the necessary skills to do the job properly.</p>
<p>I am increasingly of the opinion that software developers need to be licensed, at least for certain pieces of development, due to the risk of fraud or damage if the system breaks.</p>
<p>Earlier this week I was going through some code as part of a migration. The code was written before my time and by an outsourcing company. This was before the company I work for decided it was getting such a raw deal that it wanted to in-source its software development. I was searching the code base for a reference to a stored procedure that failed to script properly... And I found it... In the presentation layer!</p>
<p>Not only that, but it was referenced on line numbers exceeding 1500! Hadn't these people heard of custom controls, user controls, 3-tier architecture, and the like.</p>
<p>What really got me was that the application was very much like another one that was being migrated. There were several places where some common functionality could have been extracted out, put in its own class then referenced from both projects. But where's the profit in that! No point doing anything sensible like that when you can charge twice to fix the same bug. </p>
<p>I wonder how much it cost to get these things developed. I wonder what the TCO (Total Cost of Ownership) actually is.</p>

	
