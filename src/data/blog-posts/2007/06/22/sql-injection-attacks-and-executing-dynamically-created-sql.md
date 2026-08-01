---
title: "SQL Injection Attacks and executing dynamically created SQL"
slug: sql-injection-attacks-and-executing-dynamically-created-sql
publishDate: 22 Jun 2007
description: "There is a very important difference between EXEC[UTE] and sp_executesql that anyone who executes dynamically generated SQL statements ought to know. Typically..."
tags:
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
  - { name: "SQL Server", slug: sql-server }
---
<!-- TODO: convert this post's content to Markdown -->

<p>There is a very important difference between EXEC[UTE] and sp_executesql that anyone who executes dynamically generated SQL statements ought to know.</p>

<p>Typically dynamic SQL is generated when a particular construct is not possible by using parameters alone or when certain parts are added to the statement depending on other conditions. In the latter case, sp_executesql trumps EXEC[UTE] by allowing the developer the ability to pass in parameters to the dynamic SQL statement.</p>

<p>For example, consider this code:</p>

<pre>SELECT *
FROM MyTable
WHERE a = @wantedA
AND b = @wantedB</pre>

<p>If you were dynamically building this and were using EXEC then the code to dynamically build and execute it might look like this:</p>

<pre>DECLARE @sql NVARCHAR(4000);
SET @sql = N'SELECT * FROM MyTable '+
           N'WHERE a = '''+@wantedA+N''' AND b = '''+@wantedB+N'''';
EXEC(@sql)</pre>

<p>As you can probably guess, without extreme care as to the values of @wantedA and @wantedB an SQL Injection Attack is possible. However, it is possible to dynamically create the SQL statement and still use parameters within it like this:</p>

<pre>SET @sql = N'SELECT * FROM MyTable '+
           N'WHERE a = @dynWantedA AND b = @dynWantedB';
sp_executesql @sql, N'@dynWantedA varchar(100), @dynWantedB varchar(100)',
              @dynWantedA = @wantedA, @dynWantedB = @wantedB;</pre>

<p>As you can see in the second example, instead of injecting the value of the parameters we can just write parameters directly into the dynamic SQL statement and then pass them in.</p>

<p>There is, of course, caution to be exercised. Certain things cannot take parameters. For example, in SQL Server 2000 the TOP keyword must be followed by a literal value. It isn't possible to write TOP @numRows* so if that must be dynamic then the value would have to be injected into the SQL statement like this:</p>

<pre>SET @sql = 'SELECT TOP '+CAST(@numRows AS varchar(10))+' * FROM MyTable';</pre>

<p>So, using sp_executesql is not a panacea that will make all issues with SQL injection go away when building dynamic SQL, but it does help in certain cases.</p>

<p><small>* This is possible in SQL Server 2005, but not SQL Server 2000</small></p>

<p><em>NOTE: This was rescued from the Google Cache: The original date was Thursday, 26th January, 2006.</em><p>
