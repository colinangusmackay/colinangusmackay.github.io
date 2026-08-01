---
title: "eXtreme Programming in .NET"
slug: extreme-programming-in-net
publishDate: 23 Jun 2007
description: "This is a summary of a presentation by Dr. Neil Roodyn for the Scottish Developers that took place in Microsoft's offices in Edinburgh on the 21 st of July,..."
tags:
  - { name: "software development practices", slug: software-development-practices }
---
<!-- TODO: convert this post's content to Markdown -->

This is a summary of a presentation by <a href="http://www.roodyn.com/">Dr. Neil Roodyn</a> for the <a href="http://www.scottishdevelopers.com/modules/news/article.php?storyid=86">Scottish Developers</a> that took place in Microsoft's offices in Edinburgh on the 21<sup>st</sup> of July, 2005. At the end of the presentation I won a copy of Dr. Neil's book<a href="http://www.compman.co.uk/scripts/browse.asp?ref=704169"> <span id="stylebook">eXtreme .NET: Introducing eXtreme Programming Techniques to .NET Developers</span> </a> which I started reading on the train to and from work today and my initial impressions are very positive.
<h2>What is eXtreme Programming?</h2>
XP is a set of five values, although only the first four are well known.
<ul>
	<li>Communication</li>
	<li>Simplicity</li>
	<li>Feedback</li>
	<li>Courage</li>
	<li>Respect</li>
</ul>
<strong>Communication</strong> is very important, but it is often underrated. One of the important aspects is that everyone should be located together to improve communication flow. This is one of the reasons that Microsoft get all their developers together in Redmond.

<strong>Simplicity</strong>, or just keeping it simple, makes it easy to communicate and reduces the possibility of bugs. If the developers don't understand how the code works then how are they going to understand what is causing a bug and, importantly, how to fix it without creating new bugs in the process.

Rigorous <strong>Feedback</strong> loops improves the software. Customers always ask for change but if they don't see the software evolving the change request usually comes after much additional work has been done. This is prevalent in traditional software development. It is therefore important to show the customer the software frequently.

<strong>Courage</strong> is required as many of the XP practices seem hard and they don't naturally make much sense. For example, making changes when they are needed or throwing away code. However, the XP values as a whole are like a safety harness that ensure that the project can proceed quickly and safely. It is important to ensure that the other values are adhered to as without them it would be like jumping out an aeroplane without a parachute.

<strong>Respect</strong> everyone in the team so that everything runs smoothly. The team means the software developers, the project manager, the customer, and so on - basically everyone who has an interest in developing the software. If there is no respect then poor software development results as the developers will grumble about the customer being stupid, and the customer will grumble that the developers don't understand the business needs and so forth.  This lack of respect is also a symptom of a break down in communication.

Traditional engineering says that cost of change increases exponentially. This concept was stolen by software engineering but it is inappropriate. Consider, for example, the cost of having to move a concrete structure once it has set in comparison to creating the structure in the correct location in the first place versus the cost of moving a method in a piece of software. However, the traditional engineering approach has been pervasive in software development placing a burden on developers that simply does not exist if the XP values are taken on board.

Traditionally, software development has been "out of focus". When a problem comes along the first thing that is thought about is the technology that can be used to solve the problem, however technology is just made up of features and toys. Then the process, that is the methodologies and best practices, are considered. Finally, the people involved are considered. However, this is the wrong way around. First and foremost the people should be considered first, then the processes, and then the technology. If the people working on the project are happy then they write better code and they tend to meet business objectives more readily.
<h2>What is software?</h2>
Software is just code in an executable  form. Code is just a set of instructions that tell a dumb box of silicon what to do. Code is the core of software development. The end result does not exist without code. However, it is often overlooked. Most companies write reams of documentation before any code is ever written.

In order to produce a better product it must be easy to install. The easier it is to install then the the easier the customer can test the product themselves.

The software must have features the customer wants. Often people are focused on unimportant things without realising it. XP has the "planning game" to ensure that the customer can create a priority list. This priority list can be changed at any point by the customer.

The software must be of high quality, which means that it repeatedly works. Every bug is treated as a high priority task so that it must be fixed before a lower priority task.

