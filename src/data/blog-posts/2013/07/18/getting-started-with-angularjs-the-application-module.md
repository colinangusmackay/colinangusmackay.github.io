---
title: "Getting Started with AngularJS - The Application Module"
slug: getting-started-with-angularjs-the-application-module
publishDate: 18 Jul 2013
description: "As with all applications there has to be a starting point. Where does the application start? In AngularJS that starting point is the module. And because a..."
tags:
  - { name: "AngularJS", slug: angularjs }
  - { name: "HTML", slug: html }
  - { name: "javascript", slug: javascript }
---
<!-- TODO: convert this post's content to Markdown -->

<p>As with all applications there has to be a starting point. Where does the application start? In AngularJS that starting point is the module.</p>  <p>And because a module is, well, modular, you can plug modules into each other to build the application, share components and so on.</p>  <p>Actually, I suppose in Angular it actually starts with a directive, that points to the module to start with, because, if you have more than one, which one do you start with?</p>  <pre>&lt;html ng-app=&quot;angularCatalogue&quot;&gt;
  <!-- Rest of the page here -->
&lt;/html&gt;</pre>

<p>The <code>ng-app</code> directive bootstraps the application by telling AngularJS which module contains the root of the application.</p>

<p>A module is defined like this:</p>

<pre>angular.module(&quot;angularCatalogue&quot;,[])</pre>

<p>The name of the above module is &quot;angularCatalogue&quot;, the name of the application, which is what is placed in the <code>ng-app</code> directive in the html element previously.</p>

<p>You can also add as a second parameter to the module an array of other modules to inject. The modules don't necessarily have to be loaded in any particular, so it is okay to refer to a module that may not exist at that point.</p>

<p>The module function returns a Module object, which you can then set up as you need it. Typically an application will have some sort of configuration, controllers, directives, services and so on.</p>

<h3>Wiring up the view</h3>

<p>In the html you will need to indicate where the view is to be placed.</p>

<p>You can do this via the ng-view directive, which can look like this:</p>

<pre>&lt;ng-view&gt;&lt;/ng-view&gt;</pre>

<p>or</p>

<pre>&lt;div ng-view&gt;&lt;/div&gt;</pre>

<p>Everything inside the element will be replaced with the contents of the view.</p>

<p>The application then needs to be told where the view is. You can configure the application module with that information, like this:</p>

<pre>angular.module(&quot;angularCatalogue&quot;) 
    .config([&quot;$routeProvider&quot;, function($routeProvider){
        $routeProvider.when(&quot;/&quot;,
            {
                templateUrl:&quot;/ngapp/templates/search.html&quot;,
                controller: &quot;productSearchController&quot;
            });
    }]);</pre>

<p>The <code>config</code> call on the module allows the module to be configured. It takes an array that consisted of the names of objects to be injected into the configuration and the function that performs the configuration.</p>

<p>The function has a <code>$routeProvider</code> injected into it. This allows routing to be set up. In the example above a route is set up from the home page of the application (<code>&quot;/&quot;</code>) that inserts the given template into the element (<code>ng-view</code>) that designated the view and it uses the given controller.</p>

<p>I’ll move onto controllers in an upcoming post.</p>

<h3>A note on the dependency injection</h3>
If you never minify you javaScript you can get away with something like this: 

<pre>angular.module('myApplication')
    .config(function($routeProvider){
        ...
     });</pre>

<p>You'll notice that there is no array, it is just taking a function. Angular can work out from the parameter names what needs to be injected. However, if the code is minified most minifiers will alter the parameter names to save space in which case angular's built in dependency injection framework fails because it no longer knows what to resolve things to. Minifiers do not, however, minify string literals. If the string literals exist then it will use them as to determine what gets resolved into which parameter position. The strings must match the position of their counterpart in the function parameters.</p>
Therefore the minifier friendly version of the previous snippet becomes: 

<pre>angular.module('myApplication')
    .config(['$routeProvider', function($routeProvider){
        ...
     }]);</pre>

<h3>A note on naming conventions</h3>

<p>You can name things what you like but AngularJS has some conventions reserved for itself.</p>

<ul>
  <li>Its own services are prefixed with a <code>$</code> (dollar). Never name your services with a dollar prefix as your code may become incompatible with future versions of angular. </li>

  <li>Its own directives are prefixed with <code>ng</code>. Similarly to the previous convention, don't name any of your directives with an <code>ng</code> prefix as it may clash with what's in future versions of angular. </li>

  <li>In javaScript everything is camel cased (the first word is all lower cased, subsequent words have the first letter capitalised), in the HTML dashes separate the words. So if you create a directive called <code>myPersonalDirective</code> when that directive is placed in HTML it becomes <code>my-personal-directive</code>. </li>
</ul>
