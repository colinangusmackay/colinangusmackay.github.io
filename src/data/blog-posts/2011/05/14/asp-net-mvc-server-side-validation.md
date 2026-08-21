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

So far, we’ve [built up a basic application](/2011/05/13/starting-an-asp-net-mvc-3-application/ "Starting an ASP.NET MVC 3 application") and got some [client side validation](/2011/05/14/asp-net-mvc-3-introduction-to-validation/ "ASP.NET MVC 3 Client Side Validation") working. However, client side validation only goes so far. While it can prevent unnecessary trips to the server, it doesn’t prevent invalid data getting to the  server if JavaScript is turned off or if a user crafts a specific HTTP request to by pass validation.

Server side validation is quite easy, especially as we already have all the attributes attached to the view model from setting up the client side validation. The `Controller` class upon which our controller derives has a property called `ModelState` on which you can call `IsValid`. If `true` everything is okay and you can proceed. If not you need to get the user to correct the input.

The action method on the controller could change easily to something like this:

```csharp
[HttpPost]
public ActionResult CalculatorResult(HarrisBenedictViewModel viewModel)
{
    if (ModelState.IsValid)
    {
        CalculateAnswer(viewModel);
        return View(viewModel);
    }

    return RedirectToAction("CalculatorInput", viewModel);
}
```

Note that I've also refactored out the calculation to a method called CalculateAnswer.

However compelling this looks, the result is a bit of a mess. If the validation fails then it redirects back to the `CalculatorInput` controller action via a HTTP Status 302, which causes the browser to load the URL its been given. This URL now looks something like this: `http://localhost:42225/?IsMale=True&Weight=45&Height=255&Age=16&BasalMetabolicRate=0&LifestyleRates=System.Collections.Generic.List%601[System.Collections.Generic.KeyValuePair%602[System.String%2CSystem.Int32]]`

**Bleurgh!**

Let’s look at refactoring things slightly.

### Refactoring to improve server side validation

First, we want the result to come back to the same controller action (well, almost the same action) as we started with.  Also, the action name was not very well named to begin with. It is an action, however the current name is a noun phrase. Actions should be verbs (or verb phrases).

The Controller class is refactored like this:

```csharp
public class MainController : Controller
{
    public ActionResult Calculate()
    {
        HarrisBenedictViewModel viewModel = new HarrisBenedictViewModel();
        return View("CalculatorInput", viewModel);
    }

    [HttpPost]
    public ActionResult Calculate(HarrisBenedictViewModel viewModel)
    {
        if (ModelState.IsValid)
        {
            CalculateAnswer(viewModel);
            return View("CalculatorResult", viewModel);
        }

        return View("CalculatorInput", viewModel);
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
            new KeyValuePair<string, int>("Sedentry", (int)(bmr * 1.2)));
        viewModel.LifestyleRates.Add(
            new KeyValuePair<string, int>("Lightly Active", (int)(bmr * 1.375)));
        viewModel.LifestyleRates.Add(
            new KeyValuePair<string, int>("Moderately Active", (int)(bmr * 1.55)));
        viewModel.LifestyleRates.Add(
            new KeyValuePair<string, int>("Very Active", (int)(bmr * 1.725)));
        viewModel.LifestyleRates.Add(
            new KeyValuePair<string, int>("Extra Active", (int)(bmr * 1.9)));
    }
}
```

Because the View names no longer match the name of the action then they have to be named explicitly. The URLs are based on the routing information set up in the Global.asax.cs file

Because we updated the controller action name, and we want that to be the default for the route we need to update the routes:

```csharp
public static void RegisterRoutes(RouteCollection routes)
{
    routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

    routes.MapRoute(
        "Default", // Route name
        "{controller}/{action}", // URL with parameters
        new { controller = "Main", action = "Calculate" } // Parameter defaults
    );
}
```

Now everything is set up to go.

When the application is run the path element of URL in the address bar remains at “`/`” and there is no query string. The output is much cleaner.
