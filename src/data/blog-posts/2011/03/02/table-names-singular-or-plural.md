---
title: "Table names - Singular or Plural"
slug: table-names-singular-or-plural
publishDate: 02 Mar 2011
description: "Earlier this morning I tweeted asking for a quick idea of whether to go with singular table names or plural table names. i.e. the difference between having a..."
tags:
  - { name: "data design", slug: data-design }
  - { name: "Database", slug: database }
---
Earlier this morning I tweeted asking for a quick idea of whether to go with singular table names or plural table names. i.e. the difference between having a table called “Country” vs. “Countries”
Here are the very close results:

- Singular: 8
- Plural: 6
- Either: 1

Why Singular:

- That’s how the start off life on my ER diagram
- You don’t need to use a plural name to know a table will hold many of an item.
- A table consists of rows of items that are singular

Why Plural:

- It is the only choice unless you are only ever storing one row in each table.
- because they contain multiple items
- It contains Users
- I think of it as a collection rather than a type/class
- SELECT TOP 1 \* FROM Customers

Why either:

- Either works, so long as it is consistent across the entire db/app
