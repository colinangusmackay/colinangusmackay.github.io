---
title: "Setting up a website that uses multiple projects"
slug: setting-up-a-website-that-uses-multiple-projects
publishDate: 03 Jul 2013
description: "I'm looking at the possibility of restructuring some of our applications to unify them under one brand and one site. Currently our applications are on..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "ASP.NET MVC 3", slug: asp-net-mvc-3 }
  - { name: "ASP.NET MVC 4", slug: asp-net-mvc-4 }
  - { name: "C#", slug: c }
  - { name: "IIS Express", slug: iis-express }
  - { name: "Visual Studio 2012", slug: visual-studio-2012 }
---
<!-- TODO: convert this post's content to Markdown -->

I'm looking at the possibility of restructuring some of our applications to unify them under one brand and one site. Currently our applications are on different sub-domains of our main domain and we'd like to bring all that under one roof so our application can be something like https://app.example.com and that's it.

To that end I'm looking at setting up a central project (a portal, if you like) that the user enters and logs into and from there they can move off into the various applications depending on what they want to do. Each of the application would sit in a virtual directory off the main application.
<h3>Basic Setup</h3>
Each of the projects needs to have the project properties in the web tab synchronised so that they are in agreement with each other. I decided on a port number to use and duplicated that across each of the projects.
<h3>Root Project</h3>
To start with the root project (that's the one that appears at the root of the domain) should be set to use IIS Express.
<ul>
	<li>In the solution explorer right click the project and then select "Properties" from the menu, alternatively click the project then press Alt+Enter.</li>
	<li>Once the properties appear go to the "Web" tab and scroll down to the "Server" section.</li>
	<li>Ensure that "Use Local IIS Web Server" is selected</li>
	<li>Check "Use IIS Express" if it isn't already.</li>
	<li>In the project URL choose a port number that you want to use across each of the projects. (You can leave the default for this project if you wish, but take a note of it for the others)</li>
	<li>Press "Create Virtual Directory" to set up IIS Express.</li>
</ul>
[caption id="" align="aligncenter" width="640"]<img class=" " alt="Setting up the root application" src="http://static.colinmackay.co.uk/images/mvc/2013-07-13-root-application.png" width="640" height="310" /> Setting up the root application[/caption]

Remember the port number that was used for the root project as it will be needed for the other projects.
<h3>Set up the first application</h3>
In the first application project put similar details in Project Properties.

The only difference is that the Project URL has a virtual directory added to it.

[caption id="" align="aligncenter" width="602"]<img class=" " alt="Setting up the first application" src="http://static.colinmackay.co.uk/images/mvc/2013-07-03-application-one.png" width="602" height="153" /> Setting up the first application[/caption]
<h3>Set up the second application</h3>
This is similar to the first application, except that the Project URL has a different virtual directory added to it.

[caption id="" align="aligncenter" width="591"]<img class=" " alt="Setting up the second application" src="http://static.colinmackay.co.uk/images/mvc/2013-07-13-application-two.png" width="591" height="147" /> Setting up the second application[/caption]
