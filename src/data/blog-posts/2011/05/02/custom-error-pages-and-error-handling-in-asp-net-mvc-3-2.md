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
<!-- TODO: convert this post's content to Markdown -->

<p>In ASP.NET MVC 3 a new bit of code appeared in the global.asax.cs file:</p>  <pre>public static void RegisterGlobalFilters(GlobalFilterCollection filters)
{
    filters.Add(new HandleErrorAttribute());
}</pre>

<p>The above method is called from the <code>Application_Start()</code> method.</p>

<p>Out of the box, what this does is set up a global filter for handling errors. You can still attribute controller methods or classes as before, but now, if you don’t have a specific <code>HandleErrorAttribute</code> attached to the controller method or class then the global one will take over and be processed.</p>

<p>However, you are not going to get custom errors just yet. If you have a bit of code that causes an exception to be thrown that is not caught then you will just end up with the Yellow Screen of Death as before. For example, this code:</p>

<pre>public class HomeController : Controller
{
    // ...

    public ActionResult About()
    {
        throw new Exception(&quot;This is not good. Something bad happened.&quot;);
    }
}</pre>

<p>Will produce this error</p>

<p><img style="background-image:none;margin:2px auto;padding-left:0;padding-right:0;display:block;float:none;padding-top:0;border-width:1px;" title="Error Handling - Without Custom Error" border="0" alt="Error Handling - Without Custom Error" src="http://static.colinmackay.co.uk/images/mvc/2011-05-02-no-error-page-ysod-640.png" width="640" height="477" /></p>

<p>The missing part of the puzzle is to turn on Custom Errors. This happens in the web.config file. There are three basic options for the mode: “Off” which will show the YSOD to everyone, “RemoteOnly” which shows the YSOD on the local machine (the web server) and the custom error to everyone else, and “On” which shows the custom error to everyone including the local machine.</p>

<p>For development purposes I tend to leave it set to “RemoteOnly” so that I get the YSOD and I get to see what the error is, yet everyone else gets the custom error. However, for developing the actual custom errors themselves we’ll need to set the mode to “On” so we, as developers, get to see the error.</p>

<pre>&lt;system.web&gt;
  &lt;customErrors mode=&quot;On&quot; defaultRedirect=”~/BadError.htm&quot;/&gt;
&lt;/system.web&gt;</pre>

<p>The <code>defaultRedirect</code> does not go to a controller action, it is set to a static HTML page that will be displayed if all else goes wrong. This is a final backstop to ensure that the user at least will see something nice event if the error page itself has some issues. </p>

<p>Normally, the error will show the <code>~/Views/Shared/Error.cshtml</code> view. However, since the view can throw an exception itself there ought to be a backstop custom error page.</p>

<p>The HandleErrorAttribute defaults to using the view &quot;Error&quot; which will display shared view <code>~/Views/Shared/Error.cshtml</code>. </p>

<p>You can change that by setting the view property on the HandleErrorAttrubute, like this:</p>

<pre>public static void RegisterGlobalFilters(GlobalFilterCollection filters)
{
    filters.Add(new HandleErrorAttribute {View = &quot;MyCustomError&quot;});
}</pre>

<p>I've set my error view to display the details of the exception for the purposes of this demo.</p>

<pre>@model System.Web.Mvc.HandleErrorInfo

@{
    ViewBag.Title = &quot;Error&quot;;
}

&lt;h2&gt;
    Sorry, an error occurred while processing your request.
&lt;/h2&gt;
&lt;p&gt;Controller = @Model.ControllerName&lt;/p&gt;
&lt;p&gt;Action = @Model.ActionName&lt;/p&gt;
&lt;p&gt;Message = @Model.Exception.Message&lt;/p&gt;
&lt;p&gt;StackTrace :&lt;/p&gt;
&lt;pre&gt;@Model.Exception.StackTrace&lt;/pre&gt;</pre>

<p>NOTE: In normal production code you would never expose the details of the exception like this. It represents a considerable security risk and a potential attacker could use the information to gain valuable information about your system in order to construct an attack against it.</p>

<p>Now, if we re-run the same application and go to the About page (handled by the HomeController’s About action) then we will get our custom error page.</p>

<h3>Performing additional actions on an exception</h3>

<h4>Overriding OnException in a Controller</h4>

<p>If you want to perform additional actions, rather than just simply show a custom error page, then you can override the OnException method from the Controller class on your own controller derived class. If you want to do this for all controllers then&#160; you may want to create a common base controller that all your controllers inherit from. For example:</p>

<pre>public class CommonController : Controller
{
    protected override void OnException(ExceptionContext filterContext)
    {
        // Do additional things like logging here.
        base.OnException(filterContext);
    }
}</pre>

<p>Then in each of your controllers, inherit from this common controller like this: </p>

<pre>public class HomeController : CommonController
{ ...</pre>

<p>That will ensure that all your controller have the same functionality.</p>

<h4>Creating a FilterAttribute</h4>

<p>You could alternatively create a <code>FilterAttribute</code>. This can provide benefits of providing global functionality if you add it to the global filter collection, or very fine grained functionality if you need it on a few sparse controller actions by adding it as an attribute on the controller action.</p>

<p>The filter may look like this:</p>

<pre>public class LogExceptionFilterAttribute : FilterAttribute, IExceptionFilter
{
    public void OnException(ExceptionContext filterContext)
    {
        // Log the exception here with your logging framework of choice.
    }
}</pre>

<p>If you want to have the filter applied to all controller actions, you can set it up in the <code>RegisterGlobalFilters</code> method in the <code>Global.asax.cs</code> file like this: </p>

<pre>public static void RegisterGlobalFilters(GlobalFilterCollection filters)
{
    filters.Add(new LogExceptionFilterAttribute());
    filters.Add(new HandleErrorAttribute());
}</pre>

<p>Or, if you prefer to have finer grained control you can decorate individual controller classes or controller actions with it, like this:</p>

<pre>[LogExceptionFilter()]
public ActionResult About()
{
    throw new Exception(&quot;This is not good. Something bad happened.&quot;);
}</pre>
