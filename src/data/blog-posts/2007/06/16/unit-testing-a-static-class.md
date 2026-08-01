---
title: "Unit Testing a Static Class"
slug: unit-testing-a-static-class
publishDate: 16 Jun 2007
description: "I've been trying to find a way to unit test a static class. That is, a class that has no instances. The problem has been that at the end of one test the..."
tags:
  - { name: "static class", slug: static-class }
  - { name: "unit testing", slug: unit-testing }
---
<!-- TODO: convert this post's content to Markdown -->

I've been trying to find a way to unit test a static class. That is, a class that has no instances. The problem has been that at the end of one test the class's state could be altered which would mean that at the start of the next test its state would be unknown. This could lead to buggy unit tests.

The solution, I've found, is to invoke the type initialiser (sometimes known as the "class initialiser", "static initialiser", "static constructor" or "class constructor") using reflection and ensure that all fields are set up there. That way, each unit test run will be starting the static class with a clean state and it no longer matters what the unit test does.

The code to invoke the type initialiser:
<pre>Type staticType = typeof(StaticClassName);
ConstructorInfo ci = staticType.TypeInitializer;
object[] parameters = new object[0];
ci.Invoke(null, parameters);</pre>
Tags: <a rel="tag" href="http://technorati.com/tag/visual+studio"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=visual+studio" alt=" " />visual studio</a> <a rel="tag" href="http://technorati.com/tag/class+initialiser"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=class+initialiser" alt=" " />class initialiser</a> <a rel="tag" href="http://technorati.com/tag/class+initializer"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=class+initializer" alt=" " />class initializer</a> <a rel="tag" href="http://technorati.com/tag/static+constructor"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=static+constructor" alt=" " />static constructor</a> <a rel="tag" href="http://technorati.com/tag/class+constructor"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=class+constructor" alt=" " />class constructor</a> <a rel="tag" href="http://technorati.com/tag/type+initialiser"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=type+initialiser" alt=" " />type initialiser</a> <a rel="tag" href="http://technorati.com/tag/type+initializer"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=type+initializer" alt=" " />type initializer</a> <a rel="tag" href="http://technorati.com/tag/reflection"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=reflection" alt=" " />reflection</a> <a rel="tag" href="http://technorati.com/tag/c%23"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=c%23" alt=" " />c#</a> <a rel="tag" href="http://technorati.com/tag/.NET"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=.NET" alt=" " />.NET</a> <a rel="tag" href="http://technorati.com/tag/unit+test"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=unit+test" alt=" " />unit test</a> <a rel="tag" href="http://technorati.com/tag/static+class"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=static+class" alt=" " />static class</a>

<em>NOTE: This blog entry was rescued from the Google Cache. It was originally dated Monday 7th May, 2007.</em>

<hr />There was one comment of note:

If you have a static class with state, then you have a singleton - generally to be avoided, but sometimes unavoidable. One way to think of singletons is as services - they provide a service to your app. Services usually interact with the outside world in some way, so for testing purposes it is useful to be able to switch between a real implementation and a Mock one.

So the trick that I use is to create a singleton service locator class, with a manual switch for changing from Test mode to Normal mode. Fowler calls this the Registry pattern in PoEAA.
<div class="postfoot">5/8/2007 6:38 PM | <a id="Comments_ascx_CommentList_ctl00_NameLink" title="http://dukeytoo.blogspot.com/" href="http://dukeytoo.blogspot.com/" target="_blank">Steve Campbell</a></div>
