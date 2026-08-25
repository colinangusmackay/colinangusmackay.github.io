---
title: "Setting up Ubuntu for .NET Development"
slug: setting-up-ubuntu-for-net-development
publishDate: 06 Apr 2016
description: "First up, at the time of writing only Ubuntu 14.04LTS is supported. I've read that it will work on 15.04, but I know it won't work on 15.10 because of a binary..."
tags:
  - { name: ".net core", slug: net-core }
  - { name: "asp.net core", slug: asp-net-core }
  - { name: "linux", slug: linux }
  - { name: "Ubuntu", slug: ubuntu }
  - { name: "visual studio code", slug: visual-studio-code }
---

First up, at the time of writing only Ubuntu 14.04LTS is supported. I've read that it will work on 15.04, but I know it won't work on 15.10 because of a binary incompatibility on a library that .net core relies on.

### Step 1: Install the .NET Execution Environment

Follow the instructions at <https://web.archive.org/web/20160408232101/http://docs.asp.net:80/en/latest/getting-started/installing-on-linux.html> \*

This will install the .NET Execution Environment (DNX)

### Step 2: Install Node.js

Since .NET Core relies on node js for parts, and there are some cool code generators using node.js as the templating engine, install node.js by following the instructions here: <https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions>

I used version 4.x LTS (4.4.1 to be exact)

### Step 3: Install Visual Studio Code

This is actually optional - I'm installing it because I wanted to get the standard IDE for C#. You can get away with running just the regular text editor installed with Ubuntu.

First, [download Visual Studio Code](https://code.visualstudio.com/). Then follow the [setup instructions](https://code.visualstudio.com/docs/editor/setup#_linux).... Kind of.

Unzipped the zip file to `/usr/local/bin` with

```bash
sudo unzip ~/Downloads/VSCode-linux-x64-stable.zip
```

Then I created the link as in the instructions so that I can launch from the terminal.
To launch from the terminal and get the prompt back use

```bash
code &
```

### Step 4: Install Yeoman

Before you do, you'll need up to update NPM as the version that comes with 4.x LTS is older and the current version of Yeomen doesn't like it.

```bash
sudo npm install -g npm
```

Install yeoman by following the instructions here: <https://github.com/omnisharp/generator-aspnet#generator-aspnet>

Remember to put `sudo` in front of install commands specifying `-g` (global) otherwise you'll get an error message.

### Step 5: Create a project

Move to a directory that you want to create a new project in. I use `~/dev` for all my development work.

Then start Yeoman with:

```bash
yo aspnet
```

This will result in a prompt that looks like this:

```
     _-----_
    |       |    .--------------------------.
    |--(o)--|    |      Welcome to the      |
   `---------´   |   marvellous ASP.NET 5   |
    ( _´U`_ )    |        generator!        |
    /___A___\    '--------------------------'
     |  ~  |     
   __'.___.'__   
 ´   `  |° ´ Y ` 

? What type of application do you want to create? (Use arrow keys)
❯ Empty Application 
  Console Application 
  Web Application 
  Web Application Basic [without Membership and Authorization] 
  Web API Application 
  Nancy ASP.NET Application 
  Class Library 
  Unit test project 
```

You can then use the arrow keys to move up and down the list.

Choose "Web Application Basic"

It will then prompt for a name. I chose "MyHelloWorldApp"

It will create that directory and populate it with files for the project. You'll still need to restore the packages that you need, and yeomen gives you some help on getting that done.

If you follow the yeomen instructions you'll find that at the `dnu build` step it fails. This is because the project template has dual targeting. It targets .NET 4.5.1 and .NET Core. On Linux only .NET Core will run. To remove the dual targetting open the `project.json` file and find the section that looks like this:

```json
  "frameworks": {
    "dnx451": {},
    "dnxcore50": {}
  },
```

And remove the entry for `"dnx451"` then save the file.

`dnu build` won't work just yet. If you try it you'll get an error message:

```
/home/colin/dev/MyHelloWorldApp/project.lock.json(1,0): error NU1006: Dependencies in project.json were modified. Please run "dnu restore" to generate a new lock file.

Build failed.
    0 Warning(s)
    1 Error(s)
```

So, run `dnu restore` once again so that the dependencies synchronised with the project.

Once that's done type `dnu build` and it will now succeed.
You now have a basic environment set up on Linux for developing .NET Core applications and have demonstrated that you can create and build a simple ASP.NET Core application.

### Update 25th August 2026

\* Since this post was originally made some of the links no longer work, so they have been updated to the Wayback Machine. It is a very useful resource. You can [donate here](https://archive.org/donate).