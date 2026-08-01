---
title: "Git cheat sheet"
slug: git-cheat-sheet
publishDate: 11 Sep 2012
description: "Here is my little cheat sheet for working with git at the command line. Check the status of the current repository: git status This will return details of..."
tags:
  - { name: "git", slug: git }
---
<!-- TODO: convert this post's content to Markdown -->

Here is my little cheat sheet for working with git at the command line.

<strong>Check the status of the current repository:</strong>
<pre>git status</pre>
This will return details of which files are modified and any files that are untracked, etc.

<strong>Add a file to the repository</strong>:
<pre>git add <em>&lt;filename&gt;</em></pre>
You can also replace filename with a dot (.) to include all untracked files. Use git status before to find out what files are currently untracked.

<strong>Commit the changes to the local repository</strong>:
<pre>git commit -m "<em>&lt;commit message&gt;</em>"</pre>
This will only commit the changes as far as the local repository.

<strong>Send the changes back to the server</strong>:
<pre>git push origin master</pre>
<code>origin</code> is the name of the remote location of the repository. It is more-or-less, by convention, where you cloned your local repository from.

<code>master</code> is the name of the branch. By convention this is your default branch.

<strong>Revert a file to the version at the previous commit</strong>:
<pre>git checkout -f <em>&lt;filename&gt;</em></pre>
<strong>Delete files from the repository</strong>
<pre>git rm &lt;filename&gt;</pre>
If you want to delete an entire directory you need to add the <code>-r</code> (recursive) flag.
<pre>git rm -r &lt;folder-path&gt;</pre>
You may also need to choose between keeping the files on the disk and removing them altogether. In which case you want either <code>--cached</code>, to remove them from the repository but keep them on disk, or <code>-f</code> to force the removal of the file from disk.
