---
title: "Injecting a Dependency into an IHttpModule with Unity"
slug: injecting-a-dependency-into-an-ihttpmodule-with-unity
publishDate: 06 Aug 2013
description: "We’re starting a new project, and as part of that we want to get better at certain things. One is unit testing the things we didn’t last time around that were..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "Dependency Injection", slug: dependency-injection }
  - { name: "IHttpModule", slug: ihttpmodule }
  - { name: "IoC", slug: ioc }
  - { name: "Unity", slug: unity }
---
<!-- TODO: convert this post's content to Markdown -->

<p>We’re starting a new project, and as part of that we want to get better at certain things. One is unit testing the things we didn’t last time around that were in hard-to-reach places. Pretty much most things that interact with ASP.NET have hard-to-reach places. Even ASP.NET MVC, which was supposed to be wonderful and much more unit testable that vanilla ASP.NET, has lots of places where this falls down completely. However, we’re gradually finding way to overcome these obstacles.</p>  <p>In this post, I’m going to concentrate on custom <code>IHttpModule</code> implementations.</p>  <p>We have a custom <code>IHttpModule</code> that requires the services of another class. It is already set up in our IoC container and we just want to inject it into the module we’re writing. However, modules are instantiated by ASP.NET before our IoC framework can get to it.</p>  <p>How I got around this was by creating an additional module (an <code>InjectorModule</code>) that wired up all the other modules that needed dependencies injected using Unity’s <code>BuildUp</code> method to inject the dependency into the existing object.</p>  <h3>Setting up the HttpApplication</h3>  <p>The application object stores the container and implements an interface that the <code>InjectorModule</code> can access the container through.</p>  <pre>public interface IHttpUnityApplication
{
    IUnityContainer UnityContainer { get; } 
}</pre>

<p>And the Application class in the global.asax.cs file looks like this:</p>

<pre>public class MvcApplication : System.Web.HttpApplication, IHttpUnityApplication
{
    // This is static because it is normal for ASP.NET to create
    // several HttpApplication objects (pooling) but only the first
    // will run Application_Start(), which is where this is set.
    private static IUnityContainer _unityContainer;

    protected void Application_Start()
    {
        _unityContainer = UnityBootstrapper.Initialise();
	// Do other initialisation stuff here
    }

    // This implements the IHttpUnityApplication interface
    public IUnityContainer UnityContainer
    {
        get { return _unityContainer; }
    }
}</pre>

<p>The <code>UnityBootstrapper</code> initialises the container for MVC, it is created by <a href="http://www.nuget.org/packages/Unity.Mvc4/">the Unity.Mvc4 NuGet package</a> (there's also a <a href="http://www.nuget.org/packages/Unity.Mvc3/">Unity.Mvc3 package</a> too). You can read more about it <a href="http://www.devtrends.co.uk/blog/introducing-the-unity.mvc3-nuget-package-to-reconcile-mvc3-unity-and-idisposable">here</a>.</p>

<h3>The InjectorModule</h3>

<p>Next up the <code>InjectorModule</code> is created</p>

<pre>public class InjectorModule : IHttpModule
{
    public void Init(HttpApplication context)
    {
        // Get the IoC container from the application class through
        // the common interace.
        var app = (IHttpUnityApplication) context;
        IUnityContainer container = app.UnityContainer;

        // Wire up each module that is registered with the IoC container
        foreach (var module in context.GetRegisteredModules(container))
            container.BuildUp(module.GetType(), module);
    }

    public void Dispose()
    {
    }
}</pre>

<p>I've also been a wee bit sneaky and created an extension method on <code>HttpApplication</code> to work out which are the registered modules so that the code above is a bit nicer. That code is: </p>

<pre>public static class HttpApplicationExtensions
{
    public static IEnumerable GetRegisteredModules(this HttpApplication context, IUnityContainer container)
    {
        var allModules = context.Modules.AllKeys.Select(k =&gt; context.Modules[k]);
        var registeredModules = allModules.Where(m =&gt; container.IsRegistered(m.GetType()));
        return registeredModules;
    }
}</pre>

<h3>Wiring it all up</h3>

<p>The container must be told which modules have dependencies to inject and what properties to set. e.g.</p>

<pre>container.RegisterType&lt;MyCustomModule&gt;(
    new InjectionProperty(&quot;TheDependentProperty&quot;));</pre>

<p><code>MyCustomModule</code> is the class that implements the <code>IHttpModule</code> interface, and you need to supply an <code>InjectionProperty</code> for each of the properties through which the IoC containers will inject a dependency.</p>

<p>You can also decorate the properies with the <code>[Dependency]</code> attribute, but then you are just wiring in a dependency on the IoC container itself... which is not good.</p>

<p>Finally, this new module has to be wired up in the <code>web.config</code> file</p>

<pre>  &lt;system.webServer&gt;
    &lt;modules&gt;
      &lt;add name=&quot;InjectorModule&quot;
           type=&quot;Web.IoC.Unity.InjectorModule&quot; /&gt;
      &lt;!-- Other modules go here, after the Injector Module --&gt;
    &lt;/modules&gt;</pre>

<p>By putting the Injector module ahead of other modules in the web.config it means it gets a chance to run and inject the depedencies into other modules that have yet to be initialised.</p>

<h3>Other considerations </h3>

<p>The <code>IHttpModule</code> interface defines a method, <code>Init()</code>, that takes an <code>HttpApplication</code> as a parameter. Naturally, that's difficult to mock out in a unit test.</p>

<p>What I did was to extract all the bits that I needed in the <code>Init()</code> method and pass them to another method to do the work. For example, <code>HttpContext</code> is easy to do because ASP.NET MVC provides an <code>HttpContextWrapper</code> and the method that is doing all the work just takes an <code>HttpContextBase</code>, which is easily mocked in a unit test.</p>

<pre>public void Init(HttpApplication context)
{
   var wrapper = new HttpContextWrapper(context.Context);
   InitImpl(wrapper);
}
public void InitImpl(HttpContextBase httpContext)
{
    // Do stuff with the HttpContext via the abstract base class
}</pre>
