---
title: "DALs and the DAAB"
slug: dals-and-the-daab
publishDate: 03 Nov 2007
description: "I've been pondering something that was raised in passing earlier this week and that is the relationship between a DAL (Data Abstraction Layer) and the DAAB (..."
tags:
  - { name: "Database", slug: database }
  - { name: "design patterns", slug: design-patterns }
---

I've been pondering something that was raised in passing earlier this week and that is the relationship between a DAL (Data Abstraction Layer) and the DAAB (<a href="http://msdn2.microsoft.com/en-us/library/aa480458.aspx" target="_blank">Data Access Application Block</a>).

It was briefly mentioned in a conversation that I had that the DAAB provides the functionality of a DAL because the developer doesn't need to worry about the back end database that is being used. I suppose to some extent that is true. However, I don't believe that it fully functions as a DAL.

To my mind a DAL abstracts the access of data away from the rest of the application. Most people seem to restrict this view to data being held in a database.  But databases are not the only repository of data. Data can be held in plain text files, CSV files, XML files and many other formats. It doesn't need to arrive by file, it could be data from a service or other mechanism.

If you treat sources of data as being more than a database then the DAAB is not a suitable substitute for building a DAL.

Also the DAAB has some limitations in that it cannot translate the SQL itself. For example the flavour of SQL in Oracle has differences to the flavour of SQL in SQL Server. This means that any SQL code will have to be translated. One possible solution is to ensure that everything is done through stored procedures. Then all that the DAAB needs is the stored procedure's name and the values for the parameters.

But what of passing stored procedure names and parameters to the DAAB? Wouldn't they need to be known in the business layer? Surely the business layer should know absolutely nothing about the database? Absolutely, the business layer should not be concerning itself at all with the database. It shouldn't know about stored procedure names, parameters or anything else, even if the DAAB takes care of figuring out the details under the hood from information picked up from the config file. The Business Layer should just need to know there is a DAL and a method on the DAL can be called and some results come back. How the DAL does anything is of no concern to the business layer.

A quick and dirty test, in my opinion, is to look out for any classes from the System.Data namespace in the business or presentation layer to determine if the DAL is well designed.

In my mind the DAAB is just a tool that can be used to make the creation and maintenance of a DAL easier when dealing with databases. It makes it easy to change the location of databases as the development process moves along from the developers' machines, to continuous integration, test, pre-live and finally live (or what ever your process calls for). The argument that the DAAB makes it easy to swap out one type of database for another isn't something that is actually going to be done all that often. From what I've seen, companies generally run two systems concurrently until the old one is discontinued. Rarely do they ever actually update the old system to use the new database and when they do it is usually via some form of orchestration system so the old system doesn't need to be changed in any great way. If it isn't broke don't fix it.