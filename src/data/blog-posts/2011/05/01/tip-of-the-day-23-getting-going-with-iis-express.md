---
title: "Tip of the Day #23: Getting going with IIS Express"
slug: tip-of-the-day-23-getting-going-with-iis-express
publishDate: 01 May 2011
description: "First, if you don’t have it already you need to download IIS Express (you can also use this link to get the full install, not via Microsoft's web installer, if..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "IIS", slug: iis }
  - { name: "IIS Express", slug: iis-express }
  - { name: "Visual Studio 2010", slug: visual-studio-2010 }
---
<!-- TODO: convert this post's content to Markdown -->

First, if you don’t have it already you need to <a href="http://www.microsoft.com/web/gallery/install.aspx?appid=IISExpress" target="_blank">download IIS Express</a> (you can also use <a href="http://www.microsoft.com/download/en/details.aspx?id=1038">this link</a> to get the full install, not via Microsoft's web installer, if you are behind a proxy that is preventing the installation). And, I’d also recommend <a href="http://www.microsoft.com/downloads/en/details.aspx?FamilyID=75568aa6-8107-475d-948a-ef22627e57a5" target="_blank">downloading Visual Studio 2010 SP1</a> and upgrading to it.

In your web project, open up the properties by right clicking the project and selecting properties, or pressing Alt+Enter while the project is selected.

You will then be presented with a view like this:

<a title="1 Initial Web Properties by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5675492185/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border:0;" src="http://farm6.static.flickr.com/5184/5675492185_2bf7c3e143_z.jpg" alt="1 Initial Web Properties" width="640" height="568" border="0" /></a>

By default, in the servers section of the Web tab the “Use Visual Studio Development Server” (aka Cassini) will be selected. Change this to “Use Local IIS Web Server”

<a title="2 Change to Local IIS Web Server by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5675492253/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border:0;" src="http://farm6.static.flickr.com/5228/5675492253_b88737b544_z.jpg" alt="2 Change to Local IIS Web Server" width="609" height="640" border="0" /></a>

If you want to customise the settings you may do so. I tend to set a specific local port so that I know that all my applications don’t class with one another and that I can easily identify it later. My naming scheme to select 4 or 5 digits that are derived from the name of the project as if dialled into a telephone keypad. (Some people think that’s a bit weird but it makes it easy to avoid port clashes and to reverse the port into the project if you ever get lost.)

If necessary you can define the virtual directory in the Project URL and configure it by pressing “Create Virtual Directory”.

<a title="3 Setting a Virtual Directory by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5676054578/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border:0;" src="http://farm6.static.flickr.com/5023/5676054578_9d4e8b0452_z.jpg" alt="3 Setting a Virtual Directory" width="640" height="205" border="0" /></a>

If you don’t “Create Virtual Directory” and you attempt to run the project, you’ll get a warning dialog that asks if you want to configure it. If you select yes, then Visual Studio will configure the virtual directory for you and start the application.

<a title="4 Not configuring a Virtual Directory by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5676054636/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border:0;" src="http://farm6.static.flickr.com/5224/5676054636_e4bb1a13e2_o.png" alt="4 Not configuring a Virtual Directory" width="490" height="199" border="0" /></a>

Finally, if you need to see what Sites IIS Express is running there is a tray icon you can right click on to see.

<a title="5 System Tray Icon for IIS Express by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5675492425/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border:0;" src="http://farm6.static.flickr.com/5268/5675492425_80b9c211ec_z.jpg" alt="5 System Tray Icon for IIS Express" width="640" height="166" border="0" /></a>

And if you click “Show all applications” you get to see all the sites that IIS Express is running. Clicking on a URL takes you to that site, anywhere else on the line will bring up details of the site in the lower part of the dialog.

<a title="6 IIS Express Running Applications by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/5676054798/"><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border:0;" src="http://farm6.static.flickr.com/5067/5676054798_13a1a4cfb9_z.jpg" alt="6 IIS Express Running Applications" width="640" height="454" border="0" /></a>

Clicking on the “Parent” name will take you to the instance of Visual Studio that the application is running from. This is a really nifty feature to get you back to the correct instance of Visual Studio if you are running many of them at once.

Clicking on the “Path” will open up Windows Explorer to show you the folder in which the site is located. And clicking “Config” will open the config file in Visual Studio.
