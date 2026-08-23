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
We’re starting a new project, and as part of that we want to get better at certain things. One is unit testing the things we didn’t last time around that were in hard-to-reach places. Pretty much most things that interact with ASP.NET have hard-to-reach places. Even ASP.NET MVC, which was supposed to be wonderful and much more unit testable that vanilla ASP.NET, has lots of places where this falls down completely. However, we’re gradually finding way to overcome these obstacles.

In this post, I’m going to concentrate on custom `IHttpModule` implementations.

We have a custom `IHttpModule` that requires the services of another class. It is already set up in our IoC container and we just want to inject it into the module we’re writing. However, modules are instantiated by ASP.NET before our IoC framework can get to it.

How I got around this was by creating an additional module (an `InjectorModule`) that wired up all the other modules that needed dependencies injected using Unity’s `BuildUp` method to inject the dependency into the existing object.

### Setting up the HttpApplication

The application object stores the container and implements an interface that the `InjectorModule` can access the container through.

```csharp
public interface IHttpUnityApplication
{
    IUnityContainer UnityContainer { get; } 
}
```

And the Application class in the global.asax.cs file looks like this:

```csharp
public class MvcApplication : System.Web.HttpApplication, IHttpUnityApplication
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
}
```

The `UnityBootstrapper` initialises the container for MVC, it is created by [the Unity.Mvc4 NuGet package](http://www.nuget.org/packages/Unity.Mvc4/) (there's also a [Unity.Mvc3 package](http://www.nuget.org/packages/Unity.Mvc3/) too). You can read more about it [here](http://www.devtrends.co.uk/blog/introducing-the-unity.mvc3-nuget-package-to-reconcile-mvc3-unity-and-idisposable).

### The InjectorModule

Next up the `InjectorModule` is created

```csharp
public class InjectorModule : IHttpModule
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
}
```

I've also been a wee bit sneaky and created an extension method on `HttpApplication` to work out which are the registered modules so that the code above is a bit nicer. That code is:

```csharp
public static class HttpApplicationExtensions
{
    public static IEnumerable GetRegisteredModules(this HttpApplication context, IUnityContainer container)
    {
        var allModules = context.Modules.AllKeys.Select(k => context.Modules[k]);
        var registeredModules = allModules.Where(m => container.IsRegistered(m.GetType()));
        return registeredModules;
    }
}
```

### Wiring it all up

The container must be told which modules have dependencies to inject and what properties to set. e.g.

```csharp
container.RegisterType<MyCustomModule>(
    new InjectionProperty("TheDependentProperty"));
```

`MyCustomModule` is the class that implements the `IHttpModule` interface, and you need to supply an `InjectionProperty` for each of the properties through which the IoC containers will inject a dependency.

You can also decorate the properies with the `[Dependency]` attribute, but then you are just wiring in a dependency on the IoC container itself... which is not good.

Finally, this new module has to be wired up in the `web.config` file

```xml
<system.webServer>
  <modules>
    <add name="InjectorModule"
         type="Web.IoC.Unity.InjectorModule" />
    <!-- Other modules go here, after the Injector Module -->
  </modules>
```

By putting the Injector module ahead of other modules in the web.config it means it gets a chance to run and inject the depedencies into other modules that have yet to be initialised.

### Other considerations

The `IHttpModule` interface defines a method, `Init()`, that takes an `HttpApplication` as a parameter. Naturally, that's difficult to mock out in a unit test.

What I did was to extract all the bits that I needed in the `Init()` method and pass them to another method to do the work. For example, `HttpContext` is easy to do because ASP.NET MVC provides an `HttpContextWrapper` and the method that is doing all the work just takes an `HttpContextBase`, which is easily mocked in a unit test.

```csharp
public void Init(HttpApplication context)
{
   var wrapper = new HttpContextWrapper(context.Context);
   InitImpl(wrapper);
}
public void InitImpl(HttpContextBase httpContext)
{
    // Do stuff with the HttpContext via the abstract base class
}
```
