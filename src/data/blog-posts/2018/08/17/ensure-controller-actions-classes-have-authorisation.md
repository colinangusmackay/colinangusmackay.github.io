---
title: "Ensure Controller actions/classes have authorisation"
slug: ensure-controller-actions-classes-have-authorisation
publishDate: 17 Aug 2018
description: "A couple of years ago I wrote a unit test to ensure that all our controller actions (or Controller classes) had appropriate authorisation set up. This ensures..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "C#", slug: c }
  - { name: "nunit", slug: nunit }
  - { name: "Reflection", slug: reflection }
  - { name: "shouldy", slug: shouldy }
  - { name: "unit testing", slug: unit-testing }
---
<!-- TODO: convert this post's content to Markdown -->

A couple of years ago I wrote a unit test to ensure that all our controller actions (or <code>Controller</code> classes) had appropriate authorisation set up. This ensures we don't go to production with a new controller or action that falls back to the default authorisation. We must think about this and explicitly apply it.

I've not thought about that unit test much since then. But this week one of the developers on the team created some new controllers for some new functionality we have, and the unit test failed. Although he'd put an <code>[Authorize]</code> attribute on some of the controllers, he'd not done it for all. A common enough lapse. But thanks to this unit test, it was caught early.

Our build server reported it:

<pre>
The provided expression
    should be
0
    but was
1

Additional Info:
    You need to specify [AllowAnonymous] or [Authorize] or a derivative on the following actions, or the class that contains them.
 * MVC.Controllers.CommunicationsPortalController.Index


   at Shouldly.ShouldlyCoreExtensions.AssertAwesomely[T](T actual, Func`2 specifiedConstraint, Object originalActual, Object originalExpected, Func`1 customMessage, String shouldlyMethod)
   at Shouldly.ShouldBeTestExtensions.ShouldBe[T](T actual, T expected, Func`1 customMessage)
   at Shouldly.ShouldBeTestExtensions.ShouldBe[T](T actual, T expected, String customMessage)
   at MVC.UnitTests.Controllers.ControllerAccessTests.All_Controller_Actions_Have_Authorisation() in G:\TeamCityData\TeamCityBuildAgent-3\work\7cc517fed469d618\src\MyApplication\MVC.UnitTests\Controllers\ControllerAccessTests.cs:line 52
</pre>

The code for the unit test is in this GitHub Gist: https://gist.github.com/colinangusmackay/7c3d44775a61d98ee54fe179f3cd3f21

If you want to use this yourself, you'll have to edit line 24 (<code>Assembly mvcAssembly = typeof(HomeController).Assembly;</code>) and provide a controller class in your project. It has also been written for <a href="https://www.nuget.org/packages/NUnit/">NUnit</a>, and we're using <a href="https://www.nuget.org/packages/Shouldly/">Shouldly</a> as the assertion library.
