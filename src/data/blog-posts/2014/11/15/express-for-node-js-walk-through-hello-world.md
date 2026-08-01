---
title: "Express for node.js walk through – Hello World"
slug: express-for-node-js-walk-through-hello-world
publishDate: 15 Nov 2014
description: "While both Visual Studio and WebStorm have templates for node.js Express applications in this post (and and subsequent few posts) I’m going to walk through..."
tags:
  - { name: "express", slug: express }
  - { name: "node.js", slug: node-js }
---
<!-- TODO: convert this post's content to Markdown -->

<p>While both Visual Studio and WebStorm have templates for node.js Express applications in this post (and and subsequent few posts) I’m going to walk through setting up an Express application so that you can see how it fits together.</p>  <h3>Installing Express</h3>  <p>To start with I created a folder with just a <code>package.json</code> file in it, then in a command line I ran <code>npm</code> to install Express:</p>  <pre>npm install express –save</pre>

<h3>Express &quot;Hello, World!&quot;</h3>

<p>At this stage an <code>app.js</code> file is created. It will bootstrap the Express application. It will configure the environment and start the HTTP listener.</p>

<p>In both the WebStorm and Visual Studio templates there is a line of code that looks like this:</p>

<pre>app.set('port', process.env.PORT || 3000);</pre>

<p>What this is doing is getting the port to run the application on. By default it will take the value in the &quot;port&quot; environment variable, and if not found it will default to port 3000 within the scope of the process. Although it is setting back the value of the environment variable it isn't persisted outside of the application, so it really just serves to set up a default value without you having to check for a value and supply a default value when ever it is actually needed.</p>
The full application, at this point is this: 

<pre>// Requirements
var express = require(&quot;express&quot;);
var http = require(&quot;http&quot;);

// Set up the application
var app = express();
app.set(&quot;port&quot;, process.env.PORT || 3000);

// Run up the server
http.createServer(app).listen(app.get(&quot;port&quot;), function(){
    console.log(&quot;Express server listening on port &quot; + app.get(&quot;port&quot;));
});</pre>

<p>The <a href="http://nodejs.org/api/http.html" target="_blank">HTTP module</a> is the bit that communicates with the outside world, so we require it for our application to work. We create the server and pass it the <code>app</code> which is a function HTTP's <a href="http://nodejs.org/api/http.html#http_event_request" target="_blank"><code>request</code></a> event can call. The <code>createServer</code> then returns a server object. As we want to start listening immediately we can just call <code>listen</code> on the server, passing it the port we want to listen on, and a callback function that will be called when the server fires the <code>listening</code> event to indicate that it has started listening for requests.</p>

<p>At this point, browsing on localhost with the defined port will just result in Express responding with a terse error message. But at least it proves that it is listening and can respond</p>

<p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/expressjs/2014-11-13-express-no-routes.png" /></p>

<p>It seems to be a convention, not one that is enforced by the framework, that handlers for the routes are put in a folder called <code>routes</code>, so a file is created called <code>hello.js</code> and it simply looks like this:</p>

<pre>module.exports = function(req, res) {
    res.send(&quot;&lt;h1&gt;Hello, World!&lt;/h1&gt;&quot;);
};</pre>

<p><code>req</code> is the request, and <code>res</code> is the response. Very simply the response can <code>send</code> some content back to the browser. In this case it is hand crafted HTML (and very simple at that).</p>

<p>Back in the <code>app.js</code> file, a <code>require</code> line is added to bring in the <code>hello.js</code> module, and further down the route is added to the application.</p>

<pre>var hello = require(&quot;./routes/hello.js&quot;);
...
app.get(&quot;/&quot;, hello);</pre>

<p>Now the application will respond to a GET request on the root URL of the application. The function exported by <code>hello.js</code> will be run whenever this URL is requested by the browser.</p>

<p><img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/expressjs/2014-11-15-express-hello-world.png" /></p>

<p>The whole app.js file now looks like this:</p>

<pre>// Requirements
var express = require(&quot;express&quot;);
var http = require(&quot;http&quot;);
var hello = require(&quot;./routes/hello.js&quot;);

// Set up the application
var app = express();
app.set(&quot;port&quot;, process.env.PORT || 3000);
app.get(&quot;/&quot;, hello);

// Run up the server
http.createServer(app).listen(app.get(&quot;port&quot;), function(){
    console.log(&quot;Express server listening on port &quot; + app.get(&quot;port&quot;));
});</pre>
