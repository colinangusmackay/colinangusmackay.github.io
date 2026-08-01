---
title: "Working with Modules in node.js"
slug: working-with-modules-in-node-js
publishDate: 13 Nov 2014
description: "In my last post on node.js I showed how to set up a development environment to work with node. Now, I’m going to introduce some bits and pieces to get going a..."
tags:
  - { name: "javascript", slug: javascript }
  - { name: "node.js", slug: node-js }
---
<!-- TODO: convert this post's content to Markdown -->

In <a title="Setting up a development environment for node.js" href="http://colinmackay.scot/2014/10/14/node-js-setting-up-a-basic-development-environment/" target="_blank">my last post on node.js</a> I showed how to set up a development environment to work with node. Now, I’m going to introduce some bits and pieces to get going a bit further than a simple hello world.
<h3>Require</h3>
First off, unless you want to be working with JavaScript files that are thousands of lines long you’ll want to modularise your code into smaller components that you can bring in to other JavaScript files as required. From the API Documentation: “Node has a simple module loading system. In Node, files and modules are in one-to-one correspondence.”

The “<code>require</code>” keyword allows you to do this. You must also remember that <code>require</code> will return an object that represents that module, so you need to assign it to a variable.

Here is an example, showing you how to <code>require</code> the <code><a title="Node.js documentation: readline" href="http://nodejs.org/api/readline.html" target="_blank">readline</a></code> module so that you can ask questions at the command line.
<pre>var readline = require("readline"),
    rlInterface = readline.createInterface({
        input: process.stdin, 
        output:process.stdout});

rlInterface.question("What is your name? ", function(answer){
    console.log("Hello, "+answer+".");
    rlInterface.close();
});</pre>
And if you run the application, it will look something like this:
<pre>$ node whatsYourName.js
What is your name? Colin
Hello, Colin.</pre>
<h3>Exports</h3>
The above is great if you want to include a node module. But if you are building your own, then there is a little more work needing done.

In your module you need to add <code>module.exports</code> to indicate what is being exported from the module. Since it is just a bag of properties you can create what ever you need for the module.

e.g. This is the code for myModule.js
<pre>module.exports.someValue = "This is some value being exported from the module";
module.exports.someFunction = function(a, b){
    return a+b;
};</pre>
And the consumer of that module (moduleConsumer.js):
<pre>var myModule = require("./myModule.js");
console.log("This is someValue: "+myModule.someValue)
console.log("This is the result of someFunction: ", myModule.someFunction(2,3));</pre>
Which produces the output:
<pre>$ node moduleConsumer.js
This is someValue: This is some value being exported from the module
This is the result of someFunction:  5</pre>
One thing you might notice that is different from before is that when you <code>require</code> code that is in your project then you need to specify the path to the JavaScript file, even if it is in the same folder. So for files in the same folder you need to prefix the name of the JavaScript file with "<code>./</code>".

If you have various files that need to include a specific module, then the first call to <code>require</code> will create the module, then each call after that will get a cached version of the module. So, if you put in a <code>log</code> statement at the top of your module to say that it is being loaded, then that <code>log</code> statement will only be run once regardless of the number of times you <code>require</code> that module.

<h3>Requiring a folder</h3>
You can <code>require</code> a folder rather than a specific file. In this case, what node does it looks for a file in the folder called <code>packages.json</code>, then <code>index.js</code>.

<code>packages.json</code> is a file containing a piece of json that describes module that bootstraps the rest. e.g.
<pre>{ "name" : "my-library",
  "main" : "./lib/my-library.js" }</pre>
The "main" property describes the JavaScript file that is the entry point into the module that bootstraps the rest.

If it finds an <code>index.js</code> file then that file is uses as the entry point that bootstraps the rest of the folder.
