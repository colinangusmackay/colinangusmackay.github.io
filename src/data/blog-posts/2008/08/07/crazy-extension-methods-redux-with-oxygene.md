---
title: "Crazy Extension Methods Redux (with Oxygene)"
slug: crazy-extension-methods-redux-with-oxygene
publishDate: 07 Aug 2008
description: "Back in April I blogged about a crazy thing you can do with extension methods in C#3.0 . At the time I was adamant that it was a bad idea. I still think it is..."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Extension Methods", slug: extension-methods }
---
<!-- TODO: convert this post's content to Markdown -->

Back in April I blogged about a <a href="http://colinmackay.co.uk/blog/2008/04/16/crazy-extension-method/">crazy thing you can do with extension methods in C#3.0</a>. At the time I was adamant that it was a bad idea. I still think it is a bad idea, however, my thoughts have evolved a little since then and I have, possibly a solution to my hesitance to use said crazy feature.

So, if you can't be bothered to click the link, here is a quick recap. You can create an extension method and call it on a null reference and it will NOT throw a <strong>NullReferenceException</strong> like a real method call would. At the time I was saying it was not best practice because it breaks the semantics of the <a href="http://msdn.microsoft.com/en-gb/library/6zhxzbds.aspx" target="_blank">dot operator</a> which is used for member access.

Last night, I attended an excellent talk by Barry Carr on <a href="http://www.remobjects.com/product/?id={DC0A9947-5FED-4D34-8CC8-F2DCFA87A1FE}" target="_blank">Oxygene</a>, an Object Pascal based language that targets the .NET Framework. Oxygene has a very interesting feature, it has a special operator for dealing with calls on a reference that might be null. If that language can do it, what's so wrong with the functionality that Extension methods potentially give? Semantics. Notice that I said that Oxygene has "a special operator". It doesn't use the dot operator. The dot operator still breaks if the reference is null. It has a <a href="http://wiki.remobjects.com/wiki/Colon_Operator" target="_blank">colon operator</a>. In this case if the reference is null (or nil as it is called in Oxygene) then the call to the method doesn't happen. No exception is thrown.

For example. Here is the code with the regular dot operator:
<pre class="csharpcode"><strong><span class="kwrd">class</span> method ConsoleApp.Main;
<span class="kwrd">var</span>
  myString: String := nil;
begin
  Console.WriteLine(<span class="str">'The string length is {0}'</span>, myString.Length);
  Console.ReadLine();
end;</strong></pre>
And the result is that the <strong>NullReferenceException</strong> is thrown:

<a title="NullReferenceException by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/2741458987/"><img src="http://farm3.static.flickr.com/2233/2741458987_8e2a47474a_o.png" alt="NullReferenceException" width="894" height="333" /></a>

Here is the code with the colon operator:
<pre class="csharpcode"><strong><span class="kwrd">class</span> method ConsoleApp.Main;
<span class="kwrd">var</span>
  myString: String := nil;
begin
  Console.WriteLine(<span class="str">'The string length is {0}'</span>, myString:Length);
  Console.ReadLine();
end;</strong></pre>
And the result is that the program works, it just didn't call the property Length as there was nothing to call it on:

<a title="Result by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/2742296104/"><img src="http://farm4.static.flickr.com/3019/2742296104_c42882aee0_o.png" alt="Result" width="702" height="363" /></a>

At this point I really would like to show you what this looks like in Reflector to show you what is going on under the hood, however, I get a message that says "This item is obfuscated and can not be translated" and the code afterwards isn't quite right. However, the crux of it is like this in C#:

<strong>int? length;</strong>

<strong> </strong>

<strong>if (myString != null)</strong>

<strong>length = myString.Length;</strong>

<strong> </strong>

<strong> </strong>

<strong>Console.WriteLine("The string length is {0}", length);</strong>

Now, back to these extension methods. After seeing this I was thinking that perhaps my total unacceptablity of allowing a null reference to be used with an extension method was perhaps incorrect. In a normal situation with an accidental null reference exception being used the <strong>NullReferenceException</strong> wouldn't be thrown at the point of the method call (after all, the null reference is actually being passed in as the first parameter in an extension method), but somewhere in the method itself. Normal good practice would place a guard block at the start of the method so that it would be caught immediately.

However, what if you wanted to create similar functionality to the colon operator in Oxygene and have it ignore the null reference and do nothing? Well, my advice would be to create a naming convention for your extension methods to show that null references will be ignored. That way you can get the functionality with a slight semantic fudge of the dot operator. Of course, you still have to do the work and set up guard blocks to handle the null situation yourself in the extension method.

Here's an example:
<pre class="csharpcode"><span class="kwrd">class</span> Program
{
    <span class="kwrd">static</span> <span class="kwrd">void</span> Main(<span class="kwrd">string</span>[] args)
    {
        <span class="kwrd">string</span> myString = <span class="kwrd">null</span>;
        Console.WriteLine(<span class="str">"The string length is {0}"</span>, myString.NullableLength());
        Console.ReadLine();
    }
}

<span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">class</span> MyExtensions
{
    <span class="kwrd">public</span> <span class="kwrd">static</span> <span class="kwrd">int</span>? NullableLength(<span class="kwrd">this</span> <span class="kwrd">string</span> target)
    {
        <span class="kwrd">if</span> (target == <span class="kwrd">null</span>)
            <span class="kwrd">return</span> <span class="kwrd">null</span>;
        <span class="kwrd">return</span> target.Length;
    }
}</pre>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:f636dd39-cbf7-49f5-acba-d8eae1c060a7" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/extension%20methods">extension methods</a>,<a rel="tag" href="http://technorati.com/tags/dot%20operator">dot operator</a>,<a rel="tag" href="http://technorati.com/tags/colon%20operator">colon operator</a>,<a rel="tag" href="http://technorati.com/tags/c#">c#</a>,<a rel="tag" href="http://technorati.com/tags/oxygene">oxygene</a>,<a rel="tag" href="http://technorati.com/tags/semantics">semantics</a></div>
