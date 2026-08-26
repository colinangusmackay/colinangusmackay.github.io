---
title: "Speed up Visual Studio by turning off the Source Control Plug-in"
slug: speed-up-visual-studio-by-turning-off-the-source-control-plug-in
publishDate: 19 Apr 2023
description: "I don't use the built in source control plug in Visual Studio as I use GitKraken instead, so Visual Studio's plug-in just sat in the background not doing much..."
tags:
  - { name: "Source Control", slug: source-control }
  - { name: "visual studio", slug: visual-studio }
  - { name: "visual studio 2022", slug: visual-studio-2022 }
---
<!-- ISSUE: link (https://www.gitkraken.com/): The SSL connection could not be established, see inner exception. -->

I don't use the built in source control plug in Visual Studio as I use [GitKraken](https://www.gitkraken.com/) instead, so Visual Studio's plug-in just sat in the background not doing much as far as I could see.

Then out-of-the-blue I got a notification that it was slowing down Visual Studio and I should turn it off if I don't rely on it. Fair enough, I don't use it, it can go.

## Open the Options dialog

Open the options dialog by going to the Tools→Options... menu item

![](/assets/blog/2023-04-19-speed-up-visual-studio-by-turning-off-the-source-control-plug-in-1.webp)

## Find the Source Control Plug in Section

Type `Source Control Plug-in Selection` in the search box and press enter

![](/assets/blog/2023-04-19-speed-up-visual-studio-by-turning-off-the-source-control-plug-in-2.webp)

Change the drop down to `None` and then press `OK`.

If you have a solution open, it will likely tell you it has to close the solution.

That's it!
