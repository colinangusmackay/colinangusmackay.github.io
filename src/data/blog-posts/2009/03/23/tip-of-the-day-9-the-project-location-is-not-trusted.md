---
title: "Tip of the Day #9 (The Project Location Is Not Trusted)"
slug: tip-of-the-day-9-the-project-location-is-not-trusted
publishDate: 23 Mar 2009
description: "This tip is to get a tool called ZoneStripper by James Kovaks to stop the annoying \"project location not trusted\" dialog box, below, appearing when you open..."
tags:
  - { name: "Windows 7", slug: windows-7 }
  - { name: "Windows Vista", slug: windows-vista }
  - { name: "Windows XP SP2", slug: windows-xp-sp2 }
---
<!-- TODO: convert this post's content to Markdown -->

This tip is to get a tool called <a href="http://www.jameskovacs.com/blog/PermaLink.aspx?guid=6985963b-3d85-41ae-bca8-5f9efe2a79c7">ZoneStripper</a> by <a href="http://www.jameskovacs.com/blog/default.aspx">James Kovaks</a> to stop the annoying "project location not trusted" dialog box, below, appearing when you open downloaded solutions in Visual Studio.

If you download zipped source code from the web, unzip it and then open the solution in Visual Studio 2008 (and apparently VS 2003 and VS 2005 as well) you may get a dialog that says "The project location is not trusted" ... "Running the application may result in security exceptions when it attempts to perform actions which require full trust." A bit like this:

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/3379975731"><img src="http://farm4.static.flickr.com/3432/3379975731_fbd677e60b.jpg" alt="The project location is not trusted" width="500" height="323" /></a>

What happens is that when you download something from the internet Windows (from Windows XP SP2 onwards) will add an alternate stream to the file called zone.identifier. If the file is a zip it will then add that alternate stream to each of the files as it unzips.

You can view this stream by typing something like the following at a command prompt:
<pre>notepad DevWeek2009_PreCon.zip:zone.identifier</pre>
You can then read the contents of the alternate stream:

<a title="Snagit Capture for Flickr" href="http://www.flickr.com/photos/colinangusmackay/3380003693"><img src="http://farm4.static.flickr.com/3563/3380003693_2fa2a037c0.jpg" alt="" width="500" height="117" /></a>

What the ZoneStripper program does is delete the zone.identifier alternate stream from the file so that zone aware applications (and the OS) treat the file normally.

Note: If you unzip the files to a FAT based file system then you won't have a zone.identifier in the first place as the FAT file system does not support alternate file streams.
