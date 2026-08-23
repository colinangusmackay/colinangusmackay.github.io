---
title: "Getting Entity Framework to Pick up on the Auto-generated Part of the Composite Primary Key"
slug: getting-entity-framework-to-pick-up-on-the-auto-generated-part-of-the-composite-primary-key
publishDate: 30 Dec 2012
description: "In my previous post, I wrote about how to get SQL Server to automatically generate a composite primary key for a table when part of that key is also a foreign..."
tags:
  - { name: "Composite Primary Key", slug: composite-primary-key }
  - { name: "Compound Primary Key", slug: compound-primary-key }
  - { name: "Entity Framework", slug: entity-framework }
  - { name: "Identity", slug: identity }
  - { name: "Primary Key", slug: primary-key }
  - { name: "SQL", slug: sql }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---

In my previous post, I wrote about [how to get SQL Server to automatically generate a composite primary key for a table when part of that key is also a foreign key to a parent table](/2012/12/29/composite-primary-keys-including-identity-like-column/). That all works nicely in SQL Server and using regular ADO.NET commands from a .NET application. However, as the title of this post suggests, it is a little more of an issue when it comes to Entity Framework.

When you get Entity Framework to generate its model from the database then it picks up on identity columns automatically. In the example in the previous post there were no identity columns in the child table because the value was being generated from within the `INSTEAD OF INSERT` trigger and the column was not marked as an identity column.

It is easy enough to go into the entity model and manually set the properties of the `Id` column to have the `StoreGeneratedPattern` set to Identity which indicates to Entity Framework that it has to find out what the value is once the entity has been inserted into the database.

For an integer column this means that the Entity Framework will issue an `INSERT` statement like this:

```sql
exec sp_executesql N'insert [dbo].[Products]([TenantId], [Name])
values (@0, @1)
select [Id]
from [dbo].[Products]
where @@ROWCOUNT > 0 and [TenantId] = @0 and [Id] = scope_identity()',N'@0 int,@1 nvarchar(50)',@0=1,@1=N'Test Product A'
```

You'll notice that this isn't just a simple insert, it also performs a `SELECT` immediately afterwards in order to get the value of the newly inserted key back so that it can update the entity.

However, the way it does it will not produce a value. `SCOPE_IDENTITY()` will always be `null</CODEL p contained.< it value the destroyed have would trigger a used we fact was, there if even fact, In column. identity no was because> `

After much searching around on the internet I didn’t find a solution for this issue. I even [posted on StackOverflow](http://stackoverflow.com/questions/14084403/entity-framework-has-issues-with-composite-key-which-is-part-auto-generated "Entity Framework has issues with composite key which is part auto generated") and didn’t get an answer back (at least, I haven’t at the time of writing). However, I did eventually come across a workaround that could be used in place of `SCOPE_IDENITY()`. The work around involved changing the way the trigger worked to some extent.

The new trigger would capture the keys that it inserted and output them in a select statement at the end. The new trigger looked like this:

```sql
ALTER TRIGGER dbo.IOINS_Products 
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
  DECLARE @keys TABLE (Id INT);
  INSERT INTO Products
  OUTPUT inserted.Id INTO @keys
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

  SELECT Id FROM @keys
END
GO
```

As you can see the last line of the trigger performs a `SELECT in order to get the keys.`

Since the Entity Framework is only expecting one result set from the SQL it issued, the fact that we have now added in a second result set in the trigger tricks it into thinking that it has got the `SCOPE_IDENTITY()` value it was asking for. In fact, that result set, which contained a `null` value anyway, is now the second result set and is ignored by the Entity Framework.

If you are only ever going to use your database with Entity Framework then this solution may work for you. However, the idea that the trigger creates additional (and potentially unexpected) result sets may prove this workaround’s undoing in a more widely used system.
