---
title: "Custom error pages and error handling in ASP.NET MVC 3"
slug: custom-error-pages-and-error-handling-in-asp-net-mvc-3-2
publishDate: 02 May 2011
description: "In ASP.NET MVC 3 a new bit of code appeared in the global.asax.cs file: public static void RegisterGlobalFilters(GlobalFilterCollection filters) {..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "ASP.NET MVC 3", slug: asp-net-mvc-3 }
  - { name: "C#", slug: c }
  - { name: "error handling", slug: error-handling }
---
In ASP.NET MVC 3 a new bit of code appeared in the `global.asax.cs` file:

```csharp
public static void RegisterGlobalFilters(GlobalFilterCollection filters)
{
    filters.Add(new HandleErrorAttribute());
}
```

The above method is called from the `Application_Start()` method.

Out of the box, what this does is set up a global filter for handling errors. You can still attribute controller methods or classes as before, but now, if you don’t have a specific `HandleErrorAttribute` attached to the controller method or class then the global one will take over and be processed.

However, you are not going to get custom errors just yet. If you have a bit of code that causes an exception to be thrown that is not caught then you will just end up with the Yellow Screen of Death as before. For example, this code:

```csharp
public class HomeController : Controller
{
    // ...

    public ActionResult About()
    {
        throw new Exception("This is not good. Something bad happened.");
    }
}
```

Will produce this error

![Error Handling - Without Custom Error](/assets/blog/2011-05-02-custom-error-pages-and-error-handling-in-asp-net-mvc-3-2-1.webp)

The missing part of the puzzle is to turn on Custom Errors. This happens in the web.config file. There are three basic options for the mode: “Off” which will show the YSOD to everyone, “RemoteOnly” which shows the YSOD on the local machine (the web server) and the custom error to everyone else, and “On” which shows the custom error to everyone including the local machine.

For development purposes I tend to leave it set to “RemoteOnly” so that I get the YSOD and I get to see what the error is, yet everyone else gets the custom error. However, for developing the actual custom errors themselves we’ll need to set the mode to “On” so we, as developers, get to see the error.

```csharp
<system.web>
  <customErrors mode="On" defaultRedirect=”~/BadError.htm"/>
</system.web>
```

The `defaultRedirect` does not go to a controller action, it is set to a static HTML page that will be displayed if all else goes wrong. This is a final backstop to ensure that the user at least will see something nice event if the error page itself has some issues.

Normally, the error will show the `~/Views/Shared/Error.cshtml` view. However, since the view can throw an exception itself there ought to be a backstop custom error page.

The HandleErrorAttribute defaults to using the view "Error" which will display shared view `~/Views/Shared/Error.cshtml`.

You can change that by setting the view property on the HandleErrorAttrubute, like this:

```csharp
public static void RegisterGlobalFilters(GlobalFilterCollection filters)
{
    filters.Add(new HandleErrorAttribute {View = "MyCustomError"});
}
```

I've set my error view to display the details of the exception for the purposes of this demo.

```html
@model System.Web.Mvc.HandleErrorInfo

@{
    ViewBag.Title = "Error";
}

<h2>
    Sorry, an error occurred while processing your request.
</h2>
<p>Controller = @Model.ControllerName</p>
<p>Action = @Model.ActionName</p>
<p>Message = @Model.Exception.Message</p>
<p>StackTrace :</p>
<pre>@Model.Exception.StackTrace</pre>
```

NOTE: In normal production code you would never expose the details of the exception like this. It represents a considerable security risk and a potential attacker could use the information to gain valuable information about your system in order to construct an attack against it.

Now, if we re-run the same application and go to the About page (handled by the HomeController’s About action) then we will get our custom error page.

### Performing additional actions on an exception

#### Overriding OnException in a Controller

If you want to perform additional actions, rather than just simply show a custom error page, then you can override the OnException method from the Controller class on your own controller derived class. If you want to do this for all controllers then  you may want to create a common base controller that all your controllers inherit from. For example:

```csharp
public class CommonController : Controller
{
    protected override void OnException(ExceptionContext filterContext)
    {
        // Do additional things like logging here.
        base.OnException(filterContext);
    }
}
```

Then in each of your controllers, inherit from this common controller like this:

```csharp
public class HomeController : CommonController
{ ...
```

That will ensure that all your controller have the same functionality.

#### Creating a FilterAttribute

You could alternatively create a `FilterAttribute`. This can provide benefits of providing global functionality if you add it to the global filter collection, or very fine grained functionality if you need it on a few sparse controller actions by adding it as an attribute on the controller action.

The filter may look like this:

```csharp
public class LogExceptionFilterAttribute : FilterAttribute, IExceptionFilter
{
    public void OnException(ExceptionContext filterContext)
    {
        // Log the exception here with your logging framework of choice.
    }
}
```

If you want to have the filter applied to all controller actions, you can set it up in the `RegisterGlobalFilters` method in the `Global.asax.cs` file like this:

```csharp
public static void RegisterGlobalFilters(GlobalFilterCollection filters)
{
    filters.Add(new LogExceptionFilterAttribute());
    filters.Add(new HandleErrorAttribute());
}
```

Or, if you prefer to have finer grained control you can decorate individual controller classes or controller actions with it, like this:

```csharp
[LogExceptionFilter()]
public ActionResult About()
{
    throw new Exception("This is not good. Something bad happened.");
}
```
