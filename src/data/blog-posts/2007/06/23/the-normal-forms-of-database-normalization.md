---
title: "The Normal Forms of Database Normalization"
slug: the-normal-forms-of-database-normalization
publishDate: 23 Jun 2007
description: "I'm doing a clear out at the moment as I'm getting the house ready to sell - I'm planning to move to West Lothian - and I came across some old notes about..."
tags:
  - { name: "data design", slug: data-design }
  - { name: "Database", slug: database }
---
<!-- TODO: convert this post's content to Markdown -->

I'm doing a clear out at the moment as I'm getting the house ready to sell - I'm planning to move to West Lothian - and I came across some old notes about database normalisation. It was a summary about the first 5 normal forms so I thought I'd share them.

<strong>First Normal Form</strong>: Every column contains just one value. That means that if you have a person's name it should be split up to forename and surname, an address is split up so that the city and postcode are in separate columns, and so on.

<strong>Second Normal Form</strong>: The First Normal Form plus every table has a primary key. That means that everything can be uniquely referenced through the primary key.

<strong>Third Normal Form</strong>: The Second Normal Form plus every non-key column depends on the primary key. So for example, if you have an Orders table then columns such as DateOfOrder and DateOfDispatch are valid but listing the client's details such as name, address and so on are not valid.

<strong>Fourth Normal Form</strong>: Remove repeating columns to a new table. Repeating columns are indicative of a missing relationship. So, if you have an Orders table it will not have item1, item2, and item3 columns. They will be removed to a separate table and form part of a join to the orders table.

<strong>Fifth Normal Form</strong>: Remove repetition within columns. Simply, this is enumerated values. For example, a company may accept Visa, Mastercard and American Express for payment. Rather than repeat those strings in the order payment table, they can be places in a small lookup table and the order payment table can refer to their smaller primary key.

However, I should point out that my notes are at odds with other references that I found. It would seem that the correct Fifth Normal Form is to do with ternary many-to-many relationships. In fact a quick search on the internet found that what ever I had written down as the Fifth Normal Form isn't to be found. More research is in order to find out where my idea of the Fifth Normal Form comes from

NOTE: This was rescued from the Google Cache. The original date was Saturday, 22nd April 2006.
