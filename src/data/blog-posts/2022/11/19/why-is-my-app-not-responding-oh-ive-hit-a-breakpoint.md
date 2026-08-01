---
title: "Why is my app not responding? Oh... I've hit a breakpoint!"
slug: why-is-my-app-not-responding-oh-ive-hit-a-breakpoint
publishDate: 19 Nov 2022
description: "Have you ever run your app from Visual Studio to have it suddenly stop responding and you can't immediately see why, only to discover that you've hit a..."
tags:
  - { name: "accessibility", slug: accessibility }
  - { name: "audio cues", slug: audio-cues }
  - { name: "visual studio", slug: visual-studio }
  - { name: "visual studio 2022", slug: visual-studio-2022 }
---
<!-- TODO: convert this post's content to Markdown -->

<!-- wp:paragraph -->
<p>Have you ever run your app from Visual Studio to have it suddenly stop responding and you can't immediately see why, only to discover that you've hit a breakpoint and didn't realise because Visual Studio is now running behind the window you're looking at (or on a monitor you weren't looking at). Well, as of Visual Studio 17.4 (November 2022 release) you can now assign a sound to hitting a break point so that you get an audio warning when that happens.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>To get this, first go to Tools--&gt;Options, and typing "Audio Cues" into the search, then checking the "Enable Audio Cues" check box.</p>
<!-- /wp:paragraph -->

<!-- wp:image {"id":13700,"sizeSlug":"large","linkDestination":"media"} -->
<figure class="wp-block-image size-large"><a href="https://colinmackay.scot/wp-content/uploads/2022/11/image.jpeg"><img src="https://colinmackay.scot/wp-content/uploads/2022/11/image.jpeg?w=800" alt="" class="wp-image-13700" /></a></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>Next you have to open up the system sounds dialog in order to assign a sound to the event. From the Windows Start Menu search for "Change System Sounds"</p>
<!-- /wp:paragraph -->

<!-- wp:image {"id":13702,"sizeSlug":"large","linkDestination":"media"} -->
<figure class="wp-block-image size-large"><a href="https://colinmackay.scot/wp-content/uploads/2022/11/microsoftteams-image-3.png"><img src="https://colinmackay.scot/wp-content/uploads/2022/11/microsoftteams-image-3.png?w=1024" alt="" class="wp-image-13702" /></a></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>And then selecting the "Sounds" tab, and scolling to the "Microsoft Visual Studio" section and selecting "Breakpoint Hit" as the event. You can then assign a sound to the event.</p>
<!-- /wp:paragraph -->

<!-- wp:image {"id":13704,"sizeSlug":"large","linkDestination":"media"} -->
<figure class="wp-block-image size-large"><a href="https://colinmackay.scot/wp-content/uploads/2022/11/image-1.jpeg"><img src="https://colinmackay.scot/wp-content/uploads/2022/11/image-1.jpeg?w=634" alt="" class="wp-image-13704" /></a></figure>
<!-- /wp:image -->

<!-- wp:paragraph -->
<p>Once you apply this change, you will then get an alert sound when a breakpoint is hit while you are debugging your code. </p>
<!-- /wp:paragraph -->
