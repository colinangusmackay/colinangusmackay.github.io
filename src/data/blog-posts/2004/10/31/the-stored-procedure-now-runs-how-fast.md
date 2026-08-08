---
title: "The Stored Procedure Now Runs How Fast?"
slug: the-stored-procedure-now-runs-how-fast
publishDate: 31 Oct 2004
description: "On our test server the stored procedure ran acceptably in a few seconds so it came as somewhat as a shock when trying the application out on the client's test server that the same code was timing out after 20 minutes...'"
tags:
  - { name: "SQL", slug: "sql" }
  - { name: "Optimisation", slug: "optimisation" }
---

A few days ago I was having some problems with a stored procedure taking too long. On our test server the stored procedure ran acceptably in a few seconds so it came as somewhat as a shock when trying the application out on the client's test server that the same code was timing out after 20 minutes. Now given the number of times this stored procedure was going to be called the data aggregation and extraction utility it was part of would take somewhere in the region of 2 weeks to run.

So, I asked a collegue to have a look at my stored proc to see if a second set of eyes could see where the problem might lie. One of his suggestions was to pull the main select (which ran to about 2 screens of text) apart and run the subqueries independently so that we could looks at the different parts in more detail in order to determine where the bottleneck was. So I did that and discovered that the individual parts ran a lot quicker than the whole. So, I wondered, what if I just dump the results of these extracted subqueries into table variables and just plug the table variables into the main select. Curiously, it went back to taking a few seconds to run the stored procedure.

It would seem that the query optimiser got itself in a bit of a fankle* over joining the subqueries up with the main query. But by extracting them to put their results in to table variables only around 7000 rows were used in the final join rather than the near 200 million (of which all but ~7000 were discarded during the join operation) . This speed improvement is very important as the live server is likely to have many millions of more rows since we last copied it to use as the test system.

💡 When operating on very large datasets with joins onto subqueries, it can be useful to extract the subqueries in to temporary tables or table variables in order to speed up the query, and as a bonus the stored procedure will be easier to read.

\* [Fankle](https://dsl.ac.uk/entry/snd/fankle): _Scots n._ A tangle, muddle.

### 🔄 Follow up - 8th August 2026

Since this post was originally written, [Common Table Expressions](https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-ver17) were introduced into SQL Server. This may be another way to help optimise queries. However, sometimes even they fall short and temporary table or table variables are faster.