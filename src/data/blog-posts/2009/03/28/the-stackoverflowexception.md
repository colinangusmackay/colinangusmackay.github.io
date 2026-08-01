---
title: "The StackOverflowException"
slug: the-stackoverflowexception
publishDate: 28 Mar 2009
description: "Take a look at the following code: class Program { static void Main( string [] args) { try { RecurseForever(); } catch ( StackOverflowException ) { Console..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "error handling", slug: error-handling }
---
<!-- TODO: convert this post's content to Markdown -->

Take a look at the following code:
<pre class="code"><span style="color:blue;">class </span><span style="color:#2b91af;">Program
</span>{
    <span style="color:blue;">static void </span>Main(<span style="color:blue;">string</span>[] args)
    {
        <span style="color:blue;">try
        </span>{
            RecurseForever();
        }
        <span style="color:blue;">catch </span>(<span style="color:#2b91af;">StackOverflowException</span>)
        {
            <span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:#a31515;">"Caught Stack Overflow Exception"</span>);
        }
        <span style="color:blue;">catch </span>(<span style="color:#2b91af;">Exception</span>)
        {
            <span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:#a31515;">"Caught general Exception"</span>);
        }

        <span style="color:#2b91af;">Console</span>.ReadLine();
    }

    <span style="color:blue;">static void </span>RecurseForever()
    {
        RecurseForever();
    }
}</pre>
<a href="http://11011.net/software/vspaste"></a>What do you think the output of the program will be?

If you had asked me a few days ago I'd have said the output would be "Caught Stack Overflow Exception", however that isn't the case. If you run the code in the debugger this is what you actually get:

<a title="StackOverflowException by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3341673987/"><img src="http://farm4.static.flickr.com/3552/3341673987_8eeb9afd14_o.png" alt="StackOverflowException" width="596" height="343" /></a>

The exception simply isn't caught.

If the application isn't being debugged it will simply end at this point. It goes directly to jail. It does not pass GO. It does not collect £200.

<a title="ConsoleApplication2 has stopped working by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3391198076/"><img src="http://farm4.static.flickr.com/3651/3391198076_1573589921_o.png" alt="ConsoleApplication2 has stopped working" width="376" height="183" /></a>
