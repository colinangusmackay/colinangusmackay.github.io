---
title: "The try-catch-ignore anti-pattern (again!)"
slug: the-trycatchignore-antipattern-again
publishDate: 05 Mar 2009
description: "I've blogged about this a few times, but today I just want to highlight the frustration this causes on fellow developers. Earlier today I saw a tweet from..."
tags:
  - { name: "Anti-pattern", slug: anti-pattern }
  - { name: "error handling", slug: error-handling }
---
<!-- TODO: convert this post's content to Markdown -->

I've blogged about this a few times, but today I just want to highlight the frustration this causes on fellow developers. Earlier today I saw a tweet from <a href="http://blog.e4ums.co.uk/">Chris Canal</a> that said:
<blockquote>"<strong>Are you swallowing exceptions there?! Hold on, let me get something to break your fingers with :|</strong>" [<a href="http://twitter.com/chriscanal/status/1282888934">^</a>]</blockquote>
All too often I've seen the just-ignore-it school of software development when it comes to error messages. It makes it very difficult to track down bugs.

If there is a valid reason for ignoring an exception then document it. State clearly in the comments exactly why you are ignoring the exception. Log the exception at the very least - I want to know when it happens, how often and why. I don't like errors being swallowed up. I like to have them all fixed.

Incidentally, when I set up the development wiki in my company one of the first things was to put the quote on the front page "Always write software as if the person that will have to maintain it is an axe wielding maniac" - It is a very good rule to develop software by. I highly recommend it.
