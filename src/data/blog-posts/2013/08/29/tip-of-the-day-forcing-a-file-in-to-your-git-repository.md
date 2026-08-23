---
title: "Tip of the day: Forcing a file in to your Git repository"
slug: tip-of-the-day-forcing-a-file-in-to-your-git-repository
publishDate: 29 Aug 2013
description: "Normally, you'll have a .gitignore file that defines what should not go into a git repository. If you find that there is a file or two that is ignored that you..."
tags:
  - { name: "git", slug: git }
---
Normally, you'll have a `.gitignore` file that defines what should not go into a git repository. If you find that there is a file or two that is ignored that you really need in the repository (e.g. a DLL dependency in a BIN folder for some legacy application that doesn't do NuGet, or other package management) then you need a way to force that into Git.

The command you need is this:

```bash
git add --force <filename>
```

Replace `<filename>` with the file that you need to force in. This will force stage the file ready for your next commit.
You can also use . in place of a file name to force in an entire directory, or you can use wild cards to determine what is staged.
Afterwards you can use

```bash
git status
```

to see that it has been staged.
