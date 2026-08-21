---
title: "Feedback from my DDD Scotland Talk on Parallisation"
slug: feedback-from-my-ddd-scotland-talk-on-parallisation
publishDate: 10 May 2011
description: "I got my feedback from my DDD Scotland 2011 talk on Parallelisation . I was actually pleasantly surprised. I guess I was being a little too self critical and..."
tags:
  - { name: "ConcurrentDictionary", slug: concurrentdictionary }
  - { name: "DDD Scotland", slug: ddd-scotland }
  - { name: "DDD South West", slug: ddd-south-west }
  - { name: "locking", slug: locking }
  - { name: "parallelisation", slug: parallelisation }
  - { name: "parallelization", slug: parallelization }
  - { name: "Semaphore", slug: semaphore }
---
<!-- ISSUE: link (http://www.developerdeveloperdeveloper.com/scotland2011/Schedule.aspx): status 404 -->

![Slide Deck Opening Slide](/assets/blog/2011-05-10-feedback-from-my-ddd-scotland-talk-on-parallisation-1.webp)

I got my feedback from my DDD Scotland 2011 talk on Parallelisation. I was actually pleasantly surprised. I guess I was being a little too self critical and the talk went over a lot better than I thought it had.

Some of the highlights:

- Good clear samples and demos.
- Enthusiastic speaker who really knew his stuff. Great talk!
- Nice easy to understand examples. Getting the concepts across without clutter.
- Useful info. Genuinely learnt something new.

And of course my favourite comment (despite being somewhat irrelevant, or should that be irreverent): *Colin's funky hair*.

There were a couple of points that I need to address in future versions of the talk.

I only gave an overview of locking and the only demo that went close was the [ConcurrentDictionary example](/2011/04/21/parallelisation-talk-examples-concurrentdictionary/ "ConcurrentDictionary") in which all the locking mechanisms are internal to the ConcurrentDictionary. One person wanted more detail on locking so I shall endeavour to add a little extra into the presentation for DDD South West on locking including, if time allows, a specific demo.

The aspect of locking I need to address, is that I talked about when I used a semaphore in a project to restrict access to a scarce resource, but again I didn’t elaborate on it and another person would have found an example of a semaphore being used useful. I have already written about [semaphores in a previous blog post](/2011/03/30/using-semaphores-to-restrict-access-to-resources/ "Using semaphores to restrict access to resources in a parallel system"), so I shall try and work that in to the next version of the presentation.

The other part is that the intro appears to be a little long and I need to shorten than slightly. If I can do that, it will at least free up space in a one hour talk to add the additional information on locking in later on.

I really appreciate the additional few moments people took at the end of my talk to write specifically what they enjoyed and what they disliked about my presentation, especially as lunch was waiting for them. It really gives me something to work with in order to improve the talk.
