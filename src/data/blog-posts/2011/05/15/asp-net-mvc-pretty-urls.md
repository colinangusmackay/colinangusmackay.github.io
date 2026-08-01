---
title: "ASP.NET MVC – Pretty URLs"
slug: asp-net-mvc-pretty-urls
publishDate: 15 May 2011
description: "As the little Harris Benedict Calculator application stands , the only way to get some sort of answer out of it is to fill in the form. What if you wanted to..."
tags:
  - { name: ".NET", slug: net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "C#", slug: c }
---
<!-- TODO: convert this post's content to Markdown -->

<p>As the little <a title="Starter ASP.NET MVC 3 application (with Validation)" href="http://colinmackay.co.uk/blog/2011/05/14/asp-net-mvc-server-side-validation/">Harris Benedict Calculator application stands</a>, the only way to get some sort of answer out of it is to fill in the form. What if you wanted to pass someone a URL that takes them directly to the answer?</p>  <p>We could just create a controller action that takes the <code>viewModel</code> and have the MVC framework populate it from the URL. For example:</p>  <pre>public ActionResult Result(HarrisBenedictViewModel viewModel)
{
    return Calculate(viewModel);
}</pre>

<p>However, this would make the URL require a query string like this: <code>http://localhost:42225/Main/Result?IsMale=True&amp;Weight=75&amp;Height=173&amp;Age=37</code></p>

<p>This could be better.</p>

<h3>Mapping a route for nicer URLs</h3>

<p>What we can do is create a route to make the mapping nicer to look at than query string parameters. If we add it in before the default route it will be processed first if there is a match. So, the new <code>RegisterRoutes</code> method in the <code>global.asax.cs</code> file now looks like this:</p>

<pre>public static void RegisterRoutes(RouteCollection routes)
{
    routes.IgnoreRoute(&quot;{resource}.axd/{*pathInfo}&quot;);

    routes.MapRoute(&quot;Permalink&quot;,
        &quot;Gender/{Gender}/Weight/{Weight}/Height/{Height}/Age/{Age}&quot;,
        new { controller = &quot;Main&quot;, action = &quot;CalculateResult&quot;}
        );

    routes.MapRoute(
        &quot;Default&quot;,
        &quot;{controller}/{action}&quot;,
        new { controller = &quot;Main&quot;, action = &quot;Calculate&quot; }
    );
}</pre>

<p>As you can see the new “Permalink” route defines a pattern that replaces parameters with properties from the view model. The controller’s action method takes in the view model that will have been populated with the values from the URL.</p>

<p>The controller’s action method is specified in the route as <code>CalculateResult</code>, and that method looks like this:</p>

<pre>public ActionResult CalculateResult(HarrisBenedictViewModel viewModel, string gender)
{
    viewModel.IsMale = gender.ToLowerInvariant() == &quot;male&quot;;

    return Calculate(viewModel);
}</pre>

<p>There is actually on surprise here. Since we wanted a nice clean URL, the <code>IsMale</code> value is replaced with something more friendly looking. Since this isn’t in the view model, a new parameter on the action method is added to capture the value coming in from the URL. It is then processed so that the <code>viewModel</code> object is updated with the value that is needed.</p>

<p>Finally, the action calls another action, one that was created when we added our server side validation. This validates the view model and either returns the result, or if the view model is invalid directs the user to input the correct data. If the user has to fill in any data then the form will contain the values as provided in the URL and the validation messages will point out which bits need corrected.</p>

<h3>Making a permalink on the results view</h3>

<p>Now that we have everything set up to be able to pass around a URL with all the form values preset, it would be great to give people a way to get that link. So, on the <code>CalculatorResults.cshtml</code> file we are going to make that link using the HTML helper method <code>ActionLink</code>.</p>

<p>The snippet from the view looks like this:</p>

<pre>&lt;p&gt;@Html.ActionLink(&quot;Calculate another?&quot;, &quot;Calculate&quot;, &quot;Main&quot;);
@Html.ActionLink(&quot;Permalink&quot;, &quot;CalculateResult&quot;, new {
    Weight = Model.Weight,
    Height = Model.Height,
    Age = Model.Age,
    Gender = Model.IsMale ? &quot;Male&quot; : &quot;Female&quot; })&lt;/p&gt;</pre>