If every bug is treated as a high priority task then the need for a bug database is removed as new features are not permitted to be added until the bug is fixed which means that at any one point the known bug count will always be close to zero. Pair programming and frequent code reviews help find bugs early so they can be fixed early.

The attitude of the developers is very much different if they are adding yet another bug to a database with 500 bugs in it than adding a bug to a database with close to zero bugs in it. An analogy in the non-software world is the broken window syndrome. If you see a house that is clean and all the windows intact you may think is it a well maintained house. If one of the windows gets smashed and is not repaired quickly then more windows get smashed and perhaps some graffiti is added and the house will look dilapidated and rundown very quickly.

Also, to be a better product the software must also be upgradeable. This ensures that new features can be added easily.
<h3>It isn't so hard to do!</h3>
If it isn't so hard to do then why, depending on the statistics you read, do somewhere between 60% - 85% of software projects fail.

The main reason is likely to be politics. People may be are not interested in the software. They may a vested interest in ensuring the software does not get written, for instance, they may lose their job once the software goes live. There may be a lack of respect (see above) between the software developers and the customer.

Some companies base their business model on making money from the RFCs. They charge a lot more for the changes than for the initial development. They deliberately produce poor poor requirements and specification documents to ensure a high number of RFCs down the line. It is often the budgeting system in place in the customer that drives this area of poor quality.

A lot of energy is wasted arguing over petty things such as what language to use, what technology, or that the team should use X set of complex design patterns. It should be emphasised that a team should not use a set of design patterns just because they are there. Patterns should be used as a vocabulary to show what has been done, rather than what should be done.

A software company may impose a set of practices. But having one set of practices imposed over a whole company is counterproductive. The practices used should be tailored for each project. The practices must be examined to determine whether they will add value to a project or hinder it.
<h3>Why do developers make software that is so complex?</h3>
There are three main reasons for this. (1) is to make themselves look smart; (2) is to justify their "high" salary; (3) is to cover their backsides, for example, if they can exclaim "It was a tough project, look at how hard it was" then it can be used as an excuse if things fail.
<h2>Software Development the XP way</h2>
First and foremost <strong>do the simplest thing that could possibly work</strong>. Be careful not to interpret simplest as easiest. Simple does not mean easy.

<strong>Eliminate (or reduce) comments</strong> in the code. Comments are a sign that the code is unreadable and that the block of code being commented should be refactored into a method of its own with an appropriately descriptive method name.

<strong>Remove duplicate code</strong>. There are many patterns that can be used to remove code duplication. Once the code is refactored then it will be easier to read and there will be a single point in the code to change if the functionality is to be changed.

<strong>Limit the number of classes</strong> to only those that are necessary to get the software to work. It is not necessary to create unnecessary classes for "future requirements" as these may change and it would be extra work to alter these classes to fit the direction in which the software is going. Also, if old classes are no longer required then they must be removed.

<strong>As quickly as possible get feedback</strong>; interpret it; act on it. Feedback can come from many areas, for example the tests, the customer (via story cards or their response to a new iteration) or daily stand-up meetings.

<strong>Assume simplicity</strong> on day by day basis. Each day create a task list with the average task being about 30 minutes; some may take 5 minutes some may take 2 hours. If a task looks like it will take more than 4 hours then it needs to be broken down into smaller tasks. That way most problems will be easy to solve. If 90+% of tasks are easy then less than 10% will require more effort, but the ability to get through so many tasks and cross them off the task list will improve moral and improve the quality of the code.

<strong>Make changes incrementally</strong> because big changes don't work as there is too much disruption caused and large changes are harder to understand.

Keep the <strong>quality of the work consistently high</strong> - the only two choices for quality level are "excellent" and "high"

Everyone should<strong> learn from everyone else</strong>. It is important to teach everyone to learn and think about how to teach others the information that you have. That way information flows around the team and enables everyone to contribute at a high standard all the time.

It is important to make sure that the software is in a state that is <strong>ready to ship on a regular basis</strong>.

Put in <strong>time for experimentation</strong> (called "spiking" in XP). Each spike should be limited to 4 hours. If it is longer than that then break down the initial task in to smaller tasks.

Everyone should be able to work in an environment where <strong>honesty and openness is encouraged.</strong> This aids communication and any problems can be avoided or fixed as quickly as possible.

