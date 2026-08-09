---
title: "The Public Fields debate again"
slug: the-public-fields-debate-again
publishDate: 17 Jun 2006
description: "Back in November last year I wrote about why you should make fields in a class private. Some people still make fields public. I did concede on one argument though..."
tags:
  - { name: "OOP", slug: oop }
  - { name: ".NET", slug: net }
---

Back in November last year I wrote about [why you should make fields in a class private and not make them public](/2005/11/28/why-make-fields-in-a-class-private-why-not-make-them-public). A recent post in Code Project shows that some people still make fields public. I did concede on one argument though - If you have a struct with nothing but public fields then there was no need to make them private and create public properties to back them. But, I added....

As soon as you put any form of functionality in there (or even if you think that at some point in the future there will be some form of functionality in there) then make them private and create properties.

While accessing public fields and properties may look the same to a C# developer, a property is just syntactic sugar over the get_ and set_ methods. So if you make the transition to properties later on (for to add additional functionality - e.g. implementing a lazy look up on a getter, or setting a dirty flag on a setter) any assemblies that relied on public fields will fail because, to them, the public interface of the class is now different.

Therefore if you get in to the habit of creating properties backing your private fields always you'll never have to worry about how you are going to add in additional functionality later on when you realise the public interface changes.