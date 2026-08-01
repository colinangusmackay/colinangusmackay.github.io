---
title: "Types of join"
slug: types-of-join
publishDate: 23 Jun 2007
description: "Occasionally there is a post on a forum asking what a certain type of join is all about, so I thought it would probably be good to have a stock explanation to..."
tags:
  - { name: "Database", slug: database }
  - { name: "SQL", slug: sql }
---
<!-- TODO: convert this post's content to Markdown -->

Occasionally there is a post on a forum asking what a certain type of join is all about, so I thought it would probably be good to have a stock explanation to refer people to so that I don't re-write near enough the same response each time the question arises.

First lets consider these two tables.

A
<pre>Key         Data
----------- ----------
1           a
2           b</pre>
B
<pre>Key         Data
----------- ----------
1           c
3           d</pre>
We can see that the only match is where Key is 1.
<h2>INNER JOIN</h2>
In an INNER JOIN that will be the only thing returned. If we use the query
<pre>SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
INNER JOIN B ON a.[Key] = b.[Key]</pre>
the returned set will be
<pre>aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c</pre>
In the case of the various outer joins non-matches will be returned also.
<h2>LEFT OUTER JOIN</h2>
In a LEFT OUTER JOIN everything on the left side will be returned. Any matches on the right side will be returned also, but if there is no match on the right side then nulls are returned instead.

The query
<pre>SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
LEFT OUTER JOIN B ON a.[Key] = b.[Key]</pre>
returns
<pre>aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c
2           b          NULL        NULL</pre>
<h2>RIGHT OUTER JOIN</h2>
The RIGHT OUTER JOIN is very similar to the LEFT OUTER JOIN, except that, of course, the matching is reversed. Everything on the right side is returned, and only matches on the left side are returned. Any non-matches will be filled with nulls on the left side.

The query
<pre>SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
RIGHT OUTER JOIN B ON a.[Key] = b.[Key]</pre>
returns
<pre>aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c
NULL        NULL       3           d</pre>
<h2>FULL OUTER JOIN</h2>
A FULL OUTER JOIN returns a set containing all rows from either side, matched if possible, but nulls put in place if not.

The query
<pre>SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
FULL OUTER JOIN B ON a.[Key] = b.[Key]</pre>
returns
<pre>aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c
2           b          NULL        NULL
NULL        NULL       3           d</pre>
<h2>CROSS JOIN</h2>
The CROSS JOIN doesn't obey the same set of rules as the other joins. This is because it doesn't care about matching rows from either side, so there is no ON qualifier within the join clause. This is a simple join that joins all rows on the left side to all rows on the right side. Where the inner join and left/right outer join cannot return more rows than exist in the most populous of the source tables and the full outer join's maximum result set if the sum of the source rows, the CROSS JOIN will return the product of rows from each side. If you have 5 rows in Table A, and 6 rows in Table B it will return a set containing 30 rows.

The query
<pre>SELECT A.[Key] AS aKey, A.Data AS aData, B.[Key] AS bKey, b.Data AS bData
FROM A
CROSS JOIN B</pre>
returns
<pre>aKey        aData      bKey        bData
----------- ---------- ----------- ----------
1           a          1           c
2           b          1           c
1           a          3           d
2           b          3           d</pre>
<em> NOTE: This was rescued from the Google Cache: The original date was Monday, 27th February 2006.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/sql+server"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+server" alt=" " />sql server</a> <a rel="tag" href="http://technorati.com/tag/sql"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql" alt=" " />sql</a> <a rel="tag" href="http://technorati.com/tag/database"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=database" alt=" " />database</a> <a rel="tag" href="http://technorati.com/tag/join"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=join" alt=" " />join</a> <a rel="tag" href="http://technorati.com/tag/inner+join"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=inner+join" alt=" " />inner join</a> <a rel="tag" href="http://technorati.com/tag/outer+join"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=outer+join" alt=" " />outer join</a> <a rel="tag" href="http://technorati.com/tag/full+outer+join"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=full+outer+join" alt=" " />full outer join</a> <a rel="tag" href="http://technorati.com/tag/left+outer+join"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=left+outer+join" alt=" " />left outer join</a> <a rel="tag" href="http://technorati.com/tag/right+outer+join"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=right+outer+join" alt=" " />right outer join</a>