Everyone should <strong>go with their instincts</strong>. They are there for a reason.

<strong>Everyone shares the responsibilities</strong>. For example, if a developer finds a bug they should fix it (or pair with the developer that created the code). They should not put it in a big database and wait for the other developer to come back from their holiday to fix it. Sharing responsibilities also means that everyone is "aligned" and going in the same direction.

Everyone needs to <strong>be adaptable</strong> because change is to be expected. Adaptability also means not carrying unnecessary baggage. For example, if the class is no longer needed then get rid of it, or if there is duplicate code then refactor out the duplication.

It is important to make <strong>realistic measurements</strong> of the time it will take to do something. Functionality is not complete until the customer is using it.
<h3>Back to basics</h3>
The basic stuff is:
<table id="table1" border="0" width="100%">
<tbody>
<tr>
<td width="10%">Coding</td>
<td style="border-left:3px dotted;" rowspan="4" width="90%">In this order</td>
</tr>
<tr>
<td width="103">Testing</td>
</tr>
<tr>
<td width="103">Listening</td>
</tr>
<tr>
<td width="103">Designing</td>
</tr>
</tbody>
</table>
Without code there is no program.

Without tests then nothing is known about the quality of the program

Without listening the developers won't know what the other developers are doing and won't understand the business problem that is to be solved.

Without designing there is no organisation and no plane. But, designing is last on the list - Why do everything up front when it is going to change. Design just has to be for enough flexibility but no more. Too much design makes things more rigid and inflexible.
<h3>Iteration Zero</h3>
The very first iteration before any code is written is to set up the build machine to create automated builds and an installer for the software.
<h3>The Planning Game</h3>
This takes place during a customer meeting. The customer is asked to come up with a set of user stories. The developers then break the story down in to tasks that they can work on.

User stories are at the level of things such as "the user can log on to the system" which is a basic step the user would have to take to accomplish a larger overall task.

When the user stories are written down the customer must then priorities them. Preferably this would be stacking the cards in order, but if they are unwilling to commit to that level of detail then having the customer create, say, three stacks for high priority (critical and must be done to succeed), medium priority (software should have these implemented) and low priority (it would be nice to have these implemented).
<h3>Test Driven Development</h3>
Although Test Driven Development (TDD) is used by many, including Dr. Neil Roodyn, to mean "test first" this isn't a universal accepted definition. Many people make a distinction between the two and use TDD to mean that there is testing involved and that development cannot proceed until the tests are written and pass.

Writing the tests up front means that the developer has to think about the interface more than the implementation. It ensures that the least possible solution is delivered. It means that the tests can be run the moment the code is written. It puts quality first. It helps the developer understand the problem better. And it gives the developer confidence that they are doing the right thing.
<h3>Refactoring</h3>
The purpose of refactoring is to allow the next piece of code to be written faster and provides a mindset of constant improvement. It ensures that code is reread and reviewed constantly which improves the quality. It makes life easier as refactored code is easier to read and understand. It also means that it is cheaper to add new features in the future as the code is clean and easy to understand.
<h3>Testing the GUI</h3>
It is possible to use reflection to drive the GUI in a test environment. There is also a very positive side effect that controls are named better from the start and that user feedback through the GUI is improved as the test framework needs to know what has happened.
<h3>Spiking the Unknown</h3>
When the developer finds an area that they don't understand they need to explore it, experiment with it and be able to explain it to someone else (which is part of learning - see above)
<h2>Why do customers back off from XP?</h2>
<strong>Do they want the project to fail?</strong>

In fact, people still give Object Orientation lip service just as eXtreme Programming is paid lip service now. The reason is that these people don't adhere to the values of the practice.

In some software development companies the business analysists  make great proxy customers. However, if the business analysists don't really understand the business, and therefore don't understand their job, then they get scared because they will be discovered as a fraud.

<em>NOTE: This was rescued from the <a title="Google" href="http://www.google.co.uk" target="_blank">Google</a> Cache. The original date was Friday, 22nd July, 2005.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/dr+neil+roodyn"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=dr+neil+roodyn" alt=" " />dr neil roodyn</a> <a rel="tag" href="http://technorati.com/tag/scottish+developers"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=scottish+developers" alt=" " />scottish developers</a> <a rel="tag" href="http://technorati.com/tag/extreme+programming"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=extreme+programming" alt=" " />extreme programming</a> <a rel="tag" href="http://technorati.com/tag/xp"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=xp" alt=" " />xp</a> <a rel="tag" href="http://technorati.com/tag/agile"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=agile" alt=" " />agile</a>

