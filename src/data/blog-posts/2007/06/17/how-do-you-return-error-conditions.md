---
title: "How do you return error conditions?"
slug: how-do-you-return-error-conditions
publishDate: 17 Jun 2007
description: "A recent poll on Code Project asked: How do you return error conditions? I was disappointed to find that in the event of a \"critical error that leaves the app..."
tags:
  - { name: "Error", slug: error }
  - { name: "software development practices", slug: software-development-practices }
---
A recent poll on Code Project asked: **How do you return error conditions?**

I was disappointed to find that in the event of a "critical error that leaves the app in an undefined state" a shocking 5% of people would "cover up the mess and don't say anything". I think I would be shocked at even just one person responding with that answer. 

A greater percentage of people chose that answer in the event of non-critical errors, too. While the errors aren't so bad, someone, somewhere will have to eventually clean up the mess.

It reminds me of a charting component that a company I used to work for bought. I evaluated various charting components and only one did absolutely every type of we wanted. However, in my report I did indicate that the component would not return any error status or throw an exeption when it failed so it was up to the developer who was using it to somehow work out if the component actually did what was asked of it. I just wonder how much more money was spent working around the problems the component created rather than benefit from it solving the existing problem.
