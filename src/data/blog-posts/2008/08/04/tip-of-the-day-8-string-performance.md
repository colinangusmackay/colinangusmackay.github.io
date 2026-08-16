---
title: "Tip of the Day - String Performance"
slug: tip-of-the-day-8-string-performance
publishDate: 04 Aug 2008
description: "Concatenating strings in .NET can be very easy. There is the overloaded + operator that makes stringA + stringB + stringC statements very easy to write. But,..."
tags:
  - { name: ".NET", slug: net }
---
Concatenating strings in .NET can be very easy. There is the overloaded + operator that makes `stringA + stringB + stringC` statements very easy to write. But, it isn't very performant. The reason is that strings are immutable, and concatenating strings in this way causes lots of short-lived objects to be created and thrown away, which in turn causes the garbage collector to run frequently.

There are two better ways in .NET to concatenate strings. One is to use the `string.Concat()` method. The other is to use the `StringBuilder` class. They both perform better than adding strings together, but you still have to know when to use each.

According to this article on "[Performance considerations for strings in C#](https://web.archive.org/web/20240702034418/https://www.codeproject.com/Articles/10318/Performance-considerations-for-strings-in-C)"\* `string.Concat()` is good up to 600 strings. But, only if you have 600 strings to concatenate in a single statement. `StringBuilder` is better if you have more than 600 strings to concatenate, but you can do so over multiple statements. In reality, I think the benefits of appending strings over multiple statements with `StringBuilder` will work out better even with much less than 600 strings because to get the performance out of `string.Concat()` you'll have to perform some form of setup operation to line all those strings up - and that will take time.

So, today's tip is don't use the plus operator to combine strings except in quick / throw-away applications. Use `string.Concat()` if you have all the strings set up in advance, or `StringBuilder` instead.

### 🔄 Follow up notes - 16th August 2026

\* Some links have since died, so they have been updated to captures found on the wayback machine. It is an incredibly useful resource and I would highly recommend [donating](https://archive.org/donate) to keep it going. 