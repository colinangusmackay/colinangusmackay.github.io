---
title: "Node.js – Setting up a basic development environment"
slug: node-js-setting-up-a-basic-development-environment
publishDate: 14 Oct 2014
description: "Node.js is a platform for executing JavaScript outside of the browser. It runs on the Google V8 engine which effectively means it is cross platform as it can..."
tags:
  - { name: "node.js", slug: node-js }
  - { name: "Sublime", slug: sublime }
  - { name: "visual studio", slug: visual-studio }
  - { name: "WebStorm", slug: webstorm }
---
<!-- TODO: convert this post's content to Markdown -->

Node.js is a platform for executing JavaScript outside of the browser. It runs on the <a href="https://code.google.com/p/v8/" target="_blank">Google V8 engine</a> which effectively means it is cross platform as it can run on Windows, Mac OS X, and Linux.

Since JavaScript written for Node.js is running on one platform issues that plague browser based JavaScript does not occur on Node.js. There are no “Browser Compatibility” issues. It simply runs ECMAScript 5.
<h3></h3>
<h3>Installing</h3>
To install Node.js download the installer from the <a href="http://nodejs.org/" target="_blank">node.js homepage</a>. The “Install” button should give you the correct installer for the platform you are on, but if not, or your are downloading for a different platform you can get <a href="http://nodejs.org/download/" target="_blank">a list of each download</a> available, including source code.

One thing I really like about the windows installer is that it offers to add Node.js to the PATH. Something that more developer tools should do.

<img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/2014-10-11-nodejs-installer.png" alt="" />
<h3>Writing JavaScript for Node.js</h3>
While you can use a basic text editor, or even a more sophisticated text editor, IDEs are also available for writing node.js.

<strong>IDE – Node.js Tools for Visual Studio</strong>

There is a plug in for Visual Studio that is in beta (at the time of writing) which allows you to create node.js projects. This is very useful if you are doing cross platform development interacting with .NET based applications, or if you are simply used to working with Visual Studio. I like this option because I’ve been working with Visual Studio since version 2.1 (that came out in the early-to-mid-90s).

To get the extension for the Node.js tools for Visual Studio, go to <a title="http://nodejstools.codeplex.com/" href="http://nodejstools.codeplex.com/">http://nodejstools.codeplex.com/</a>. If you don’t want to default download (which is for the latest version of visual studio) go to the downloads tab and select the appropriate download for your version of Visual Studio.

In the future, I would expect it to be available directly in Visual Studio through the <strong>Tools-&gt;Extensions and Updates…</strong> manager.

Once installed, you can create a new node.js project in the same way you’d create any new project. The Extension will have added some extra options in to the New Project dialog.

<img src="http://static.colinmackay.co.uk/images/nodejs/2014-10-14-nodejs-new-project-visual-studio.png" alt="" />

You can set break-points, examine variables, set watches and so on. The following is an example of a very simple Hello World application with a break point set and the local variables showing up in the panel at the bottom.

<img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/2014-10-11-nodejs-in-visual-studio.png" alt="" />

<strong>IDE – JetBrains Web Storm</strong>

If you don’t already have Visual Studio it may be an expensive option. <a href="http://www.jetbrains.com/" target="_blank">JetBrains</a> <a href="http://www.jetbrains.com/webstorm/" target="_blank">Web Storm</a> is another IDE that allows you to create Node.js applications with a similar set of features to the Visual Studio extension above. Personally, I find Web Storm a little clunky but it works across Windows, Mac OS X, and Linux. If you don’t already have access to Visual Studio it is a much less expensive too.

<img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/2014-10-14-nodejs-helloworld-webstorm.png" alt="" />

<strong>Text Editors</strong>

Besides IDEs you can always use text editors. Some are more advanced than others.

The text editor I hear most about these days is <a href="http://www.sublimetext.com/" target="_blank">Sublime</a>, which can be more expensive than WebStorm depending on the license needed.  Sublime is a very nice looking text editor and it has its own plug-in system so can be extended, but for roughly the same money you could get a fully featured IDE.

<img style="float:none;margin-left:auto;display:block;margin-right:auto;" src="http://static.colinmackay.co.uk/images/nodejs/2014-10-14-sublime-helloworld.png" alt="" />
<h3>Summary</h3>
I’ve not really gone all that much into the text editors available that support developing for JavaScript with Note.js because I don’t feel they really add much. A fully featured IDE with refactoring support is much more important to me. Maybe installing ReSharper corrupted me.
