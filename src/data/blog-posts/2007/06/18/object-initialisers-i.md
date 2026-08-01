---
title: "Object Initialisers I"
slug: object-initialisers-i
publishDate: 18 Jun 2007
description: "Continuing with the language enhancements in C#3.0. This post presents the concept of object initailisation. Say you have a class with a default constructor..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
---
<!-- TODO: convert this post's content to Markdown -->

Continuing with the language enhancements in C#3.0. This post presents the concept of object initailisation.

<span lang="en-gb">Say you have a class with a default constructor and lots of properties and you want to be able in initialise the object in one line but the class doesn’t support it. What you can do is use object initailisers: </span>

<span lang="en-gb">So, a series of calls like this in C#2.0: </span>
<pre>Policy p = new InsurancePolicy();
p.Id = 123;
p.GrossPremium = 100;
p.IptAmount = 10;</pre>
<span lang="en-gb">Could now be written as this in C#3.0: </span>
<pre>InsurancePolicy p = new InsurancePolicy {Id = 123, GrossPremium = 100, IptAmount = 10};</pre>
<span lang="en-gb">You’ve probably seen something similar already with respect to declaring attributes on an assembly, class or method. </span>

<span lang="en-gb">Again, like the other language features in C#3.0, this is just syntactic sugar. The compiler will output the calls in a similar way to the first (C# 2.0) example. </span>

<span lang="en-gb">At the moment I can’t see this feature being useful for classes that I build myself as I have control over the class's constructors and if needed then I can accommodate the parameters as appropriate. Also, the idea of having a single line of code with so many object initialisers in it would seem to me to be a potential source of some really ugly code.</span>

<span lang="en-gb">That isn’t to say this isn’t useful for my own classes – it could be used as a way of reducing the need to provide many overloaded versions of the constructor. It would no longer be necessary to anticipate every permutation and combination of properties that are needed to initialise the object past a basic valid state. It could save quite a bit of time. However, caution would need to be exercised. Any constructor created would still need to ensure that the object was created into a valid state. Using object initialisers to initialise the object completely from scratch may not be appropriate.</span>

Object initialisers are a tool. So long as the developer remembers to use the right tool for the right job then this new language feature can be used very effectively.

<span lang="en-gb">What object initialisers would be most useful for, as far as I can see, would be for existing classes where I don’t have control over their makeup. e.g. Framework classes, or classes from a third party.</span>

<a rel="tag" href="http://technorati.com/tag/c%23"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23" alt=" " />c#</a> <a rel="tag" href="http://technorati.com/tag/c%23+3.0"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23+3.0" alt=" " />c# 3.0</a> <a rel="tag" href="http://technorati.com/tag/.NET+3.5"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=.NET+3.5" alt=" " />.NET 3.5</a> <a rel="tag" href="http://technorati.com/tag/Orcas"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=Orcas" alt=" " />Orcas</a> <a rel="tag" href="http://technorati.com/tag/visual+studio"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio" alt=" " />visual studio</a> <a rel="tag" href="http://technorati.com/tag/object+initialiser"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=object+initialiser" alt=" " />object initialiser</a> <a rel="tag" href="http://technorati.com/tag/object+initializer"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=object+initializer" alt=" " />object initializer</a> <a rel="tag" href="http://technorati.com/tag/language+enhancements"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=language+enhancements" alt=" " />language enhancements</a>

<em>NOTE: This post was rescued from the Google Cache. The original date was Saturday 10th March, 2007.</em>

<hr />Original comments:

My first thought when seeing this code was, how will this work with Intelisense?
<div class="postfoot">3/10/2007 6:54 PM | <a id="Comments_ascx_CommentList_ctl00_NameLink" title="http://www.garyshort.org/" href="http://www.garyshort.org/" target="_blank">Gary Short</a></div>
The demonstration that I saw at the MSDN roadshow in Glasgow earlier this week shows that it works.

I would guess that because it knows what object you are instantiating as it comes directly after the new keyword it will be able to determine what public properties with setters are available.
<div class="postfoot">3/10/2007 7:05 PM | <a id="Comments_ascx_CommentList_ctl01_NameLink" class="author" title="http://www.colinmackay.net/" href="http://www.colinmackay.net/" target="_blank">Colin Angus Mackay</a></div>
Cool, thanks for the info Colin!
<div class="postfoot">3/10/2007 7:09 PM | <a id="Comments_ascx_CommentList_ctl02_NameLink" title="http://www.garyshort.org/" href="http://www.garyshort.org/" target="_blank">Gary Short</a></div>
Yep - with the March CTP intellisense for object initialization works great.

Hope this helps,

Scott
<div class="postfoot">3/10/2007 11:33 PM | <a id="Comments_ascx_CommentList_ctl03_NameLink" title="http://weblogs.asp.net/scottgu" href="http://weblogs.asp.net/scottgu" target="_blank">scottgu</a></div>
