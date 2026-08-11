---
title: "Types of join"
slug: types-of-join
publishDate: 23 Jun 2007
description: "Occasionally there is a post on a forum asking what a certain type of join is all about, so I thought it would probably be good to have a stock explanation to..."
tags:
  - { name: "Database", slug: database }
  - { name: "SQL", slug: sql }
---

Occasionally there is a post on a forum asking what a certain type of join is all about, so I thought it would probably be good to have a stock explanation to refer people to so that I don't re-write near enough the same response each time the question arises.
First lets consider these two tables.
A

```
Key         Data
----------- ----------
1           a
2           b
```

B

```
Key         Data
----------- ----------
1           c
3           d
```

We can see that the only match is where Key is 1.

## INNER JOIN

In an INNER JOIN that will be the only thing returned. If we use the query

```
SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
INNER JOIN B ON a.[Key] = b.[Key]
```

the returned set will be

```
aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c
```

In the case of the various outer joins non-matches will be returned also.

## LEFT OUTER JOIN

In a LEFT OUTER JOIN everything on the left side will be returned. Any matches on the right side will be returned also, but if there is no match on the right side then nulls are returned instead.
The query

```
SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
LEFT OUTER JOIN B ON a.[Key] = b.[Key]
```

returns

```
aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c
2           b          NULL        NULL
```

## RIGHT OUTER JOIN

The RIGHT OUTER JOIN is very similar to the LEFT OUTER JOIN, except that, of course, the matching is reversed. Everything on the right side is returned, and only matches on the left side are returned. Any non-matches will be filled with nulls on the left side.
The query

```
SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
RIGHT OUTER JOIN B ON a.[Key] = b.[Key]
```

returns

```
aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c
NULL        NULL       3           d
```

## FULL OUTER JOIN

A FULL OUTER JOIN returns a set containing all rows from either side, matched if possible, but nulls put in place if not.
The query

```
SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
FULL OUTER JOIN B ON a.[Key] = b.[Key]
```

returns

```
aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c
2           b          NULL        NULL
NULL        NULL       3           d
```

## CROSS JOIN

The CROSS JOIN doesn't obey the same set of rules as the other joins. This is because it doesn't care about matching rows from either side, so there is no ON qualifier within the join clause. This is a simple join that joins all rows on the left side to all rows on the right side. Where the inner join and left/right outer join cannot return more rows than exist in the most populous of the source tables and the full outer join's maximum result set if the sum of the source rows, the CROSS JOIN will return the product of rows from each side. If you have 5 rows in Table A, and 6 rows in Table B it will return a set containing 30 rows.
The query

```
SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
CROSS JOIN B
```

returns

```
aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c
2           b          1           c
1           a          3           d
2           b          3           d
```

*NOTE: This was rescued from the Google Cache: The original date was Monday, 27th February 2006.*

