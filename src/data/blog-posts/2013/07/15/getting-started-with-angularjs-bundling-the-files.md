---
title: "Getting Started with AngularJS - Bundling the files"
slug: getting-started-with-angularjs-bundling-the-files
publishDate: 15 Jul 2013
description: "When you are building AngularJS apps you will probably want to store all your various controllers, directives, filters, etc. into different files to keep it..."
tags:
  - { name: "AngularJS", slug: angularjs }
  - { name: "ASP.NET 4.5", slug: asp-net-4-5 }
  - { name: "Bundles", slug: bundles }
  - { name: "C#", slug: c }
  - { name: "System.Web.Optimization", slug: system-web-optimization }
---
<!-- TODO: convert this post's content to Markdown -->

<p>When you are building AngularJS apps you will probably want to store all your various controllers, directives, filters, etc. into different files to keep it all nicely separated and easy to manage. However, putting script blocks to all those files in your HTML is not efficient in the least. Not only do you have several round-trips to the server, the browser will be downloading a lot of code that is designed to be readable and maintainable, potentially with lots of additional whitespace and comments.</p>  <p>If the back end of your application is using .NET then you can bundle together CSS and Javascript files to make them more optimised.</p>  <p>For example, I have a small AngularJS prototype application that uses bundling so that, when it is run with the optimisations turned on, it will need less files and more compact javascript and CSS. The method that creates these bundles looks like this:</p>  <pre>public static void RegisterBundles(BundleCollection bundles)
{
    bundles.Add(new StyleBundle(&quot;~/Content/base-styles.css&quot;)
        .Include(&quot;~/Content/bootstrap.css&quot;)
        .Include(&quot;~/Content/angular-ui.css&quot;)
        .Include(&quot;~/Content/angularCatalogue.css&quot;));

    bundles.Add(new ScriptBundle(&quot;~/Scripts/base-frameworks.js&quot;)
        .Include(&quot;~/Scripts/jquery-{version}.js&quot;)
        .Include(&quot;~/Scripts/angular.js&quot;)
        .Include(&quot;~/Scripts/angular-resource.js&quot;)
        .Include(&quot;~/Scripts/angular-ui.js&quot;)
        .Include(&quot;~/Scripts/bootstrap.js&quot;));

    bundles.Add(new ScriptBundle(&quot;~/Scripts/angular-catalogue.js&quot;)
    // Configure the Angular Application
      .Include(&quot;~/ngapp/app.js&quot;)

    // Filters
      .Include(&quot;~/ngapp/filters/idFilter.js&quot;)
      .Include(&quot;~/ngapp/filters/allBut.js&quot;)

    // The services
      .Include(&quot;~/ngapp/Services/colourService.js&quot;)
      .Include(&quot;~/ngapp/Services/brandService.js&quot;)
      .Include(&quot;~/ngapp/Services/productTypeService.js&quot;)
      .Include(&quot;~/ngapp/Services/productService.js&quot;)
      .Include(&quot;~/ngapp/Services/sizeService.js&quot;)

  // Directives
      .Include(&quot;~/ngapp/Directives/userFilter.js&quot;)
      .Include(&quot;~/ngapp/Directives/productDetailsDirective.js&quot;)

  // Controllers
      .Include(&quot;~/ngapp/Controllers/productSearchController.js&quot;)
      .Include(&quot;~/ngapp/Controllers/productDetailController.js&quot;)
      .Include(&quot;~/ngapp/Controllers/editProductController.js&quot;));
}</pre>

<p>This method is called from the <code>Application_Start()</code> method in global.asax.cs.</p>

<p>What this does is set up a number of bundles. In this case three bundles are set up. One for the CSS, and two for javascript (one is a set of standard third party libraries, the other is the angularJS application itself).</p>

<p>In the layout or view you can then reference these bundles using the path passed in to the constructor. Like this:</p>

<pre>&lt;html&gt;
  &lt;head&gt;
    &lt;!-- Other bits go here --&gt;
    @Styles.Render(&quot;~/Content/base-styles.css&quot;)
  &lt;/head&gt;
  &lt;body&gt;
    @RenderBody()
    @Scripts.Render(&quot;~/Scripts/base-frameworks.js&quot;)
    @Scripts.Render(&quot;~/Scripts/angular-catalogue.js&quot;)
  &lt;/body&gt;
&lt;/html&gt;</pre>

<p>Remember to use the tilde notation just like in the code that defines the bundles.</p>

<p>When the optimisations are turned off the scripts will render as a script block per include. When the optimisations are turned on then it outputs one script block. When the server receives a request for that script it resolves the name to match the bundle, it then sends back an amalgamated and minified&#160; version of that script file. This then loads much faster on the client as there are less roundtrips to the server and takes much less bandwidth.</p>

<p>Here’s what the two scenarios look like:</p>

<h3>Optimisations turned off</h3>

<p>This is what the two <code>@Script.Render()</code> blocks at the end of the HTML look like:</p>

<pre>&lt;script src=&quot;/Scripts/jquery-1.9.1.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/Scripts/angular.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/Scripts/angular-resource.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/Scripts/angular-ui.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/Scripts/bootstrap.js&quot;&gt;&lt;/script&gt;

&lt;script src=&quot;/ngapp/app.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/filters/idFilter.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/filters/allBut.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Services/colourService.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Services/brandService.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Services/productTypeService.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Services/productService.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Services/sizeService.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Directives/userFilter.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Directives/productDetailsDirective.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Controllers/productSearchController.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Controllers/productDetailController.js&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/ngapp/Controllers/editProductController.js&quot;&gt;&lt;/script&gt;</pre>

<p>And when this is rendered in the browser, the following calls are made.</p>

<p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/system.web.optimisation/2013-07-15-not-optimised-600.png" /></p>

<p>There are 18 requests in the above example. 901kb is transferred to the browser and it took 911ms to complete loading everything (the above does not show images, css or ajax calls that are also downloaded as part of the page) </p>

<h3>Optimisations turned on</h3>

<p>Now, compare the above to this representation of the same section of the page:</p>

<pre>&lt;script src=&quot;/Scripts/base-frameworks.js?v=oHeDdLNj8HfLhlxvF-JO29sOQaQAldq0rEKGzugpqe01&quot;&gt;&lt;/script&gt;
&lt;script src=&quot;/Scripts/angular-catalogue.js?v=fF1y8sFMbNn8d7ARr-ft_HBP_vPDpBfWVNTMCseNPC81&quot;&gt;&lt;/script&gt;</pre>

<p>And when rendered in the browser, it makes the following requests:</p>

<p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/system.web.optimisation/2013-07-15-optimised-600.png" /></p>

<p>There are now just two requests, one for the base-framework bundle, and one for the angular-catalogue (our application code) bundle. </p>

<p>Because the bundling process minifies the files the amount of data transferred is much smaller too, in this case 223kb (a saving of 678kb or roughly 75%). For established frameworks that ship with a *.min.js version the bundling framework will use that convention and use the existing minified file. If it can’t find one it will minify the file for you.</p>

<p>And because there is less data to transfer and less network round-trips to wait for the time to fully load the page has been reduced&#160; to 618ms (a saving of 293ms or roughly ⅔ of the time of the previous request).</p>

<h3>More information</h3>

<p>There is a lot more to bundling than I’ve mentioned here. For a more in depth view of bundling read <a href="http://weblogs.asp.net/scottgu/archive/2011/11/27/new-bundling-and-minification-support-asp-net-4-5-series.aspx">Scott Guthrie’s blog on Bundling and Minification Support</a>.</p>
