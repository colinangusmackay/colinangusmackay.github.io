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
<!-- TODO: convert this post's content to Markdown -->

In this post, I'll look at getting Umbraco and MVC to play nice with each other in the same project.
<h3>Installing Umbraco 4.8</h3>
First off create a Web Application project in Visual Studio. For this example, I'm just going to create the project as "UmbMvc".

[caption id="" align="aligncenter" width="600"]<img title="Visual Studio 2010: New Project" src="http://static.colinmackay.co.uk/images/umbraco/2012-08-10-CreateWebApplication-600.png" alt="Visual Studio 2010: New Project" width="600" height="415" /> Visual Studio 2010: New Project[/caption]

Once Visual Studio has created the project, delete most of its content. We're doing this because we don't have fully empty projects. If you were doing this in VS 2012 you could have selected the Empty Web Application project instead.

The Solution explorer should look like this when your done:

[caption id="" align="aligncenter" width="325"]<img title="Visual Studio 2010: Solution Explorer" src="http://static.colinmackay.co.uk/images/umbraco/2012-08-10-SolutionExplorer.png" alt="Visual Studio 2010: Solution Explorer" width="325" height="187" /> Visual Studio 2010: Solution Explorer[/caption]

Next up, Umbraco has to be installed. This can be done with NuGet. I used the Package Manager Console, which can be accessed from the Tools menu:

[caption id="" align="aligncenter" width="586"]<img title="Visual Studio: NuGut Package Manager Console" src="http://static.colinmackay.co.uk/images/umbraco/2012-08-10-NuGetPackageManagerConsole.png" alt="Visual Studio: NuGut Package Manager Console" width="586" height="533" /> Visual Studio: NuGut Package Manager Console[/caption]

Then typed <code>Install-Package UmbracoCms</code> to install the package and its dependencies. The output looks like this:
<pre>PM&gt; Install-Package UmbracoCms
'UmbracoCms.Core (= 4.8.0)' not installed. Attempting to retrieve dependency from source...
Done.
Successfully installed 'UmbracoCms.Core 4.8.0'.
Successfully installed 'UmbracoCms 4.8.0'.
Successfully added 'UmbracoCms.Core 4.8.0' to UmbMvc.
'web.config' already exists. Skipping...
Successfully added 'UmbracoCms 4.8.0' to UmbMvc.</pre>
Don't worry about the message about web.config. It will write the necessary detail into the web.config file for you.

If you prefer to use the NuGet dialog, you can search for "UmbracoCms" and install the package from there. It will download and install the dependencies for you there too.

[caption id="" align="aligncenter" width="600"]<img title="NuGet Package Manager Dialog" src="http://static.colinmackay.co.uk/images/umbraco/2012-08-10-NuGetPackageManagerDialog-600.png" alt="NuGet Package Manager Dialog" width="600" height="338" /> NuGet Package Manager Dialog[/caption]

At this point you can run up Umbraco to configure it and set the databases up and so on. When you've finished this process you'll arrive at the Umbraco administration area. At this point you want to stop the app from running in Visual Studio.
<h3>Wiring up MVC 4</h3>
Next up is to get MVC installed. For this I'm taking the advice on <a href="http://www.aaron-powell.com/umbraco/using-mvc-in-umbraco-4">Aaron Powell's blog</a>, so go visit there for the detail. (Start at the section marked "Getting MVC installed"). I've added my own notes below for some differences I found between our experiences.

Installing ASP.NET at the time of writing installs MVC 4:
<pre>PM&gt; install-package microsoft.aspnet.mvc
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
Successfully added 'Microsoft.AspNet.Mvc 4.0.20505.0' to UmbMvc.</pre>
Because of the way paths work in Umbraco, I was either going to have to reserve every controller and area name in the umbracoReservedPaths configuration element, or create a prefix. I decided it was probably best to create a prefix, that way I only have to modify the config once and everything else simply works after that. So, my <code>RouteSetup</code> class looked like this:
<pre>using System.Web;
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
}</pre>
Note the "x" at the start of the URL part of the route.

My <code>umbracoReservedPaths</code> config element now looks like this:
<pre>&lt;!-- Remember to add into the umbracoReservedPaths every route that MVC wants to take. 
     It may be better to create a prefix so you only have to do this the once.--&gt;
&lt;add key="umbracoReservedPaths" value="~/umbraco,~/install/,~/x" /&gt;</pre>
<h3>Fixing up the web.config file</h3>
From Aaron's blog post, I still couldn't quite get it to work. I got an error message that read: <strong>Compiler Error Message: CS0234: The type or namespace name 'Helpers' does not exist in the namespace 'System.Web' (are you missing an assembly reference?)</strong>

I found that I needed to add the following to the <code>&lt;assemblies&gt;</code> section of the web.config file:
<pre>&lt;add assembly="System.Web.WebPages, Version=2.0.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35" /&gt;
&lt;add assembly="System.Web.Helpers, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31BF3856AD364E35" /&gt;</pre>
That helped, but I was still getting error an error message. This time it was <strong>Compiler Error Message: CS0234: The type or namespace name 'Ajax' does not exist in the namespace 'System.Web.Mvc' (are you missing an assembly reference?)</strong>

I found that I also needed to set the reference to <code>System.Web.Mvc</code> to "Copy Local"

[caption id="" align="aligncenter" width="314"]<img title="Visual Studio 2010: System.Web.Mvc Copy Local" src="http://static.colinmackay.co.uk/images/umbraco/2012-08-10-System.Web.Mvc-copy-local.png" alt="Visual Studio 2010: System.Web.Mvc Copy Local" width="314" height="598" /> Visual Studio 2010: System.Web.Mvc Copy Local[/caption]

Then when I ran the application and went to the URL http://localhost:60445/x/Home, I got a page back that said: <strong>Hello I'm a razor view.</strong>

This is finally what I expected.
<h3>Fixing up the project type.</h3>
One last thing, Aaron also mentions that you'll get various errors in the views in Visual Studio because the project type was a Web Application not an MVC Web Appliction project. Although it doesn't stop the application from running correctly, it is very disconcerting to see. He doesn't give a solution to that. To solve this, you need to add a GUID in the csproj file.

To do this, you need to right click on the web project and click "Unload Project", when it has unloaded, right-click again and click "Edit xxx.csproj".

Look for the element named "ProjectTypeGuids" and add in the guid: <strong>{E3E379DF-F4C6-4180-9B81-6769533ABE47}</strong>. The whole line should now read:
<pre>&lt;ProjectTypeGuids&gt;{E3E379DF-F4C6-4180-9B81-6769533ABE47};{349c5851-65df-11da-9384-00065b846f21};{fae04ec0-301f-11d3-bf4b-00c04f79efbc}&lt;/ProjectTypeGuids&gt;</pre>
Save the file, then right-click the project in the solution and click "Reload project". It will prompt you to close the text version of the project file, and then the project will be loaded back. Now you should not have any issues with the views finding false errors, such as not being able to resolve <code>ViewBag</code>.
