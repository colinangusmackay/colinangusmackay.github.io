---
title: "Checking for NULL using Entity Framework"
slug: checking-for-null-using-entity-framework
publishDate: 22 Nov 2011
description: "Here is a curious gotcha using the Entity Framework: If you are filtering on a value that may be null then you may not be getting back the results you expect...."
tags:
  - { name: ".NET", slug: net }
  - { name: "C#", slug: c }
  - { name: "Entity Framework", slug: entity-framework }
---
Here is a curious gotcha using the Entity Framework: If you are filtering on a value that may be null then you may not be getting back the results you expect.

For example, if you do something like this:

```csharp
var result = context.GarmentsTryOns
    .Where(gto => 
        gto.WeddingId == weddingId &&
        gto.PersonId == personId);
```

And `personId` is `null` then you won't get any results back. This is because under the hood the query is structured like this:

```sql
…WHERE WeddingId = @p0 AND PersonId = @p1
```

That's all great when `@p1` has a value, but when it is `null` SQL Sever says nothing matches. In SQL Server, `NULL` is not a value, it is the absence of a value, it does not equal to anything (including itself) e.g. Try this:

```sql
SELECT CASE WHEN NULL = NULL THEN 1 ELSE 0 END
```

That returns **0**!

Anyway, if you want to test NULL-ability, you need the `IS` operator, e.g.

```sql
SELECT CASE WHEN NULL IS NULL THEN 1 ELSE 0 END
```

That returns **1**, which is what you'd expect.

Now, for whatever reason, EF is not clever enough to realise that in the above example, `personId` is (perfectly validly) `null` in some cases and switch from using `=` to `IS` as needed. So, what we need is a little jiggery-pokery to get this to work. EF can tell if you hard code the `null`, so you can do this in advance to set things up:

```csharp
Expression<Func<GarmentTryOns, bool>> personExpression;
if (personId == null)
    personExpression = gto => gto.PersonId == null;
else
    personExpression = gto => gto.PersonId == personId;
```

This can then be injected as a `Where` filter onto the query and it EF will interpret it correctly. Like this:

```csharp
var result = context.GarmentTryOns
                    .Where(gto => gto.WeddingId == weddingId)
                    .Where(personExpression);
```

The SQL that EF produces now correctly uses `PersonId IS NULL` when appropriate.
