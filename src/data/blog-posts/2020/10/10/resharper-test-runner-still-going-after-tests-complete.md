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
<!-- TODO: convert this post's content to Markdown -->

<!-- wp:paragraph -->
<p>I've been writing some tests and I got this message:</p>
<!-- /wp:paragraph -->

<!-- wp:image {"id":13617,"sizeSlug":"large","linkDestination":"media"} -->
<figure class="wp-block-image size-large"><a href="https://colinmackay.scot/wp-content/uploads/2020/10/image.png"><img src="https://colinmackay.scot/wp-content/uploads/2020/10/image.png?w=563" alt="" class="wp-image-13617" /></a></figure>
<!-- /wp:image -->

<!-- wp:quote -->
<blockquote class="wp-block-quote"><p><strong>[RIDER LOGO] Unit Test Runner</strong></p><p>The process ReSharperTestRunner64:26252 has finished running tests assigned to it, but is still running.</p><p>Possible reasons are incorrect asynchronous code or lengthy test resource disposal. If test cleanup is expected to be slow, please extend the wait timout in the Unit Testing options page.</p></blockquote>
<!-- /wp:quote -->

<!-- wp:paragraph -->
<p>It turns out that because I was setting up an <code>IHost</code> as part of my test (via a <code>WebApplicationFactory</code>) that it was what was causing issues. Normally, it would hang around until the application is told to terminate, but nothing in the tests was telling it to terminate.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>The culprit was this line of code:</p>
<!-- /wp:paragraph -->

<!-- wp:code -->
<pre class="wp-block-code"><code>var factory = new WebApplicationFactory&lt;Startup&gt;<strong>()</strong>.WithWebHostBuilder();</code></pre>
<!-- /wp:code -->

<!-- wp:paragraph -->
<p>The <code>factory</code> is disposable and I wasn't calling <code>Dispose()</code> explicitly, or implicitly via a <code>using</code> statement.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>The fix to this was simply to wrap the returned <code>WebApplicationFactory&lt;T&gt;</code> in a using block and the test running completed in a timely manner at the end of the tests.</p>
<!-- /wp:paragraph -->

<!-- wp:code -->
<pre id="block-ba0cf4d7-e91d-49ea-94a4-c9b0c3c3fb5f" class="wp-block-code"><code>using var factory = new WebApplicationFactory&lt;Startup&gt;<strong>()</strong><br>     .WithWebHostBuilder();</code></pre>
<!-- /wp:code -->

<!-- wp:paragraph -->
<p>or, if by preference, or using an older version of C#:</p>
<!-- /wp:paragraph -->

<!-- wp:code -->
<pre class="wp-block-code"><code>using (var factory = new WebApplicationFactory&lt;Startup&gt;<strong>()</strong>.WithWebHostBuilder())<br>{<br>    // do stuff with the factory<br>}</code></pre>
<!-- /wp:code -->

<!-- wp:paragraph -->
<p>Although this was running in JetBrains Rider, it uses ReSharper under the hood, so I'm assuming this issue happens with ReSharper running in Visual Studio too.</p>
<!-- /wp:paragraph -->
