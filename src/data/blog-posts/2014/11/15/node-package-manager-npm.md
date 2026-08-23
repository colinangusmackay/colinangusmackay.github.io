---
title: "Node Package Manager – npm"
slug: node-package-manager-npm
publishDate: 15 Nov 2014
description: "The Node Package Manager is a bit like NuGet for node. It is a way to get additional functionality into node for frameworks that were not bundled with node..."
tags:
  - { name: "node.js", slug: node-js }
  - { name: "npm", slug: npm }
---
<!-- ISSUE: link (https://www.npmjs.org/doc/files/package.json.html): status 404 -->

The Node Package Manager is a bit like NuGet for node. It is a way to get additional functionality into node for frameworks that were not bundled with node itself.

Like NuGet it has its own website where you can browse the available packages. It is at <https://www.npmjs.org/>

### Installing a package

To installing a package, just type at the command line while in your application directory:

```bash
npm install [package-name]
```

For example:

```bash
npm install express 
```

which will install the **express** framework (a web application framework which is very similar to Sinatra on Ruby or Nancy on .NET)

The package manager will create a directory called `node_modules` and put the package(s) it installs there.

### Using the package in your application

As with any module you need a `require` statement in your application. However, even although npm has installed the package in your application's directory you don't need a path to the module like you would with your own modules within your application. A simple `require("[package-name]")` will do.

### Modules and Source Control

Like other package managers you wouldn’t generally expect the packages themselves to be checked into source control. You can put a file called `package.json` in the root of your application to define how your application is configured. It contains some basic metadata about the application and can also include the packages that the application relies on. Full details can be found here: <https://web.archive.org/web/20150319125214/https://docs.npmjs.com/files/package.json>. If that is a bit much and you want a quick overview, there is also a [cheat sheet available](http://browsenpm.org/package.json "package.json Cheat Sheet").

At its most basic, you want to have a package.json with at least the opening and closing braces. This is enough for npm to update the file with the details of the package it is installing. An empty file will just cause an error.

To ensure that the packages get saved to the package.json file remember the `--save` switch on the command line. e.g.

```bash
npm install express --save
```

So, now your application can be committed to source control without having to add the packages in too. You can add the `node_packages` folder in your `.gitignore` file (or what ever your source control system requires)

When retrieving the application from source control or getting an update, you can run the install command on its own without any other parameters to tell the node package manager to read the `package.json` file and install all of the dependencies it finds. Like this:

```bash
npm install
```
