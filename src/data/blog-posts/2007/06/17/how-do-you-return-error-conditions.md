---
title: "How do you return error conditions?"
slug: how-do-you-return-error-conditions
publishDate: 17 Jun 2007
description: "A recent poll on Code Project asked: How do you return error conditions? I was disappointed to find that in the event of a \"critical error that leaves the app..."
tags:
  - { name: "Error", slug: error }
  - { name: "software development practices", slug: software-development-practices }
---
<!-- TODO: convert this post's content to Markdown -->

<p>A recent poll on <a title="Code Project" target="_blank" href="http://www.codeproject.com/">Code Project</a> asked: <a href="http://www.codeproject.com/script/survey/detail.asp?survey=665">How do you return error conditions?</a></p>
<p>I was disappointed to find that in the event of a "critical error that leaves the app in an undefined state" a shocking 5% of people would "cover up the mess and don't say anything". I think I would be shocked at even just one person responding with that answer. What is it with these people anyway? Do I have to explain why that is really unwise?</p>
<p>A greater percentage of people chose that answer in the event of non-critical errors, too. While the errors aren't so bad, someone, somewhere will have to eventually clean up the mess.</p>
<p>It reminds me of a charting component that a company I used to work for bought. I evaluated various charting components and only one did absolutely every type of we wanted. However, in my report I did indicate that the component would not return any error status or throw an exeption when it failed so it was up to the developer who was using it to somehow work out if the component actually did what was asked of it. I just wonder how much more money was spent working around the problems the component created rather than benefit from it solving the existing problem.</p>
<p>Tags: <a rel="tag" href="http://technorati.com/tag/error"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=error">error</a> <a rel="tag" href="http://technorati.com/tag/+poll"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=+poll">poll</a> <a rel="tag" href="http://technorati.com/tag/+survey"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=+survey">survey</a> <a rel="tag" href="http://technorati.com/tag/+coverup"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=+coverup">coverup</a> <a rel="tag" href="http://technorati.com/tag/+software+development"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=+software+development">software development</a> <a rel="tag" href="http://technorati.com/tag/+practice"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=+practice">practice</a> </p>
<p>NOTE: This post was rescued from the Google Cache. The original date was Monday, 23rd April, 2007</p>

