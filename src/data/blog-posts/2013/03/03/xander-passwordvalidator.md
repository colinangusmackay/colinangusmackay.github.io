---
title: "Xander.PasswordValidator"
slug: xander-passwordvalidator
publishDate: 03 Mar 2013
description: "I was looking for a way to validate passwords for an upcoming project because we need to do that better than we are, so I was looking for some .NET library to..."
tags:
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "GitHub", slug: github }
  - { name: "open source", slug: open-source }
  - { name: "Xander.PasswordValidator", slug: xander-passwordvalidator }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I was looking for a way to validate passwords for an upcoming project because we need to do that better than we are, so I was looking for some .NET library to do that. Unfortunately, Google only turned up a ton of regular expressions which is all fine an well, but it wasn’t really what I was looking for. I really wanted to be able to check against a dictionary of potential passwords and have it reject a password because it was in the list and it also had to check against the regular rules of “must has a number”, and so on.</p>  <p>So, I created <a href="https://github.com/colinangusmackay/Xander.PasswordValidator">Xander.PasswordValidator which is available on GitHub</a>.</p>  <p>The idea is that you can create a Validator object which can then be used to evaluate the suitability of potential passwords. When creating the validator you can pass in settings from code, or have it read settings from a config file. You can extend the functionality, so if there is something that you want to check that I’ve not thought about you have points where you can extend that. If the lists of forbidden passwords are not suitable then you can add your own lists, if the rules for checking against those lists are not suitable, then you can add your own ways to check.</p>  <p>Also, if you write web applications using ASP.NET MVC then there is a really simple attribute you can apply to a property in your model to have the validator check the value.</p>  <p>Over the next few days I’ll be writing more documentation for the project and showing what can be done with it in a series of blog posts. The <a title="Xander.PasswordValidator Wiki" href="https://github.com/colinangusmackay/Xander.PasswordValidator/wiki">“official” documentation</a> will be on the project’s wiki at GitHub. An initial version of the built code will also be available in the next few days. However, you can get the code from GitHub and build it yourself if you so desire.</p>
