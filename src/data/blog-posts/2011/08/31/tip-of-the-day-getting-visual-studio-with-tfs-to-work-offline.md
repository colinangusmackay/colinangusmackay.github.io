---
title: "Tip of the day: Getting Visual Studio with TFS to work offline"
slug: tip-of-the-day-getting-visual-studio-with-tfs-to-work-offline
publishDate: 31 Aug 2011
description: "Earlier to day our TFS server went down. Visual Studio likes to have a constant connection open to it, but obviously that wasn't going to happen. Luckily, it..."
tags:
  - { name: "Source Control", slug: source-control }
  - { name: "TFS", slug: tfs }
  - { name: "TFS 2010", slug: tfs-2010 }
  - { name: "Visual Studio 2010", slug: visual-studio-2010 }
---
<!-- TODO: convert this post's content to Markdown -->

Earlier to day our TFS server went down. Visual Studio likes to have a constant connection open to it, but obviously that wasn't going to happen. Luckily, it is possible to work on a solution with no connection to TFS.
<h3>If you were just starting some work...</h3>
If Visual Studio was open when TFS went off-line then it won't allow you to check out any files. If all your files are checked in already, then you can just shut down Visual Studio and then start again. When the solution opens it detects that TFS is gone and offers to open the project in Offline mode:

[caption id="" align="aligncenter" width="451" caption="TFS Go Offline"]<img title="Go Offline" src="http://static.colinmackay.co.uk/images/tfs/2011-08-31-tfs-open-offline.png" alt="Go Offline" width="451" height="210" />[/caption]

When TFS is available again you can simply reconnect to the server by selecting the <em>Team?</em><em>Connect to Team Foundation Server...</em> menu. Once you are connected, you can right-click the solution and select "<em>Go Online</em>".

You'll get a dialog that asks to to confirm the files that you've changed in the meantime:

[caption id="" align="aligncenter" width="633" caption="TFS Go Online"]<img title="Go Online" src="http://static.colinmackay.co.uk/images/tfs/2011-08-31-tfs-go-online.png" alt="Go Online" width="633" height="341" />[/caption]

It will then take a few moments for TFS to catch up (I have quite a large solution, so it took about a minute for me) then the files appeared in the Pending Changes window ready to be checked in as normal.
<h3>If you were in the middle of something</h3>
If you already had files checked out when TFS went offline then this post about <a href="http://msmvps.com/blogs/p3net/pages/tfs-2010-in-offline-mode.aspx">converting to offline</a> may be more useful to you.

There is also a Visual Studio extension, if you prefer not having to restart Visual Studio called <a href="http://visualstudiogallery.msdn.microsoft.com/425f09d8-d070-4ab1-84c1-68fa326190f4?SRC=Home">Go Offline</a>. Once installed, just to to <em>File?</em><em>Source Control?</em><em>Go Offline</em>. This may be a more useful solution if you are constantly going in and out of connection with TFS (a mobile broadband connection on a train for example).
