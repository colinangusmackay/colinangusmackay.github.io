---
title: "If you really must do dynamic SQL..."
slug: if-you-really-must-do-dynamic-sql
publishDate: 21 Sep 2009
description: "I may have mentioned in previous posts and articles about SQL Injection Attacks that dynamic SQL (building SQL commands by concatenating strings together) is a..."
tags:
  - { name: "security", slug: security }
  - { name: "SQL", slug: sql }
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
  - { name: "SQL Server", slug: sql-server }
---
<!-- TODO: convert this post's content to Markdown -->



		<p>I may have mentioned in previous posts and articles about SQL Injection Attacks that dynamic SQL (building SQL commands by concatenating strings together) is a source of failure in the security of a data driven application. It becomes easy to inject malicious text in there to cause the system to return incorrect responses. Generally the solution is to use parameterised queries</p>  <p>However, there are times where you may have no choice. For example, if you want to dynamically reference tables or columns. You can’t do that as the table name or column name cannot be replaced with a parameter. You then have to use dynamic SQL and inject these into a SQL command.</p>  <h2>The problem</h2>  <p>It is possible for SQL Server to do that concatenation for you. For example:</p>  <pre>CREATE PROCEDURE GetData
	@Id INT,
	@TableName sysname,
	@ColumnName sysname
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @sql nvarchar(max) =
		'SELECT ' + @ColumnName +
		' FROM ' + @TableName +
		' WHERE Id = '+cast(@Id as nvarchar(20));
	EXEC(@sql)
END
GO</pre>

<p>This is a simple stored procedure that gets some data dynamically. However, even although everything is neatly parameterised it is no protection. All that has happened is that the location for vulnerability (i.e. the location of the construction of the SQL) has moved from the application into the database. The application is now parameterising everything, which is good. But there is more to consider than just that.</p>

<h2>Validating the input</h2>

<p>The next line of defence should be verifying that the table and column names passed are actually valid. In SQL Server you can query the <strong>INFORMATION_SCHEMA</strong> views to determine whether the column and tables exist.</p>

<p>If, for example, there is a table called <strong>MainTable</strong> in the database you can check it with a query like this:</p>

<pre>SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'MainTable'</pre>

<p>And it will return:</p>

<p><a title="INFORMATION_SCHEMA.TABLES by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3940740909/"><img style="border-width:0;" border="0" alt="INFORMATION_SCHEMA.TABLES" src="http://farm4.static.flickr.com/3510/3940740909_32d8c15927_o.png" width="417" height="64"></a></p>

<p>There is a similar view for checking columns. For example:</p>

<p><a title="INFORMATION_SCHEMA.COLUMNS by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/3940756637/"><img style="border-width:0;" border="0" alt="INFORMATION_SCHEMA.COLUMNS" src="http://farm4.static.flickr.com/3504/3940756637_c35304d4f9_o.png" width="510" height="70"></a></p>

<p>As you can see, the <strong>INFORMATION_SCHEMA.COLUMNS</strong> view also contains sufficient detail on the table so that when we implement it we only have to make one check:</p>

<pre>ALTER PROCEDURE GetData
	@Id INT,
	@TableName sysname,
	@ColumnName sysname
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME = @TableName AND COLUMN_NAME = @ColumnName)
    BEGIN
        DECLARE @sql nvarchar(max) =
            'SELECT ' + @ColumnName +
            ' FROM ' + @TableName +
            ' WHERE Id = '+cast(@Id as nvarchar(20));
        EXEC(@sql)
    END
END
GO</pre>

<h2>Formatting the input</h2>

<p>The above is only part of the solution, it is perfectly possible for a table name to contain characters that mean it needs to be escaped. (e.g. a space character or the table may share a name with a SQL keyword). To escape a table or column name it is enclosed in square brackets, so a table name of <strong>My Table</strong> becomes <strong>[My Table]</strong> or a table called <strong>select</strong> becomes <strong>[select]</strong>.</p>

<p>You can escape table and column names that wouldn’t ordinarily require escaping also. It makes no difference to them.</p>

<p>The code now becomes:</p>

<pre>ALTER PROCEDURE GetData
	@Id INT,
	@TableName sysname,
	@ColumnName sysname
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME = @TableName AND COLUMN_NAME = @ColumnName)
    BEGIN
        DECLARE @sql nvarchar(max) =
            'SELECT [' + @ColumnName + '] ' +
            'FROM [' + @TableName + '] ' +
            'WHERE Id = '+cast(@Id as nvarchar(20));
        EXEC(@sql)
    END
END
GO</pre>

<p>But that's not quite the full story.</p>

<h2>Really formatting the input</h2>

