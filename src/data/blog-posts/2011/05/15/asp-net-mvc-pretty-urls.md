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

As the little [Harris Benedict Calculator application stands](/2011/05/14/asp-net-mvc-server-side-validation/ "Starter ASP.NET MVC 3 application (with Validation)"), the only way to get some sort of answer out of it is to fill in the form. What if you wanted to pass someone a URL that takes them directly to the answer?

We could just create a controller action that takes the `viewModel` and have the MVC framework populate it from the URL. For example:

```csharp
public ActionResult Result(HarrisBenedictViewModel viewModel)
{
    return Calculate(viewModel);
}
```

However, this would make the URL require a query string like this: `http://localhost:42225/Main/Result?IsMale=True&Weight=75&Height=173&Age=37`

This could be better.

### Mapping a route for nicer URLs

What we can do is create a route to make the mapping nicer to look at than query string parameters. If we add it in before the default route it will be processed first if there is a match. So, the new `RegisterRoutes` method in the `global.asax.cs` file now looks like this:

```csharp
public static void RegisterRoutes(RouteCollection routes)
{
    routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

    routes.MapRoute("Permalink",
        "Gender/{Gender}/Weight/{Weight}/Height/{Height}/Age/{Age}",
        new { controller = "Main", action = "CalculateResult"}
        );

    routes.MapRoute(
        "Default",
        "{controller}/{action}",
        new { controller = "Main", action = "Calculate" }
    );
}
```

As you can see the new “Permalink” route defines a pattern that replaces parameters with properties from the view model. The controller’s action method takes in the view model that will have been populated with the values from the URL.

The controller’s action method is specified in the route as `CalculateResult`, and that method looks like this:

```csharp
public ActionResult CalculateResult(HarrisBenedictViewModel viewModel, string gender)
{
    viewModel.IsMale = gender.ToLowerInvariant() == "male";

    return Calculate(viewModel);
}
```

There is actually on surprise here. Since we wanted a nice clean URL, the `IsMale` value is replaced with something more friendly looking. Since this isn’t in the view model, a new parameter on the action method is added to capture the value coming in from the URL. It is then processed so that the `viewModel` object is updated with the value that is needed.

Finally, the action calls another action, one that was created when we added our server side validation. This validates the view model and either returns the result, or if the view model is invalid directs the user to input the correct data. If the user has to fill in any data then the form will contain the values as provided in the URL and the validation messages will point out which bits need corrected.

### Making a permalink on the results view

Now that we have everything set up to be able to pass around a URL with all the form values preset, it would be great to give people a way to get that link. So, on the `CalculatorResults.cshtml` file we are going to make that link using the HTML helper method `ActionLink`.

The snippet from the view looks like this:

```html
<p>@Html.ActionLink("Calculate another?", "Calculate", "Main");
@Html.ActionLink("Permalink", "CalculateResult", new {
    Weight = Model.Weight,
    Height = Model.Height,
    Age = Model.Age,
    Gender = Model.IsMale ? "Male" : "Female" })</p>
```

The first action link is what was there before. The second is for the new permalink.

The first parameter is the text the user sees. The second parameter is the action method to use. When the routes are examined the first match is used, so the first route that can be determined to use the `CalculateResult` action method is the one we set up earlier. The third parameter is an anonymous type that provides the values to inject into the URL template provided in the `RegisterRoutes` method in the `global.asax.cs` file.

Now the user can get a permalink with nice URLs like this: `http://localhost:42225/Gender/Male/Weight/75/Height/173/Age/37`

### Tidying things up a bit

Although we’ve got what we want, we are not going to leave things here. There is a little bit of tidying up to do first.

The action method is a little clunky. It essentially has to marshal values between the view model and the URL. The view model is a model of the view and the URL is just as valid a view as the HTML. If we can move that marshalling into the view model itself things would look better.

The `HarrisBenedictViewModel` class gets a new property that acts as a friendlier route to setting the `IsMale` property. The new property, called `Gender`, looks like this:

```csharp
public string Gender
{
    get
    {
        return IsMale ? "Male" : "Female";
    }
    set
    {
        IsMale = (value.ToLowerInvariant() == "male");
    }
}
```

As a result, the action method on the controller no longer needs the extra parameter nor does it need the code to interpret that extra parameter. It now looks like this:

```csharp
public ActionResult CalculateResult(HarrisBenedictViewModel viewModel)
{
    return Calculate(viewModel);
}
```

Finally, because the view model now contains a way to get the gender out (as well as in) the code in the cshtml file to generate the permalink can be cleaned up too. It now looks like this:

```html
@Html.ActionLink("Permalink", "CalculateResult", new {
    Weight = Model.Weight,
    Height = Model.Height,
    Age = Model.Age,
    Gender = Model.Gender })
```

### But why not…?

All the code in the cshtml file is doing is passing only bits of the view model to the `ActionLink` method, what’s wrong with just passing the whole view model. Surely it will just discard the bits it doesn’t need.

The problem is that it doesn’t know which bits it will need. If it finds properties on the view model that aren’t already in the URL template defined on the route, it will just add them as query string parameters, which makes the URL look like this:`http://localhost:42225/Gender/Male/Weight/80/Height/173/Age/35?IsMale=True&BasalMetabolicRate=0&LifestyleRates=System.Collections.Generic.List%601[System.Collections.Generic.KeyValuePair%602[System.String%2CSystem.Int32]]`

That list on the view model looks really ugly in the URL (and it doesn’t actually mean anything useful either).

### Summary

In this post we made a new route to provide pretty URLs in order to access the resource that we needed in a permanent fashion without having to fill in the form or craft an HTTP Post. Then we tidied up the code a little in order to keep things a little cleaner.

### Other posts in this series

- [Starting an ASP.NET MVC 3 application](/2011/05/13/starting-an-asp-net-mvc-3-application/)
- [Introduction to validation (client side)](/2011/05/14/asp-net-mvc-3-introduction-to-validation/ "ASP.NET MVC 3 Unobtrusive Client Side Validation")
- [Server side validation](/2011/05/14/asp-net-mvc-server-side-validation/ "ASP.NET MVC Server Side Validation")
