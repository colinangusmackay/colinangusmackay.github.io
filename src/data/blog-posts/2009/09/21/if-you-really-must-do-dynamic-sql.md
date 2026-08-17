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
I may have mentioned in previous posts and articles about SQL Injection Attacks that dynamic SQL (building SQL commands by concatenating strings together) is a source of failure in the security of a data driven application. It becomes easy to inject malicious text in there to cause the system to return incorrect responses. Generally the solution is to use parameterised queries

However, there are times where you may have no choice. For example, if you want to dynamically reference tables or columns. You can’t do that as the table name or column name cannot be replaced with a parameter. You then have to use dynamic SQL and inject these into a SQL command.

### The problem

It is possible for SQL Server to do that concatenation for you. For example:

```sql
CREATE PROCEDURE GetData
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
GO
```

This is a simple stored procedure that gets some data dynamically. However, even although everything is neatly parameterised it is no protection. All that has happened is that the location for vulnerability (i.e. the location of the construction of the SQL) has moved from the application into the database. The application is now parameterising everything, which is good. But there is more to consider than just that.

### Validating the input

The next line of defence should be verifying that the table and column names passed are actually valid. In SQL Server you can query the **INFORMATION_SCHEMA** views to determine whether the column and tables exist.

If, for example, there is a table called **MainTable** in the database you can check it with a query like this:

```sql
SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'MainTable'
```

And it will return:

![](/assets/blog/2009-09-21-if-you-really-must-do-dynamic-sql-1.webp)

There is a similar view for checking columns. For example:

![](/assets/blog/2009-09-21-if-you-really-must-do-dynamic-sql-2.webp)

As you can see, the **INFORMATION_SCHEMA.COLUMNS** view also contains sufficient detail on the table so that when we implement it we only have to make one check:

```sql
ALTER PROCEDURE GetData
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
GO
```

### Formatting the input

The above is only part of the solution, it is perfectly possible for a table name to contain characters that mean it needs to be escaped. (e.g. a space character or the table may share a name with a SQL keyword). To escape a table or column name it is enclosed in square brackets, so a table name of **My Table** becomes **\[My Table\]** or a table called **select** becomes **\[select\]**.

You can escape table and column names that wouldn’t ordinarily require escaping also. It makes no difference to them.

The code now becomes:

```sql
ALTER PROCEDURE GetData
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
GO
```

But that's not quite the full story.

### Really formatting the input

What if you have a table called **Cra\]zee Table**? Okay - Why on earth would you have a table with such a stupid name? It happens, and it is a perfectly legitimate table name in SQL Server. People do weird stuff and you have to deal with it.

At the moment the current stored procedure will simply fall apart when presented with such input. The call to the stored procedure would look like this:

```sql
EXEC GetData 1, 'Cra]zee Table', 'MadStuff'
```

And it gets past the validation stage because it is a table in the system. The result is a message:

```
Msg 156, Level 15, State 1, Line 1
Incorrect syntax near the keyword 'Table'.
```

The SQL produced looks like this:

```sql
SELECT [MadStuff] FROM [Cra]zee Table] WHERE Id = 1
```

By this point is should be obvious why it failed. The SQL Parser interpreted the first closing square bracket as the terminator for the escaped section.

There are other special characters in SQL that require special consideration and you could write code to process them before adding it to the SQL string. In fact, I’ve seen many people do that. And more often than not they get it wrong.

The better way to deal with that sort of thing is to use a built in function in SQL Server called **[QUOTENAME](http://msdn.microsoft.com/en-us/library/ms176114.aspx "QUOTENAME function (SQL Server Books On-Line)")**. This will ensure the column or table name is properly escaped. The stored procedure we are now building now looks like this:

```sql
ALTER PROCEDURE GetData
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
GO
```

### Things that can be parameterised

There is still something that can be done to this. The Id value is being injected in to the SQL string, yet it is something that can quite easily be parameterised.

The issue at the moment is that the SQL String is being executed by using the [**EXECUTE**](http://msdn.microsoft.com/en-us/library/ms188332.aspx "EXECUTE (T-SQL) (SQL Server Books On-Line)") command. However, you cannot pass parameters into this sort of executed SQL. You need to use a stored procedure called **[sp_executesql](http://msdn.microsoft.com/en-us/library/ms188001.aspx "sp_executesql (Stored Procedure, Transact SQL) (SQL Server Books On-Line)")**. This allows parameters to be defined and passed into the dynamically created SQL.

The stored procedure now looks like this:

```sql
ALTER PROCEDURE GetData
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
GO
```

This is not quite the end of the story. There are performance improvements that can be made when using `sp_executesql`. You can find out about these in the SQL Server books-online.

### And finally...

If you must use dynamic SQL in stored procedures do take care to ensure that all the data is validated and cannot harm your database. This is an area in which I tread very carefully if I have no other choice.

Try and consider every conceivable input, especially inputs outside of the bounds of your application. Remember also, that defending your database is a multi-layered strategy. Even if you have the best firewalls and security procedures elsewhere in your system a determined hacker may find a way though your other defences and be communicating with the database in a way in which you didn’t anticipate. Assume that an attacker has got through your other defences, how do you provide the data services to your application(s) yet protect the database?
