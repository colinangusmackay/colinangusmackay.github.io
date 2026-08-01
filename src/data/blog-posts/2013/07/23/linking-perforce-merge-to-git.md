---
title: "Linking Perforce Merge to Git"
slug: linking-perforce-merge-to-git
publishDate: 23 Jul 2013
description: "Git's built in Merge conflict resolution is awful. Although all the information is there it is difficult to use for all but the simplest of conflicts. Luckily,..."
tags:
  - { name: "diff tools", slug: diff-tools }
  - { name: "git", slug: git }
  - { name: "merge tools", slug: merge-tools }
  - { name: "merging", slug: merging }
  - { name: "Source Control", slug: source-control }
---
<!-- TODO: convert this post's content to Markdown -->

Git's built in Merge conflict resolution is awful. Although all the information is there it is difficult to use for all but the simplest of conflicts. Luckily, it is relatively easy to wire up a third party diff and merge tools to help.
<h3>Setting up as a diff tool.</h3>
You can <a href="http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools">download the Perforce Visual Merge Tool here</a>. The only part of the installer that is needed is the "Visual Merge Tool (P4Merge)"

[caption id="" align="aligncenter" width="514"]<a href="http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools"><img alt="Perforce Installation Wizard - Feature Selection" src="http://static.colinmackay.co.uk/images/github/2013-07-22-perforce-installation-wizard-select-features.png" width="514" height="393" /></a> Perforce Installation Wizard - Feature Selection[/caption]

To configure Git to use the p4merge as the diff tool, the global config needs to be edited. The global config, on Windows 7 and 8 is found in <code>c:\users\<em>&lt;username&gt;</em>\.gitconfig</code>

The following needs to be added:
<pre>[diff]
    tool = P4Merge
[difftool "P4Merge"]
    cmd = p4merge "$LOCAL" "$REMOTE"</pre>
The <code>[diff]</code> section sets up the default tool to use, you can configure as many as you like. The <code>[difftool "<em>toolname</em>"]</code> section sets up the options for a specific tool.

Now, in Git Bash, you can type <code>git difftool</code> and it will show the diffs in the perforce merge tool between the current file and the previous commit.

If you have multiple files that have changes it will prompt one-by-one to view them in the diff tool.

If you've already staged the files (prior to a commit) then you'll need to type <code>git difftool --cached</code> in order for them to show up.

If you wish to see just a specific file you can use <code>git difftool <em>name-of-file</em></code>

Again, add the <code>--cached</code> option (just before the filename) if you've already staged the file prior to a commit.
<h3>Setting up as a Merge Tool</h3>
Open up the <code>.gitconfig</code> file, as above, and make some changes to it. Add the following sections to it which are similar to the diff tool.

<pre>
[merge]
    tool = P4Merge
[mergetool "P4Merge"]
    cmd = p4merge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"
    keepTemporaries = false
    trustExitCode = false
    keepBackup = false
</pre>

If you get a merge conflict when merging branches or pulling down from the remote repository you can now use <code>git mergetool</code> to merge the changes.


