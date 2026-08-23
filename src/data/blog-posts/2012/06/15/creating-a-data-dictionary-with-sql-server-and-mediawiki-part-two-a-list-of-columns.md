---
title: "Creating a data dictionary with SQL Server and MediaWiki - Part two: a list of columns"
slug: creating-a-data-dictionary-with-sql-server-and-mediawiki-part-two-a-list-of-columns
publishDate: 15 Jun 2012
description: "In my previous post , I showed how to create a SQL Script that generates Mediawiki mark-up to create a list of tables (or views) in your database. In this..."
tags:
  - { name: "data dictionary", slug: data-dictionary }
  - { name: "documentation", slug: documentation }
  - { name: "MediaWiki", slug: mediawiki }
  - { name: "SQL", slug: sql }
---
In my [previous post](/2012/06/14/creating-a-data-dictionary-with-sql-server-and-mediawiki-part-one-a-list-of-tables/ "Creating a data dictionary with SQL Server and MediaWiki – Part one: a list of tables"), I showed how to create a SQL Script that generates Mediawiki mark-up to create a list of tables (or views) in your database. In this post, I'll continue with generating a list of columns.

### Script walk through

At the top of the script are three variables used to define which table (or view) from which we want the columns. The `@catalogue` is the name of the database, the `@schema` and `@table` are the schema name (often simply 'dbo') and the table or view name, respectively.

After a little housekeeping (defining all the variables we'll be using later) we output the head of the wiki table. This includes the instructions that it is to be sortable, and on which columns the sort is happening.

Then we open our first cursor. The `table_cursor` walks through all the columns in the table.

Inside the loop of the `table_cursor`, we create a `constraint_cursor` to get the constraints for each column by building up the `@constraints` variable with the details which will be put on the wiki table later.

After the that, a new cursor (`pk_cursor`) is set up to find the primary key end points of the foreign key column that is being rendered.
Finally, all the information that has been collected is output to the screen.

Once the `table_cursor` is over the mark-up for closing off the wiki table is output.

### How it renders

The wiki mark-up looks like this:

```
{| class="wikitable sortable"
|-
! scope="col" | Column Name
! scope="col" | Ordinal Position
! scope="col" | Is Nullable
! scope="col" | Data type
! scope="col" | Constraints
! scope="col" | FK Endpoint
! scope="col" class="unsortable" | Notes
|-
| ProductID
| 1
| NO
| int
| PRIMARY KEY
|
|
|-
```

And it renders to the screen like this:

![Mediawiki representation of the columns in a table](/assets/blog/2012-06-15-creating-a-data-dictionary-with-sql-server-and-mediawiki-part-two-a-list-of-columns-1.webp)

### The script

The script can be found in full as a gist on github: <https://gist.github.com/3035964>.

### Coming up

Next, I'll be showing creating a list of inbound references to the table.
