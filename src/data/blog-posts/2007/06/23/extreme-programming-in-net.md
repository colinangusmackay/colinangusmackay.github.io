---
title: "eXtreme Programming in .NET"
slug: extreme-programming-in-net
publishDate: 23 Jun 2007
description: "This is a summary of a presentation by Dr. Neil Roodyn for the Scottish Developers that took place in Microsoft's offices in Edinburgh on the 21 st of July,..."
tags:
  - { name: "software development practices", slug: software-development-practices }
---
<!-- ISSUE: link (http://www.scottishdevelopers.com/modules/news/article.php?storyid=86): status 404 -->
<!-- ISSUE: link (http://technorati.com/tag/dr+neil+roodyn): status 410 -->
<!-- ISSUE: link (http://technorati.com/tag/scottish+developers): status 410 -->
<!-- ISSUE: link (http://technorati.com/tag/extreme+programming): status 410 -->
<!-- ISSUE: link (http://technorati.com/tag/xp): status 410 -->
<!-- ISSUE: link (http://technorati.com/tag/agile): status 410 -->
<!-- ISSUE: link (http://blogs.wdevs.com/ColinAngusMackay/): nodename nor servname provided, or not known (blogs.wdevs.com:80) -->
<!-- ISSUE: link (http://craigmurphy.com/blog/?p=111): status 403 -->
<!-- ISSUE: link (http://blogs.wdevs.com/ColinAngusMackay/): nodename nor servname provided, or not known (blogs.wdevs.com:80) -->
<!-- ISSUE: link (http://blogs.wdevs.com/colinangusmackay): nodename nor servname provided, or not known (blogs.wdevs.com:80) -->
<!-- ISSUE: image #1 (http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=dr+neil+roodyn): download failed - nodename nor servname provided, or not known (static.technorati.com:80) -->
<!-- ISSUE: image #2 (http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=scottish+developers): download failed - nodename nor servname provided, or not known (static.technorati.com:80) -->
<!-- ISSUE: image #3 (http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=extreme+programming): download failed - nodename nor servname provided, or not known (static.technorati.com:80) -->
<!-- ISSUE: image #4 (http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=xp): download failed - nodename nor servname provided, or not known (static.technorati.com:80) -->
<!-- ISSUE: image #5 (http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=agile): download failed - nodename nor servname provided, or not known (static.technorati.com:80) -->

This is a summary of a presentation by [Dr. Neil Roodyn](http://www.roodyn.com/) for the [Scottish Developers](https://web.archive.org/web/20060116075148/http://www.scottishdevelopers.com/modules/news/article.php?storyid=86) that took place in Microsoft's offices in Edinburgh on the 21<sup>st</sup> of July, 2005. At the end of the presentation I won a copy of Dr. Neil's book [eXtreme .NET: Introducing eXtreme Programming Techniques to .NET Developers](https://amzn.eu/d/08PzhaeU) which I started reading on the train to and from work today and my initial impressions are very positive.

## What is eXtreme Programming?

XP is a set of five values, although only the first four are well known.

- Communication
- Simplicity
- Feedback
- Courage
- Respect

**Communication** is very important, but it is often underrated. One of the important aspects is that everyone should be located together to improve communication flow. This is one of the reasons that Microsoft get all their developers together in Redmond.

**Simplicity**, or just keeping it simple, makes it easy to communicate and reduces the possibility of bugs. If the developers don't understand how the code works then how are they going to understand what is causing a bug and, importantly, how to fix it without creating new bugs in the process.

Rigorous **Feedback** loops improves the software. Customers always ask for change but if they don't see the software evolving the change request usually comes after much additional work has been done. This is prevalent in traditional software development. It is therefore important to show the customer the software frequently.

**Courage** is required as many of the XP practices seem hard and they don't naturally make much sense. For example, making changes when they are needed or throwing away code. However, the XP values as a whole are like a safety harness that ensure that the project can proceed quickly and safely. It is important to ensure that the other values are adhered to as without them it would be like jumping out an aeroplane without a parachute.

**Respect** everyone in the team so that everything runs smoothly. The team means the software developers, the project manager, the customer, and so on - basically everyone who has an interest in developing the software. If there is no respect then poor software development results as the developers will grumble about the customer being stupid, and the customer will grumble that the developers don't understand the business needs and so forth.  This lack of respect is also a symptom of a break down in communication.

Traditional engineering says that cost of change increases exponentially. This concept was stolen by software engineering but it is inappropriate. Consider, for example, the cost of having to move a concrete structure once it has set in comparison to creating the structure in the correct location in the first place versus the cost of moving a method in a piece of software. However, the traditional engineering approach has been pervasive in software development placing a burden on developers that simply does not exist if the XP values are taken on board.

Traditionally, software development has been "out of focus". When a problem comes along the first thing that is thought about is the technology that can be used to solve the problem, however technology is just made up of features and toys. Then the process, that is the methodologies and best practices, are considered. Finally, the people involved are considered. However, this is the wrong way around. First and foremost the people should be considered first, then the processes, and then the technology. If the people working on the project are happy then they write better code and they tend to meet business objectives more readily.

## What is software?

Software is just code in an executable  form. Code is just a set of instructions that tell a dumb box of silicon what to do. Code is the core of software development. The end result does not exist without code. However, it is often overlooked. Most companies write reams of documentation before any code is ever written.
In order to produce a better product it must be easy to install. The easier it is to install then the the easier the customer can test the product themselves.
The software must have features the customer wants. Often people are focused on unimportant things without realising it. XP has the "planning game" to ensure that the customer can create a priority list. This priority list can be changed at any point by the customer.
The software must be of high quality, which means that it repeatedly works. Every bug is treated as a high priority task so that it must be fixed before a lower priority task.
If every bug is treated as a high priority task then the need for a bug database is removed as new features are not permitted to be added until the bug is fixed which means that at any one point the known bug count will always be close to zero. Pair programming and frequent code reviews help find bugs early so they can be fixed early.
The attitude of the developers is very much different if they are adding yet another bug to a database with 500 bugs in it than adding a bug to a database with close to zero bugs in it. An analogy in the non-software world is the broken window syndrome. If you see a house that is clean and all the windows intact you may think is it a well maintained house. If one of the windows gets smashed and is not repaired quickly then more windows get smashed and perhaps some graffiti is added and the house will look dilapidated and rundown very quickly.
Also, to be a better product the software must also be upgradeable. This ensures that new features can be added easily.

### It isn't so hard to do!

If it isn't so hard to do then why, depending on the statistics you read, do somewhere between 60% - 85% of software projects fail.

The main reason is likely to be politics. People may be are not interested in the software. They may a vested interest in ensuring the software does not get written, for instance, they may lose their job once the software goes live. There may be a lack of respect (see above) between the software developers and the customer.

Some companies base their business model on making money from the RFCs. They charge a lot more for the changes than for the initial development. They deliberately produce poor poor requirements and specification documents to ensure a high number of RFCs down the line. It is often the budgeting system in place in the customer that drives this area of poor quality.

A lot of energy is wasted arguing over petty things such as what language to use, what technology, or that the team should use X set of complex design patterns. It should be emphasised that a team should not use a set of design patterns just because they are there. Patterns should be used as a vocabulary to show what has been done, rather than what should be done.

A software company may impose a set of practices. But having one set of practices imposed over a whole company is counterproductive. The practices used should be tailored for each project. The practices must be examined to determine whether they will add value to a project or hinder it.

### Why do developers make software that is so complex?

There are three main reasons for this. (1) is to make themselves look smart; (2) is to justify their "high" salary; (3) is to cover their backsides, for example, if they can exclaim "It was a tough project, look at how hard it was" then it can be used as an excuse if things fail.

## Software Development the XP way

First and foremost **do the simplest thing that could possibly work**. Be careful not to interpret simplest as easiest. Simple does not mean easy.

**Eliminate (or reduce) comments** in the code. Comments are a sign that the code is unreadable and that the block of code being commented should be refactored into a method of its own with an appropriately descriptive method name.

**Remove duplicate code**. There are many patterns that can be used to remove code duplication. Once the code is refactored then it will be easier to read and there will be a single point in the code to change if the functionality is to be changed.

**Limit the number of classes** to only those that are necessary to get the software to work. It is not necessary to create unnecessary classes for "future requirements" as these may change and it would be extra work to alter these classes to fit the direction in which the software is going. Also, if old classes are no longer required then they must be removed.

**As quickly as possible get feedback**; interpret it; act on it. Feedback can come from many areas, for example the tests, the customer (via story cards or their response to a new iteration) or daily stand-up meetings.

**Assume simplicity** on day by day basis. Each day create a task list with the average task being about 30 minutes; some may take 5 minutes some may take 2 hours. If a task looks like it will take more than 4 hours then it needs to be broken down into smaller tasks. That way most problems will be easy to solve. If 90+% of tasks are easy then less than 10% will require more effort, but the ability to get through so many tasks and cross them off the task list will improve moral and improve the quality of the code.

**Make changes incrementally** because big changes don't work as there is too much disruption caused and large changes are harder to understand.

Keep the **quality of the work consistently high** - the only two choices for quality level are "excellent" and "high"

Everyone should **learn from everyone else**. It is important to teach everyone to learn and think about how to teach others the information that you have. That way information flows around the team and enables everyone to contribute at a high standard all the time.

It is important to make sure that the software is in a state that is **ready to ship on a regular basis**.

Put in **time for experimentation** (called "spiking" in XP). Each spike should be limited to 4 hours. If it is longer than that then break down the initial task in to smaller tasks.

Everyone should be able to work in an environment where **honesty and openness is encouraged.** This aids communication and any problems can be avoided or fixed as quickly as possible.

Everyone should **go with their instincts**. They are there for a reason.

**Everyone shares the responsibilities**. For example, if a developer finds a bug they should fix it (or pair with the developer that created the code). They should not put it in a big database and wait for the other developer to come back from their holiday to fix it. Sharing responsibilities also means that everyone is "aligned" and going in the same direction.

Everyone needs to **be adaptable** because change is to be expected. Adaptability also means not carrying unnecessary baggage. For example, if the class is no longer needed then get rid of it, or if there is duplicate code then refactor out the duplication.

It is important to make **realistic measurements** of the time it will take to do something. Functionality is not complete until the customer is using it.

### Back to basics

The basic stuff is:

<table id="table1" data-border="0" width="100%">
<tbody>
<tr>
<td width="10%">Coding</td>
<td rowspan="4" style="border-left: 3px dotted" width="90%">In this order</td>
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

* Without code there is no program.
* Without tests then nothing is known about the quality of the program
* Without listening the developers won't know what the other developers are doing and won't understand the business problem that is to be solved.
* Without designing there is no organisation and no plane. But, designing is last on the list - Why do everything up front when it is going to change. Design just has to be for enough flexibility but no more. Too much design makes things more rigid and inflexible.

### Iteration Zero

The very first iteration before any code is written is to set up the build machine to create automated builds and an installer for the software.

### The Planning Game

This takes place during a customer meeting. The customer is asked to come up with a set of user stories. The developers then break the story down in to tasks that they can work on.

User stories are at the level of things such as "the user can log on to the system" which is a basic step the user would have to take to accomplish a larger overall task.

When the user stories are written down the customer must then priorities them. Preferably this would be stacking the cards in order, but if they are unwilling to commit to that level of detail then having the customer create, say, three stacks for high priority (critical and must be done to succeed), medium priority (software should have these implemented) and low priority (it would be nice to have these implemented).

### Test Driven Development

Although Test Driven Development (TDD) is used by many, including Dr. Neil Roodyn, to mean "test first" this isn't a universal accepted definition. Many people make a distinction between the two and use TDD to mean that there is testing involved and that development cannot proceed until the tests are written and pass.

Writing the tests up front means that the developer has to think about the interface more than the implementation. It ensures that the least possible solution is delivered. It means that the tests can be run the moment the code is written. It puts quality first. It helps the developer understand the problem better. And it gives the developer confidence that they are doing the right thing.

### Refactoring

The purpose of refactoring is to allow the next piece of code to be written faster and provides a mindset of constant improvement. It ensures that code is reread and reviewed constantly which improves the quality. It makes life easier as refactored code is easier to read and understand. It also means that it is cheaper to add new features in the future as the code is clean and easy to understand.

### Testing the GUI

It is possible to use reflection to drive the GUI in a test environment. There is also a very positive side effect that controls are named better from the start and that user feedback through the GUI is improved as the test framework needs to know what has happened.

### Spiking the Unknown

When the developer finds an area that they don't understand they need to explore it, experiment with it and be able to explain it to someone else (which is part of learning - see above)

## Why do customers back off from XP?

**Do they want the project to fail?**

In fact, people still give Object Orientation lip service just as eXtreme Programming is paid lip service now. The reason is that these people don't adhere to the values of the practice.

In some software development companies the business analysists  make great proxy customers. However, if the business analysists don't really understand the business, and therefore don't understand their job, then they get scared because they will be discovered as a fraud.

*NOTE: This was rescued from the Google Cache. The original date was Friday, 22nd July, 2005.*


