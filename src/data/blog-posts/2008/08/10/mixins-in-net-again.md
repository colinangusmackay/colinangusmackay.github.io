---
title: "Mixins in .NET (again)"
slug: mixins-in-net-again
publishDate: 10 Aug 2008
description: "A while ago I wrote about Mixins in C# 3.0 , at the time I was saying that you can get some of the functionality, but not all, from some of the new language..."
tags:
  - { name: "C#", slug: c }
  - { name: "design patterns", slug: design-patterns }
---
<!-- TODO: convert this post's content to Markdown -->

A while ago I wrote about <a href="http://colinmackay.co.uk/blog/2008/02/24/mixins-in-c-30/">Mixins in C# 3.0</a>, at the time I was saying that you can get some of the functionality, but not all, from some of the new language features in C#3.0. The solution is a bit of a fudge because the language doesn't support the concept. I've been looking at <a href="http://www.remobjects.com/product/page.asp?id={E10F7F5C-AE94-4833-9E4B-2EDD5ED69768}" target="_blank">Oxygene</a> recently and it has some language features that go a bit further than C# does and will support greater mixin-like functionality which it calls interface delegation.

Interface delegation is again a bit of a fudge, but not quite like C#. In this case the language supports this mixin-like functionality and the fudge happens in the compiler. Let's take the class hierarchy that I used the last time:

<a title="Class-Diagram-2 by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/2287423942/"><img src="http://farm3.static.flickr.com/2112/2287423942_1be2458fac_o.png" alt="Class-Diagram-2" width="658" height="405" /></a>

In Oxygene the Dog class looks like this:
<pre class="csharpcode"><span class="kwrd">interface</span>

type
  Dog = <span class="kwrd">public</span> <span class="kwrd">class</span>(Mammal, IRun, ISwim)
  <span class="kwrd">private</span>
      runInterfaceDelegate : RunMixin; implements IRun;
      swimInterfaceDelegate : SwimMixin; implements ISwim;
  <span class="kwrd">protected</span>
  <span class="kwrd">public</span>
  end;

implementation

end.</pre>
From this we can see that <strong>Dog</strong> inherits from <strong>Mammal</strong> and implements <strong>IRun</strong> and <strong>ISwim</strong>. The <strong>IRun</strong> interface has one method (<strong>Run</strong>), and the <strong>ISwim</strong> interface has only one method also (<strong>Swim</strong>). Of course, there could be as many methods and properties as you like.

The C# version of the Dog class, as produced by Reflector, looks like this:
<pre class="csharpcode"><span class="kwrd">public</span> <span class="kwrd">class</span> Dog : Mammal, IRun, ISwim
{
    <span class="rem">// Fields</span>
    <span class="kwrd">private</span> RunMixin runInterfaceDelegate;
    <span class="kwrd">private</span> SwimMixin swimInterfaceDelegate;

    <span class="rem">// Methods</span>
    <span class="kwrd">void</span> IRun.Run()
    {
        <span class="kwrd">this</span>.runInterfaceDelegate.Run();
    }

    <span class="kwrd">void</span> ISwim.Swim()
    {
        <span class="kwrd">this</span>.swimInterfaceDelegate.Swim();
    }
}</pre>
As you can see, there are two private fields holding a reference to the appropriate mixin, in each of the methods the responsibility for carrying out the action is delegated to the appropriate surrogate mixin object.

What you will also notice is that you still have to instantiate the surrogate mixin objects. Under normal circumstances that would be in the constructor. If it were a real mixin you wouldn't have the option as the mixin would be created at the same time as the object it is used with. In fact, the mixin would be <em>mixed in</em> as part of the object itself. So, perhaps interface delegates gives you slightly greater power than with a real mixin as you could reuse the surrogate mixin object. Then again, would you want to? I've not been able to think of a scenario where I would, but perhaps it could be useful.

I'd like to see interface delegates in C# at some point in the future (sooner rather than later). In fact, I'd like to see proper mixin functionality, but I recon that will require changes to the CLR to support multiple inheritance. In the meantime, I think I'll have to write some sort of snippet in C# to quickly generate the code that Oxygene gives me in one line. Either that or start writing in Oxygene... Now, there's a thought!
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:c4866e66-ce36-4e3d-a1b1-4a4c4b588b76" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/Oxygene">Oxygene</a>,<a rel="tag" href="http://technorati.com/tags/C#">C#</a>,<a rel="tag" href="http://technorati.com/tags/interface%20delegates">interface delegates</a>,<a rel="tag" href="http://technorati.com/tags/mixin">mixin</a></div>
