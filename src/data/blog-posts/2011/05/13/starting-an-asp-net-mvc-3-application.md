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
<!-- TODO: convert this post's content to Markdown -->

<p>In this post, I’m going to show the basics of starting an application with ASP.NET MVC 3. The demo application will be a simple calorie counter that takes in a number of values from the user that is then used to calculate the calorific intake. The original calculation can be found here here: <a title="How many calories should I be eating? (Harris Benedict Calculator)" href="http://www.daveywaveyfitness.com/nutrition/how-many-calories-should-i-be-eating-harris-benedict-calculator/" target="_blank">How many calories should I be eating?</a></p>  <p>First, if you don’t have it already, you’ll need to <a href="http://www.microsoft.com/Downloads/en/details.aspx?FamilyID=82cbd599-d29a-43e3-b78b-0f863d22811a&amp;displaylang=en" target="_blank">download ASP.NET MVC 3</a>. Remember to shut down Visual Studio 2010 for the installation. And if you don’t have it already, I’d also recommend <a href="http://www.microsoft.com/downloads/en/details.aspx?FamilyID=75568aa6-8107-475d-948a-ef22627e57a5" target="_blank">downloading Visual Studio 2010 SP1</a> and upgrading to it.</p>  <h3></h3>  <h3>Creating the project</h3>  <p>In Visual Studio 2010, from the New Project Dialog, go to the Visual C#/Web templates section and select ASP.NET MVC 3 Web Application from the list in the middle. If you don’t see it, ensure that the drop down says .NET Framework 4.</p>  <p>For this project, the Name will be set to “HarrisBenedictCalculator” as that is the type of calculation that the application will be performing.</p>  <p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" alt="1 - Visual Studio 2010 New Project dialog" src="http://static.colinmackay.co.uk/images/mvc/2011-05-13-Step-1-Visual-Studio-2010-New-Project_Dialog-640.png" width="640" height="442" /></p>  <p>Once the appropriate details are entered the OK button takes you to a more specific dialog for ASP.NET MVC 3 projects.</p>  <p>Since I want to show everything rather than rely on existing templates where some of the ground work is already done, I’m selecting the Empty template. I’m also going to select the “Use HTML5 semantic markup” and set the view engine to Razor. </p>  <p>Because we are selecting the empty template, unit tests project creation is not available. We can do that later.</p>  <p><img style="margin:2px auto;display:block;float:none;" alt="2 - New ASP.NET MVC 3 Project dialog" src="http://static.colinmackay.co.uk/images/mvc/2011-05-13-Step-2-New-ASPNET-MVC-Project-640.png" width="640" height="577" /></p>  <p>When the second dialog is OK’ed the project will be created. For all that I selected “Empty” Visual Studio has created an awful lot of files already.</p>  <h3></h3>  <h3>What’s already in this “empty” project?</h3>  <p><img style="background-image:none;margin:2px auto;padding-left:0;padding-right:0;display:block;float:none;padding-top:0;border-width:1px;" border="1" alt="3 - What&#039;s in the empty ASP.NET MVC 3 project" src="http://static.colinmackay.co.uk/images/mvc/2011-05-13-Step-3-What-is-in-the-empty-project.png" width="257" height="1260" /></p>  <p>The project contains a set of predefined folders, some of which are already populated with files.</p>  <ul>   <li>Content: Contains static content files such as CSS, graphics and javascript files. </li>    <li>Scripts: Contains a profusion of javascript files. </li>    <li>Views:&#160; This contains some files that act like Master files for the Razor engine, an error page Razor template and a web.config. </li> </ul>  <p>The top level folder also contains a global.asax file which defines a set of default routes and filters, a packages.config file which is used by NuGet and a set of web.config files.</p>  <p>If you attempt to run the application as is then it will compile, but you go directly to a error message that says “The resource cannot be found” because there are not controllers as yet, so the routing engine cannot find a route for the default resource.</p>  <p><img style="background-image:none;margin:2px auto;padding-left:0;padding-right:0;display:block;float:none;padding-top:0;border-width:0;" border="0" alt="4 - Resource Not Found" src="http://static.colinmackay.co.uk/images/mvc/2011-05-13-Step-4-Resource-not-found-ysod.png" width="640" height="480" /></p>  <p>For the moment, we are going to have a simple static HTML page for the error. To that end the web.config will have the following added to it:</p>  <pre>&lt;customErrors mode=&quot;RemoteOnly&quot; defaultRedirect=&quot;Error.htm&quot; /&gt;</pre>

<p>We will see error messages, but once deployed the end users won’t. If you want to learn more about error handling see this other post on <a href="http://colinmackay.co.uk/blog/2011/05/02/custom-error-pages-and-error-handling-in-asp-net-mvc-3-2/" target="_blank">custom error handling in ASP.NET MVC 3</a>.</p>

<h3>Creating the initial view and controller</h3>

