---
title: "Then and Now"
slug: then-and-now
publishDate: 03 Sep 2007
description: "Recently a post was put up on Code Project that was basically a direct copy of a homework assignment. I don't answer questions for people's homework. I have..."
tags:
  - { name: "learning", slug: learning }
---
<!-- TODO: convert this post's content to Markdown -->


		 
<p>Recently a post was put up on Code Project that was basically a direct copy of a homework assignment. I don't answer questions for people's homework. I have enough trouble trying to hire a good developer as it is without contributing to another generation of useless code monkeys. </p>
<p>Anyway, the question was in two parts. The first part, in summary, was to write some code that calculates powers. e.g. 2<sup>3</sup>=8; 7<sup>4</sup>=2401; etc. by just using simple multiplication. The second part was to solve the same problem but without using a multiplication operator.</p>
<p>This has got me thinking for most of the afternoon, even after watching an episode of Judge John Deed (I'm on holiday). What I was thinking about was the different ways in which I'd tackle the problem. They way I would have tackled the problem when I was a student, and the way I'd do it now.</p>
<p>Then (15 years ago as a student) I'd have created a console application, read in a couple of integers from the keyboard and performed the calculation all in one horrible Main function. Then I would have thrown a few random integers at the command line to satisfy myself that it would work. If it didn't I'd hack away at it until it did. There wouldn't be any consistency in the testing as I'd be throwing different integers at it.</p>
<p>Now, because I was curious what the answer was, I did the following: I created a test assembly and wrote some unit tests so that each time I ran the tests it would be the same tests. Then I created a method that performed the calculation. It took two integers, x and y, and calculates x<sup>y</sup> using the multiplication technique. Then I ran my tests to see if it worked. Once that was working, I re-wrote the method to use the addition only technique. Then I ran the tests again to ensure that I still got the same results.</p>
<p>Tags: <a rel="tag" href="http://technorati.com/tag/software+development"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=software+development">software development</a> <a rel="tag" href="http://technorati.com/tag/unit+testing"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=unit+testing">unit testing</a> <a rel="tag" href="http://technorati.com/tag/problem+solving"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=problem+solving">problem solving</a> <a rel="tag" href="http://technorati.com/tag/puzzle"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=puzzle">puzzle</a> <a rel="tag" href="http://technorati.com/tag/homework"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=homework">homework</a> <a rel="tag" href="http://technorati.com/tag/assignment"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" alt=" " src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=assignment">assignment</a> </p>

	
