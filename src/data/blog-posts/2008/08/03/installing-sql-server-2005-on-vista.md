---
title: "Installing SQL Server 2005 on Vista"
slug: installing-sql-server-2005-on-vista
publishDate: 03 Aug 2008
description: "Perhaps this is not so much an issue with installing SQL Server 2005 on Vista, but of the way I install SQL Server 2005 on Vista, or even more accurately..."
tags:
  - { name: "Installation", slug: installation }
  - { name: "SQL Server 2005", slug: sql-server-2005 }
  - { name: "Windows Vista", slug: windows-vista }
---
<!-- TODO: convert this post's content to Markdown -->

Perhaps this is not so much an issue with installing SQL Server 2005 on Vista, but of the way I install SQL Server 2005 on Vista, or even more accurately install it on my laptop on Vista.

A SQL Server will expect to run constantly on the machine that it is installed on. However, not on my laptop. I generally have SQL Server turned off on my laptop because it uses resources that it does not need. I don't frequently use SQL Server on my laptop but I do need it sometimes. Because of this, during the installation I customise it so that the SQL Server services do not start up automatically as they normally would.

There is a slight problem with this approach I've discovered when installing on Vista. SQL Server 2005 came out before Windows Vista and they don't actually get along out of the box. You have to install SQL Server 2005 SP2 (or so several dialogs claim) before you can start working with SQL Server 2005 on Windows Vista.

At the end of the process for installing SP2 it will let you know that admin users on the Vista box will not be admin in SQL Server unless you are explicit about which users to add. It then launches a "SQL Server 2005 User Provisioning Tool for Vista" to allow you to set up the admin users. However, if the SQL Server services are not running it cannot do this - the User Provisioning Tool will run, but when you apply the changes it will popup an error message and quit. So, it would seem that what I should have done is let the installer get on with running SQL Server 2005 when it finished so that the admin users could be set up. However, I didn't and it failed. So, without any users set up on the SQL Server I could not log in.

After hunting around on disk for this User Provisioning Tool I discovered that the SQL Server 2005 Surface Area Configuration tool will allow me to launch the tool by pressing the "Add New Administrator" link in its dialog. So, with the SQL Server services (all of them indicating in the User Provisioning Tool, in my case the Database Engine and the Analysis Services) running I add myself to the list of users, click OK and.... A moment later everything seem to work. There is no confirmation, the dialog just goes away without any error messages. To test it worked I opened up the SQL Server Management Studio and attempt to log in. It works. I'm happy.

Now, finally, I go and limit the amount of memory I'm prepared to allow SQL Server to use. See my post on managing <a href="http://colinmackay.co.uk/blog/2008/07/20/tip-of-the-day-5-sql-server-memory-usage/">SQL Server's memory usage</a>. It is a laptop after all...

<strong>Update</strong>:
Please note that this was using SQL Server 2005 <em>Developer</em> Edition.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:a752e2b0-3e97-43f3-9c2d-9bdac36ce5fb" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/sql%20server">sql server</a>,<a rel="tag" href="http://technorati.com/tags/sql%20server%202005">sql server 2005</a>,<a rel="tag" href="http://technorati.com/tags/vista">vista</a>,<a rel="tag" href="http://technorati.com/tags/user%20provisioning%20tool">user provisioning tool</a>,<a rel="tag" href="http://technorati.com/tags/sp2">sp2</a>,<a rel="tag" href="http://technorati.com/tags/administrator">administrator</a></div>
