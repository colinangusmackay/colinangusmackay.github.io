---
title: "Table names - Singular or Plural"
slug: table-names-singular-or-plural
publishDate: 02 Mar 2011
description: "Earlier this morning I tweeted asking for a quick idea of whether to go with singular table names or plural table names. i.e. the difference between having a..."
tags:
  - { name: "data design", slug: data-design }
  - { name: "Database", slug: database }
---
<!-- TODO: convert this post's content to Markdown -->

Earlier this morning I tweeted asking for a quick idea of whether to go with singular table names or plural table names. i.e. the difference between having a table called “Country” vs. “Countries”

Here are the very close results:
<ul>
	<li>Singular: 8</li>
	<li>Plural: 6</li>
	<li>Either: 1</li>
</ul>
Why Singuar:
<ul>
	<li>That’s how the start off life on my ER diagram</li>
	<li>You don’t need to use a plural name to know a table will hold many of an item.</li>
	<li>A table consists of rows of items that are singular</li>
</ul>
Why Plural:
<ul>
	<li>It is the only choice unless you are only ever storing one row in each table.</li>
	<li>because they contain multiple items</li>
	<li>It contains Users</li>
	<li>I think of it as a collection rather than a type/class</li>
	<li>SELECT TOP 1 * FROM Customers</li>
</ul>
Why either:
<ul>
	<li>Either works, so long as it is consistent across the entire db/app</li>
</ul>
