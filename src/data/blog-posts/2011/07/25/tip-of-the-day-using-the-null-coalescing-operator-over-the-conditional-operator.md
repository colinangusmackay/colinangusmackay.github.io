---
title: "Tip of the day: Using the null-coalescing operator over the conditional operator"
slug: tip-of-the-day-using-the-null-coalescing-operator-over-the-conditional-operator
publishDate: 25 Jul 2011
description: "I’ve recently been refactoring a lot of code that used the conditional operator and looked something like this: int someValue =..."
tags:
  - { name: "C# 2", slug: c-2 }
  - { name: "C# 3", slug: c-3 }
  - { name: "C# 4", slug: c-4 }
  - { name: "refactoring", slug: refactoring }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I’ve recently been refactoring a lot of code that used the <a href="http://msdn.microsoft.com/en-us/library/ty67wk28.aspx">conditional operator</a> and looked something like this:</p><pre>int someValue = myEntity.SomeNullableValue.HasValue
                    ? myEntity.SomeNullableValue.Value
                    : 0;</pre>
<p>That might seem less verbose than the traditional alternative, which looks like this:</p><pre>int someValue = 0;
if (myEntity.SomeNullableValue.HasValue)
    someValue = myEntity.SomeNullableValue.Value;
</pre>
<p>…or other variations on that theme. </p>
<p>However, there is a better way of expressing this. That is to use the <a href="http://msdn.microsoft.com/en-us/library/ms173224.aspx">null-coalescing operator</a>.</p>
<p>Essentially, what is says is that the value on the left of the operator will be used, unless it is null in which case the value ont the right is used. You can also chain them together which effectively returns the first non-null value.</p>
<p>So now the code above looks a lot more manageable and understandable:</p><pre>int someValue = myEntity.SomeNullableValue ?? 0;</pre>
