---
title: "Umbraco installation woes"
slug: umbraco-installation-woes
publishDate: 31 Aug 2012
description: "Recently, I created an Umbraco site on one machine and I wanted to move it to another. I say site, there was nothing in it. It was really a basic database, but..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "Umbraco", slug: umbraco }
---
<!-- TODO: convert this post's content to Markdown -->

Recently, I created an Umbraco site on one machine and I wanted to move it to another. I say site, there was nothing in it. It was really a basic database, but I'd configured it with just an empty install before I zipped up the solution and all the files in it.

When I unzipped the files on to a new machine every time I tried to run the Umbraco install routine it would redirect me to a log on page even although the site had only a completely empty database to connect to (not a single table because the installation hadn't run yet).

The reason is that on installation part of the web.config is updated.
<pre>&lt;add key="umbracoConfigurationStatus" value="4.8.0" /&gt;</pre>
And that indicates to Umbraco that the installation is complete. So, allow installation to proceed normally remove the value and the installation can start normally, like this:
<pre>&lt;add key="umbracoConfigurationStatus" value="" /&gt;</pre>
