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
Git's built in Merge conflict resolution is awful. Although all the information is there it is difficult to use for all but the simplest of conflicts. Luckily, it is relatively easy to wire up a third party diff and merge tools to help.

### Setting up as a diff tool.

You can [download the Perforce Visual Merge Tool here](http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools). The only part of the installer that is needed is the "Visual Merge Tool (P4Merge)"

![Perforce Installation Wizard - Feature Selection](/assets/blog/2013-07-23-linking-perforce-merge-to-git-1.webp)

To configure Git to use the p4merge as the diff tool, the global config needs to be edited. The global config, on Windows 7 and 8 is found in `c:\users\`*`<username>`*`\.gitconfig`

The following needs to be added:

```
[diff]
    tool = P4Merge
[difftool "P4Merge"]
    cmd = p4merge "$LOCAL" "$REMOTE"
```

The `[diff]` section sets up the default tool to use, you can configure as many as you like. The `[difftool "`*`toolname`*`"]` section sets up the options for a specific tool.

Now, in Git Bash, you can type `git difftool` and it will show the diffs in the perforce merge tool between the current file and the previous commit.

If you have multiple files that have changes it will prompt one-by-one to view them in the diff tool.

If you've already staged the files (prior to a commit) then you'll need to type `git difftool --cached` in order for them to show up.

If you wish to see just a specific file you can use `git difftool `*`name-of-file`*

Again, add the `--cached` option (just before the filename) if you've already staged the file prior to a commit.

### Setting up as a Merge Tool

Open up the `.gitconfig` file, as above, and make some changes to it. Add the following sections to it which are similar to the diff tool.

```
[merge]
    tool = P4Merge
[mergetool "P4Merge"]
    cmd = p4merge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"
    keepTemporaries = false
    trustExitCode = false
    keepBackup = false
```

If you get a merge conflict when merging branches or pulling down from the remote repository you can now use `git mergetool` to merge the changes.
