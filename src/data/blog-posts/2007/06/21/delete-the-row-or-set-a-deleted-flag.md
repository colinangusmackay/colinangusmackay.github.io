---
title: "Delete the row, or set a deleted flag?"
slug: delete-the-row-or-set-a-deleted-flag
publishDate: 21 Jun 2007
description: "For auditing purposes some database system run without deleting rows from the database - they just flag the row as being deleted and ensure that queries that..."
tags:
  - { name: "data design", slug: data-design }
  - { name: "Database", slug: database }
---
For auditing purposes some database system run without deleting rows from the database - they just flag the row as being deleted and ensure that queries that run on the table add a line to the WHERE clause to filter out the "deleted" rows.

However, as [Daniel Turini](https://web.archive.org/web/20200807222558/https://www.codeproject.com/script/Membership/View.aspx?mid=18901)\* points out on Code Project, this can hurt the database performance.

Specifically he says:

> Bear in mind that having a flag leads to bad index performance. In my (rather old) [SQL Server DO's and DONT's](https://www.codeproject.com/Articles/3171/SQL-Server-DO-s-and-DONT-s-8)\*, I suggest you not to index on the "sex" or "gender" field:
>
> > *First, let's understand how indexes speed up table access. You can see indexes as a way of quickly partitioning a table based on a criteria. If you create an index with a column like "Sex", you'll have only two partitions: Male and Female. What optimization will you have on a table with 1,000,000 rows? Remember, mantaining an index is slow. Always design your indexes with the most sparse columns first and the least sparse columns last, e.g, Name + Province + Sex.*
>
> Creating a "deleted" flag will lead to bad performance, on several common cases. What I'd suggest is to move those rows to a "Deleted" table, and have a view using UNION ALL so you can easily access all the data for auditing purposes.
> Not to mention that it's easy to forget an `AND NOT IsDeleted` in some of your queries.\**

However, others recon the performance hit is negligable. Or that moving the data to a new table could damage the data. It is an interesting debate.

*NOTE: This was rescued from the Google Cache. The original date was Thursday, 29th June 2006.*

### 🔄 Follow up footnotes - 9th August 2026

\* Unfortunately, in the time since this original blog post, The Code Project has ceased to be and the wayback machine only captured so much of that site. I have, where available, updated the links to point to the wayback machine, but the link to the original debate has been removed from this post as it lead nowhere.

\** The idea that "it's easy to forget an `AND NOT IsDeleted` in some of your queries" can be mitigated in modern ORMs such as Entity Framework by setting [global query filters](https://learn.microsoft.com/en-us/ef/core/querying/filters?tabs=ef10), so that by default your queries will add the filter for `IsDeleted = 0` and you won't need to worry about it so much.