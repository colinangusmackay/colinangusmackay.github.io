---
title: "Method hiding or overriding - or the difference between new and virtual"
slug: method-hiding-or-overriding-or-the-difference-between-new-and-virtual
publishDate: 10 Oct 2008
description: "When developing applications it is very important to understand the difference between method hiding and method overriding. By default C# methods are..."
tags:
  - { name: "C#", slug: c }
  - { name: "object oriented design", slug: object-oriented-design }
---
<!-- TODO: convert this post's content to Markdown -->

When developing applications it is very important to understand the difference between method hiding and method overriding.

By default C# methods are non-virtual. If you are a Java developer this may come as a surprise. This means that in C# if you want a method to be extensible you must explicitly declare it as virtual if you want to override it.

So, what is overriding? Wikipedia has a succinct definition. <a href="http://en.wikipedia.org/wiki/Method_overriding_(programming)" target="_blank">Method overriding</a> is a language feature that allows a <a href="http://en.wikipedia.org/wiki/Subclass_(computer_science)">subclass</a> [aka derived class] to provide a specific implementation of a <a href="http://en.wikipedia.org/wiki/Method_(computer_science)">method</a> that is already provided by ... its [<a href="http://en.wikipedia.org/wiki/Superclass_(computer_science)">superclass</a>] [aka base class]. The implementation in the subclass overrides (replaces) the implementation in the superclass.

The important thing to remember about overriding is that the method that is doing the overriding is related to the method in the base class.

Method hiding, by contrast, does not have a relationship between the methods in the base class and derived class. The method in the derived class hides the method in the base class.

I wouldn't personally recommend method hiding as a strategy for developing code. In my opinion, if you feel the need to hide the method on the base class then you are most likely doing something wrong. I haven't come across any scenarios where method hiding couldn't be better implemented by other means, even as simple as just naming the method on the derived class to something else.

Let's look at some code to show you what I mean. First off we are going to use this class structure (it's my favourite when showing off inheritance, and you may have seen variations of it already on my blog).

<img src="http://static.colinmackay.co.uk/images/uml/2008-10-10-animal-class-heirarchy.png" alt="Partial Class Diagram" width="690" height="503" />

Let's say that the Dog class has a method call Bark()
<blockquote>
<pre class="code"><span style="color:blue;">public class </span><span style="color:#2b91af;">Dog</span>: <span style="color:#2b91af;">Mammal
</span>{
    <span style="color:blue;">public void </span>Bark()
    {
        <span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:#a31515;">"Woof!"</span>);
    }
}</pre>
<a href="http://11011.net/software/vspaste"></a></blockquote>
<a href="http://11011.net/software/vspaste"></a>

So far, so good. We can call it like this:
<blockquote>
<pre class="code"><span style="color:blue;">static void </span>Main(<span style="color:blue;">string</span>[] args)
{
    <span style="color:#2b91af;">Dog </span>d = <span style="color:blue;">new </span><span style="color:#2b91af;">Dog</span>();
    d.Bark();
    <span style="color:#2b91af;">Console</span>.ReadLine();
}</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

And the output of the program is as you'd expect. "Woof!" is written to the console.

Now, Chihuahuas are nippy wee things and they tend to "yip" rather than "woof" so what we'll do is create a Bark() method in Chihuahua class that writes out "Yip!" instead.
<blockquote>
<pre class="code"><span style="color:blue;">public class </span><span style="color:#2b91af;">Chihuahua </span>: <span style="color:#2b91af;">Dog
</span>{
    <span style="color:blue;">public void </span>Bark()
    {
        <span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:#a31515;">"Yip!"</span>);
    }
}</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

What happens here is that the C# compiler will display a warning to indicate that it has found a situation that it can guess at the intended functionality, but it really wants to to be explicit.

<a title="warning-message by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/2925701554/"><img src="http://farm4.static.flickr.com/3069/2925701554_aaa5532ee6_o.png" alt="warning-message" width="562" height="162" /></a>

'Animals.Chihuahua.Bark()' hides inherited member 'Animals.Dog.Bark()'. Use the new keyword if hiding was intended.

By inserting the new keyword between the public and the void in the method declaration we can get rid of this warning. We are being explict and telling the compiler that we know what we are doing. So, what are the implications of method hiding? Consider the following bit of code:
<blockquote>
<pre class="code"><span style="color:blue;">static void </span>Main(<span style="color:blue;">string</span>[] args)
{
    <span style="color:#2b91af;">Dog </span>d = <span style="color:blue;">new </span><span style="color:#2b91af;">Chihuahua</span>();
    d.Bark();
    <span style="color:#2b91af;">Console</span>.ReadLine();
}</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a>

Well, if you have a Dog reference that actually refers to an instance of the Chihuahua class then when you call bark it will still say "Woof!" That goes against many people's expectations. This is because you've actually drawn that line in the sand and are saying that the Bark method on Chihuahua is unrelated. If you hold a reference to a Dog then you may not be expected to know about the existence of a Chihuahua so if your calling code suddenly got the functionality of the Bark method in the Chihuahua class then it might break. The CLR cannot make that decision for you. If you do know about your Dog reference actually being a Chihuahua then you must cast it before using it. However, that means you are likely to have to litter your code with conditional statements based on the actual type of the object and that defeats the power of having an object oriented language.

What you should have done is make the Bark method virtual then overriden the derived version like this:
<blockquote>
<pre class="code"><span style="color:blue;">public class </span><span style="color:#2b91af;">Dog </span>: <span style="color:#2b91af;">Mammal
</span>{
    <span style="color:blue;">public virtual void </span>Bark()
    {
        <span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:#a31515;">"Woof!"</span>);
    }
}</pre>
<pre class="code"><span style="color:blue;">public class </span><span style="color:#2b91af;">Chihuahua </span>: <span style="color:#2b91af;">Dog
</span>{
    <span style="color:blue;">public override void </span>Bark()
    {
        <span style="color:#2b91af;">Console</span>.WriteLine(<span style="color:#a31515;">"Yip!"</span>);
    }
}</pre>
</blockquote>
<a href="http://11011.net/software/vspaste"></a><a href="http://11011.net/software/vspaste"></a>

This way when you have a Chihuahua object then the correct Bark method is called regardless of the type of the reference so long as the reference type can see a Bark method on that hierarchy

The way I see it is that there is no reason to have to draw that line in the sand and use the new keyword in the context of method hiding. If you feel the need to do that then your two realistic options are either to consider whether what you really want to do is make the base virtual and then override in the derived class, or whether you need to think of a better name for the method in the derived class. If the methods are related (like the Bark example above) then method overriding is what you need. If they are not related then make that explicit by giving the method in the derived class a different name.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:acc14320-9998-4c0b-aa1f-a7ac6e294890" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/c#">c#</a>,<a rel="tag" href="http://technorati.com/tags/.NET">.NET</a>,<a rel="tag" href="http://technorati.com/tags/method%20hiding">method hiding</a>,<a rel="tag" href="http://technorati.com/tags/method%20overriding">method overriding</a>,<a rel="tag" href="http://technorati.com/tags/virtual">virtual</a>,<a rel="tag" href="http://technorati.com/tags/override">override</a>,<a rel="tag" href="http://technorati.com/tags/new">new</a></div>
