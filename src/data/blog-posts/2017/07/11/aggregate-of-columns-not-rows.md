---
title: "Aggregate of columns, not rows"
slug: aggregate-of-columns-not-rows
publishDate: 11 Jul 2017
description: "In SQL Server it is very easy to aggregate a value across many rows. You simply just write something like this: SELECT MAX(SomeColumn) FROM SomeTable This will..."
tags:
  - { name: "SQL Server", slug: sql-server }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
  - { name: "SQL Server 2012", slug: sql-server-2012 }
  - { name: "SQL Server 2014", slug: sql-server-2014 }
  - { name: "SQL Server 2016", slug: sql-server-2016 }
---
<!-- TODO: convert this post's content to Markdown -->

In SQL Server it is very easy to aggregate a value across many rows. You simply just write something like this:
<pre>SELECT MAX(SomeColumn)
FROM SomeTable
</pre>
This will return one row with the aggregate value (in this case MAXimum) of the column.

However, what if you want to do this across columns. What if you have a table with two or more columns you want to aggregate for each row?

You can do this with a tedious case statement that just gets more and more cumbersome for each additional column you have, especially if any of the columns are nullable. Or, you can create a subquery with a table in it and you aggregate the table in the subquery exposing the final value to your main query already aggregated.

Here's an example:
<pre>SELECT Id, 
       (SELECT MAX(num) FROM (VALUES(st.ANumber), (st.AnotherNumber)) AS AllNumbers(num)) AS MaxNumber
FROM SomeTable st
</pre>
The second line contains the subquery which is then exposed as a column in the final result set.

The subquery effectively pivots the columns into rows, then aggregates the rows. Just be careful with where you put the brackets so that it interprets them as separate rows rather than columns.

This also deals with NULL values quite effectively too, since the aggregate function will ignore any null value it finds.
