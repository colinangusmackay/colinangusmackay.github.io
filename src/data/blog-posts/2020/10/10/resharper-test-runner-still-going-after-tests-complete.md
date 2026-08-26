---
title: "ReSharper test runner still going after tests complete"
slug: resharper-test-runner-still-going-after-tests-complete
publishDate: 10 Oct 2020
description: "I've been writing some tests and I got this message: [RIDER LOGO] Unit Test Runner The process ReSharperTestRunner64:26252 has finished running tests assigned..."
tags:
  - { name: "C#", slug: c }
  - { name: "IDisposable", slug: idisposable }
  - { name: "IHost", slug: ihost }
  - { name: "JetBrains Rider", slug: jetbrains-rider }
  - { name: "R#", slug: r }
  - { name: "ReSharper", slug: resharper }
  - { name: "Rider", slug: rider }
  - { name: "testing", slug: testing }
  - { name: "unit testing", slug: unit-testing }
  - { name: "WebApplicationFactory", slug: webapplicationfactory }
---
I've been writing some tests and I got this message:

![](/assets/blog/2020-10-10-resharper-test-runner-still-going-after-tests-complete-1.webp)

> **\[RIDER LOGO\] Unit Test Runner**
>
> The process ReSharperTestRunner64:26252 has finished running tests assigned to it, but is still running.
>
> Possible reasons are incorrect asynchronous code or lengthy test resource disposal. If test cleanup is expected to be slow, please extend the wait timout in the Unit Testing options page.

It turns out that because I was setting up an `IHost` as part of my test (via a `WebApplicationFactory`) that it was what was causing issues. Normally, it would hang around until the application is told to terminate, but nothing in the tests was telling it to terminate.

The culprit was this line of code:

```csharp
var factory = new WebApplicationFactory<Startup>().WithWebHostBuilder();
```

The `factory` is disposable and I wasn't calling `Dispose()` explicitly, or implicitly via a `using` statement.

The fix to this was simply to wrap the returned `WebApplicationFactory<T>` in a using block and the test running completed in a timely manner at the end of the tests.

```csharp
using var factory = new WebApplicationFactory<Startup>()
     .WithWebHostBuilder();
```

or, if by preference, or using an older version of C#:

```csharp
using (var factory = new WebApplicationFactory<Startup>().WithWebHostBuilder())
{
    // do stuff with the factory
}
```

Although this was running in JetBrains Rider, it uses ReSharper under the hood, so I'm assuming this issue happens with ReSharper running in Visual Studio too.
