---
title: "Entity Framework Tracing Provider: Schema specified is not valid"
slug: entity-framework-tracing-provider-schema-specified-is-not-valid
publishDate: 08 Aug 2011
description: "I've been trying to get the Tracing and Caching Provider Wrappers for Entity Framework working and I ran in to a small problem. It turned out it was actually a..."
tags: []
---
<!-- TODO: convert this post's content to Markdown -->

I've been trying to get the <a href="http://code.msdn.microsoft.com/EFProviderWrappers/Release/ProjectReleases.aspx?ReleaseId=4747">Tracing and Caching Provider Wrappers for Entity Framework</a> working and I ran in to a small problem. It turned out it was actually a silly RTFM issue, but in case you miss out a step here's what happens when it is missed.

In the <code>CreateWrappedMetadataWorkspace</code> method in the <code>EntityConnectionWrapperUtils</code> class a MetadataException is thrown that states:
<blockquote>Schema specified is not valid. Errors:
(0,0) : error 0175: The specified store provider cannot be found in the configuration, or is not valid</blockquote>
<img class="aligncenter" src="http://static.colinmackay.co.uk/images/ef/2011-08-08-entity-connection-wrapper-utils.png" alt="" />

This happens on the line that reads:
<pre>StoreItemCollection sic = new StoreItemCollection(ssdl.Select(c =&gt; c.CreateReader()));</pre>
[Note: <a href="http://connect.microsoft.com/VisualStudio/feedback/details/641947/exception-assistant-highlights-incorrect-line-of-code">Your Exception Assistant may show it on a different line</a> but the stack trace in the exception itself will report correctly.]

What I had missed was some config changes I'd somehow missed out when I was setting up the provider. The missing config is:
<pre>&lt;system.data&gt;
  &lt;DbProviderFactories&gt;
    &lt;add name="EF Caching Data Provider"
         invariant="EFCachingProvider"
         description="Caching Provider Wrapper"
         type="EFCachingProvider.EFCachingProviderFactory, EFCachingProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=def642f226e0e59b" /&gt;
    &lt;add name="EF Tracing Data Provider"
         invariant="EFTracingProvider"
         description="Tracing Provider Wrapper"
         type="EFTracingProvider.EFTracingProviderFactory, EFTracingProvider, Version=1.0.0.0, Culture=neutral, PublicKeyToken=def642f226e0e59b" /&gt;
    &lt;add name="EF Generic Provider Wrapper"
         invariant="EFProviderWrapper"
         description="Generic Provider Wrapper"
         type="EFProviderWrapperToolkit.EFProviderWrapperFactory, EFProviderWrapperToolkit, Version=1.0.0.0, Culture=neutral, PublicKeyToken=def642f226e0e59b" /&gt;
  &lt;/DbProviderFactories&gt;
&lt;/system.data&gt;</pre>