<p>First up we are going to create the model of the view, the ViewModel if you like. This will contains all the variables needed to generate the request and receive data back in the response.</p>

<pre>public class HarrisBenedictViewModel
{
    public HarrisBenedictViewModel()
    {
        LifestyleRates = new List&lt;KeyValuePair&gt;();
    }

    public bool IsMale { get; set; }
    public double Weight { get; set; }
    public double Height { get; set; }
    public int Age { get; set; }
    public double BasalMetabolicRate { get; set; }
    public IList&lt;KeyValuePair&lt;string, int&gt;&gt; LifestyleRates { get; set; }
}</pre>

<p>Incidentally, I always initialise lists so that I don’t have to do a null check. Normally most code will loop over the list, an empty list will loop the same number of times as a list that isn’t there.</p>

<p>Now, we are ready to create the controller. When you right click on the Controllers folder in the project structure, you get an “Controller…” option in the &quot;Add” sub-menu. </p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="5 - Add Controller" src="http://static.colinmackay.co.uk/images/mvc/2011-05-13-Step-5-Add-Controller.png" width="604" height="393" /></p>

<p>For this, I’m going to create a controller called Main and leave it empty. That gives us a class called <code>MainController</code> that is derived from <code>Controller</code>.</p>

<p>The controller is going to have two actions (this is a very simple application), one called <code>CalculatorInput</code> which will simply return a view for accepting the values, and the other called <code>CalculatorResult</code> which will display the results of the calculation. Both views use the view model we created earlier.</p>

<p>The <code>CalculatorInput</code> method looks like this:</p>

<pre>public ActionResult CalculatorInput()
{
    HarrisBenedictViewModel viewModel = new HarrisBenedictViewModel();
    return View(viewModel);
}</pre>

<p>The empty view model will be populated by the user. If we want to pre-populate values on the view then we can do so by setting the appropriate values in the view model.</p>

<p>ASP.NET MVC uses naming conventions to find things. So, by default, the view will be in a folder named after the controller (in this case “Main”) and the view will be named after the controller action (in this case “CalculatorInput”).</p>

<p>To create the View, create the appropriate folder in the Views folder (if it doesn’t already exist) and then right click the folder you’ve just created and select Add-&gt;View… </p>

<p>A dialog appears that looks like this:</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="6 - Add View" src="http://static.colinmackay.co.uk/images/mvc/2011-05-13-Step-6-Add-View.png" width="511" height="504" /></p>

<pre>@model HarrisBenedictCalculator.Models.HarrisBenedictViewModel

@{
    ViewBag.Title = &quot;Harris Benedict Calculator&quot;;
}

&lt;h2&gt;Harris Benedict Calculator&lt;/h2&gt;

@using(Html.BeginForm(&quot;CalculatorResult&quot;, &quot;Main&quot;, FormMethod.Post)){
    &lt;fieldset&gt;
        &lt;legend&gt;Information about you&lt;/legend&gt;

        &lt;div class=&quot;editor-label&quot;&gt;Are you male?&lt;/div&gt;
        &lt;div class=&quot;editor-field&quot;&gt;@Html.CheckBox(&quot;IsMale&quot;, Model.IsMale)&lt;/div&gt;


        &lt;div class=&quot;editor-label&quot;&gt;Weight (in kilos)&lt;/div&gt;
        &lt;div class=&quot;editor-field&quot;&gt;&lt;input name=&quot;Weight&quot; value=&quot;@Model.Weight&quot; /&gt;&lt;/div&gt;

        &lt;div class=&quot;editor-label&quot;&gt;Height (in centimetres)&lt;/div&gt;
        &lt;div class=&quot;editor-field&quot;&gt;&lt;input name=&quot;Height&quot; value=&quot;@Model.Height&quot; /&gt;&lt;/div&gt;

        &lt;div class=&quot;editor-label&quot;&gt;Age (in years)&lt;/div&gt;
        &lt;div class=&quot;editor-field&quot;&gt;&lt;input name=&quot;Age&quot; value=&quot;@Model.Age&quot; /&gt;&lt;/div&gt;

        &lt;div class=&quot;submit&quot;&gt;&lt;input type=&quot;submit&quot; value=&quot;Calculate!&quot; /&gt;&lt;/div&gt;
    &lt;/fieldset&gt;
}</pre>

<p>The view sets up the form for getting the user inputs.</p>

<p>The <code>Html.BeginForm</code> defines where the form will be sent to once it is complete and how it will be sent. In this case, the form will be sent by and HTTP POST to the <code>CalculatorResult</code> method on the <code>MainController</code> class. I’ll talk more about what that does in the next section.</p>

<p>The form consists of a number of inputs which, by convention, have the same name as properties on the Model. If the model is pre-populated then the initial values will be used to populate the values in each of the input elements.</p>

