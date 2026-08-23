---
title: "Tip of the day: How to tell why your app couldn’t log on to SQL Server"
slug: tip-of-the-day-how-to-tell-why-your-app-couldnt-log-on-to-sql-server
publishDate: 26 Jul 2013
description: "When you get a log in failure on SQL Server the message you get back from SQL Server Management Studio, or in a .NET Exception is vague for security. They..."
tags:
  - { name: "Event Viewer", slug: event-viewer }
  - { name: "security", slug: security }
  - { name: "SQL Server", slug: sql-server }
---
When you get a log in failure on SQL Server the message you get back from SQL Server Management Studio, or in a .NET Exception is vague for security. They don’t want to give away too much information just in case.

For example, the exception message will be something like “Login failed for user 'someUser'.” which doesn’t give you much of a clue as to what is actually happening. There could be a multitude of reasons that login failed.

![Exception Assistant](/assets/blog/2013-07-26-tip-of-the-day-how-to-tell-why-your-app-couldnt-log-on-to-sql-server-1.webp)

If you want more information about why a log-in failed you can open up the event viewer on the machine that SQL Server is installed on and have a look. You’ll find a more detailed message there.

![](/assets/blog/2013-07-26-tip-of-the-day-how-to-tell-why-your-app-couldnt-log-on-to-sql-server-2.webp)

The wider messages may be things like:

- “Login failed for user 'someUser'. Reason: Could not find a login matching the name provided. \[CLIENT: \<local machine\>\]”
- Login failed for user 'someUser'. Reason: Password did not match that for the login provided. \[CLIENT: \<local machine\>\]
- Login failed for user 'someUser'. Reason: Failed to open the explicitly specified database. \[CLIENT: \<local machine\>\]
  Note: This could be because the database doesn’t exist, or because the user doesn’t have permissions to the database.
