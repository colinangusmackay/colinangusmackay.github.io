---
title: "Oh No! More on SQL Injection Attacks"
slug: oh-no-more-on-sql-injection-attacks
publishDate: 22 Jun 2007
description: "I've not written about this in a while becuase it seemed that people were getting the message. But today I was asked, on Code Project , \"I am wondering why..."
tags:
  - { name: "1990 misuse of computers act", slug: 1990-misuse-of-computers-act }
  - { name: "misuse of computers act", slug: misuse-of-computers-act }
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
  - { name: "SQL Server", slug: sql-server }
---
I've not written about this in a while becuase it seemed that people were getting the message. But today I was asked, on <a href="http://www.codeproject.com/" target="_blank" title="Code Project">Code Project</a>, "I am wondering why injecting values into the \[SQL\] string is considered a security risk?" Here is my response: Because if you inject strings into the SQL, especially ones that come straight from the user interface, then an attacker can produce malformed SQL and gain access to your system. (Where do you live? I can come and do one of my SQL Injection Attack presentations in your town if you want a real live demonstration where I compromise a SQL Server into divulging the inner most secrets of the server it is running on. And I mean the whole server, not just the SQL Server process.\*) Lets say you have a simple bit of SQL like this:

```
cmd.CommandText = "SELECT * FROM Products where Name = '"+txtSearch.Text+"'";
```

What happens if the user types in the following?

```
'; DELETE FROM Products; --
```

The whole string becomes:

```
SELECT * FROM Products where Name = ''; DELETE FROM Products; --'
```

That will return a dataset back to the application, which is what it expects, and then deletes all the products from the database. When the next customer comes to the website what is it going to show when there are no products in the database? Okay - there may be some constraints on the table (foreign key constraints) that don't permit the rows to be deleted. How about something equally damaging to the company. Let's set their entire inventory to a penny! The mallicious user then types:

```
'; UPDATE Products SET Price = 0.01; --
```

The word will quickly spread around the internet and the company will soon be out of business or have a huge number of very pissed off customers. If you don't secure your system the possibilities for attack are endless. Finally, if you want to know more, I encourage you to read my article [SQL Injection Attacks and Tips on How To Prevent Them](/2005/04/23/sql-injection-attacks-and-some-tips-on-how-to-prevent-them/ "SQL Injection Attacks and Some Tips on How to Prevent Them")

### Footnotes

\* The demonstration is done on a server box that I own. Performing a SQL Injection Attack on a system without the permission of the system owner is, in the UK, a breach of the 1990 Misue of Computers Act and can carry a penalty of 5 years in jail.

This was rescued from the Google Cache after the original blog site died. The original date was Wednesday 7th June, 2006.
