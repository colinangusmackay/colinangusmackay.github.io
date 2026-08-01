---
title: "Open Source Risk Management"
slug: open-source-risk-management
publishDate: 30 Jun 2009
description: "There are some pretty cool things happening in the open source space on the .NET platform these days and new projects are being started every day. However how..."
tags:
  - { name: "open source", slug: open-source }
  - { name: "risk management", slug: risk-management }
  - { name: "software development practices", slug: software-development-practices }
---
<!-- TODO: convert this post's content to Markdown -->

<a href="http://www.opensource.org" target="_blank"><img style="margin:5px 10px 5px 15px;display:inline;border-width:0;" title="Open Source Initiative Logo" src="http://blog.colinmackay.net/images/blog_colinmackay_net/WindowsLiveWriter/OpenSourceRiskManagement_630/OSI-logo-100x117_3.png" border="0" alt="Open Source Initiative Logo" width="120" height="137" align="right" /></a> There are some pretty cool things happening in the open source space on the .NET platform these days and new projects are being started every day. However how do you sort the wheat from the chaff? How do you manage risk when using open source?

In this post I hope to address this issue as it relates specifically to open source frameworks that target .NET. Although I am sure the ideas are probably equally applicable to other forms of open source, I don’t have much experience outside of this field so I can’t really comment.

I have a some fairly simple rules when it comes to open source frameworks and perhaps they show me as being somewhat conservative but it works for me. I see that as trying to manage risks as effectively as I can. These rules are:
<ul>
	<li>It must have a “buzz” surrounding it.</li>
	<li>It must have reached at least version 1</li>
	<li>It must have at the very least prebuilt libraries/assemblies/executables (as needed)</li>
</ul>
<h2>The “Buzz”</h2>
The first rule is that there must be a “buzz” surrounding it. By “buzz” what I really mean is that there is a viable community of people who are using the open source software so that if I need support there will be forums or discussion groups that I can join and ask my questions. This community will also have produced good quality documentation, tutorials, articles, blog posts, and so on.

When I start using a some open source framework I want to be able to ramp up quickly and get using it. I want to see that there is MSDN style documentation for when I need to dig into individual methods, properties and the like. I want to see that there are walk-throughs and tutorials so I can see immediately how everything fits together. If there are videos available they need to be good quality because it is really off putting to try and read source code on a video that’s been over-compressed. Podcasts discussing the high level stuff can be useful, but it has to be of the type that I can easily listen to in the car or while walking down the street because I will rarely listen to a podcast while sat at my PC.

A good open source project will also have fairly active support forums with questions being answered from those that understand the technology. It is interesting that lack of “support” is what many people claim as being one of the big risks with open source. However, how many times have you called Microsoft for support? (assuming you are developing on the Microsoft platform) In the last 14 years I’ve phoned them exactly once. Meanwhile, I’ve used newsgroups and support forums more times than I care to remember. The response from forums is usually quite good and well within the length of time I would generally wish.

However, not everything is rosy with forums, open source or otherwise. A couple of years ago I saw a forum dealing with an open source project where the main (possibly only) developer was an arrogant arse in response to any request for help. His standard response was “read the code”. That was it, end of discussion. There didn’t seem to be that many other people using his library so perhaps he put many people off. If this were a commercial operation, that person would have been removed as a support engineer for fear of losing sales. Then again, how many times do you hear of companies with poor after-sales support.

Incidentally, I’ve heard the response “just read the code” or “read the unit tests” from a number of open source advocates. That is one way to turn me away from the project. I really don’t have time to read the code when I’m evaluating a number of frameworks that do similar things. I want to see if the framework will do the job I want it to do. If it doesn’t do what I want it to do I want a quick easy way to short circuit the evaluation.

Don’t get me wrong here. I am not saying I never read the code. It can be extremely useful to read the code when tracking down a bug somewhere and you need to see what the framework is actually doing. What I’m saying is that it should not be the only source of documentation. I will often get around to reading some of the code before fully committing to the open source framework.
<h2>Release Version</h2>
The second rule is that it must have reached at least version 1. I’m not interested in using betas, CTPs or nightly builds. There are very few things I will use prior to a release. (Curiously as I type this, I’m doing so on a pre-release version of Windows 7. The other thing I’ll use in a pre-release form is Visual Studio – both major products in an already fairly mature state. I’ve been using Windows since 1992 and Visual Studio since 1995.)

What a version number gives above all else is a point where the developers stick their flag in the ground that people can rally around. Without that I could end up having to use various nightly builds. While the nightly builds are great for the testers and developers on a software system, I don’t think they are good for those building upon the system.

For example, if I have an issue and I go to a forum dealing with the framework I can very easily say I’m using, say, Version 2.1 and know that there will be a good number of people also using that version. If however I go along and say I’m using nightly build 518 then I might find that there are very few other people using that specific nightly build and that any potential solutions to my problem by people using other nightly builds may not be able to take into account some weird quirk that only happened in that specific nightly build.

The “standard” response would likely be to download the latest nightly build and use that. However, I see that as adding extra risk into my project. Apart from anything else I would now have to retest all the places where that new nightly build is being used. Sure, unit tests can help at this stage, but integration tests still need to be run, end-to-end testing, user testing and so on.

One of the advantages of open source is its speedy resolution and it may sound that my strategy here is negating that effort. I don’t believe that is so.

When a project has milestones and release goals the development gets to a point where all the features are there and the public interface has solidified although there may still be some bugs. At this point betas are released and a wider audience can evaluate the framework, report bugs, and generally give it a much more thorough testing that the core development team could do. By the time the framework is RTM’ed (although RTW maybe more appropriate in this internet age) the major bugs will have been worked out.

Once a release has been made even more people will start using it, so some of the more esoteric bugs will be found and a service release will likely become available shortly afterwards that rolls up a number of bug fixes. This is still a lot faster than most commercial offerings.
<h2>Pre-built Assemblies</h2>
The third rule is that the assemblies must already be built in advance. I don’t want the hassle of building these myself. The process is too prone to error in my opinion.

If I build the assemblies then there are risks based on the way my machine may be set up. I’ve seen systems where the build process is quite flake to begin with and I simply don’t want to add to that. I also don’t want to waste lots of time  having to faff about with a build process trying to get it to work as it can easily eat up a lot of time.

Incidentally, I may concede this point once <a href="http://code.google.com/p/scotaltdotnet" target="_blank">The Horn Package Management Project</a> reaches some level of maturity. However, it looks like it may be more useful for those developing complimentary open source projects to keep up with each other rather than someone like me.
<h2>Where’s the risk?</h2>
As I said at the start, I’m probably fairly conservative when it comes to using open source. I want to see that others are getting benefits and that the major bugs have been ironed out. Yet, I have no real concerns about using open source projects that are clearly maturing or are mature. In that scenario the risk is fairly minimal, and probably a lot less than using an equivalent commercial offering – After all, you still have the source code if the project stops, what do you have if the company fails?

&nbsp;

&nbsp;

CC-Attribution:
<ul>
	<li><a href="http://www.opensource.org/node/442" target="_blank">OSI Logo</a> by Ken Coar (June 10th, 2009)</li>
</ul>
