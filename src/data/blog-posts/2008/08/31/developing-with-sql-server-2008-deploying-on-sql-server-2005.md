---
title: "Developing with SQL Server 2008, deploying on SQL Server 2005"
slug: developing-with-sql-server-2008-deploying-on-sql-server-2005
publishDate: 31 Aug 2008
description: "I received the following by email today: Hi Colin! I found your blog after googling for a bit about SQL Server. I had a question for you... As someone fairly..."
tags:
  - { name: "software development practices", slug: software-development-practices }
  - { name: "SQL Server 2005", slug: sql-server-2005 }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

I received the following by email today:
<blockquote><em>Hi Colin! I found your blog after googling for a bit about SQL Server. I had a question for you... As someone fairly new to .NET development, would it be easier to stick with SQL Server 2005 for now, or just install SQL Server 2008 express? I ask because I don't yet know enough about the differences between the two to know if there will be any issues when developing small web applications with 2008, but then deploying them to a hosting provider with 2005. Hope that makes sense. :) </em>

<em>Cheers,
Sean</em></blockquote>
I don't recommend moving to SQL Server 2008 if you will ultimately be deploying on SQL Server 2005.

If you don't know the difference between SQL Server 2005 and 2008, yet your hosting provider only supports 2005 then you would be better off sticking to working with SQL Server 2005 on your system. The reason for this is that you don't want to accidentally stumble into features of 2008 that are not supported on 2005.

Also, even if you were intimately aware of the differences between the two versions it is still a good rule of thumb to develop on a system that is as close to the eventual live system as you can. That way you won't get any unexpected nasty surprises when you do deploy the application and suddenly realise that things are not quite as expected.

If you have already developed the applications then you can set the compatibility level of the database to mimic SQL Server 2005:
<pre>ALTER DATABASE [MyDatabaseName] SET COMPATIBILITY_LEVEL = 90</pre>
That way you should have a similar (although not necessarily quite the same) experience as if you were developing on a real SQL Server 2005 system. There will still be things that you cannot do. I don't think backing up your 2008 database and restoring it on a 2005 system will work.
