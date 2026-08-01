---
title: "Join Null Check with Assignment"
slug: join-null-check-with-assignment
publishDate: 16 Jul 2017
description: "I recently wrote some code and asked ReSharper to add a null check for me, which it did. Then it suggested that I could simplify the null check by joining it..."
tags:
  - { name: "C#", slug: c }
  - { name: "C# 7", slug: c-7 }
  - { name: "null-coalescing operator", slug: null-coalescing-operator }
  - { name: "R#", slug: r }
  - { name: "ReSharper", slug: resharper }
  - { name: "throw-expression", slug: throw-expression }
  - { name: "visual studio 2015", slug: visual-studio-2015 }
---
<!-- TODO: convert this post's content to Markdown -->

<img class="alignnone size-full wp-image-13364" src="https://colinmackay.scot/wp-content/uploads/2017/07/2017-07-16-join-null-check-with-assignment.png" alt="2017-07-16-join-null-check-with-assignment" width="1017" height="194" />

I recently wrote some code and asked ReSharper to add a null check for me, which it did. Then it suggested that I could simplify the null check by joining it to the assignment.

Intrigued, I let it.

The code went from this:
<pre>public void SetMessage(string message)
{
    if (message == null) throw new ArgumentNullException(nameof(message));
    Message = message;
}
</pre>
To this:
<pre>public void SetMessage(string message)
{
    Message = message ?? throw new ArgumentNullException(nameof(message));
}
</pre>
So, I assign <code>message</code> to the property <code>Message</code> unless it is <code>null</code> in which case I throw the exception. This is a new feature in C# 7 called a "throw expression".

At first glance, I thought it would still assign null to <code>Message</code> before throwing the exception, but that's not what the code looks like underneath.

I got out my trusty dotPeek to see what it actually compiled to. (Don't worry, I'm not going to show you IL, just what the C# looks like without the syntactic sugar). The result was this:
<pre>public void SetMessage(string message)
{
  string str = message;
  if (str == null)
    throw new ArgumentNullException("message");
  this.Message = str;
}
</pre>
Excellent, it is still doing the <code>null</code> check in advance. So the semantics of what I wrote have not changed. That's great. I learned something new today.
<h3>But...</h3>
ReShaper also suggested it in an overloaded version of that function that takes two parameters. And the result was not semantically equivalent. So, be careful. Here's what happened there. I started with this:
<pre>public void SetMessage(string message, string transitionMessage)
{
    if (message == null) throw new ArgumentNullException(nameof(message));
    if (transitionMessage == null) throw new ArgumentNullException(nameof(transitionMessage));

    Message = message;
    TransitionMessage = transitionMessage;
}</pre>
Let ReSharper refactor to this:
<pre>public void SetMessage(string message, string transitionMessage)
{
    Message = message ?? throw new ArgumentNullException(nameof(message));
    TransitionMessage = transitionMessage ?? throw new ArgumentNullException(nameof(transitionMessage));
}</pre>
And, I'm beginning to get a little apprehensive at this point because I think I see a problem. In fact, when I look at it in dotPeek, I can see exactly what the issue is. Here's the same code with the syntactic sugar removed:
<pre>public void SetMessage(string message, string transitionMessage)
{
  string str1 = message;
  if (str1 == null)
    throw new ArgumentNullException("message");
  this.Message = str1;
  string str2 = transitionMessage;
  if (str2 == null)
    throw new ArgumentNullException("transitionMessage");
  this.TransitionMessage = str2;
}
</pre>
It does the first <code>null</code> check, then assigns to the <code>Message</code> property. Then it does the second <code>null</code> check... And that's not what I want at all. This method should be an all or nothing proposition. Either both properties are set, or neither are changed and this isn't the case any more.

<strong>Caveat Programmator</strong>, as they say in Latin.
