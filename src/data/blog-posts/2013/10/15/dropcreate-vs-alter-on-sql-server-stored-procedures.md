---
title: "DROP/CREATE vs ALTER on SQL Server Stored Procedures"
slug: dropcreate-vs-alter-on-sql-server-stored-procedures
publishDate: 15 Oct 2013
description: "We have a number of migration scripts that modify the database as our applications progress. As a result we have occasion to alter stored procedures, but..."
tags:
  - { name: "SQL Server", slug: sql-server }
---
We have a number of migration scripts that modify the database as our applications progress. As a result we have occasion to alter stored procedures, but during development the migrations may be run out of sequence on various test and development databases. We sometimes don’t know if a stored procedure will exist on a particular database because of the state of various branches of development.

So, which is better, dropping a stored procedure and recreating it, or just simply altering the existing one, and if we’re altering it, what needs to happen if it simply doesn’t exist already?

### DROP / CREATE

This is the code we used for the DROP/CREATE cycle of adding/updating stored procedures

```sql
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'MyProc')
BEGIN
       DROP PROCEDURE MyProc;
END
GO
 
CREATE PROCEDURE MyProc
AS
    -- Body of proc here
GO
```

### CREATE / ALTER

We recently changed the above for a new way of dealing with changes to stored procedures. What we do now is detect if the procedure exists or not, if it doesn't then we create a dummy. Regardless of whether the stored procedure previously existed or not, we can now ALTER the stored procedure (whether it was an existing procedure or the dummy one we just created

That code looks like this

```sql
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'MyProc')
BEGIN
       EXEC('CREATE PROCEDURE [dbo].[MyProc] AS BEGIN SET NOCOUNT ON; END')
END
GO
 
ALTER PROCEDURE [dbo].[MyProc]
AS
    -- Body of proc here
GO
```

This looks counter-intuitive to create a dummy procedure just to immediately alter it but it has some advantages over drop/create.

If an error occurs with drop/create while creating the stored procedure and there had been a stored procedure to drop originally you are now left without anything. With the create/alter in the event of an error when altering the stored procedure the original is still available.

Altering a stored procedure keeps any security settings you may have on the procedure. If you drop it, you’ll lose those settings. The same goes for dependencies.

### Update on 23 August 2026

Since this original blog post, SQL Server now has `CREATE OR ALTER PROCEDURE` so the above is no longer needed.