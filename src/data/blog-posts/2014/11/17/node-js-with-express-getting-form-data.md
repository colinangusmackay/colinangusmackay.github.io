---
title: "Node.js with Express - Getting form data"
slug: node-js-with-express-getting-form-data
publishDate: 17 Nov 2014
description: "Now that view engines are wired up and working on this application, the next area to look at is getting data back from the browser. By default Express doesn’t..."
tags:
  - { name: "body-parser", slug: body-parser }
  - { name: "express", slug: express }
  - { name: "node.js", slug: node-js }
---
<!-- TODO: convert this post's content to Markdown -->

<p>Now that <a href="http://colinmackay.scot/2014/11/16/express-for-node-js-view-engines/" target="_blank">view engines are wired up and working</a> on this application, the next area to look at is getting data back from the browser.</p>  <p>By default Express doesn’t do anything with form data in the request and a piece of “middleware” needs to be added to get this to work. The reason for this is that there are many ways to process data from the browser (or perhaps it is data from something that is not a browser), so it is left up to the developer how best to process that data.</p>  <p>The view now has a form element and a submit button. It also has an input which will contain the name of the language the user wants. This information is transmitted to the server when the user presses the submit button.</p>  <p>In order to read this information a piece of middleware called <code><a href="https://www.npmjs.org/package/body-parser" target="_blank">body-parser</a></code> is added.</p>  <p>First, it has to be installed into the application:</p>  <pre>npm install body-parser --save</pre>

<p>Then the application need to know about it. The following changes are made to the <code>app.js</code> file:</p>

<pre>// In the requiments section
var bodyParser = require(&quot;body-parser&quot;);
...
// In the set up section
app.use(bodyParser.urlencoded());
...
// Set up the route as an HTTP POST request.
app.post(&quot;/set-language&quot;, setLanguage);</pre>

<p>Since <code>body-parser</code> can handle a few different types of encoding the application needs to know which to expect. Browsers return form data as <code>application/x-www-form-urlencoded parser</code>, so that's the parser that is used by the application.</p>

<p>There are some limitations to <code>body-parser</code> but it is good enough for this application. For example, it does not handle multi-part form data.</p>

<p>The route function can now read the <code>body</code> property that <code>body-parser</code> previously populated.</p>

<pre>module.exports = function(req, res){
    var language = req.body.language;
    res.send(&quot;set-language to &quot;+language);
};</pre>

<p>This will now return a simple message to the user with the language code that was set on the previous page.</p>

<h3>Viewing the full source code</h3>

<p>Rather than paste the source code at the end of the blog post, I’ve released the project on to <a href="https://github.com/colinangusmackay/Xander.Flashcards" target="_blank">GitHub</a>. You can either browse the code there, or get&#160; a copy of the repository for examining yourself. There may be changes coming, so it is best to look for <a href="https://github.com/colinangusmackay/Xander.Flashcards/releases/tag/0.0.1" target="_blank">the release that corresponds with this blog post</a>. </p>