<p>What if you have a table called <strong>Cra]zee Table</strong>? Okay - Why on earth would you have a table with such a stupid name? It happens, and it is a perfectly legitimate table name in SQL Server. People do weird stuff and you have to deal with it.</p>

<p>At the moment the current stored procedure will simply fall apart when presented with such input. The call to the stored procedure would look like this: </p>

<pre>EXEC GetData 1, 'Cra]zee Table', 'MadStuff'</pre>

<p>And it gets past the validation stage because it is a table in the system. The result is a message: </p>

<pre>Msg 156, Level 15, State 1, Line 1
Incorrect syntax near the keyword 'Table'.</pre>
The SQL produced looks like this:

<pre>SELECT [MadStuff] FROM [Cra]zee Table] WHERE Id = 1</pre>

<p>By this point is should be obvious why it failed. The SQL Parser interpreted the first closing square bracket as the terminator for the escaped section.</p>

<p>There are other special characters in SQL that require special consideration and you could write code to process them before adding it to the SQL string. In fact, I’ve seen many people do that. And more often than not they get it wrong.</p>

<p>The better way to deal with that sort of thing is to use a built in function in SQL Server called <strong><a title="QUOTENAME function (SQL Server Books On-Line)" href="http://msdn.microsoft.com/en-us/library/ms176114.aspx">QUOTENAME</a></strong>. This will ensure the column or table name is properly escaped. The stored procedure we are now building now looks like this:</p>

<pre>ALTER PROCEDURE GetData
	@Id INT,
	@TableName sysname,
	@ColumnName sysname
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME = @TableName AND COLUMN_NAME = @ColumnName)
    BEGIN
        DECLARE @sql nvarchar(max) =
            'SELECT ' + QUOTENAME(@ColumnName) +
            ' FROM ' + QUOTENAME(@TableName) +
            ' WHERE Id = '+cast(@Id as nvarchar(20));
        EXEC(@sql)
    END
END
GO</pre>

<h2>Things that can be parameterised</h2>

<p>There is still something that can be done to this. The Id value is being injected in to the SQL string, yet it is something that can quite easily be parameterised.</p>

<p>The issue at the moment is that the SQL String is being executed by using the <a title="EXECUTE (T-SQL) (SQL Server Books On-Line)" href="http://msdn.microsoft.com/en-us/library/ms188332.aspx"><strong>EXECUTE</strong></a> command. However, you cannot pass parameters into this sort of executed SQL. You need to use a stored procedure called <strong><a title="sp_executesql (Stored Procedure, Transact SQL) (SQL Server Books On-Line)" href="http://msdn.microsoft.com/en-us/library/ms188001.aspx">sp_executesql</a></strong>. This allows parameters to be defined and passed into the dynamically created SQL.</p>

<p>The stored procedure now looks like this:</p>

<pre>ALTER PROCEDURE GetData
	@Id INT,
	@TableName sysname,
	@ColumnName sysname
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME = @TableName AND COLUMN_NAME = @ColumnName)
    BEGIN
        DECLARE @sql nvarchar(max) =
            'SELECT ' + QUOTENAME(@ColumnName) +
            ' FROM ' + QUOTENAME(@TableName) +
            ' WHERE Id = @Identifier';
        EXEC sp_executesql @sql, N'@Identifier int',
                           @Identifier = @Id
    END
END
GO</pre>

<p>This is not quite the end of the story. There are performance improvements that can be made when using sp_executesql. You can find out about these in the SQL Server books-online.</p>

<h2>And finally...</h2>

<p>If you must use dynamic SQL in stored procedures do take care to ensure that all the data is validated and cannot harm your database. This is an area in which I tread very carefully if I have no other choice. </p>

<p>Try and consider every conceivable input, especially inputs outside of the bounds of your application. Remember also, that defending your database is a multi-layered strategy. Even if you have the best firewalls and security procedures elsewhere in your system a determined hacker may find a way though your other defences and be communicating with the database in a way in which you didn’t anticipate. Assume that an attacker has got through your other defences, how do you provide the data services to your application(s) yet protect the database?</p>

<div style="margin:0;display:inline;float:none;padding:0;" id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:80b80b8f-e1ea-40c0-bbd9-6e4760f85a79" class="wlWriterEditableSmartContent">Technorati Tags: <a href="http://technorati.com/tags/sql" rel="tag">sql</a>,<a href="http://technorati.com/tags/sql+server" rel="tag">sql server</a>,<a href="http://technorati.com/tags/sql+injection+attack" rel="tag">sql injection attack</a>,<a href="http://technorati.com/tags/dynamic+sql" rel="tag">dynamic sql</a></div>

	
