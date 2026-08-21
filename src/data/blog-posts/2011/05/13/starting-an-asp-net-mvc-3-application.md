---
title: "Starting an ASP.NET MVC 3 application"
slug: starting-an-asp-net-mvc-3-application
publishDate: 13 May 2011
description: "In this post, I’m going to show the basics of starting an application with ASP.NET MVC 3. The demo application will be a simple calorie counter that takes in a..."
tags:
  - { name: ".NET", slug: net }
  - { name: "asp.net", slug: asp-net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "ASP.NET MVC 3", slug: asp-net-mvc-3 }
  - { name: "C#", slug: c }
---

In this post, I’m going to show the basics of starting an application with ASP.NET MVC 3. The demo application will be a simple calorie counter that takes in a number of values from the user that is then used to calculate the calorific intake. The original calculation can be found here here: [How many calories should I be eating?](https://web.archive.org/web/20110610220712/http://www.daveywaveyfitness.com/nutrition/how-many-calories-should-i-be-eating-harris-benedict-calculator/ "How many calories should I be eating? (Harris Benedict Calculator)")

### Creating the project

In Visual Studio 2010, from the New Project Dialog, go to the Visual C#/Web templates section and select ASP.NET MVC 3 Web Application from the list in the middle. If you don’t see it, ensure that the drop down says .NET Framework 4.

For this project, the Name will be set to “HarrisBenedictCalculator” as that is the type of calculation that the application will be performing.

![1 - Visual Studio 2010 New Project dialog](/assets/blog/2011-05-13-starting-an-asp-net-mvc-3-application-1.webp)

Once the appropriate details are entered the OK button takes you to a more specific dialog for ASP.NET MVC 3 projects.

Since I want to show everything rather than rely on existing templates where some of the ground work is already done, I’m selecting the Empty template. I’m also going to select the “Use HTML5 semantic markup” and set the view engine to Razor.

Because we are selecting the empty template, unit tests project creation is not available. We can do that later.

![2 - New ASP.NET MVC 3 Project dialog](/assets/blog/2011-05-13-starting-an-asp-net-mvc-3-application-2.webp)

When the second dialog is OK’ed the project will be created. For all that I selected “Empty” Visual Studio has created an awful lot of files already.

### What’s already in this “empty” project?

![3 - What's in the empty ASP.NET MVC 3 project](/assets/blog/2011-05-13-starting-an-asp-net-mvc-3-application-3.webp)

The project contains a set of predefined folders, some of which are already populated with files.

- Content: Contains static content files such as CSS, graphics and javascript files.
- Scripts: Contains a profusion of javascript files.
- Views:  This contains some files that act like Master files for the Razor engine, an error page Razor template and a web.config.

The top level folder also contains a global.asax file which defines a set of default routes and filters, a packages.config file which is used by NuGet and a set of web.config files.

If you attempt to run the application as is then it will compile, but you go directly to a error message that says “The resource cannot be found” because there are not controllers as yet, so the routing engine cannot find a route for the default resource.

![4 - Resource Not Found](/assets/blog/2011-05-13-starting-an-asp-net-mvc-3-application-4.webp)

For the moment, we are going to have a simple static HTML page for the error. To that end the web.config will have the following added to it:

```html
<customErrors mode="RemoteOnly" defaultRedirect="Error.htm" />
```

We will see error messages, but once deployed the end users won’t. If you want to learn more about error handling see this other post on [custom error handling in ASP.NET MVC 3](/2011/05/02/custom-error-pages-and-error-handling-in-asp-net-mvc-3-2/).

### Creating the initial view and controller

First up we are going to create the model of the view, the ViewModel if you like. This will contains all the variables needed to generate the request and receive data back in the response.

```csharp
public class HarrisBenedictViewModel
{
    public HarrisBenedictViewModel()
    {
        LifestyleRates = new List<KeyValuePair>();
    }

    public bool IsMale { get; set; }
    public double Weight { get; set; }
    public double Height { get; set; }
    public int Age { get; set; }
    public double BasalMetabolicRate { get; set; }
    public IList<KeyValuePair<string, int>> LifestyleRates { get; set; }
}
```

Incidentally, I always initialise lists so that I don’t have to do a null check. Normally most code will loop over the list, an empty list will loop the same number of times as a list that isn’t there.

Now, we are ready to create the controller. When you right click on the Controllers folder in the project structure, you get an “Controller…” option in the "Add” sub-menu.

![5 - Add Controller](/assets/blog/2011-05-13-starting-an-asp-net-mvc-3-application-5.webp)

For this, I’m going to create a controller called Main and leave it empty. That gives us a class called `MainController` that is derived from `Controller`.

The controller is going to have two actions (this is a very simple application), one called `CalculatorInput` which will simply return a view for accepting the values, and the other called `CalculatorResult` which will display the results of the calculation. Both views use the view model we created earlier.

The `CalculatorInput` method looks like this:

```csharp
public ActionResult CalculatorInput()
{
    HarrisBenedictViewModel viewModel = new HarrisBenedictViewModel();
    return View(viewModel);
}
```

The empty view model will be populated by the user. If we want to pre-populate values on the view then we can do so by setting the appropriate values in the view model.

ASP.NET MVC uses naming conventions to find things. So, by default, the view will be in a folder named after the controller (in this case “Main”) and the view will be named after the controller action (in this case “CalculatorInput”).

To create the View, create the appropriate folder in the Views folder (if it doesn’t already exist) and then right click the folder you’ve just created and select Add-\>View…

A dialog appears that looks like this:

![6 - Add View](/assets/blog/2011-05-13-starting-an-asp-net-mvc-3-application-6.webp)

```html
@model HarrisBenedictCalculator.Models.HarrisBenedictViewModel

@{
    ViewBag.Title = "Harris Benedict Calculator";
}

<h2>Harris Benedict Calculator</h2>

@using(Html.BeginForm("CalculatorResult", "Main", FormMethod.Post)){
    <fieldset>
        <legend>Information about you</legend>

        <div class="editor-label">Are you male?</div>
        <div class="editor-field">@Html.CheckBox("IsMale", Model.IsMale)</div>


        <div class="editor-label">Weight (in kilos)</div>
        <div class="editor-field"><input name="Weight" value="@Model.Weight" /></div>

        <div class="editor-label">Height (in centimetres)</div>
        <div class="editor-field"><input name="Height" value="@Model.Height" /></div>

        <div class="editor-label">Age (in years)</div>
        <div class="editor-field"><input name="Age" value="@Model.Age" /></div>

        <div class="submit"><input type="submit" value="Calculate!" /></div>
    </fieldset>
}
```

The view sets up the form for getting the user inputs.

The `Html.BeginForm` defines where the form will be sent to once it is complete and how it will be sent. In this case, the form will be sent by and HTTP POST to the `CalculatorResult` method on the `MainController` class. I’ll talk more about what that does in the next section.

The form consists of a number of inputs which, by convention, have the same name as properties on the Model. If the model is pre-populated then the initial values will be used to populate the values in each of the input elements.

The `CheckBox` is a special case. Because of the way HTML works, if the checkbox is unchecked then nothing is returned. The MVC application then does not know if the checkbox was not ticked, or if the checkbox simply didn’t exist at all. This may be an important distinction. Therefore an Html helper method is available that outputs the checkbox and an hidden field to go with it.

At this point we can run the application and get the initial view being displayed to us:

![7 - Rendering first view](/assets/blog/2011-05-13-starting-an-asp-net-mvc-3-application-7.webp)

### Submitting the answers

As I mentioned above, the `Html.BeginForm` helper method tells ASP.NET MVC what controller and method to return the result to when the user presses the submit button. So, we have to create a method to process that on the specified controller (in this case `Main`)

The Main.CalculatorResult method looks like this:

```csharp
[HttpPost]
public ActionResult CalculatorResult(HarrisBenedictViewModel viewModel)
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

    return View(viewModel);
}
```

The above performs the calculation. The code may look a bit long, but the calculation is relatively simple. In a full business application this code would be separated out elsewhere.

The method is decorated with the `HttpPost` attribute which tells MVC that the method may only be called in response to an HTTP POST verb. The method also takes the view model class as a parameter. MVC will may the form inputs to the view model class as best it can. You can also specify a list of more primitive types (like `int`, `string`, `double`, etc.) that map to the input elements on the form.

The method itself performs the calculation then updates some items in the view model with the results of the calculation. The `View` is then returned with the view model.

The convention is that, unless specified otherwise, the view returned will be named after the controller method in a folder named after the controller class. So the view is in the ~ViewsMain folder in a file called CalculatorResult.cshtml

```html
@model HarrisBenedictCalculator.Models.HarrisBenedictViewModel

@{
    ViewBag.Title = "Harris Benedict Calculator Result";
}

<h2>Result</h2>

<p>For a <em>@(Model.IsMale ? "man" : "woman")</em> aged <em>@Model.Age</em> years old,
weighing <em>@Model.Weight.ToString("0.0")</em> kg, and <em>@Model.Height</em> cm tall
should be taking in the following calories per day:
</p>

<div class="result">
@foreach (var lifestyle in Model.LifestyleRates)
{
    <div class="result-line">
        <span class="result-label">@lifestyle.Key</span>@lifestyle.Value Calories
    </div>
}
</div>

<p>@Html.ActionLink("Calculate another?", "CalculatorInput", "Main")</p>
```

This view extracts the data from the view model and renders it to the browser.

So, the answer I get looks like this:

![8 - Final Result](/assets/blog/2011-05-13-starting-an-asp-net-mvc-3-application-8.webp)

The Razor syntax is quite easy to follow for the most part. Anything starting with an @ sign indicates the start of some C# code. The rendering engine is clever enough to detect HTML code and revert back when needed.

At the bottom of the page the HTML helper method ActionLink generates the URL to take the user back round to the start of the process again in case they want to calculate another set of calorie intakes.
