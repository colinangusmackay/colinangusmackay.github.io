---
title: "Debugging a process that cannot be invoked through Visual Studio."
slug: debugging-a-process-that-cannot-be-invoked-through-visual-studio
publishDate: 31 Aug 2015
description: "Sometimes it is rather difficult to debug through Visual Studio directly even although the project is right there in front of you. In my case I have an..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Debugging", slug: debugging }
---
<!-- TODO: convert this post's content to Markdown -->

Sometimes it is rather difficult to debug through Visual Studio directly even although the project is right there in front of you. In my case I have an assembly that is invoked from a wrapper that is itself invoked from an MSBuild script. I could potentially get VS to invoke the whole pipeline but it seemed to me a less convoluted process to try and attach the debugger to the running process and debug from there.

But what if the process is something quite ephemeral. If the process starts up, does its thing, then shuts down you might not have time to attach a debugger to it before the process has completed. Or the thing you are debugging is in the start up code and there is no way to attach a debugger in time for that.

However there is something that can be done (if you have access to the source code and can rebuild).

<pre>for (int i = 30; i &gt;= 0; i--)
{
    Console.WriteLine("Waiting for debugger to attach... {0}", i);
    if (Debugger.IsAttached)
        break;
    Thread.Sleep(1000);
}

if (Debugger.IsAttached)
{
    Console.WriteLine("A debugger has attached to the process.");
    Debugger.Break();
}
else
{
    Console.WriteLine("A debugger was not detected... Continuing with process anyway.");
}</pre>

You could get away with less code, but I like this because is is reasonably flexible and I get to see what's happening.

First up, I set a loop to count down thirty seconds to give me time to attach the debugger. On each loop it checks to see if the debugger is attached already and exits early if it has (This is important as otherwise you could attach the debugger then get frustrated waiting for the process to continue.)

After the loop (regardless of whether it simply timed-out or a debugger was detected) it does a final check and breaks the execution if a debugger is detected.

Each step of the way it outputs to the console what it is doing so you can see when to attach the debugger and you can see when the debugger got attached, or not.

My recommendation, if you want to use this code, is to put it in a utility class somewhere that you can call when needed, then take the call out afterwards.
