---
title: "Git cheat sheet"
slug: git-cheat-sheet
publishDate: 11 Sep 2012
description: "Here is my little cheat sheet for working with git at the command line. Check the status of the current repository: git status This will return details of..."
tags:
  - { name: "git", slug: git }
---
Here is my little cheat sheet for working with git at the command line.
**Check the status of the current repository:**

```bash
git status
```

This will return details of which files are modified and any files that are untracked, etc.
**Add a file to the repository**:

```bash
git add <filename>
```

You can also replace filename with a dot (.) to include all untracked files. Use git status before to find out what files are currently untracked.
**Commit the changes to the local repository**:

```bash
git commit -m "<commit message>"
```

This will only commit the changes as far as the local repository.
**Send the changes back to the server**:

```bash
git push origin master
```

`origin` is the name of the remote location of the repository. It is more-or-less, by convention, where you cloned your local repository from.
`master` is the name of the branch. By convention this is your default branch.
**Revert a file to the version at the previous commit**:

```bash
git checkout -f <filename>
```

**Delete files from the repository**

```bash
git rm <filename>
```

If you want to delete an entire directory you need to add the `-r` (recursive) flag.

```bash
git rm -r <folder-path>
```

You may also need to choose between keeping the files on the disk and removing them altogether. In which case you want either `--cached`, to remove them from the repository but keep them on disk, or `-f` to force the removal of the file from disk.
