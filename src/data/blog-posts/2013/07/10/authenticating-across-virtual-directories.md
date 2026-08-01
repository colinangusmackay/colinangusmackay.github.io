---
title: "Authenticating Across Virtual Directories"
slug: authenticating-across-virtual-directories
publishDate: 10 Jul 2013
description: "If you have an application set up in a way similar to the previous post , which is essentially a domain that contains a number of web application hosted in..."
tags:
  - { name: "asp.net", slug: asp-net }
  - { name: "ASP.NET MVC", slug: asp-net-mvc }
  - { name: "ASP.NET MVC 4", slug: asp-net-mvc-4 }
  - { name: "authentication", slug: authentication }
  - { name: "IIS", slug: iis }
  - { name: "Virtual Directories", slug: virtual-directories }
---
<!-- TODO: convert this post's content to Markdown -->

If you have an application set up in a way similar to the <a title="Setting up a website that uses multiple projects" href="http://colinmackay.co.uk/2013/07/03/setting-up-a-website-that-uses-multiple-projects/">previous post</a>, which is essentially a domain that contains a number of web application hosted in various virtual directories on the server.

In my previous example, the root of the domain contains the application that contains the account management (the sign in, password retrieval, account set up, etc.), however each of the applications in each virtual directory must know who is logged in.

Assuming you are using the .NET's built in authentication mechanisms this is unlikely to work out of the box. There is some configuration that need to happen to allow each of the applications to sync up.
<h3>Setting up the web.config file</h3>
In MVC 4 Forms Authentication must be set up explicitly.
<pre>&lt;system.web&gt;
  &lt;authentication mode="Forms"&gt;
  &lt;/authentication&gt;
  &lt;!-- Other config settings --&gt;
&lt;/system.web&gt;</pre>
To ensure that each application can decrypt the authentication ticket in the cookie, they all must share the same machine key as by default IIS will assign each application its own encryption and decryption keys for security.
<pre>&lt;system.web&gt;
  &lt;machineKey decryptionKey="10FE3824EFDA35A7EE5E759651D2790747CEB6692467A57D" validationKey="E262707B8742B1772595A963EDF00BB0E32A7FACA7835EBE983A275A5307DEDBBB759B8B3D45CA44DA948A51E68B99195F9405780F8D80EE9C6AB46B9FEAB876" /&gt;
  &lt;!-- Other config settings --&gt;
&lt;/system.web&gt;</pre>
Do not use the above key - it is only an example.

These two settings must be shared across each of the applications sitting in the one domain.
<h3>Generating a Machine Key</h3>
To generate a machine key:
<ul>
	<li>Open "Internet Information Services (IIS) Manager" on your development machine.</li>
	<li>Set up a dummy application so that it won't affect anything else on the machine.</li>
	<li>Open up the Machine Key feature in the ASP.NET section

[caption id="" align="aligncenter" width="403"]<img alt="IIS Manager" src="http://static.colinmackay.co.uk/images/mvc/2013-07-03-iis-asp.net-section.png" width="403" height="248" /> IIS Manager[/caption]</li>
	<li>(1) In the "Validation key" section uncheck "Automatically generate at runtime" and "Generate a unique key for each application".

[caption id="" align="aligncenter" width="719"]<img alt="Machine Key Configuration in the IIS Manager" src="http://static.colinmackay.co.uk/images/mvc/2013-07-13-machine-key-settings.png" width="719" height="516" /> Machine Key Configuration in the IIS Manager[/caption]</li>
	<li>(2) In the "Decryption key" section uncheck "Automatically generate at runtime" and "Generate a unique key for each application".</li>
	<li>(3) Click "Generate Keys" (this will change the keys randomly each time it is pressed)</li>
	<li>(4) Click "Apply"</li>
</ul>
The <strong>web.config</strong> for this web application will now contain the newly generated machine key in the <code>system.web</code> section. Copy the complete <code>machineKey</code> element to the applications that are linked together.

There is an "Explore" link on the site's main page in IIS to open up Windows Exporer on the folder which contains the web site and the web.config file.
