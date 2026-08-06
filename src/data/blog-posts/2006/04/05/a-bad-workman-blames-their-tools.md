---
title: "A Bad Workman Blames Their Tools"
slug: a-bad-workman-blames-their-tools
publishDate: 5 Apr 2006
description: "I wish that some people, when asking questions on a forum, would look inwards for a moment and reflect whether they really understand before making unfounded bold statments...'"
tags:
  - { name: "forums", slug: forums }
---

I wish that some people, when asking questions on a forum, would look inwards for a moment and reflect whether they really understand what they are talking about before making unfounded bold statments such as:

> .NET is only one problem after another problem 🤬 🤬 🤬

One such poster on Code Project made a statement like that, then provided his code that was talking 2 minutes to run and that was unacceptable. He was blaming Microsoft and the .NET Framework but from one look at his code it was obvious where the problem was - and it wasn't with Microsoft or the .NET Framework.

He wanted to update a column on a table. In fact he wanted to update that column on every row in the table. So, he pulled across 100,000 rows in to his .NET application then proceeds to loop over each returned row performing an UPDATE statement. So, in total he sent 100,001 commands to SQL Server. His complaint was magnified because he was expecting to have situations where 1,000,000 rows would need to be updated and that would take much longer. (20 minutes by the method he was employing)

Was the .NET application doing anything fancy as part of the update? No, it was simply copying the value from one column to another.

All his .NET code could be reduced to sending just one single piece of SQL to the database to do all the work. A simple UPDATE statement would do everything and take less than a second to execute - most likely even for a million rows.

But, did the poster seem to accept that perhaps it was his code or his misunderstanding of how the database could be leveraged that was at fault. No! He was insistant, with lots of angry faces, that it was Microsoft's fault for not getting the .NET framework right.