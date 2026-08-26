---
title: "How to Undelete a Branch in Git"
slug: how-to-undelete-a-branch-in-git
publishDate: 10 Dec 2021
description: "About a month ago I deleted a branch that I thought I wasn't going to need. The ticket had been parked, then put back in the backlog and there were lots of..."
tags: []
---
About a month ago I deleted a branch that I thought I wasn't going to need. The ticket had been parked, then put back in the backlog and there were lots of discussions about what actually needed to be done and it looked like the work wasn't going to be needed, at least not in its current form. So, the branch got deleted.

Then things started moving again and I wanted some of the code in the branch that I'd deleted.

When you delete a branch in Git it doesn't actually delete the commits. It just deleted the reference to the branch, which is essentially just a pointer to the commit at the head of that branch. You can prune these orphaned commits to really get rid of them, but if you do nothing then they just hang around.

## Steps to undelete a branch

First, in the terminal or shell use the command:

```
git reflog
```

And then you'll see all the commits in the repository, including the deleted ones.

![Start of the reflog output](/assets/blog/2021-12-10-how-to-undelete-a-branch-in-git-1.webp)

Once you find the commit you want to retrieve then you can create a new branch at that commit like this:

```
git checkout -b "<branch-name>" "<head-ref-or-commit-sha>"
```

e.g.

![Example creating branch for a specific commit](/assets/blog/2021-12-10-how-to-undelete-a-branch-in-git-2.webp)

Which makes the commit and its predecessors available again as a branch.

e.g.

![GitKraken tree of the repo with the old branch back in place](/assets/blog/2021-12-10-how-to-undelete-a-branch-in-git-3.webp)

And there you have it.
