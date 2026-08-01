---
title: "Singular Vs Plural table names"
slug: singular-vs-plural-table-names
publishDate: 23 Sep 2011
description: "A while ago I blogged about whether to make table names singular or plural . The subject raised itself again recently in the office after Microsoft's Entity..."
tags: []
---
<!-- TODO: convert this post's content to Markdown -->

A while ago <a href="http://colinmackay.co.uk/blog/2011/03/02/table-names-singular-or-plural/">I blogged about whether to make table names singular or plural</a>. The subject raised itself again recently in the office after Microsoft's Entity Framework makes some pretty odd decisions when converting from Plural to Singular form. (According to EF the singular of "ranges" is "ranx"... and if you look on places like <a href="http://stackoverflow.com/questions/5089525/ef-singularizes-changes-to-chanx">Stack Overflow you'll find other examples, such as "changes" to "chanx"</a>)

Here are the updated results
<ul>
	<li>Singular: 9</li>
	<li>Plural: 10</li>
	<li>Either: 4</li>
</ul>
Again, there is no overall winner

Those in favour of pluralising the names said:
<ul>
	<li>To me, table names should always be plural – they’re a collection of records, and the singular form applies to the record.</li>
</ul>
Those with no preference:
<ul>
	<li>I've tended to find that people who are more used to thinking of the model in class terms tend to prefer singular. People who are used to thinking from the DB first tend to prefer plural.</li>
	<li>For me using an ORM should be removing the need for me to think about database naming because ideally I will never have to go direct to the database tables, I will always be going through objects.</li>
</ul>
In favour of Singularising names:
<ul>
	<li>I’ve always used and prefer singular – better ordering of tables and fewer problems with mappings, but as long as we’re consistent (within a single database)</li>
</ul>
I suspect this debate will continue on for as long as there are table based databases...
