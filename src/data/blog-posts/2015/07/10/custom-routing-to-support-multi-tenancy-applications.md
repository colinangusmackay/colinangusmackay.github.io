---
title: "Custom routing to support multi-tenancy applications"
slug: custom-routing-to-support-multi-tenancy-applications
publishDate: 10 Jul 2015
description: "The company I currently work for has many brands so they are looking for a website that can be restyled for each brand. They also want the styling information..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "custom route", slug: custom-route }
  - { name: "handlers", slug: handlers }
  - { name: "IIS", slug: iis }
  - { name: "IRouteHandler", slug: iroutehandler }
  - { name: "multi-tenancy", slug: multi-tenancy }
  - { name: "RequestContext", slug: requestcontext }
  - { name: "RouteValueDictionary", slug: routevaluedictionary }
  - { name: "system.webServer", slug: system-webserver }
  - { name: "web.config", slug: web-config }
---
The company I currently work for has many brands so they are looking for a website that can be restyled for each brand. They also want the styling information to be managed through an admin area rather than have to go to the development team each time they want to change something.

To that end I have added some custom routing into the application to allow assets to be delivered via a controller yet have the URL look like a path to a file on disk.

The summary of the steps involved are:

- Set up a custom route with a custom route handler
- Build the logic in the custom route handler to ensure that the data is passed to the controller correctly.
- Update the `web.config` file to tell IIS to allow certain paths through to ASP.NET MVC that would otherwise look like a static path.

### Setting up the custom route

My custom route is inside an area to keep all tenant specific URLs separate from the rest of the application.

```csharp
public override void RegisterArea(AreaRegistrationContext context) 
{
    context.MapRoute(
        "Tenant_customLogic",
        "Tenant/{tenant}/content/{*contents}",
        new { action = "Index", controller="Content"}
    ).RouteHandler = new TenantRouteHandler();
}
```

So, this means that the routing engine can extract the "tenant" from the URL and it will also allow multiple path parts in the "contents" value. So, if the URL is: `http://example.com/Tenant/MyBrand/content/my/virtual/file/path/to/styles.css` then the `RouteValueDictionary` will contain:

- tenant: MyBrand
- controller = Content
- action = Index
- contents = my/virtual/file/path/to/styles.css

However, we want to split up the contents into its individual components, so a `TenantRouteHandler` class is created to do that.

### Build the custom route handler

Without going too much in to what this class does in this specific instance (which isn't relevant to the general concept) the basics are

- Create a class that implements IRouteHandler
- In `GetHttpHandler` process the routing information to get what we want in a format that suits the application.
- Create a regular `IRouteHandler` object (normally an `MvcRouteHandler`) and call its `GetHttpHandler()` method with the updated `requestContext` as I otherwise want the same functionality as a regular handler.

```csharp
public class TenantRouteHandler : IRouteHandler
{
    private readonly Func<IRouteHandler> _routeHandlerFactory;
 
    public TenantRouteHandler()
    {
        _routeHandlerFactory = ()=> new MvcRouteHandler();
    }

    public TenantRouteHandler(Func<IRouteHandler> routeHandlerFactory)
    {
        _routeHandlerFactory = routeHandlerFactory;
    }

    public IHttpHandler GetHttpHandler(RequestContext requestContext)
    {
        ProcessRoute(requestContext); // does stuff to modify the request context
        IRouteHandler handler = _routeHandlerFactory();
        return handler.GetHttpHandler(requestContext);
    }
}
```

`ProcessRoute(requestContext)` is the specific implementation that extracts the information out of the route and I then add it back into the `RouteValueDictionary` so my controller can access it. It isn't relevant so I'm not including it.

What I also do here (because ASP.NET MVC, despite being launched in 2009 to a fanfare of being easy to unit test, isn't east to unit test at all) is also set up some functional hooks that I can use in unit testing. The default constructor simply sets up the strategy to return a regular `MvcRouteHandler` and that's the constructor that will be used in production. The other constructor is used in unit tests so that I can inject my own handler that doesn't need tons of MVC infrastructure to be set up in advance.

So, the contents part of the route is now split out as we need it for the application.

### Getting IIS to pass through these routes to ASP.NET MVC

Running the application at this point won't return anything. In fact, IIS will throw up an error page that it cannot find the file. The expected paths all look like static content, which IIS thinks it is best placed to deal with. However, the web.config can be updated to let IIS know that certain paths have to be passed through to ASP.NET MVC for processing.

Once the following is added to the web.config everything should work as expected.

```xml
  <system.webServer>
    <handlers>
      <!-- This is required for the multi-tenancy part so it can serve virtual files that don't exist on the disk -->
      <add
        name="TenantVirtualFiles"
        path="Tenant/*"
        verb="GET"
        type="System.Web.Handlers.TransferRequestHandler"
        preCondition="integratedMode" />
    </handlers>
  </system.webServer>
```

And that's it. Everything should work now. Anything in the Tenant/\* path will be processed by ASP.NET MVC and the controller will decide what to serve up to the browser.
