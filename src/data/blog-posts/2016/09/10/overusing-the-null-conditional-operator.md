---
title: "Overusing the Null-Conditional Operator"
slug: overusing-the-null-conditional-operator
publishDate: 10 Sep 2016
description: "The null-conditional operator is the ?. between object and field/property/method. It simply says that if the thing on the left hand side is null then the thing..."
tags:
  - { name: "Anti-pattern", slug: anti-pattern }
  - { name: "C#", slug: c }
  - { name: "C# 6", slug: c-6 }
  - { name: "Null-Conditional Operator", slug: null-conditional-operator }
---
<!-- TODO: convert this post's content to Markdown -->

The <a href="https://msdn.microsoft.com/en-us/library/dn986595.aspx">null-conditional operator</a> is the ?. between object and field/property/method. It simply says that if the thing on the left hand side is null then the thing on the right hand side is not evaluated. It is a shorthand, so:
<pre>if (a != null)
{
    a.DoSomething();
}
</pre>
becomes
<pre>a?.DoSomething();</pre>
And that's great. It makes life much simpler, and if you're using ReSharper it will alert you when you could use this operator over a null guard check.

But, and this is quite a big "but", I have noticed a trend to overuse it.

I've seen people do crazy stuff like replace most (almost all) instances of the dot-operator so their code is littered with these question-marks before the dot.
<pre>var result = myObject?.GetSomething()?.SomeValue?.ToString()?.Split()?.Where(s=&gt;s?.Length &gt; 0);</pre>
And when you get to that level of lunacy you're basically turning on the old Visual Basic <code>OnError Resume Next</code> head-in-the-sand error handling anti-pattern.

I want to make this absolutely clear. The null-conditional operator is not bad, per se. However, over using it or using it without thought to the logic of your application is bad as it hides potential bugs.

You should only use it when you would normally do a null check in advance. If ReSharper says you can refactor your code to use it, then it most likely is fine to use (you were probably using a longer construct for the same thing already which implies you've most likely thought about it - No on likes writing reams of code for no good reason).
