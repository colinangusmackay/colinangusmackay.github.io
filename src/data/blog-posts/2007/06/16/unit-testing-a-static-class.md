---
title: "Unit Testing a Static Class"
slug: unit-testing-a-static-class
publishDate: 16 Jun 2007
description: "I've been trying to find a way to unit test a static class. That is, a class that has no instances. The problem has been that at the end of one test the..."
tags:
  - { name: "static class", slug: static-class }
  - { name: "unit testing", slug: unit-testing }
---

I've been trying to find a way to unit test a static class. That is, a class that has no instances. The problem has been that at the end of one test the class's state could be altered which would mean that at the start of the next test its state would be unknown. This could lead to buggy unit tests.
The solution, I've found, is to invoke the type initialiser (sometimes known as the "class initialiser", "static initialiser", "static constructor" or "class constructor") using reflection and ensure that all fields are set up there. That way, each unit test run will be starting the static class with a clean state and it no longer matters what the unit test does.
The code to invoke the type initialiser:

```csharp
Type staticType = typeof(StaticClassName);
ConstructorInfo ci = staticType.TypeInitializer;
object[] parameters = new object[0];
ci.Invoke(null, parameters);
```

Ideally, you'd probably want to create the static class as a singleton and have your dependency injection framework resolve it in your application. Then you can create new instances of it in your test to be able to effectively reset the state each test. However, this is not always possible, especially in old or legacy applications.
