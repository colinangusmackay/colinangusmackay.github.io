---
title: "How to recover deleted files, folders and branches in TFS"
slug: how-to-recover-deleted-files-folders-and-branches-in-tfs
publishDate: 27 Feb 2015
description: "In Visual Studio go to the menu item Tools-->Options... Then navigate to the Source Control --> Visual Studio Team Foundation Server section. In that section..."
tags:
  - { name: "Source Control", slug: source-control }
  - { name: "TFS", slug: tfs }
  - { name: "visual studio", slug: visual-studio }
---
<!-- TODO: convert this post's content to Markdown -->

In Visual Studio go to the menu item Tools--&gt;Options...

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/tfs/2015-02-27-01-vs-tools-options.png" alt="" width="484" height="615" />

Then navigate to the Source Control --&gt; Visual Studio Team Foundation Server section.

In that section is a check box that says "Show deleted items in the Source Control Explorer"

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/tfs/2015-02-27-02-vs-tfs-show-deleted-items.png" alt="" width="757" height="440" />

Once you've ensured that the checkbox is checked, press "OK"

Then navigate to the Source Control Explorer and you'll see that deleted files, folders and branches are now displayed with a large red cross next to them.

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/tfs/2015-02-27-03-vs-source-control-explorer.png" alt="" width="378" height="372" />

Right click the item you want to recover and select “Undelete” from the menu.

At this point Visual Studio stops responding to input. It displays a wait spinner briefly, but mostly it just looks like it has hung.

When Visual Studio does come back to life you can go to the Pending Changes to see the newly recovered files, folders, or branches.

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/tfs/2015-02-27-04-vs-pending-changes.png" alt="" width="392" height="153" />

If you are happy with this change, you can check it in to TFS as normal.
