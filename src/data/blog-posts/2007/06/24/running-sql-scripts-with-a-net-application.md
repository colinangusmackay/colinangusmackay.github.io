---
title: "Running SQL Scripts with a .NET Application"
slug: running-sql-scripts-with-a-net-application
publishDate: 24 Jun 2007
description: "I was recently asked to show how to run a SQL Script on a SQL Server but being controlled by a .NET application. The other guy had been trying to use isql for..."
tags: []
---
<!-- TODO: convert this post's content to Markdown -->



		<p>I was recently asked to show how to run a SQL Script on a SQL Server but being controlled by a .NET application. The other guy had been trying to use <code>isql</code> for the task but somehow wasn't getting it to work. I commented that I'd needed something similar for three different projects recently, but I'd taken a completely different approach. At the time I rushed an explanation of how I achieved the same result. So here is a less rushed explanation of how to run a SQL Script on a SQL Server. I would also imagine this would work for other database systems as well with some slight modifications.</p>
<p>At its simplest you can throw just about any SQL statements you like through the <code>SqlCommand</code> object in .NET and have .NET execute them. </p>
<p> </p>
<pre>SqlConnection connection = new SqlConnection(connectionString);
SqlCommand command = new SqlCommand(script,connection);</pre>
<p>That's it. You can just call <code>command.ExecuteNonQuery();</code> if you don't expect, or are not interested in, any values that might come back. You could have a <code>SqlAdapter.Fill</code> a <code>DataSet</code>, or a get a <code>DataReader</code>. </p>
<p>For a demonstration I have put a simple application together that reads in a script from a file, or even from embedded resource and runs the script it finds. If the script returns any data a <code>DataSet</code> is populated and the tables are then output to the console.</p>
<p>The demo application takes two command line arguments. The first is either a <code>-r</code> (for embedded resource) or <code>-f</code> (for a file). The second argument is either the name of the resource, or the name of the file. For example:</p>
<pre>RunSQL -r GroupedTurnover</pre>
<p>runs the embedded script called <code>RunSQL.GroupedTurnover.sql</code>. For convenience the application will add the prefix and the suffix.</p>
<p>The file can contain GO delimiters so that you can have the application process the script in batches rather than need one script per batch.</p>
<p>Downloads:<br />
</p>
<ul>
    <li>The <a href="http://web.archive.org/web/20041205202801/http://userfiles.wdevs.com/ColinAngusMackay/RunSql_Source.zip">Source Code</a> (9kb zipped) </li>
    <li>The <a href="http://web.archive.org/web/20041205202801/http://userfiles.wdevs.com/ColinAngusMackay/RunSql.zip">Demo Application</a> (5kb zipped)</li>
</ul>
<p>NOTE: The demo application needs a default instance of SQL Server 2000 or MSDE running on the local machine which contains the Northwind database. If you download the source code you can, of course, change these settings to suite your need.</p>
<p><em>NOTE: This was rescued from the <a title="Wayback Machine" href="http://www.archive.org/web/web.php" target="_blank">Wayback Machine</a>. The original was dated Friday, 15th October, 2005. The downloads currenly point to the <a title="Wayback Machine" href="http://www.archive.org/web/web.php" target="_blank">Wayback Machine</a> version. These will be updated shortly.</em></p>

	