<hr />Original Comments:

This is why I think that while XP has some great ideas, they totally lose it on presentation. To quote from your blog (nice post, BTW, I'm not criticizing you at all):

Why do developers make software that is so complex?
There are three main reasons for this. (1) is to make themselves look smart; (2) is to justify their "high" salary; (3) is to cover their backsides, for example, if they can exclaim "It was a tough project, look at how hard it was" then it can be used as an excuse if things fail.

This is plain BS, IMO. Developers make software too complex because they're taught that OOD is the cat's meow, and programming "the Microsoft way" leads to a lot of awful design. It all comes down to education and experience, not puffing the feathers.

I wish XP would lose it's own "attitude" and simply discuss the merits of its practices, and also talk about when and why and how XP fails. No system is perfect, and XP would be stronger if it looked at its own imperfections.

My 2c. :)

Marc
<div class="postfoot">7/23/2005 12:37 AM | <a id="Comments_ascx_CommentList_ctl01_NameLink" title="PingBack/TrackBack" href="http://www.marcclifton.com/" target="_blank">Marc</a></div>
I accept your 2c and offer in return my tuppenny-worth.

I don't take what you said as any form of critisism of me as this blog entry is, as I said at the top, a summary of a presentation that I attended. That said, I am a big fan of agile software methods (not just XP).

The presentation that I attended did discuss the weaknesses. In fact some of it is above: "A software company may impose a set of practices. But having one set of practices imposed over a whole company is counterproductive. The practices used should be tailored for each project. The practices must be examined to determine whether they will add value to a project or hinder it."

So, if the practices of XP don't fit the organisation then simply don't use it.

As to other limitations - From what I've seen of XP, team member buy in is a big stumbling block. If they don't buy in to the ideas then they'll oppose it, even if they don't mean to and are trying to stay neutral. The presenter gave an example of one team where one person just wouldn't do pair programming - eventually he quit, even although the team were willing to accomodate him and permit him to code alone. However, if a more substantial number of team members don't buy into the idea then XP simply won't work.

Continuing with the example of pair programming. In the company that I work I have pair programmed on a small number of occasions. Each time the knowledge transfer was fantastic and we managed to get the work done in a fraction of the time. However, if I suggest it to most people they back off and say it isn't necessary or it is a waste of time. I recon that a piece of work that took me almost a month to complete as I was stumbling through other peoples code would have been completed in less than a week if they guy who wrote the code, or was involved with it when it was created - however he wasn't having any of it.

On to the "puffing the feathers". I have to say that it is a problem that I've seen. In my younger days I may even have been guilty of it myself.

What is "programming the Microsoft way"? I've briefly looked as MSF (Microsoft Solution Framework) and it seems a reasonable way of constructing software. It is obviously biased towards MS technologies, but many of the principles can be transferred to other technologies. If, however, you are talking about some of these awful examples that can be seen in MSDN magazine on how to use some funky control then I agree that is often bad, but that is on a different level as it deals with the implementation and not the way the team works.

You mentioned that "XP would be stronger if it looked at its own imperfections". I think that if you follow the values of XP then you are being critical of it all the time. The tight feedback loop provides a fast way of discovering what is wrong, not just of the software, but of the process and practices that are in place.
<div class="postfoot">7/23/2005 1:02 AM | <a id="Comments_ascx_CommentList_ctl02_NameLink" title="PingBack/TrackBack" href="http://blogs.wdevs.com/ColinAngusMackay/" target="_blank">Colin Angus Mackay</a></div>
I've often heard the problems of XP from the XP community, many of which are actually project problems rather than specific XP issues. To take a few....

1. Doesn't scale to large teams
However, the majority of really large projects are probably a series of smaller projects if someone took the time to look hard enough.
The ideal XP team size is 12 or less. Can you imagine a billion pound health system being done by a team of 12! Perhaps XP and small teams is actually the answer to government projects?

