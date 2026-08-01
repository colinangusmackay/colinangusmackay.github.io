---
title: "Tip of the Day #5 (SQL Server memory usage)"
slug: tip-of-the-day-5-sql-server-memory-usage
publishDate: 20 Jul 2008
description: "You can limit the amount of memory that SQL Server uses by using the sp_configure stored procedure. By limiting the amount of memory that SQL Server is..."
tags:
  - { name: "SQL Server", slug: sql-server }
---
<!-- TODO: convert this post's content to Markdown -->

You can limit the amount of memory that SQL Server uses by using the <strong>sp_configure</strong> stored procedure. By limiting the amount of memory that SQL Server is permitted to use it means that more memory is available to other applications or other instances of SQL Server. In fact books on-line recommends setting the minimum and maximum memory used on each instance of SQL Server running on the same machine as SQL Server does not make any attempts to balance memory usage across instances.

In order to use this you must be in an advanced mode. To set this up use:
<pre class="code"><span style="color:blue;">EXEC </span><span style="color:maroon;">sp_configure </span><span style="color:red;">'show advanced options'</span><span style="color:gray;">, </span>1
<span style="color:blue;">RECONFIGURE WITH OVERRIDE </span></pre>
&nbsp;

Next, to make the actual change you need the following:
<pre class="code"><span style="color:blue;">EXEC </span><span style="color:maroon;">sp_configure </span><span style="color:red;">'max server memory (MB)'</span><span style="color:gray;">, </span>512
<span style="color:blue;">RECONFIGURE WITH OVERRIDE </span></pre>
&nbsp;

The above example will set the maximum amount of memory the server will use to 512MB. The <span style="color:blue;">RECONFIGURE WITH OVERRIDE</span> is necessary in order for the change to take effect immediately. If it is missed out then the change won't take place until the SQL Server is restarted.

If you want to check that the change has taken place you can use the following:
<pre class="code"><span style="color:blue;">EXEC </span><span style="color:maroon;">sp_configure </span><span style="color:red;">'max server memory (MB)' </span></pre>
&nbsp;

This will just display the current setting. You will get a result set that looks something like this:

<img class="aligncenter" src="http://static.colinmackay.co.uk/images/sql/2008-07-20-sp_configure-max-server-memory.png" alt="SQL Server 2005 memory options result set" />

The congif_value is the value that the SQL Server is currently configured with. However, it may not be what is currently in force. The run_value shows you what is currently in force.

<span style="float:right;"><img src="http://static.colinmackay.co.uk/images/sql/2008-07-20-server-properties.png" alt="SQL Server 2005 memory options dialog" /></span>If you don't want to type so much SQL yourself, then you can do the same in the SQL Server Management Studio. Right-click the server in the object explorer and select "properties" from the context menu. This will bring you up a dialog with all the server level properties in it. Go to the "memory" page and you can set the values that you want there. There are a couple of radio buttons that will allow you to switch between the currently configured value and the running value. By pressing Okay the updated value is applied to the server immediately.

For more information:
<ul>
	<li><a href="http://msdn.microsoft.com/en-us/library/ms188787.aspx" target="_blank">sp_configure (Books On-Line)</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/ms189631.aspx" target="_blank">Configuration Options (Books On-Line)</a></li>
	<li><a href="http://msdn.microsoft.com/en-us/library/ms178067.aspx" target="_blank">SQL Server Memory Options (Books On-Line)</a></li>
</ul>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:6bc45091-fd7c-41e0-9f03-058559759878" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a href="http://technorati.com/tags/sql%20server" rel="tag">sql server</a>,<a href="http://technorati.com/tags/memory" rel="tag">memory</a></div>
