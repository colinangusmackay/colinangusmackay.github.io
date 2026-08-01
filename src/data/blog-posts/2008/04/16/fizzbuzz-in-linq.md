---
title: "Fizz-Buzz in LINQ"
slug: fizzbuzz-in-linq
publishDate: 16 Apr 2008
description: "This just occurred to me. It is somewhat pointless, but I thought it was interesting: static void Main( string [] args) { var result = from say in Enumerable..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "C# 3", slug: c-3 }
  - { name: "LINQ", slug: linq }
---
<!-- TODO: convert this post's content to Markdown -->

This just occurred to me. It is somewhat pointless, but I thought it was interesting:
<pre class="code"><span style="color:blue;">static void </span>Main(<span style="color:blue;">string</span>[] args)
{
    <span style="color:blue;">var </span>result = <span style="color:blue;">from </span>say <span style="color:blue;">in </span><span style="color:#2b91af;">Enumerable</span>.Range(1, 100)
                 <span style="color:blue;">select </span>(say % 15 == 0) ? <span style="color:#a31515;">"BuzzFizz" </span>:
                    (say % 5 == 0) ? <span style="color:#a31515;">"Buzz" </span>:
                        (say % 3 == 0) ? <span style="color:#a31515;">"Fizz" </span>: say.ToString();
    <span style="color:blue;">foreach </span>(<span style="color:blue;">string </span>say <span style="color:blue;">in </span>result)
        <span style="color:#2b91af;">Console</span>.WriteLine(say);
}</pre>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:ed7b0d12-ada9-43c6-8e64-caf0b9436074" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/linq">linq</a>,<a rel="tag" href="http://technorati.com/tags/fizzbuzz">fizzbuzz</a>,<a rel="tag" href="http://technorati.com/tags/buzzfizz">buzzfizz</a></div>