2. Designing and coding for today
Although this is a strength it is also a weakness. Sometime we can take the time to code for something we'll use tomorrow. This approach also means we can see significant refactoring effort as the project design evolves.

3. It requires good people
Any successful team requires a majority of good / experienced people to be part of the project. It doesn't matter whether they are an XP team or not, a bad / inexperienced team are in danger of failing.

4. Distributed Teams
It is certainly more difficult to run distributed XP teams than using one of the more traditional development methods.

5. Feedback
Get effective communication between the business oriented client and the techies in the development team can be difficult.

I could go on and on. The weaknesses are actually challenges and many are present in non-Agile projects as well.

I have heard from many hardened XPers how and when it has failed them. Usually they learn the lessons from this and hopefully don't repeat the same experience in future projects. All you need to do is ask the right questions of the XP community and they will tell you where it breaks or fails, sometimes suggestion alternatives or workarounds to mitigate the risks.

Remember, the original XP project was considered a failure!

Kent wouldn't have brought out a 2nd edition of the white book if he didn't want to modify and change some elements of XP to improve things and on occasions correct stuff that may be at risk of failing.

I think the previous commentator was referring to the flawed model of dropping components onto forms and running wizards, amongst other such intrinsically bad practices. This isn't just a flaw of Microsoft - just about all the major compiler / tool developers has this poor software engineering approach to development. Oh! I'm in agreement with you. I hate the idea of a component that knows how to display itself, can control what it does and can do things with the persistence layer! This really is dreadful software engineering IMHO!

I agree that this is a really good post. Glad you enjoyed the events so much. It was rather good as someone else who was there.

Regards

John
<div class="postfoot">7/24/2005 1:16 AM | <a id="Comments_ascx_CommentList_ctl03_NameLink" title="PingBack/TrackBack" href="http://blog.roundtripsolutions.com/" target="_blank">John A Thomson</a></div>
More information about this session can be found on Craig Murphy's blog: <a href="http://craigmurphy.com/blog/?p=111" target="_new">http://craigmurphy.com/blog/?p=111</a>
<div class="postfoot">8/2/2005 7:16 PM | <a id="Comments_ascx_CommentList_ctl04_NameLink" title="PingBack/TrackBack" href="http://blogs.wdevs.com/ColinAngusMackay/" target="_blank">Colin Angus Mackay</a></div>
I find this all very interesting.

I have been in the role of the client/business analyst on a complex software development project, using the XP programming philosophy for the last 8 months.

For people who own or manage a software development company here are a few observations about XP programming from "the other side":

For XP programming to work, the development company needs to:

-commit to hiring programmers for their attitude and communications skills. They need to be able to talk to the client.

-look for programmers that are interested in learning, not just about technology, but about their clients business models. Programmers that are truly interested ask more questions, and produce results that better reflect what the client wants.

-find out what would make the client want to spend more time at their company (their own workstation, extension etc.)

-encourage interaction between the client and the developers in a non-work environment (arrange team lunches for the clients and the developers, without upper management)

It really comes down to building trust. This trust goes a long way with the client when things get rough (and a story estimated as 2 points turns into 8 points ;-)

The programmers need to be gAs a client I believe I will get a better product from the developer who asks me 50 questions about my business, than from the developer who makes assumptions, even if the second developer is a more "skilled" programmer.

2. The development company should do what they can to encourage client, developer interaction. Here are a few things that have worked for our project:

- The development company that I work with has set up a fully equipped workstation for me in the project room. As a result I spend more time working there, where I am available to answer developers questions, than I do at my own company.

-The development team is given a budget for team lunches, and I am invited as a member of the team. These team lunches happen without upper management from the development company attending, which makes it a more relaxed environment.

-The development company arranges sporting events and invites the clients.
<div class="postfoot">8/17/2005 7:25 AM | <a id="Comments_ascx_CommentList_ctl05_NameLink" title="PingBack/TrackBack" target="_blank">Jen</a></div>
Thanks Jen, that sounds like some excellent advice.
<div class="postfoot">8/17/2005 10:19 AM | <a id="Comments_ascx_CommentList_ctl06_NameLink" title="PingBack/TrackBack" href="http://blogs.wdevs.com/colinangusmackay" target="_blank">Colin Angus Mackay</a></div>
