---
title: "ASP.NET MVC – Server Side Validation"
slug: asp-net-mvc-server-side-validation
publishDate: 14 May 2011
description: "So far, we’ve built up a basic application and got some client side validation working. However, client side validation only goes so far. While it can prevent..."
tags:
  - { name: ".NET", slug: net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "C#", slug: c }
---
<!-- TODO: convert this post's content to Markdown -->

<p>So far, we’ve <a title="Starting an ASP.NET MVC 3 application" href="http://colinmackay.co.uk/blog/2011/05/13/starting-an-asp-net-mvc-3-application/">built up a basic application</a> and got some <a title="ASP.NET MVC 3 Client Side Validation" href="http://colinmackay.co.uk/blog/2011/05/14/asp-net-mvc-3-introduction-to-validation/">client side validation</a> working. However, client side validation only goes so far. While it can prevent unnecessary trips to the server, it doesn’t prevent invalid data getting to the&#160; server if JavaScript is turned off or if a user crafts a specific HTTP request to by pass validation.</p>  <p>Server side validation is quite easy, especially as we already have all the attributes attached to the view model from setting up the client side validation. The <code>Controller</code> class upon which our controller derives has a property called <code>ModelState</code> on which you can call <code>IsValid</code>. If <code>true</code> everything is okay and you can proceed. If not you need to get the user to correct the input.</p>  <p>The action method on the controller could change easily to something like this:</p>  <pre>[HttpPost]
public ActionResult CalculatorResult(HarrisBenedictViewModel viewModel)
{
    if (ModelState.IsValid)
    {
        CalculateAnswer(viewModel);
        return View(viewModel);
    }

    return RedirectToAction(&quot;CalculatorInput&quot;, viewModel);
}</pre>

<p>Note that I've also refactored out the calculation to a method called CalculateAnswer.</p>

<p>However compelling this looks, the result is a bit of a mess. If the validation fails then it redirects back to the CalculatorInput controller action via a HTTP Status 302, which causes the browser to load the URL its been given. This URL now looks something like this: <code>http://localhost:42225/?IsMale=True&amp;Weight=45&amp;Height=255&amp;Age=16&amp;BasalMetabolicRate=0&amp;LifestyleRates=System.Collections.Generic.List%601[System.Collections.Generic.KeyValuePair%602[System.String%2CSystem.Int32]]</code></p>

<p><strong>Bleurgh!</strong></p>

<p>Let’s look at refactoring things slightly.</p>

<h3>Refactoring to improve server side validation</h3>

<p>First, we want the result to come back to the same controller action (well, almost the same action) as we started with.&#160; Also, the action name was not very well named to begin with. It is an action, however the current name is a noun phrase. Actions should be verbs (or verb phrases).</p>

<p>The Controller class is refactored like this:</p>

<pre>public class MainController : Controller
{
    public ActionResult Calculate()
    {
        HarrisBenedictViewModel viewModel = new HarrisBenedictViewModel();
        return View(&quot;CalculatorInput&quot;, viewModel);
    }

    [HttpPost]
    public ActionResult Calculate(HarrisBenedictViewModel viewModel)
    {
        if (ModelState.IsValid)
        {
            CalculateAnswer(viewModel);
            return View(&quot;CalculatorResult&quot;, viewModel);
        }

        return View(&quot;CalculatorInput&quot;, viewModel);
    }

    private static void CalculateAnswer(HarrisBenedictViewModel viewModel)
    {
        double bmr = 0; // Base Metabolic Rate
        if (viewModel.IsMale)
        {
            bmr =
                66 +
                (13.7 * viewModel.Weight) +
                (5 * viewModel.Height) -
                (6.76 * viewModel.Age);
        }
        else
        {
            bmr =
                655 +
                (9.6 * viewModel.Weight) +
                (1.8 * viewModel.Height) -
                (4.7 * viewModel.Age);
        }

        viewModel.LifestyleRates.Clear();
        viewModel.LifestyleRates.Add(
            new KeyValuePair&lt;string, int&gt;(&quot;Sedentry&quot;, (int)(bmr * 1.2)));
        viewModel.LifestyleRates.Add(
            new KeyValuePair&lt;string, int&gt;(&quot;Lightly Active&quot;, (int)(bmr * 1.375)));
        viewModel.LifestyleRates.Add(
            new KeyValuePair&lt;string, int&gt;(&quot;Moderately Active&quot;, (int)(bmr * 1.55)));
        viewModel.LifestyleRates.Add(
            new KeyValuePair&lt;string, int&gt;(&quot;Very Active&quot;, (int)(bmr * 1.725)));
        viewModel.LifestyleRates.Add(
            new KeyValuePair&lt;string, int&gt;(&quot;Extra Active&quot;, (int)(bmr * 1.9)));
    }
}</pre>

<p>Because the View names no longer match the name of the action then they have to be named explicitly. The URLs are based on the routing information set up in the Global.asax.cs file</p>

<p>Because we updated the controller action name, and we want that to be the default for the route we need to update the routes:</p>

<pre>public static void RegisterRoutes(RouteCollection routes)
{
    routes.IgnoreRoute(&quot;{resource}.axd/{*pathInfo}&quot;);

    routes.MapRoute(
        &quot;Default&quot;, // Route name
        &quot;{controller}/{action}&quot;, // URL with parameters
        new { controller = &quot;Main&quot;, action = &quot;Calculate&quot; } // Parameter defaults
    );
}</pre>

<p>Now everything is set up to go.</p>

<p>When the application is run the path element of URL in the address bar remains at “<code>/</code>” and there is no query string. The output is much cleaner.</p>

<h3>Summary</h3>

<p>In this post the validation was refactored to better support server side validation and ensure that the URLs are kept clean.</p>

<p>The <a title="ASP.NET MVC 3 Server Side Validation Example Code" href="http://bit.ly/jFVjTJ" rel="enclosure">code is available for download</a> if you want a play with it.</p>
