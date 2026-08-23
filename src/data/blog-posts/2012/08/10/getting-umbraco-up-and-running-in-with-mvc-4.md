---
title: "Getting umbraco up and running in with MVC 4"
slug: getting-umbraco-up-and-running-in-with-mvc-4
publishDate: 10 Aug 2012
description: "In this post, I'll look at getting Umbraco and MVC to play nice with each other in the same project. Installing Umbraco 4.8 First off create a Web Application..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "ASP.NET MVC 4", slug: asp-net-mvc-4 }
  - { name: "Umbraco", slug: umbraco }
  - { name: "Umbraco 4.8", slug: umbraco-4-8 }
---
<!-- ISSUE: link (http://www.aaron-powell.com/umbraco/using-mvc-in-umbraco-4): status 404 -->

In this post, I'll look at getting Umbraco and MVC to play nice with each other in the same project.

### Installing Umbraco 4.8

First off create a Web Application project in Visual Studio. For this example, I'm just going to create the project as "UmbMvc".

![Visual Studio 2010: New Project](/assets/blog/2012-08-10-getting-umbraco-up-and-running-in-with-mvc-4-1.webp)

Once Visual Studio has created the project, delete most of its content. We're doing this because we don't have fully empty projects. If you were doing this in VS 2012 you could have selected the Empty Web Application project instead.
The Solution explorer should look like this when your done:

![Solution Explorer](/assets/blog/2012-08-10-getting-umbraco-up-and-running-in-with-mvc-4-2.webp")

Next up, Umbraco has to be installed. This can be done with NuGet. I used the Package Manager Console, which can be accessed from the Tools menu:

![NuGet Package Manager Console](/assets/blog/2012-08-10-getting-umbraco-up-and-running-in-with-mvc-4-3.webp)

Then typed `Install-Package UmbracoCms` to install the package and its dependencies. The output looks like this:

```pwsh
PM> Install-Package UmbracoCms
'UmbracoCms.Core (= 4.8.0)' not installed. Attempting to retrieve dependency from source...
Done.
Successfully installed 'UmbracoCms.Core 4.8.0'.
Successfully installed 'UmbracoCms 4.8.0'.
Successfully added 'UmbracoCms.Core 4.8.0' to UmbMvc.
'web.config' already exists. Skipping...
Successfully added 'UmbracoCms 4.8.0' to UmbMvc.
```

Don't worry about the message about `web.config`. It will write the necessary detail into the web.config file for you.

If you prefer to use the NuGet dialog, you can search for "UmbracoCms" and install the package from there. It will download and install the dependencies for you there too.

![NuGet Package Manager Dialog](/assets/blog/2012-08-10-getting-umbraco-up-and-running-in-with-mvc-4-4.webp)

At this point you can run up Umbraco to configure it and set the databases up and so on. When you've finished this process you'll arrive at the Umbraco administration area. At this point you want to stop the app from running in Visual Studio.

### Wiring up MVC 4

Next up is to get MVC installed. For this I'm taking the advice on [Aaron Powell's blog](https://web.archive.org/web/20120815140347/https://www.aaron-powell.com/umbraco/using-mvc-in-umbraco-4), so go visit there for the detail. (Start at the section marked "Getting MVC installed"). I've added my own notes below for some differences I found between our experiences.
Installing ASP.NET at the time of writing installs MVC 4:

```pwsh
PM> install-package microsoft.aspnet.mvc
'Microsoft.AspNet.WebPages (= 2.0.20505.0)' not installed. Attempting to retrieve dependency from source...
Done.
'Microsoft.Web.Infrastructure (= 1.0.0.0)' not installed. Attempting to retrieve dependency from source...
Done.
'Microsoft.AspNet.Razor (= 2.0.20505.0)' not installed. Attempting to retrieve dependency from source...
Done.
Successfully installed 'Microsoft.Web.Infrastructure 1.0.0.0'.
Successfully installed 'Microsoft.AspNet.Razor 2.0.20505.0'.
Successfully installed 'Microsoft.AspNet.WebPages 2.0.20505.0'.
Successfully installed 'Microsoft.AspNet.Mvc 4.0.20505.0'.
Successfully added 'Microsoft.Web.Infrastructure 1.0.0.0' to UmbMvc.
Successfully added 'Microsoft.AspNet.Razor 2.0.20505.0' to UmbMvc.
Successfully added 'Microsoft.AspNet.WebPages 2.0.20505.0' to UmbMvc.
Successfully added 'Microsoft.AspNet.Mvc 4.0.20505.0' to UmbMvc.
```

Because of the way paths work in Umbraco, I was either going to have to reserve every controller and area name in the umbracoReservedPaths configuration element, or create a prefix. I decided it was probably best to create a prefix, that way I only have to modify the config once and everything else simply works after that. So, my `RouteSetup` class looked like this:

```csharp
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

[assembly: PreApplicationStartMethod(typeof(UmbMvc.App_Start.RouteSetup), "Setup")]
namespace UmbMvc.App_Start
{
  public class RouteSetup
  {
     public static void Setup()
     {
       RouteTable.Routes.MapRoute(
         "Default", // Route name
         "x/{controller}/{action}/{id}", // URL with parameters
         new {controller = "Home", action = "Index", id = UrlParameter.Optional} // Parameter defaults
         );
     }
  }
}
```

Note the "x" at the start of the URL part of the route.
My `umbracoReservedPaths` config element now looks like this:

```xml
<!-- Remember to add into the umbracoReservedPaths every route that MVC wants to take. 
     It may be better to create a prefix so you only have to do this the once.-->
<add key="umbracoReservedPaths" value="~/umbraco,~/install/,~/x" />
```

### Fixing up the web.config file

From Aaron's blog post, I still couldn't quite get it to work. I got an error message that read: **Compiler Error Message: CS0234: The type or namespace name 'Helpers' does not exist in the namespace 'System.Web' (are you missing an assembly reference?)**
I found that I needed to add the following to the `<assemblies>` section of the web.config file:

```xml
<add assembly="System.Web.WebPages, Version=2.0.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35" />
<add assembly="System.Web.Helpers, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35" />
```

That helped, but I was still getting error an error message. This time it was **Compiler Error Message: CS0234: The type or namespace name 'Ajax' does not exist in the namespace 'System.Web.Mvc' (are you missing an assembly reference?)**

I found that I also needed to set the reference to `System.Web.Mvc` to "Copy Local"

![Visual Studio 2010: System.Web.Mvc Copy Local](/assets/blog/2012-08-10-getting-umbraco-up-and-running-in-with-mvc-4-5.webp)

Then when I ran the application and went to the URL `http://localhost:60445/x/Home`, I got a page back that said: **Hello I'm a razor view.**

This is finally what I expected.

### Fixing up the project type.

One last thing, Aaron also mentions that you'll get various errors in the views in Visual Studio because the project type was a Web Application not an MVC Web Appliction project. Although it doesn't stop the application from running correctly, it is very disconcerting to see. He doesn't give a solution to that. To solve this, you need to add a GUID in the csproj file.

To do this, you need to right click on the web project and click "Unload Project", when it has unloaded, right-click again and click "Edit xxx.csproj".

Look for the element named "ProjectTypeGuids" and add in the guid: **{E3E379DF-F4C6-4180-9B81-6769533ABE47}**. The whole line should now read:

```xml
<ProjectTypeGuids>{E3E379DF-F4C6-4180-9B81-6769533ABE47};{349c5851-65df-11da-9384-00065b846f21};{fae04ec0-301f-11d3-bf4b-00c04f79efbc}</ProjectTypeGuids>
```

Save the file, then right-click the project in the solution and click "Reload project". It will prompt you to close the text version of the project file, and then the project will be loaded back. Now you should not have any issues with the views finding false errors, such as not being able to resolve `ViewBag`.
