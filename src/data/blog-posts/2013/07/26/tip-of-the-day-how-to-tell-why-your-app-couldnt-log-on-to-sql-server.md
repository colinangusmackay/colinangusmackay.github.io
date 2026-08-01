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
<!-- TODO: convert this post's content to Markdown -->

When you get a log in failure on SQL Server the message you get back from SQL Server Management Studio, or in a .NET Exception is vague for security. They don’t want to give away too much information just in case.

For example, the exception message will be something like “Login failed for user 'someUser'.” which doesn’t give you much of a clue as to what is actually happening. There could be a multitude of reasons that login failed.

<img style="float:none;margin-left:auto;display:block;margin-right:auto;" alt="" src="http://static.colinmackay.co.uk/images/sql/2013-07-26-sql-login-failure-exception-assistant.png" />

If you want more information about why a log-in failed you can open up the event viewer on the machine that SQL Server is installed on and have a look. You’ll find a more detailed message there.

<img style="float:none;margin-left:auto;display:block;margin-right:auto;" alt="" src="http://static.colinmackay.co.uk/images/sql/2013-07-26-sql-login-faiure-event-viewer.png" width="600" height="518" />

The wider messages may be things like:
<ul>
	<li>“Login failed for user 'someUser'. Reason: Could not find a login matching the name provided. [CLIENT: &lt;local machine&gt;]”</li>
	<li>Login failed for user 'someUser'. Reason: Password did not match that for the login provided. [CLIENT: &lt;local machine&gt;]</li>
	<li>Login failed for user 'someUser'. Reason: Failed to open the explicitly specified database. [CLIENT: &lt;local machine&gt;]
Note: This could be because the database doesn’t exist, or because the user doesn’t have permissions to the database.</li>
</ul>
