---
title: "IDisposable objects with StructureMap and ASP.NET MVC 4"
slug: idisposable-objects-with-structuremap-and-asp-net-mvc-4
publishDate: 21 Dec 2012
description: "I’ve recently discovered a bit of an issue with running an IoC container with ASP.NET MVC’s IDependencyResolver . If you have a controller that has..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "ASP.NET MVC 4", slug: asp-net-mvc-4 }
  - { name: "IDisposable", slug: idisposable }
  - { name: "IoC", slug: ioc }
  - { name: "StructureMap", slug: structuremap }
---
I’ve recently discovered a bit of an issue with running an IoC container with ASP.NET MVC’s `IDependencyResolver`. If you have a controller that has dependencies on things that implement `IDisposable` then the dispose method was not being called.

Apparently, if the controller itself is disposable then MVC will clean that up and that can obviously clean up any dependencies that it created and are also disposable. However, if you are injecting the dependency then the controller should not really be disposing of those dependencies because it did not create them as it has no knowledge of the lifecycle of those objects – the owner (the object that created the dependency) is really responsible for disposing of its objects.

So, the responsible party for disposing of the is what ever created it. However, in MVC 4 the Service Locator has no way of disposing downstream objects that get created when instantiating the controller, it only deals with the controller directly, so if a downstream object that the controller depends on needs to be disposed then the IoC container has to manage that. [Mike Hadlow](http://mikehadlow.blogspot.co.uk/) has a much better explanation of what is going on here and his dealings with using, specifically, [Castle Windsor and the IDepenencyResolver](http://mikehadlow.blogspot.co.uk/2011/02/mvc-30-idependencyresolver-interface-is.html).

Since I’m using [StructureMap](http://docs.structuremap.net/), it does have a way of helping you clean up.

For example, in the Initialisation expression that the `ObjectFactory.Initialize` uses I’ve got a repository set up like this:

```
x.For<IRepository>().HttpContextScoped().Use<Repository>();
```

This creates a new Repository for each request that the MVC application receives. However, this on its own is not enough because it means that while each request gets a new repository, none of the resources of these repository objects are being cleaned up because it never releases them. Eventually those resources will run out, be they database connections, file handles, or what ever the repository needs to use.

You can put in your Global.asax.cs file a method called `Application_EndRequest()` which is called at the end of each request. Or, if you already have one you can simply add this line of code to it.

```
protected void Application_EndRequest()
{
  ObjectFactory.ReleaseAndDisposeAllHttpScopedObjects();
}
```
