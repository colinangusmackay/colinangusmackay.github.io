---
title: "Rewiring the users and logins in SQL Server"
slug: rewiring-the-users-and-logins-in-sql-server
publishDate: 17 Oct 2011
description: "As a developer I find that I'm frequently backing up and restoring SQL Server databases between servers for development and testing purposes. However, each..."
tags:
  - { name: "SQL Server", slug: sql-server }
  - { name: "SQL Server 2005", slug: sql-server-2005 }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

As a developer I find that I'm frequently backing up and restoring SQL Server databases between servers for development and testing purposes. However, each time I do the link between the login (a server concept) and the user (a per database concept) gets broken.

There is a stored procedure in SQL Server to wire it all back up again and I keep forgetting what it is. So here it is (my aide memoir):

<a title="Maps an existing database user to a SQL Server login." href="http://msdn.microsoft.com/en-us/library/ms174378.aspx" target="_blank"><strong>sp_change_users_login</strong></a>: It maps an a database user to a SQL Server login.

The quick and easy way is as follows:

<code>sp_change_users_login 'Update_One', 'myUserName', 'myLoginName'</code>

&nbsp;
