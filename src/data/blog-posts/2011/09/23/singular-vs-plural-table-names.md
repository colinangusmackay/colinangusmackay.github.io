---
title: "Singular Vs Plural table names"
slug: singular-vs-plural-table-names
publishDate: 23 Sep 2011
description: "A while ago I blogged about whether to make table names singular or plural . The subject raised itself again recently in the office after Microsoft's Entity..."
tags: []
---
<!-- ISSUE: link (http://stackoverflow.com/questions/5089525/ef-singularizes-changes-to-chanx): status 403 -->

A while ago [I blogged about whether to make table names singular or plural](/2011/03/02/table-names-singular-or-plural/). The subject raised itself again recently in the office after Microsoft's Entity Framework makes some pretty odd decisions when converting from Plural to Singular form. (According to EF the singular of "ranges" is "ranx"... and if you look on places like [Stack Overflow you'll find other examples, such as "changes" to "chanx"](http://stackoverflow.com/questions/5089525/ef-singularizes-changes-to-chanx))
Here are the updated results

- Singular: 9
- Plural: 10
- Either: 4

Again, there is no overall winner
Those in favour of pluralising the names said:

- To me, table names should always be plural – they’re a collection of records, and the singular form applies to the record.

Those with no preference:

- I've tended to find that people who are more used to thinking of the model in class terms tend to prefer singular. People who are used to thinking from the DB first tend to prefer plural.
- For me using an ORM should be removing the need for me to think about database naming because ideally I will never have to go direct to the database tables, I will always be going through objects.

In favour of Singularising names:

- I’ve always used and prefer singular – better ordering of tables and fewer problems with mappings, but as long as we’re consistent (within a single database)

I suspect this debate will continue on for as long as there are table based databases...
