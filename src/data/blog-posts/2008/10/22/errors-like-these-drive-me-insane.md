---
title: "Errors like these drive me insane"
slug: errors-like-these-drive-me-insane
publishDate: 22 Oct 2008
description: "Today I was trying to fix up a website for one of our clients. I got the site out of source control but somehow or other it wouldn't compile. I'm not going to..."
tags:
  - { name: ".NET", slug: net }
  - { name: "asp.net", slug: asp-net }
  - { name: "C#", slug: c }
  - { name: "Debugging", slug: debugging }
---
<!-- TODO: convert this post's content to Markdown -->

Today I was trying to fix up a website for one of our clients. I got the site out of source control but somehow or other it wouldn't compile. I'm not going to talk about the fact it didn't compile out of the box - We all know that is not a good situation and the person who allows source to get into a state like that needs to be slapped repeatedly with a wet fish.

What I'm going to talk about is what the eventual error turned out to be because it is not something I've ever seen before and it was such a bizarre thing that I can only hope it isn't common. But if you are afflicted by it you will be pleased to know that the solution is easy, even if the discovery of what the problem actually was wasted several hours.

If you are reading this then I suspect you will probably be suffering from this problem in which case you are probably now yelling "STOP BABBLING MAN AND TELL ME WHAT TO DO".

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/2964494165"><img style="margin:0 10px 0 15px;" src="http://farm4.static.flickr.com/3192/2964494165_13d6818fd0.jpg" alt="" width="263" height="222" align="right" /></a>First, a description of the problem:

There is an ASP.NET web site project (probably does the same thing on a web application... And let's not get in to why this is a web site project, it's an old project and the standard now is web applications) with a number of web forms in it.

The ASPX for the default page currently looks something like this:
<pre class="code"><span style="background:#ffee62;">&lt;%</span><span style="color:blue;">@ </span><span style="color:#a31515;">Page </span><span style="color:red;">Language</span><span style="color:blue;">="C#" </span><span style="color:red;">AutoEventWireup</span><span style="color:blue;">="true"
      </span><span style="color:red;">CodeFile</span><span style="color:blue;">="Default.aspx.cs" </span><span style="color:red;">Inherits</span><span style="color:blue;">="Default" </span><span style="background:#ffee62;">%&gt;
</span><span style="color:blue;">&lt;</span><span style="color:#a31515;">html</span><span style="color:blue;">&gt;
&lt;</span><span style="color:#a31515;">head</span><span style="color:blue;">&gt;&lt;</span><span style="color:#a31515;">title</span><span style="color:blue;">&gt;&lt;/</span><span style="color:#a31515;">title</span><span style="color:blue;">&gt;&lt;/</span><span style="color:#a31515;">head</span><span style="color:blue;">&gt;
&lt;</span><span style="color:#a31515;">body</span><span style="color:blue;">&gt;
    &lt;</span><span style="color:#a31515;">form </span><span style="color:red;">id</span><span style="color:blue;">="form1" </span><span style="color:red;">runat</span><span style="color:blue;">="server"&gt;
        </span>Stuff that's on my page
        <span style="color:blue;">&lt;</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">Label </span><span style="color:red;">ID</span><span style="color:blue;">="MyLabel" </span><span style="color:red;">runat</span><span style="color:blue;">="server"&gt;&lt;/</span><span style="color:#a31515;">asp</span><span style="color:blue;">:</span><span style="color:#a31515;">Label</span><span style="color:blue;">&gt;
    &lt;/</span><span style="color:#a31515;">form</span><span style="color:blue;">&gt;
&lt;/</span><span style="color:#a31515;">body</span><span style="color:blue;">&gt;
&lt;/</span><span style="color:#a31515;">html</span><span style="color:blue;">&gt;
</span></pre>
<a href="http://11011.net/software/vspaste"></a>

Nothing too odd about that, you might say... And you'd be right. There is nothing at all wrong with this page. However, when you go to compile your website you get this error:

<a title="Infuriation 2 by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/2964511913/"><img src="http://farm4.static.flickr.com/3182/2964511913_003cd4b59c_o.png" alt="Infuriation 2" width="727" height="170" /></a>
The name 'MyLabel' does not exist in the current context

But... but... but... You can see that MyLabel exists on the ASPX page and if you type in the C# or VB source file you'll see that intellisense finds the object perfectly well. So what is going on?

Well, it is interesting to note that Page1 and Page2 are very similar to Default. In fact, so similar that when they were created the person that did this just copied Default.aspx and Default.aspx.cs (or Default.aspx.vb if that's your poison). What they didn't do when they made the copies was to change the page directive at the top that has the Inherits attribute that points to Default. So, Page1 and Page2 are inheriting the behaviour in Default.

When this first happened that wasn't a problem. Page1 and Page2 had just minor cosmetic differences, the behaviour was the same and no one noticed.

At some point later someone came along and added MyLabel to Default.aspx... This still didn't make a difference. Everything worked as normal.

Then someone came along and realised that MyLabel needed to change on some condition and added some code into the Default.aspx.cs file that modified MyLabel. At this point all hell broke loose!

Suddenly, MyLabel can't be found and no one can figure out why. It is there on the ASPX page, intellisense picks it up, the stupid compiler can't see it.

<strong>The Solution</strong>

Eventually, after spending a couple of hours on the problem and batting it around some collegues and doing bit of brainstorming someone (let's call him Craig Muirhead because he figured it out in the end and deserves the credit) comes up with the idea that perhaps other pages are inheriting the wrong class. A quick find in files on the name of the class and we found it was referenced by 4 other pages. It takes a matter of moments to fix all those files to point to their respective code behind files/classes rather than the one on our hapless page. And all of a sudden everything compiles.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:dc6216ef-732c-4045-a558-ba97b722cbd4" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/c#">c#</a>,<a rel="tag" href="http://technorati.com/tags/vb">vb</a>,<a rel="tag" href="http://technorati.com/tags/.net">.net</a>,<a rel="tag" href="http://technorati.com/tags/asp.net">asp.net</a>,<a rel="tag" href="http://technorati.com/tags/compiler%20error">compiler error</a></div>
