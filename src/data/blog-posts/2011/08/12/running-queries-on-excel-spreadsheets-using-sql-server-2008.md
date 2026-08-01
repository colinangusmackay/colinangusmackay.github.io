---
title: "Running Queries on Excel Spreadsheets using SQL Server 2008"
slug: running-queries-on-excel-spreadsheets-using-sql-server-2008
publishDate: 12 Aug 2011
description: "I’m more a database person than a spreadsheet person. I’m more used to using SQL to bend data to my will than all the fancy gubbins that you’ll find in Excel...."
tags:
  - { name: "Excel", slug: excel }
  - { name: "SQL", slug: sql }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

<p>I’m more a database person than a spreadsheet person. I’m more used to using SQL to bend data to my will than all the fancy gubbins that you’ll find in Excel. With some chunky (for a spreadsheet) ad hoc data in hand I set about connecting it up to SQL Server so I could run a few choice SELECT statements on the data.</p>  <p>The details in this post work with 64bit editions of Excel 2010 and SQL Server 2008 R2</p>  <p>The basic ad hoc connection looks something like this:</p>  <p><code>SELECT *      <br />FROM OPENDATASOURCE( 'Microsoft.ACE.OLEDB.12.0', 'Data Source=&quot;<em><strong>&lt;full file path to excel file&gt;</strong></em>&quot;; Extended properties=Excel 12.0')...[<em><strong>&lt;data sheet name&gt;</strong></em>$]</code></p>  <p>However, if you try that in SQL Server Management Studio on a raw SQL Server installation you’ll get this error message:</p>  <p><code><font color="#ff0000">Msg 15281, Level 16, State 1, Line 7        <br />SQL Server blocked access to STATEMENT 'OpenRowset/OpenDatasource' of component 'Ad Hoc Distributed Queries' because this component is turned off as part of the security configuration for this server. A system administrator can enable the use of 'Ad Hoc Distributed Queries' by using sp_configure. For more information about enabling 'Ad Hoc Distributed Queries', see &quot;<a href="http://msdn.microsoft.com/en-us/library/ms161956(v=SQL.105).aspx">Surface Area Configuration</a>&quot; in SQL Server Books Online.</font></code></p>  <h3></h3>  <h3>Enabling Ad Hoc Remote Queries</h3>  <p>I’ve linked to the Books On-Line entry in the above, but it is only part of the story. Once you’ve followed its instructions on opening the View Facets dialog, you have to hunt around a little to find where you turn on and off the ad hoc remote queries. To save you the time, they’re in the “Server Configuration” facet.</p>  <p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/sql/2011-08-11-view-facets-ad-hoc-remote-queries-enabled.png" /></p>  <p>The alternative, also mentioned, is to issue a SQL Command. This command:</p>  <pre>sp_configure 'Ad Hoc Distributed Queries', 1;</pre>

<p>However, that still won't work directly. You'll get the following error message:</p>

<p><code><font color="#ff0000">Msg 15123, Level 16, State 1, Procedure sp_configure, Line 51
      <br />The configuration option 'Ad Hoc Distributed Queries' does not exist, or it may be an advanced option.</font></code></p>

<p>The full SQL you need is:</p>

<pre>sp_configure 'show advanced options', 1;
RECONFIGURE
GO
sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE
GO</pre>

<p>And you'll get output that looks like this:</p>

<p><code>Configuration option 'show advanced options' changed from 0 to 1. Run the RECONFIGURE statement to install.
    <br />Configuration option 'Ad Hoc Distributed Queries' changed from 0 to 1. Run the RECONFIGURE statement to install.</code></p>

<p>Now, we can try running the SELECT statement again, but this time the following error appears:</p>

<p><code><font color="#ff0000">Msg 7302, Level 16, State 1, Line 2
      <br />Cannot create an instance of OLE DB provider &quot;Microsoft.ACE.OLEDB.12.0&quot; for linked server &quot;(null)&quot;.</font></code></p>

<h3></h3>

<h3>ODBC Configuration</h3>

<p>This is because the ODBC driver is not configured correctly, go to the Control Panel –&gt; System and Security –&gt; Administrative Tools –&gt; Data Sources (ODBC), alternatively you can just type “ODBC” in the Windows start bar.</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/sql/2011-08-11-find-odbc.png" /></p>

<p>Either way, you get to this dialog:</p>

<p><img style="display:block;float:none;margin-left:auto;margin-right:auto;" src="http://static.colinmackay.co.uk/images/sql/2011-08-11-odbc-drivers.png" /></p>

<p>And as you can see the ODBC Driver needed for reading Excel files is not installed. A pretty big configuration failure. But it is easy enough to get the correct drivers. You can download them from Microsoft:</p>

<ul>
  <li><a href="http://www.microsoft.com/download/en/details.aspx?displaylang=en&amp;id=23734">Drivers for Excel and Access 2007</a> </li>

  <li><a href="http://www.microsoft.com/download/en/details.aspx?displaylang=en&amp;id=13255">Drivers for Excel and Access 2010 (32bit and 64bit)</a> Remember that the version you install is based on whether you have the 32bit or 64bit version of Office, not Windows. </li>
</ul>

<p>However, there is a problem if you have 32bit Office installed and 64bit SQL Server. The 32bit installer for the ODBC Drivers won’t work with 64bit SQL Server, and the 64bit drivers won’t install if it finds an existing 32bit installation of Office on the machine. For my desktop machine that was a problem, but luckily my laptop is running both 64bit versions of Office and SQL Server.</p>

<h3>Finally</h3>

<p>I eventually found this code snippet that works:</p>

<pre>SELECT *
FROM OPENROWSET('MSDASQL',
'DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);
DBQ=c:devPerformance-results.xlsx',
'SELECT * FROM [results$]')</pre>

<p>The only issue that I have with this is that it uses MSDASQL which is surrounded in uncertainty. In one blog post it was said to be <a href="http://blogs.msdn.com/b/selvar/archive/2007/11/10/msdasql-oledb-provider-for-odbc-drivers.aspx">deprecated and 64bit versions won’t be available</a>. Yet, there is <a title="64-Bit OLEDB Provider for ODBC (MSDASQL)" href="http://www.microsoft.com/download/en/details.aspx?displaylang=en&amp;id=20065">a 64-bit version available for download</a>. But for the ad hoc work I’m doing at the moment, it works.</p>
