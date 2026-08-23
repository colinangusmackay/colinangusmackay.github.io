---
title: "Express for node.js walk through – Hello World"
slug: express-for-node-js-walk-through-hello-world
publishDate: 15 Nov 2014
description: "While both Visual Studio and WebStorm have templates for node.js Express applications in this post (and and subsequent few posts) I’m going to walk through..."
tags:
  - { name: "express", slug: express }
  - { name: "node.js", slug: node-js }
---
While both Visual Studio and WebStorm have templates for node.js Express applications in this post (and and subsequent few posts) I’m going to walk through setting up an Express application so that you can see how it fits together.

### Installing Express

To start with I created a folder with just a `package.json` file in it, then in a command line I ran `npm` to install Express:

```bash
npm install express –save
```

### Express "Hello, World!"

At this stage an `app.js` file is created. It will bootstrap the Express application. It will configure the environment and start the HTTP listener.

In both the WebStorm and Visual Studio templates there is a line of code that looks like this:

```js
app.set('port', process.env.PORT || 3000);
```

What this is doing is getting the port to run the application on. By default it will take the value in the "port" environment variable, and if not found it will default to port 3000 within the scope of the process. Although it is setting back the value of the environment variable it isn't persisted outside of the application, so it really just serves to set up a default value without you having to check for a value and supply a default value when ever it is actually needed.

The full application, at this point is this:

```js
// Requirements
var express = require("express");
var http = require("http");

// Set up the application
var app = express();
app.set("port", process.env.PORT || 3000);

// Run up the server
http.createServer(app).listen(app.get("port"), function(){
    console.log("Express server listening on port " + app.get("port"));
});
```

The [HTTP module](http://nodejs.org/api/http.html) is the bit that communicates with the outside world, so we require it for our application to work. We create the server and pass it the `app` which is a function HTTP's [`request`](http://nodejs.org/api/http.html#http_event_request) event can call. The `createServer` then returns a server object. As we want to start listening immediately we can just call `listen` on the server, passing it the port we want to listen on, and a callback function that will be called when the server fires the `listening` event to indicate that it has started listening for requests.

At this point, browsing on localhost with the defined port will just result in Express responding with a terse error message. But at least it proves that it is listening and can respond

![](/assets/blog/2014-11-15-express-for-node-js-walk-through-hello-world-1.webp)

It seems to be a convention, not one that is enforced by the framework, that handlers for the routes are put in a folder called `routes`, so a file is created called `hello.js` and it simply looks like this:

```js
module.exports = function(req, res) {
    res.send("<h1>Hello, World!</h1>");
};
```

`req` is the request, and `res` is the response. Very simply the response can `send` some content back to the browser. In this case it is hand crafted HTML (and very simple at that).

Back in the `app.js` file, a `require` line is added to bring in the `hello.js` module, and further down the route is added to the application.

```js
var hello = require("./routes/hello.js");
...
app.get("/", hello);
```

Now the application will respond to a GET request on the root URL of the application. The function exported by `hello.js` will be run whenever this URL is requested by the browser.

![](/assets/blog/2014-11-15-express-for-node-js-walk-through-hello-world-2.webp)

The whole app.js file now looks like this:

```cs
// Requirements
var express = require("express");
var http = require("http");
var hello = require("./routes/hello.js");

// Set up the application
var app = express();
app.set("port", process.env.PORT || 3000);
app.get("/", hello);

// Run up the server
http.createServer(app).listen(app.get("port"), function(){
    console.log("Express server listening on port " + app.get("port"));
});
```
