---
title: "Taking ownership of a file"
slug: taking-ownership-of-a-file
publishDate: 20 Feb 2018
description: "I'm currently looking at using IIS Administration as a way to automate some deployment tasks. However, the way it got installed, it's appsettings.json file..."
tags:
  - { name: "ACL", slug: acl }
  - { name: "file access", slug: file-access }
  - { name: "permissions", slug: permissions }
  - { name: "take ownership", slug: take-ownership }
  - { name: "takeown", slug: takeown }
---
<!-- TODO: convert this post's content to Markdown -->

I'm currently looking at using <a href="https://docs.microsoft.com/en-us/iis-administration/">IIS Administration</a> as a way to automate some deployment tasks. However, the way it got installed, it's <code>appsettings.json</code> file could not be written to, even when running the text editor as Administrator.

It turns out, SYSTEM had full control of the file, and the installer configured it to only allow me to access the ReST API, yet I needed a deployment script running from the Continuous Delivery server to be able to access IIS Administration, so I needed to modify the settings file, somehow.

<h3>To take ownership - The quick guide</h3>

So, to take ownership of the <code>appsettings.json</code> file, what I needed was to run two commands at command prompt running as Administrator.
<pre>takeown /f "appsettings.json" /a

icacls "appsettings.json" /grant administrators:F /c /l
</pre>
<h3>TAKEOWN</h3>
<code>/f [filename]</code> : Specifies the file or directory name, can contain wildcards.

<code>/a</code> : Optional, gives the ownership to the Administrators group, rather than the current user.

 
<h3>ICACLS</h3>

<code>/grant [sid]:[permission]</code> : Where <code>sid</code> is the name of the user or group, and [permission] is the permission set, in this case <code>F</code> for "full access"

<code>/C</code> : Indicates to continue on error

<code>/L</code> : Indicates the operation will run on the symbolic link itself, rather than the target of the link.