<p>The first action link is what was there before. The second is for the new permalink.</p>

<p>The first parameter is the text the user sees. The second parameter is the action method to use. When the routes are examined the first match is used, so the first route that can be determined to use the <code>CalculateResult</code> action method is the one we set up earlier. The third parameter is an anonymous type that provides the values to inject into the URL template provided in the <code>RegisterRoutes</code> method in the <code>global.asax.cs</code> file.</p>

<p>Now the user can get a permalink with nice URLs like this: <code>http://localhost:42225/Gender/Male/Weight/75/Height/173/Age/37</code></p>

<h3>Tidying things up a bit</h3>

<p>Although we’ve got what we want, we are not going to leave things here. There is a little bit of tidying up to do first.</p>

<p>The action method is a little clunky. It essentially has to marshal values between the view model and the URL. The view model is a model of the view and the URL is just as valid a view as the HTML. If we can move that marshalling into the view model itself things would look better.</p>

<p>The <code>HarrisBenedictViewModel</code> class gets a new property that acts as a friendlier route to setting the <code>IsMale</code> property. The new property, called <code>Gender</code>, looks like this:</p>

<pre>public string Gender
{
    get
    {
        return IsMale ? &quot;Male&quot; : &quot;Female&quot;;
    }
    set
    {
        IsMale = (value.ToLowerInvariant() == &quot;male&quot;);
    }
}</pre>

<p>As a result, the action method on the controller no longer needs the extra parameter nor does it need the code to interpret that extra parameter. It now looks like this:</p>

<pre>public ActionResult CalculateResult(HarrisBenedictViewModel viewModel)
{
    return Calculate(viewModel);
}</pre>

<p>Finally, because the view model now contains a way to get the gender out (as well as in) the code in the cshtml file to generate the permalink can be cleaned up too. It now looks like this:</p>

<pre>@Html.ActionLink(&quot;Permalink&quot;, &quot;CalculateResult&quot;, new {
    Weight = Model.Weight,
    Height = Model.Height,
    Age = Model.Age,
    Gender = Model.Gender })</pre>

<h3>But why not…?</h3>

<p>All the code in the cshtml file is doing is passing only bits of the view model to the <code>ActionLink</code> method, what’s wrong with just passing the whole view model. Surely it will just discard the bits it doesn’t need.</p>

<p>The problem is that it doesn’t know which bits it will need. If it finds properties on the view model that aren’t already in the URL template defined on the route, it will just add them as query string parameters, which makes the URL look like this:<code>http://localhost:42225/Gender/Male/Weight/80/Height/173/Age/35?IsMale=True&amp;BasalMetabolicRate=0&amp;LifestyleRates=System.Collections.Generic.List%601[System.Collections.Generic.KeyValuePair%602[System.String%2CSystem.Int32]]</code></p>

<p>That list on the view model looks really ugly in the URL (and it doesn’t actually mean anything useful either).</p>

<h3>Summary</h3>

<p>In this post we made a new route to provide pretty URLs in order to access the resource that we needed in a permanent fashion without having to fill in the form or craft an HTTP Post. Then we tidied up the code a little in order to keep things a little cleaner.</p>

<p>You can <a title="ASP.NET MVC Routes - Harris Benedict Calculator" href="http://bit.ly/in88qY">download the sample code</a> if you want to have a further play with it.</p>

<h3>Other posts in this series</h3>

<ul>
  <li><a href="http://colinmackay.co.uk/blog/2011/05/13/starting-an-asp-net-mvc-3-application/">Starting an ASP.NET MVC 3 application</a></li>

  <li><a title="ASP.NET MVC 3 Unobtrusive Client Side Validation" href="http://colinmackay.co.uk/blog/2011/05/14/asp-net-mvc-3-introduction-to-validation/">Introduction to validation (client side)</a></li>

  <li><a title="ASP.NET MVC Server Side Validation" href="http://colinmackay.co.uk/blog/2011/05/14/asp-net-mvc-server-side-validation/">Server side validation</a></li>
</ul>
