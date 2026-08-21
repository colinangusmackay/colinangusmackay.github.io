---
title: "ASP.NET MVC 3 – Introduction to validation"
slug: asp-net-mvc-3-introduction-to-validation
publishDate: 14 May 2011
description: "In my previous post on MVC 3 I started a project to calculate a calorific intake required to maintain a stable weight. In this post I’ll extent that to add..."
tags:
  - { name: ".NET", slug: net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "ASP.NET MVC 3", slug: asp-net-mvc-3 }
  - { name: "C#", slug: c }
---
<!-- ISSUE: link (http://bit.ly/jSWQ18): status 403 -->

In my [previous post on MVC 3](/2011/05/13/starting-an-asp-net-mvc-3-application/ "Starting an MVC 3 Project") I started a project to calculate a calorific intake required to maintain a stable weight. In this post I’ll extent that to add some validation to the inputs.

At the moment, since there is no validation, the use can just submit the input as it is with the default values. This produces this not so useful result:

![1 - Result without validation](/assets/blog/2011-05-14-asp-net-mvc-3-introduction-to-validation-1.webp)

ASP.NET MVC 3 introduces unobtrusive client validation. It uses the data attributes available in HTML5 to store bits of data about the validation so that it can work more effectively and cleanly. If you want to enable unobtrusive client validation you need to add the following to the `appSettings` section in the web.config file:

```xml
<add key="ClientValidationEnabled" value="true"/>
<add key="UnobtrusiveJavaScriptEnabled" value="true"/>
```

Since our project is brand new (not being upgraded from a previous version of ASP.NET) then the `appSettings` is already there. It is also possible to enable or disable this for individual views.

You also need to add the following to the `<head>` section of the \_Layout.chhtml file:

```html
<script src="@Url.Content("~/Scripts/jquery.validate.min.js")" type="text/javascript"></script>
<script src="@Url.Content("~/Scripts/jquery.validate.unobtrusive.min.js")" type="text/javascript"></script>
```

At this point we need to attribute the view model so that it knows what validation rules to put in place. The view model class file needs an additional using statement:

```csharp
using System.ComponentModel.DataAnnotations;
```

Then each property can be attributed appropriately. The model is updated to look like this:

```csharp
public class HarrisBenedictViewModel
{
    public HarrisBenedictViewModel()
    {
        LifestyleRates = new List<KeyValuePair<string, int>>();
    }

    public bool IsMale { get; set; }

    [Required(ErrorMessage = "Weight is required.")]
    [Range(50, 500, ErrorMessage = "Weight must be between {1}kg and {2}kg.")]
    public double Weight { get; set; }

    [Required(ErrorMessage = "Height is required.")]
    [Range(100, 250, ErrorMessage = "Height must be between {1}cm and {2}cm.")]
    public double Height { get; set; }

    [Required(ErrorMessage = "Age is required.")]
    [Range(18, 100, ErrorMessage = "Age must be between {1} and {2} years old.")]
    public int Age { get; set; }

    public double BasalMetabolicRate { get; set; }
    public IList<KeyValuePair<string, int>> LifestyleRates { get; set; }
}
```

As can be seen Validators can take string formatting placeholders so that if the data for the validation the message automatically updates to match, helping with the DRY principle.

The view also needs to be updated in order that the error messages are output when the user puts in incorrect data.

In the [previous post](/2011/05/13/starting-an-asp-net-mvc-3-application/ "Starting an ASP.NET MVC Application"), the fields in the input view looked like this:

```html
<div class="editor-label">Height (in centimetres) </div>
<div class="editor-field">
    <input type="text" name="Height" value="@Model.Height" />
</div>
```

However, now we have to start using Html.EditorFor and Html.ValidationMessageFor as the validation feature adds a lot of data-\* attributes to the elements in order to work.

If we change the .cshtml file to use the HTML Helper methods it looks like this:

```html
<div class="editor-label">Height (in centimetres)</div>
<div class="editor-field">
    @Html.EditorFor(model => model.Height)
    @Html.ValidationMessageFor(model => model.Height)
</div>
```

And the rendered output looks a little like this (modified slightly to word-wrap on to this blog):

```html
<div class="editor-label">Height (in centimetres)</div>
<div class="editor-field">
    <input class="text-box single-line" data-val="true"
        data-val-number="The field Height must be a number."
        data-val-range="Height must be between 100cm and 250cm." data-val-range-max="250"
        data-val-range-min="100"
        data-val-required="Height is required." id="Height" name="Height"
        type="text" value="0" />
    <span class="field-validation-valid" data-valmsg-for="Height"
        data-valmsg-replace="true"></span>
</div>
```

Now if the application is run up then the validation kicks in when the submit button is pressed and the user is presented with messages telling them what needs fixed in order to submit the form

![2 - Result with validation](/assets/blog/2011-05-14-asp-net-mvc-3-introduction-to-validation-2.webp)
