---
title: "I guess I've never needed to do this before..."
slug: i-guess-ive-never-needed-to-do-this-before
publishDate: 23 Mar 2009
description: "I guess I've never created a struct in a while (at least in Visual Studio 2008 using C# 3.0) because I've just discovered that the Automatic Properties don't..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
---
<!-- TODO: convert this post's content to Markdown -->

I guess I've never created a struct in a while (at least in Visual Studio 2008 using C# 3.0) because I've just discovered that the Automatic Properties don't work in structs.

I've just created this struct:
<pre class="code"><span style="color:blue;">public struct </span><span style="color:#2b91af;">CapacityUnit
</span>{
    <span style="color:blue;">public string </span>Name { <span style="color:blue;">get</span>; <span style="color:blue;">private set</span>; }
    <span style="color:blue;">public long </span>Multiplier { <span style="color:blue;">get</span>; <span style="color:blue;">private set</span>; }

    <span style="color:blue;">public </span>CapacityUnit(<span style="color:blue;">string </span>name, <span style="color:blue;">long </span>multiplier)
    {
        Name = name;
        Multiplier = multiplier;
    }
}</pre>
<a href="http://11011.net/software/vspaste"></a>Which at first glance looks okay except that I get a compiler error in the constructor on <strong>Name</strong>. The reason for this is that structs need to have the fields initialised before the <strong>this</strong> object can be used. <strong>Name</strong> uses this implicitly as in <strong>this.Name</strong>. So, it would seem that there is no way, at least as far as I can see, to initialise these properties when using Automatic Properties as I would need to use an implicit this.
