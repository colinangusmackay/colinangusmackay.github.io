---
title: "How to Undelete a Branch in Git"
slug: how-to-undelete-a-branch-in-git
publishDate: 10 Dec 2021
description: "About a month ago I deleted a branch that I thought I wasn't going to need. The ticket had been parked, then put back in the backlog and there were lots of..."
tags: []
---
<!-- TODO: convert this post's content to Markdown -->

<!-- wp:paragraph -->
<p>About a month ago I deleted a branch that I thought I wasn't going to need. The ticket had been parked, then put back in the backlog and there were lots of discussions about what actually needed to be done and it looked like the work wasn't going to be needed, at least not in its current form. So, the branch got deleted.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Then things started moving again and I wanted some of the code in the branch that I'd deleted.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>When you delete a branch in Git it doesn't actually delete the commits. It just deleted the reference to the branch, which is essentially just a pointer to the commit at the head of that branch. You can prune these orphaned commits to really get rid of them, but if you do nothing then they just hang around.</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2 id="steps-to-undelete-a-branch">Steps to undelete a branch</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>First, in the terminal or shell use the command:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code {"language":"bash"} -->
<pre class="wp-block-syntaxhighlighter-code">git reflog</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>And then you'll see all the commits in the repository, including the deleted ones.</p>
<!-- /wp:paragraph -->

<!-- wp:image {"id":13670,"sizeSlug":"large","linkDestination":"media"} -->
<figure class="wp-block-image size-large"><a href="https://colinmackay.scot/wp-content/uploads/2021/12/microsoftteams-image.png"><img src="https://colinmackay.scot/wp-content/uploads/2021/12/microsoftteams-image.png?w=1024" alt="" class="wp-image-13670" /></a><figcaption>Start of the reflog output</figcaption></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>Once you find the commit you want to retrieve then you can create a new branch at that commit like this:</p>
<!-- /wp:paragraph -->

<!-- wp:syntaxhighlighter/code {"language":"bash"} -->
<pre class="wp-block-syntaxhighlighter-code">git checkout -b "&lt;branch-name&gt;" "&lt;head-ref-or-commit-sha&gt;"</pre>
<!-- /wp:syntaxhighlighter/code -->

<!-- wp:paragraph -->
<p>e.g.</p>
<!-- /wp:paragraph -->

<!-- wp:image {"id":13673,"sizeSlug":"large","linkDestination":"media"} -->
<figure class="wp-block-image size-large"><a href="https://colinmackay.scot/wp-content/uploads/2021/12/microsoftteams-image-2.png"><img src="https://colinmackay.scot/wp-content/uploads/2021/12/microsoftteams-image-2.png?w=782" alt="" class="wp-image-13673" /></a><figcaption>Example creating branch for a specific commit</figcaption></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>Which makes the commit and its predecessors available again as a branch.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>e.g.</p>
<!-- /wp:paragraph -->

<!-- wp:image {"id":13675,"sizeSlug":"large","linkDestination":"media"} -->
<figure class="wp-block-image size-large"><a href="https://colinmackay.scot/wp-content/uploads/2021/12/microsoftteams-image-1.png"><img src="https://colinmackay.scot/wp-content/uploads/2021/12/microsoftteams-image-1.png?w=1024" alt="" class="wp-image-13675" /></a><figcaption>GitKraken tree of the repo with the old branch back in place</figcaption></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>And there you have it.</p>
<!-- /wp:paragraph -->
