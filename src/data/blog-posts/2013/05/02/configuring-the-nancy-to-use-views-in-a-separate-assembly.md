---
title: "Configuring Nancy to use views in a separate assembly"
slug: configuring-the-nancy-to-use-views-in-a-separate-assembly
publishDate: 02 May 2013
description: "I’m in the process of setting up a Nancy application that will run in ASP.NET on IIS and on Ubuntu (using Mono). As a result I put the main Nancy application..."
tags:
  - { name: "Mono", slug: mono }
  - { name: "NancyFX", slug: nancyfx }
  - { name: "Ubuntu", slug: ubuntu }
  - { name: "xbuild", slug: xbuild }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I’m in the process of setting up a Nancy application that will run in ASP.NET on IIS and on Ubuntu (using Mono). As a result I put the main Nancy application into an assembly all of its own and created two host assemblies, one for each environment.</p>  <p>I found pretty quickly that it was a real pain to get the <code>FileSystemViewLocationProvider</code> to work properly in this scenario without a lot of futzing about… and I don’t like it when you have to manually mess around with thing just to get an application deployed properly, or even just running in the debugger.</p>  <p>My solution was to use the <code>ResourceViewLocationProvider</code> instead and just have the views added as resources to the assembly.</p>  <p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nancy/2013-05-01-view-as-a-resource.png" /></p>  <p>I also created a custom bootstrapper for my application so that it would know to pick up the resources instead of the files.</p>  <pre>using Nancy;
using Nancy.Bootstrapper;
using Nancy.TinyIoc;
using Nancy.ViewEngines;
using Nancy.ViewEngines.Razor;

namespace HelloWorld.Web
{
  public class HelloWorldBootstrapper : DefaultNancyBootstrapper
  {
    protected override void ConfigureApplicationContainer(TinyIoCContainer container)
    {
      base.ConfigureApplicationContainer(container);

      // Configure the resource view location provider
      var assembly = GetType().Assembly;
      ResourceViewLocationProvider
          .RootNamespaces
          .Add(assembly, &quot;HelloWorld.Web.Views&quot;);
    }
    protected override void ApplicationStartup(TinyIoCContainer container, IPipelines pipelines)
    {
      StaticConfiguration.CaseSensitive = true;
      StaticConfiguration.DisableErrorTraces = false;
      StaticConfiguration.EnableRequestTracing = true;
      base.ApplicationStartup(container, pipelines);
    }
    protected override NancyInternalConfiguration InternalConfiguration
    {
      get
      {
        var result = NancyInternalConfiguration
          .WithOverrides(nic =&gt; nic.ViewLocationProvider = typeof (ResourceViewLocationProvider));
        return result;
      }
    }

    protected override System.Collections.Generic.IEnumerable ViewEngines
    {
      get 
      { 
        yield return typeof (RazorViewEngine);
      }
    }
  }
}</pre>

<p>I also found that adding the Razor view engine via NuGet also adds <a href="https://github.com/NancyFx/Nancy/issues/1082">a post build action to the project file which doesn’t work in Ubuntu</a>. I had to strip that out to allow the build to work, however, since my bootstrapper explicitly references to the <code>RazorViewEngine</code> the file is copied by the build engine to the output directory anyway.</p>
