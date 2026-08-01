---
title: "Tip of the Day #4 (Connection Strings in Config files)"
slug: tip-of-the-day-4-connection-strings-in-config-files
publishDate: 19 Jul 2008
description: "From .NET 2.0 onwards a new and improved configuration management system has been put in place. You can now add a <connectionString> element to the config file..."
tags:
  - { name: ".NET", slug: net }
  - { name: "ADO.NET", slug: ado-net }
  - { name: "C#", slug: c }
  - { name: "Database", slug: database }
  - { name: "SQL", slug: sql }
---
<!-- TODO: convert this post's content to Markdown -->

From .NET 2.0 onwards a new and improved configuration management system has been put in place. You can now add a <strong>&lt;connectionString&gt;</strong> element to the config file and use it to place the connection strings to the database and then retrieve then in a consistent way in your application. It supports multiple connection strings too if you need to access multiple databases.

The config file looks like this:
<pre class="code"><span style="color:blue;">&lt;</span><span style="color:#a31515;">configuration</span><span style="color:blue;">&gt;
...
 </span><span style="color:blue;">  &lt;</span><span style="color:#a31515;">connectionStrings</span><span style="color:blue;">&gt;
    &lt;</span><span style="color:#a31515;">add </span><span style="color:red;">name</span><span style="color:blue;">=</span>"<span style="color:blue;">Default</span>" <span style="color:red;">connectionString</span><span style="color:blue;">=</span>"<span style="color:blue;">Server=(local);database=MyDatabase</span>"<span style="color:blue;">/&gt;
  &lt;/</span><span style="color:#a31515;">connectionStrings</span><span style="color:blue;">&gt;
...
</span><span style="color:blue;">&lt;</span><span style="color:#a31515;">configuration</span><span style="color:blue;">&gt;</span><a href="http://11011.net/software/vspaste"></a></pre>
From the .NET application you can access the connection string like this:
<pre class="code">connectionString =
    <span style="color:#2b91af;">ConfigurationManager</span>.ConnectionStrings[<span style="color:#a31515;">"Default"</span>].ConnectionString;</pre>
<a href="http://11011.net/software/vspaste"></a>

Just remember to add a reference to System.Configuration in your project and ensure that the code file is using the System.Configuration namespace as well.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:c8a83277-e372-4388-ac90-400230209d2e" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/.net">.net</a>,<a rel="tag" href="http://technorati.com/tags/connection%20string">connection string</a>,<a rel="tag" href="http://technorati.com/tags/config">config</a>,<a rel="tag" href="http://technorati.com/tags/configuration">configuration</a></div>
