---
title: "Composite Primary Keys Including Identity Like Column"
slug: composite-primary-keys-including-identity-like-column
publishDate: 29 Dec 2012
description: "I’ve been thinking of a way to organise some data for a multi-tenanted system. As such the database that would be used would have to mark pretty much every..."
tags:
  - { name: "Composite Primary Key", slug: composite-primary-key }
  - { name: "Compound Primary Key", slug: compound-primary-key }
  - { name: "Identity", slug: identity }
  - { name: "Primary Key", slug: primary-key }
  - { name: "SQL", slug: sql }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
I’ve been thinking of a way to organise some data for a multi-tenanted system. As such the database that would be used would have to mark pretty much every piece of data with the id of the tenant in some way. This got me thinking about using composite primary keys on tables.
Using a composite primary key with the `TenantId` as the first part has the advantage that all data relating to a single tenant is adjacent in the database which should speed up reads as there will be less to read. Any reads will likely be confined to a single tenant. I can’t see lookups being made independent of the tenant being frequent, and if they do occur then it is most likely not as part of the application but as a DBA sitting down at SSMS.

The second part of the composite primary key is kind of like an identity column, but not. While an identity column could be used it will produce gaps in the sequence for an individual tenant and I didn’t want that. I wanted similar behaviour to an identity column but separate counters for each tenant.

### Pitfalls on the way

When I was looking for a solution much of what I found talked about doing the process manually, often from the application side. I really don’t want the application having to know that much about the database.

Other solutions talked about only ever using stored procedures, which is a little better, but then if you have many stored procedures that insert into the table with the composite key then you have to remember to call the code from all those places.

In the end I went for an `INSTEAD OF INSERT` trigger. But implementing the ideas I’d run across in a trigger proved problematic.

I tried a few different ideas which worked well when a single user was accessing the database, but when stress testing the design with multiple simultaneous inserts I got either primary key violations (insufficient locks) or deadlocks (too much locking). In the end I discovered that there is a mutex like concept in SQL Server that locks sections of code rather than tables. While this may not sound terribly useful if there is only ever one piece of code that generates the identity like column, such as the `INSTEAD OF INSERT` trigger then it could work.

### The Solution

Here is the solution, which I’ll walk you through in a moment. For the moment, just be aware that there are two tables: Tenants and Products. A product can be owned by a single tenant only, so there is a parent/child relationship.

Tables:

```sql
CREATE TABLE [dbo].[Tenants](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Tenants] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Products](
    [TenantId] [int] NOT NULL,
    [Id] [int] NOT NULL,
    [Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
    [TenantId] ASC,
    [Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Products]  WITH CHECK ADD  CONSTRAINT [FK_Products_Tenants] FOREIGN KEY([TenantId])
REFERENCES [dbo].[Tenants] ([Id])
GO

ALTER TABLE [dbo].[Products] CHECK CONSTRAINT [FK_Products_Tenants]
GO
```

Trigger:

```sql
CREATE TRIGGER dbo.IOINS_Products 
   ON  dbo.Products 
   INSTEAD OF INSERT
AS 
BEGIN
  SET NOCOUNT ON;

  -- Acquire the lock so that no one else can generate a key at the same time.
  -- If the transaction fails then the lock will automatically be released.
  -- If the acquisition takes longer than 15 seconds an error is raised.
  DECLARE @res INT;
  EXEC @res = sp_getapplock @Resource = 'IOINS_Products', 
    @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = '15000',
    @DbPrincipal = 'public'
  IF (@res < 0)
  BEGIN
    RAISERROR('Unable to acquire lock to update Products table.', 16, 1);
  END

  -- Work out what the current maximum Ids are for each tenant that is being
  -- inserted in this operation.
  DECLARE @baseId TABLE(BaseId int, TenantId int);
  INSERT INTO @baseId
  SELECT MAX(ISNULL(p.Id, 0)) AS BaseId, i.TenantId 
  FROM  inserted i
  LEFT OUTER JOIN Products p ON i.TenantId = p.TenantId
  GROUP BY i.TenantId

  -- The replacement insert operation
  INSERT INTO Products
  SELECT 
    i.TenantId, 
    ROW_NUMBER() OVER(PARTITION BY i.TenantId ORDER BY i.TenantId) + b.BaseId 
      AS Id,
    Name
  FROM inserted i
  INNER JOIN @baseId b ON b.TenantId = i.TenantId

  -- Release the lock.
  EXEC @res = sp_releaseapplock @Resource = 'IOINS_Products', 
    @DbPrincipal = 'public', @LockOwner = 'Transaction'
END
GO
```

The `Tenants` table does use a traditional `IDENTITY` column for its primary key, but the `Products` table does not.

The `INSTEAD OF INSERT` trigger will do just what it says, instead of using the insert statement that was issues, it will replace it with its own code. This means that the database has the opportunity to perform additional actions before the insert takes place, potentially replacing the `INSERT` itself.

The first thing the trigger does is attempt to acquire a lock to ensure that no one else can calculate the next available id value. Rather than locking a table it uses [`sp_getapplock`](http://msdn.microsoft.com/en-us/library/ms189823(v=sql.90).aspx) (available from SQL Server 2005 onwards) which locks code instead since the trigger is the only place that will calculate the next `Id` value.

A table variable is created to hold all the current max values of `Id` for each `TenantId` in the current insert operation. These will act as the base `Id`s for the subsequent `INSERT` operation. This ensures that if the `INSERT` is processing multiple `TenantId`s in one operation they are all accounted for. In reality, for the tenant based application I’m thinking about, I don’t see this happening all that frequently if at all, but fortune favours the prepared, so they say.

Next is the actual `INSERT` statement that will put the data into the database. I’m using the [`ROW_NUMBER()`](http://msdn.microsoft.com/en-us/library/ms186734(v=sql.90).aspx) function (available from SQL Server 2005) to work out a sequential value for each row that is being inserted partitioned by the `TenantId`. This means that each `TenantId` will have a row number starting a 1 which can then be added to the base Id that was worked out in the previous step. The `Id` column is the only substitution in the `INSERT`, the remainder of the columns are passed through as is without alteration.

Finally, the lock is released using [sp_releaseapplock()](http://msdn.microsoft.com/en-us/library/ms178602(v=sql.90).aspx). This ensures that any other process that is waiting to `INSERT` data into this table can do so. In the event that the transaction fails the lock will be released automatically as the Owner was set to the transaction.

### Issues

While composite keys can mean that you can create more natural keys for your data over using a surrogate key like an single unique identity column or GUID/UUID as it follows more closely the model of the business, it does mean that if the business changes then you may end up needing to find ways to change a primary key, something that should remain immutable. For example, if you have two tenants in your system and then they merge into a single tenant it is likely you are going to have duplicate keys if you simply change the tenant Id on one.

If the shape of the table changes then the INSTEAD OF INSERT trigger will have to be updated as well as the replacement insert statement will have to take account of the new columns or eliminate references to columns that no longer exist.

There are also issues with Entity Framework not being able to get the newly generated value back. I'll discuss that in more detail in a future blog post.
