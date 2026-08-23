---
title: "Creating a data dictionary with SQL Server and MediaWiki - Part one: a list of tables"
slug: creating-a-data-dictionary-with-sql-server-and-mediawiki-part-one-a-list-of-tables
publishDate: 14 Jun 2012
description: "Background We've just installed MediaWiki as a documentation tool where I work. To get things up and running as quickly as possible, I created a few SQL..."
tags:
  - { name: "data dictionary", slug: data-dictionary }
  - { name: "documentation", slug: documentation }
  - { name: "MediaWiki", slug: mediawiki }
  - { name: "SQL", slug: sql }
---
### Background

We've just installed MediaWiki as a documentation tool where I work. To get things up and running as quickly as possible, I created a few SQL Scripts to pull out schema information from the SQL Server in order to create a data dictionary. The SQL Scripts produce WikiMedia mark up that allows various things to be cross referenced in a way that makes navigating around the wiki fairly easy.

### Getting a list of tables

The first thing to do is to get a list of tables. In the code below, the first line is the only one you'll need to modify if you want to accept the output in its current format. The first line determines whether you are getting back a list of tables or a list of views.
`SET NOCOUNT ON` ensures that we don't get any messages midway through saying things like "(504 row(s) affected)"
The first print statement simple outputs the header for the table in wiki markup. We are also marking certain columns on the table as sortable. That way the user can sort the table to the way they want it rather than the way it was initially rendered.
Then we head into the cursor (as we will be looping over each to the tables in turn outputting wiki mark up for each of them).
In each loop we are outputting various details about the tables. The mark up includes links to a wiki page that will contain more detail about the specific table. Although the rendered wiki table only shows the table name, the underlying link ensures a fully qualified name is used so that you don't run into clashes between databases or schemas.
Finally, when the loop created by the cursor is complete we put in the closing markup for the wiki table.
There are a few more things going on, but I thought I'd just concentrate on the essentials and not go into a tutorial on how cursors work or anything like that

### How it renders

The script renders Wiki Markup, which the MediaWiki engine renders as a table. Using the Adventure Works database as an example, this is what the end result looks like.

![Data Dictionary showing a list of tables](/assets/blog/2012-06-14-creating-a-data-dictionary-with-sql-server-and-mediawiki-part-one-a-list-of-tables-1.webp)

### The script

The script is now located in a github gist: <https://gist.github.com/3035858>

### Coming up

In the next post, I'll be showing the script for getting the column information out for each of the individual tables (or views).

### Updates

- This article was updated by adding in the code to generate sortable tables on Friday, 15/June/2012 at 22:00