<p>The <code>CheckBox</code> is a special case. Because of the way HTML works, if the checkbox is unchecked then nothing is returned. The MVC application then does not know if the checkbox was not ticked, or if the checkbox simply didn’t exist at all. This may be an important distinction. Therefore an Html helper method is available that outputs the checkbox and an hidden field to go with it.</p>

<p>At this point we can run the application and get the initial view being displayed to us:</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="7 - Rendering first view" src="http://static.colinmackay.co.uk/images/mvc/2011-05-13-Step-7-Rendering-the-first-view.png" width="640" height="480" /></p>

<h3>Submitting the answers</h3>

<p>As I mentioned above, the <code>Html.BeginForm</code> helper method tells ASP.NET MVC what controller and method to return the result to when the user presses the submit button. So, we have to create a method to process that on the specified controller (in this case <code>Main</code>)</p>

<p>The Main.CalculatorResult method looks like this:</p>

<pre>[HttpPost]
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
        new KeyValuePair&lt;string, int&gt;(&quot;Sedentry&quot;, (int)(bmr * 1.2)));
    viewModel.LifestyleRates.Add(
        new KeyValuePair&lt;string, int&gt;(&quot;Lightly Active&quot;, (int)(bmr * 1.375)));
    viewModel.LifestyleRates.Add(
        new KeyValuePair&lt;string, int&gt;(&quot;Moderately Active&quot;, (int)(bmr * 1.55)));
    viewModel.LifestyleRates.Add(
        new KeyValuePair&lt;string, int&gt;(&quot;Very Active&quot;, (int)(bmr * 1.725)));
    viewModel.LifestyleRates.Add(
        new KeyValuePair&lt;string, int&gt;(&quot;Extra Active&quot;, (int)(bmr * 1.9)));

    return View(viewModel);
}</pre>

<p>The above performs the calculation. The code may look a bit long, but the calculation is relatively simple. In a full business application this code would be separated out elsewhere.</p>

<p>The method is decorated with the <code>HttpPost</code> attribute which tells MVC that the method may only be called in response to an HTTP POST verb. The method also takes the view model class as a parameter. MVC will may the form inputs to the view model class as best it can. You can also specify a list of more primitive types (like <code>int</code>, <code>string</code>, <code>double</code>, etc.) that map to the input elements on the form.</p>

<p>The method itself performs the calculation then updates some items in the view model with the results of the calculation. The <code>View</code> is then returned with the view model.</p>

<p>The convention is that, unless specified otherwise, the view returned will be named after the controller method in a folder named after the controller class. So the view is in the ~ViewsMain folder in a file called CalculatorResult.cshtml</p>

<pre>@model HarrisBenedictCalculator.Models.HarrisBenedictViewModel

@{
    ViewBag.Title = &quot;Harris Benedict Calculator Result&quot;;
}

&lt;h2&gt;Result&lt;/h2&gt;

&lt;p&gt;For a &lt;em&gt;@(Model.IsMale ? &quot;man&quot; : &quot;woman&quot;)&lt;/em&gt; aged &lt;em&gt;@Model.Age&lt;/em&gt; years old,
weighing &lt;em&gt;@Model.Weight.ToString(&quot;0.0&quot;)&lt;/em&gt; kg, and &lt;em&gt;@Model.Height&lt;/em&gt; cm tall
should be taking in the following calories per day:
&lt;/p&gt;

&lt;div class=&quot;result&quot;&gt;
@foreach (var lifestyle in Model.LifestyleRates)
{
    &lt;div class=&quot;result-line&quot;&gt;
        &lt;span class=&quot;result-label&quot;&gt;@lifestyle.Key&lt;/span&gt;@lifestyle.Value Calories
    &lt;/div&gt;
}
&lt;/div&gt;

&lt;p&gt;@Html.ActionLink(&quot;Calculate another?&quot;, &quot;CalculatorInput&quot;, &quot;Main&quot;)&lt;/p&gt;</pre>

<p>This view extracts the data from the view model and renders it to the browser.</p>

<p>So, the answer I get looks like this:</p>

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" alt="8 - Final Result" src="http://static.colinmackay.co.uk/images/mvc/2011-05-13-Step-8-Final-Result.png" width="640" height="480" /></p>

<p>The Razor syntax is quite easy to follow for the most part. Anything starting with an @ sign indicates the start of some C# code. The rendering engine is clever enough to detect HTML code and revert back when needed.</p>

<p>At the bottom of the page the HTML helper method ActionLink generates the URL to take the user back round to the start of the process again in case they want to calculate another set of calorie intakes.</p>

<h3>Summary</h3>

<p>In this post I’ve demonstrated some very basic initial steps to get going with ASP.NET MVC 3.</p>

<p>You can also <a title="Beginning ASP.NET MVC3 source code (Harris Benedict Calculator)" href="http://bit.ly/l4AVPn">download the sample code</a> in order to have a play yourself.</p>
