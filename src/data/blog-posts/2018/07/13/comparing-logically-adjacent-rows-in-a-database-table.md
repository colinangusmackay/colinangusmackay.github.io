---
title: "Comparing logically adjacent rows in a database table"
slug: comparing-logically-adjacent-rows-in-a-database-table
publishDate: 13 Jul 2018
description: "If you have database table that stores something such as when an action occurred, it might be useful to work out how far apart these events are. It is easy to..."
tags:
  - { name: "SQL", slug: sql }
---
If you have database table that stores something such as when an action occurred, it might be useful to work out how far apart these events are. It is easy to join different tables together, or even if you have a self-referential join to join rows of the same table together if an existing relationship exists. But what if you want to join on a logically adjacent row?

First of all, I'm saying "logically adjacent row" because relational databases are set based, there is no concept of sequence unless we specifically define it (e.g. an `ORDER BY` clause). So we have to define what adjacent row means in the context of what ever query we want. It could be based on date/time (as is the example I'm going to show you later), or some other sort order (alphabetical listing, distance from a point, etc.)
So, to start with we need a way of ordering the data that we have.

```sql
SELECT 
    RANK() OVER (ORDER BY ColumnThatDefinesSequence) as [Sequence], 
    PrimaryKeyIdColumn
FROM MyTable
```

What this will do is create a result set consisting of an uninterrupted sequence that increments by one each time which maps to the primary key of the table. You can add in filters such as a `WHERE` clause to remove any rows you are not interested in and the `RANK` function will always ensure that it results in a sequence that starts at one and increments by one, thus effectively closing the gaps in the source data's key. \`Sequence\` will become our key later on.
Next, we need join each adjacent row together:

```sql
WITH Seq(Sequence, Id)
AS
(
    SELECT 
        RANK() OVER (ORDER BY ColumnThatDefinesSequence) as [Sequence], 
        PrimaryKeyIdColumn
    FROM MyTable
)
SELECT *
FROM Seq s1
INNER JOIN Seq s2 ON s1.[Sequence] = s2.[Sequence]-1
```

This now produces a result set that has each adjacent row joined with each other. Because we know that the `Sequence` will always increment by one compared to its logically adjacent neighbour we can join against the row with the `Sequence` number one lower than this row.
This can now use used with the source table to get the final data set.

```sql
WITH Seq(Sequence, Id)
AS
(
    SELECT 
        RANK() OVER (ORDER BY ColumnThatDefinesSequence) as [Sequence], 
        PrimaryKeyIdColumn
    FROM MyTable
)
SELECT mt1.*, mt2.*
FROM Seq s1
INNER JOIN Seq s2 ON s1.[Sequence] = s2.[Sequence]-1
INNER JOIN MyTable mt1 ON mt1.PrimaryKeyId = s1.Id
INNER JOIN MyTable mt2 ON mt2.PrimaryKeyId = s2.Id
```

The result set here is now just the source table rows joined to their logically adjacent row.
So, if your source table is a set of actions and it has a column of an action occurred (which we'll call `ActionDate` in this example), you could find out how far apart the actions are with a query like this.

```sql
WITH Seq(Sequence, Id)
AS
(
    SELECT 
        RANK() OVER (ORDER BY ColumnThatDefinesSequence) as [Sequence], 
        PrimaryKeyIdColumn
    FROM MyTable
)
SELECT 
    mt1.PrimaryKeyId AS FirstActionId, 
    mt1.ActionDate AS FirstActionDate, 
    mt2.PrimaryKeyId AS SecondActionId, 
    mt2.ActionDate AS SecondActionDate 
    DATEDIFF(SECOND, mt1.ActionDate, mt2.ActionDate) AS TimeBetweenActions
FROM Seq s1
INNER JOIN Seq s2 ON s1.[Sequence] = s2.[Sequence]-1
INNER JOIN MyTable mt1 ON mt1.PrimaryKeyId = s1.Id
INNER JOIN MyTable mt2 ON mt2.PrimaryKeyId = s2.Id
```
