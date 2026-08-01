---
title: "Really getting the latest changes with TFS"
slug: really-getting-the-latest-changes-with-tfs
publishDate: 28 Feb 2015
description: "TFS Source Control doesn't always get the latest changes. It gets what it thinks are the latest changes (and for the most part it gets it right if you work..."
tags:
  - { name: "Source Control", slug: source-control }
  - { name: "TFS", slug: tfs }
  - { name: "visual studio", slug: visual-studio }
---
<!-- TODO: convert this post's content to Markdown -->

TFS Source Control doesn't always get the latest changes. It gets what it thinks are the latest changes (and for the most part it gets it right if you work exclusively in Visual Studio). However, there are times when it gets it wrong and you have to force its hand a little.

So, if you have issues getting latest code then what you need to do is:
<ul>
	<li>Right click the branch or folder that is problematic</li>
	<li>Go to the "advanced" sub-menu and click "Get Specific Version…"</li>
	<li>Then in the dialog check the two “overwrite…” boxes</li>
	<li>Finally, press “Get”</li>
</ul>
<img class="aligncenter" src="http://static.colinmackay.co.uk/images/tfs/2015-02-27-11-vs-get.png" alt="" width="600" height="405" />

At this point VS/TFS will retrieve all the files in the branch/folder selected and overwrite existing files. It will also retrieve files it didn't already have, even although it thought it had them.
