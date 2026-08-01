---
title: "Running an ASP.NET MVC application on a fresh IIS8 install"
slug: running-an-asp-net-mvc-application-on-a-fresh-iis8-install
publishDate: 13 Dec 2013
description: "IIS has ever increasing amounts of security, you can’t publish a basic ASP.NET MVC website anymore and expect IIS to host it without some additional work. The..."
tags:
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "deployment", slug: deployment }
  - { name: "IIS", slug: iis }
  - { name: "iis8", slug: iis8 }
---
<!-- TODO: convert this post's content to Markdown -->

<p>IIS has ever increasing amounts of security, you can’t publish a basic ASP.NET MVC website anymore and expect IIS to host it without some additional work. The default config settings that the MVC uses are locked down in IIS, so it issues an error when you try to navigate to your fresh site.</p>  <p>Initially you may get a screen that says something bland and non-descriptive, like “Internal Server Error” with no further information.</p>  <p>To get the more detailed error messages modify your web application’s web.config file and add the following line to the system.webServer section:</p>  <pre>&lt;httpErrors errorMode=&quot;Detailed&quot; /&gt;</pre>

<p>Now, you’ll get a more detailed error message. It will look something like this:</p>

<p><a title="Full sized image" href="http://static.colinmackay.co.uk/images/iis/2013-12-13-IIS-500.19-Internal-Server-Error.png"><img src="http://static.colinmackay.co.uk/images/iis/2013-12-13-IIS-500.19-Internal-Server-Error-600.png" /></a></p>

<p>The key to the message is: This configuration section cannot be used at this path. This happens when the section is locked at a parent level. Locking is either by default (<code>overrideModeDefault=&quot;Deny&quot;</code>), or set explicitly by a location tag with <code>overrideMode=&quot;Deny&quot;</code> or the legacy <code>allowOverride=&quot;false&quot;</code>.</p>

<p>The “Config Source” section of the error message will highlight in red the part that is denied.</p>

<p>In order to allow the web.config to modify the the identified configuration element you need to find and modify the ApplicationHost.config file. It is located in <code>C:\Windows\System32\inetsrv\config</code>. You’ll need to be running as an Administrator level user in order to modify the file.</p>

<p>Find the section group the setting belongs to, e.g.</p>

<pre>&lt;sectionGroup name=&quot;system.webServer&quot;&gt;</pre>

<p>Then the section itself:</p>

<pre>&lt;section name=&quot;handlers&quot; overrideModeDefault=&quot;Deny&quot; /&gt;</pre>

<p>And update <code>overrideModeDefault</code> to <code>&quot;Allow&quot;</code> in order to allow the web.config to override it.</p>

<p>When you refresh the page for the website the error will be gone (or replaced with an error for the next section that you are not permitted to override)</p>
