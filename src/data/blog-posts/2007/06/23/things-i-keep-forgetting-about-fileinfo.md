---
title: "Things I keep forgetting about FileInfo"
slug: things-i-keep-forgetting-about-fileinfo
publishDate: 23 Jun 2007
description: "This is going to sound like a real newbie post. But I keep forgetting this particular bit of information and I keep having to write little throw away..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
---
<!-- TODO: convert this post's content to Markdown -->

This is going to sound like a real newbie post. But I keep forgetting this particular bit of information and I keep having to write little throw away applications to find out the answer. <a href="http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofileinfoclasstopic.asp">FileInfo</a> has a number of properties and the MSDN description on them are almost next to useless.

Given the file C:\folder\file.ext
<ul>
	<li><a href="http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofileinfoclassnametopic.asp">FileInfo.Name</a> returns "file.ext"</li>
	<li><a href="http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofilesysteminfoclassfullnametopic.asp">FileInfo.FullName</a> returns "C:\folderfile.ext"</li>
	<li><a href="http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofilesysteminfoclassextensiontopic.asp">FileInfo.Extension</a> returns ".ext" (note the dot suffix)</li>
	<li><a href="http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cpref/html/frlrfsystemiofileinfoclassdirectorynametopic.asp">FileInfo.DirectoryName</a> returns "C:\folder"
<ul>
	<li>An exception is if the file is in the root directory. The result would be something like "C:\" with the trailing slash will be returned.</li>
</ul>
</li>
</ul>
So there we have it. The things that I keep forgetting about <code>FileInfo</code> that MSDN just does not explain (except the Extension property, it at least does explain that one)

<em>NOTE: This was rescued from the <a title="Google" href="http://www.google.co.uk" target="_blank">Google</a> Cache. The original was dated Monday, 28th March 2005.</em>
