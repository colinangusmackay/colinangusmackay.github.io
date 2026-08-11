---
title: "Things I keep forgetting about FileInfo"
slug: things-i-keep-forgetting-about-fileinfo
publishDate: 23 Jun 2007
description: "This is going to sound like a real newbie post. But I keep forgetting this particular bit of information and I keep having to write little throw away..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---

This is going to sound like a real newbie post. But I keep forgetting this particular bit of information and I keep having to write little throw away applications to find out the answer. [FileInfo](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofileinfoclasstopic.asp) has a number of properties and the MSDN description on them are almost next to useless.
Given the file C:\folder\file.ext

- [FileInfo.Name](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofileinfoclassnametopic.asp) returns "file.ext"
- [FileInfo.FullName](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofilesysteminfoclassfullnametopic.asp) returns "C:\folderfile.ext"
- [FileInfo.Extension](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofilesysteminfoclassextensiontopic.asp) returns ".ext" (note the dot suffix)
- [FileInfo.DirectoryName](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofileinfoclassdirectorynametopic.asp) returns "C:\folder"
  - An exception is if the file is in the root directory. The result would be something like "C:\\ with the trailing slash will be returned.

So there we have it. The things that I keep forgetting about `FileInfo` that MSDN just does not explain (except the Extension property, it at least does explain that one)

*NOTE: This was rescued from the Google Cache. The original was dated Monday, 28th March 2005.*
