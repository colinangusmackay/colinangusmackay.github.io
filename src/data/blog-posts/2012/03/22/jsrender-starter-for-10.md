---
title: "JsRender .... starter for 10"
slug: jsrender-starter-for-10
publishDate: 22 Mar 2012
description: "I was going to look at jQuery Templates recently, but then I discovered they have been discontinued. Which is a real pity as I saw a demonstration at a..."
tags:
  - { name: "javascript", slug: javascript }
  - { name: "jQuery", slug: jquery }
  - { name: "JsRender", slug: jsrender }
---
<!-- TODO: convert this post's content to Markdown -->

I was going to look at jQuery Templates recently, but then I discovered they have been discontinued. Which is a real pity as I saw a demonstration at a conference about a year ago and they looked rather promising. However, there are other similar projects out there that do similar things. So instead, I'm going to look at <a href="https://github.com/BorisMoore/jsrender">JsRender</a> and <a href="https://github.com/BorisMoore/jsviews">JsViews</a>.

At the moment there is very little documenation out there for either JsRender or JsViews, so this is some of the bits I've been able to piece together. Some of the simpler demos actually only use JsRender. And, of course, at this stage the project is still pre-beta so some of this may change.

To get going you need to add a reference to the JsRender javascript library. You can find that on <a title="JsRender project on github" href="https://github.com/BorisMoore/jsrender">github</a>. Although you don't need jQuery for JsRender, it can take advantage of jQuery to make some things easier. I'll be showing JsRender with jQuery as I happen to think it makes things easier.
<h3>Hello World!</h3>
To start with the template is rendered in a script block with a type of "text/x-jsrender". The templated parts themselves are made up of two sets of braces with an expression inside. For example:
<pre>&lt;script id="helloTemplate" type="text/x-jsrender"&gt;
  &lt;p&gt;Hello, {{:name}}!&lt;/p&gt;
&lt;/script&gt;</pre>
Next, we need some javascript to wire up the template with some data
<pre>&lt;script type="text/javascript"&gt;
  $(function(){
    // Set up the data
    var thePerson = { name: "Colin" };

    // Render the template to a string
    var renderedHtml = $("#helloTemplate").render(thePerson);

    // insert the rendered template into an existing element
    // In this case it is a span.
    $("#container").html(renderedHtml);
  });
&lt;/script&gt;</pre>
To see the example in action, <a href="http://static.colinmackay.co.uk/examples/2012/JsRender/demos/hello-world.html">click here</a> and view the source of the page to see the underlying code.
