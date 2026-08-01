---
title: "Node Package Manager – npm"
slug: node-package-manager-npm
publishDate: 15 Nov 2014
description: "The Node Package Manager is a bit like NuGet for node. It is a way to get additional functionality into node for frameworks that were not bundled with node..."
tags:
  - { name: "node.js", slug: node-js }
  - { name: "npm", slug: npm }
---
<!-- TODO: convert this post's content to Markdown -->

<p>The Node Package Manager is a bit like NuGet for node. It is a way to get additional functionality into node for frameworks that were not bundled with node itself.</p>  <p>Like NuGet it has its own website where you can browse the available packages. It is at <a title="https://www.npmjs.org/" href="https://www.npmjs.org/">https://www.npmjs.org/</a>&#160;</p>  <h3>Installing a package</h3>  <p>To installing a package, just type at the command line while in your application directory:</p>  <pre>npm install [package-name]</pre>

<p>For example:</p>

<pre>npm install express </pre>

<p>which will install the <strong>express</strong> framework (a web application framework which is very similar to Sinatra on Ruby or Nancy on .NET)</p>

<p>The package manager will create a directory called <code>node_modules</code> and put the package(s) it installs there.</p>

<h3>Using the package in your application</h3>

<p>As with any module you need a <code>require</code> statement in your application. However, even although npm has installed the package in your application's directory you don't need a path to the module like you would with your own modules within your application. A simple <code>require(&quot;[package-name]&quot;)</code> will do.</p>

<h3>Modules and Source Control</h3>

<p>Like other package managers you wouldn’t generally expect the packages themselves to be checked into source control. You can put a file called <code>package.json</code> in the root of your application to define how your application is configured. It contains some basic metadata about the application and can also include the packages that the application relies on. Full details can be found here: <a title="https://www.npmjs.org/doc/files/package.json.html" href="https://www.npmjs.org/doc/files/package.json.html">https://www.npmjs.org/doc/files/package.json.html</a>. If that is a bit much and you want a quick overview, there is also a <a title="package.json Cheat Sheet" href="http://browsenpm.org/package.json" target="_blank">cheat sheet available</a>.</p>

<p>At its most basic, you want to have a package.json with at least the opening and closing braces. This is enough for npm to update the file with the details of the package it is installing. An empty file will just cause an error.</p>

<p>To ensure that the packages get saved to the package.json file remember the <code>--save</code> switch on the command line. e.g.</p>

<pre>npm install express --save</pre>

<p>So, now your application can be committed to source control without having to add the packages in too. You can add the <code>node_packages</code> folder in your <code>.gitignore</code> file (or what ever your source control system requires)</p>

<p>When retrieving the application from source control or getting an update, you can run the install command on its own without any other parameters to tell the node package manager to read the <code>package.json</code> file and install all of the dependencies it finds. Like this:</p>

<pre>npm install</pre>
