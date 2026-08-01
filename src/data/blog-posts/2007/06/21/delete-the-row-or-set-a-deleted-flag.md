---
title: "Delete the row, or set a deleted flag?"
slug: delete-the-row-or-set-a-deleted-flag
publishDate: 21 Jun 2007
description: "For auditing purposes some database system run without deleting rows from the database - they just flag the row as being deleted and ensure that queries that..."
tags:
  - { name: "data design", slug: data-design }
  - { name: "Database", slug: database }
---
<!-- TODO: convert this post's content to Markdown -->

For auditing purposes some database system run without deleting rows from the database - they just flag the row as being deleted and ensure that queries that run on the table add a line to the WHERE clause to filter out the "deleted" rows.

However, as <a href="http://www.codeproject.com/script/profile/whos_who.asp?id=18901">Daniel Turini</a> points out on <a title="Code Project" href="http://www.codeproject.com/" target="_blank">Code Project</a>, <a href="http://www.codeproject.com/script/comments/forums.asp?msg=1554949&amp;forumid=1159#xx1554949xx">this can hurt the database performance</a>.

Specifically he says:
<blockquote style="margin-right:0;">Bear in mind that having a flag leads to bad index performance. In my (rather old) <a href="http://www.codeproject.com/cs/database/sqldodont.asp">SQL Server DO's and DONT's</a>[<a href="http://www.codeproject.com/cs/database/sqldodont.asp" target="_blank">^</a>], I suggest you not to index on the "sex" or "gender" field:
<blockquote><em>First, let's understand how indexes speed up table access. You can see indexes as a way of quickly partitioning a table based on a criteria. If you create an index with a column like "Sex", you'll have only two partitions: Male and Female. What optimization will you have on a table with 1,000,000 rows? Remember, mantaining an index is slow. Always design your indexes with the most sparse columns first and the least sparse columns last, e.g, Name + Province + Sex.</em>

<em> </em></blockquote>
Creating a "deleted" flag will lead to bad performance, on several common cases. What I'd suggest is to move those rows to a "Deleted" table, and have a view using UNION ALL so you can easily access all the data for auditing purposes.

Not to mention that it's easy to forget an "AND NOT IsDeleted" in some of your queries.</blockquote>
However, others recon the performance hit is negligable. Or that moving the data to a new table could damage the data. It is an interesting debate and you can read it <a href="http://www.codeproject.com/script/comments/forums.asp?msg=1554923&amp;forumid=1159#xx1554923xx">here, from the start</a>.

<em>NOTE: This was rescued from the Google Cache. The original date was Thursday, 29th June 2006.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/database"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=database" alt=" " />database</a> <a rel="tag" href="http://technorati.com/tag/delete"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=delete" alt=" " />delete</a> <a rel="tag" href="http://technorati.com/tag/flag"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=flag" alt=" " />flag</a> <a rel="tag" href="http://technorati.com/tag/audit"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=audit" alt=" " />audit</a> <a rel="tag" href="http://technorati.com/tag/row"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=row" alt=" " />row</a> <a rel="tag" href="http://technorati.com/tag/performance"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=performance" alt=" " />performance</a> <a rel="tag" href="http://technorati.com/tag/data+integrity"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=data+integrity" alt=" " />data integrity</a>
