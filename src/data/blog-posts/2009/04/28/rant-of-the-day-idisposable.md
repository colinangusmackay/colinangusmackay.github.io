---
title: "Rant of the day: IDisposable"
slug: rant-of-the-day-idisposable
publishDate: 28 Apr 2009
description: "My colleagues are probably used to the fact that I rant about code quality frequently. I take code quality very seriously. Not because I'm especially expert in..."
tags:
  - { name: ".NET", slug: net }
  - { name: "Anti-pattern", slug: anti-pattern }
  - { name: "C#", slug: c }
  - { name: "Code Quality", slug: code-quality }
---
<!-- TODO: convert this post's content to Markdown -->


		<p>My colleagues are probably used to the fact that I rant about code quality frequently. I take code quality very seriously. Not because I'm especially expert in it, but because features of basic code quality make it easier for other people to read and maintain the code. </p>  <p>Today's irritation comes from some code (replicated in a number of classes I might add) that implements IDisposable. It is a fine interface and by implementing it you are telling the rest of the world that you have some stuff that can't just be left to the garbage collector to clean up. These are things like file streams, database connections, etc. Any type of scarce resource that you want to hand back as soon as you are finished with it rather than leave it up to the garbage collector.</p>  <p>However, I came across this "gem" in some code today where the class, basically a utility class, contained no fields (so it wasn't holding on to anything at all, let alone anything that might be a scarce resource). Yet, for some reason it implemented IDisposable. What was it going to dispose? What could it dispose?</p>  <p>The answer was in the code:</p>  <pre>public void Dispose()
{
    // Nothing to dispose of.
}</pre>

<p>Quite!</p>

	
