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
<!-- TODO: convert this post's content to Markdown -->

<p>In my <a title="Starting an MVC 3 Project" href="http://colinmackay.co.uk/blog/2011/05/13/starting-an-asp-net-mvc-3-application/">previous post on MVC 3</a> I started a project to calculate a calorific intake required to maintain a stable weight. In this post I’ll extent that to add some validation to the inputs.</p>  <p>At the moment, since there is no validation, the use can just submit the input as it is with the default values. This produces this not so useful result:</p>  <p><img style="background-image:none;border-bottom:0;border-left:0;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;border-top:0;margin-right:auto;border-right:0;padding-top:0;" border="0" alt="1 - Result without validation" src="http://static.colinmackay.co.uk/images/mvc/2011-05-14-result-without-validation-640.png" width="640" height="480" /></p>  <p>ASP.NET MVC 3 introduces unobtrusive client validation. It uses the data attributes available in HTML5 to store bits of data about the validation so that it can work more effectively and cleanly. If you want to enable unobtrusive client validation you need to add the following to the <code>appSettings</code> section in the web.config file:</p>  <pre>&lt;add key=&quot;ClientValidationEnabled&quot; value=&quot;true&quot;/&gt;
&lt;add key=&quot;UnobtrusiveJavaScriptEnabled&quot; value=&quot;true&quot;/&gt;</pre>

<p>Since our project is brand new (not being upgraded from a previous version of ASP.NET) then the <code>appSettings</code> is already there. It is also possible to enable or disable this for individual views.</p>

<p>You also need to add the following to the <code>&lt;head&gt;</code> section of the _Layout.chhtml file:</p>

<pre>&lt;script src=&quot;@Url.Content(&quot;~/Scripts/jquery.validate.min.js&quot;)&quot; type=&quot;text/javascript&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;@Url.Content(&quot;~/Scripts/jquery.validate.unobtrusive.min.js&quot;)&quot; type=&quot;text/javascript&quot;&gt;&lt;/script&gt;</pre>

<p>At this point we need to attribute the view model so that it knows what validation rules to put in place. The view model class file needs an additional using statement:</p>

<pre>using System.ComponentModel.DataAnnotations;</pre>

<p>Then each property can be attributed appropriately. The model is updated to look like this:</p>

<pre>public class HarrisBenedictViewModel
{
    public HarrisBenedictViewModel()
    {
        LifestyleRates = new List&lt;KeyValuePair&lt;string, int&gt;&gt;();
    }

    public bool IsMale { get; set; }

    [Required(ErrorMessage = &quot;Weight is required.&quot;)]
    [Range(50, 500, ErrorMessage = &quot;Weight must be between {1}kg and {2}kg.&quot;)]
    public double Weight { get; set; }

    [Required(ErrorMessage = &quot;Height is required.&quot;)]
    [Range(100, 250, ErrorMessage = &quot;Height must be between {1}cm and {2}cm.&quot;)]
    public double Height { get; set; }

    [Required(ErrorMessage = &quot;Age is required.&quot;)]
    [Range(18, 100, ErrorMessage = &quot;Age must be between {1} and {2} years old.&quot;)]
    public int Age { get; set; }

    public double BasalMetabolicRate { get; set; }
    public IList&lt;KeyValuePair&lt;string, int&gt;&gt; LifestyleRates { get; set; }
}</pre>

<p>As can be seen Validators can take string formatting placeholders so that if the data for the validation the message automatically updates to match, helping with the DRY principle.</p>

<p>The view also needs to be updated in order that the error messages are output when the user puts in incorrect data.</p>

<p>In the <a title="Starting an ASP.NET MVC Application" href="http://colinmackay.co.uk/blog/2011/05/13/starting-an-asp-net-mvc-3-application/">previous post</a>, the fields in the input view looked like this:</p>

<pre>&lt;div class=&quot;editor-label&quot;&gt;Height (in centimetres) &lt;/div&gt;
&lt;div class=&quot;editor-field&quot;&gt;
    &lt;input type=&quot;text&quot; name=&quot;Height&quot; value=&quot;@Model.Height&quot; /&gt;
&lt;/div&gt;</pre>

<p>However, now we have to start using Html.EditorFor and Html.ValidationMessageFor as the validation feature adds a lot of data-* attributes to the elements in order to work.</p>

<p>If we change the .cshtml file to use the HTML Helper methods it looks like this:</p>

<pre>&lt;div class=&quot;editor-label&quot;&gt;Height (in centimetres)&lt;/div&gt;
&lt;div class=&quot;editor-field&quot;&gt;
    @Html.EditorFor(model =&gt; model.Height)
    @Html.ValidationMessageFor(model =&gt; model.Height)
&lt;/div&gt;</pre>

<p>And the rendered output looks a little like this (modified slightly to word-wrap on to this blog):</p>

<pre>&lt;div class=&quot;editor-label&quot;&gt;Height (in centimetres)&lt;/div&gt;
&lt;div class=&quot;editor-field&quot;&gt;
    &lt;input class=&quot;text-box single-line&quot; data-val=&quot;true&quot;
        data-val-number=&quot;The field Height must be a number.&quot;
        data-val-range=&quot;Height must be between 100cm and 250cm.&quot; data-val-range-max=&quot;250&quot;
        data-val-range-min=&quot;100&quot;
        data-val-required=&quot;Height is required.&quot; id=&quot;Height&quot; name=&quot;Height&quot;
        type=&quot;text&quot; value=&quot;0&quot; /&gt;
    &lt;span class=&quot;field-validation-valid&quot; data-valmsg-for=&quot;Height&quot;
        data-valmsg-replace=&quot;true&quot;&gt;&lt;/span&gt;
&lt;/div&gt;</pre>

<p>Now if the application is run up then the validation kicks in when the submit button is pressed and the user is presented with messages telling them what needs fixed in order to submit the form</p>

<p><img style="background-image:none;border-bottom:0;border-left:0;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;border-top:0;margin-right:auto;border-right:0;padding-top:0;" border="0" alt="2 - Result with validation" src="http://static.colinmackay.co.uk/images/mvc/2011-05-14-result-with-validation-640.png" width="640" height="480" /></p>

<h3>Summary</h3>

<p>In this post I’ve introduced the concept of unobtrusive client side validation. It should be stressed that if JavaScript is disabled on the browser then validation does not take place. By the same token, if a user crafts an HTTP Post request to the server, the validation will not have taken place either.</p>

<p>You can <a title="Unobtrusive Client Validation Sample Code" href="http://bit.ly/jSWQ18">download the source code</a> if you want to have a play with it.</p>
