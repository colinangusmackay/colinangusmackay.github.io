---
title: "Moving Databases"
slug: moving-databases
publishDate: 21 Jun 2007
description: "If you ever move a database from one SQL Server to another you may come across the situation where the logins no longer map to the users in your database (and..."
tags:
  - { name: "authentication", slug: authentication }
  - { name: "authorisation", slug: authorisation }
  - { name: "security", slug: security }
  - { name: "SQL Server", slug: sql-server }
---
<!-- TODO: convert this post's content to Markdown -->

If you ever move a database from one SQL Server to another you may come across the situation where the logins no longer map to the users in your database (and that's assuming that the SQL Server you've moved the database to has the same logins).

If the new SQL Server does have the same logins then you can fix the mapping by using <a href="http://msdn.microsoft.com/library/default.asp?url=/library/en-us/tsqlref/ts_sp_ca-cz_8qzy.asp">sp_change_users_login</a>. The neat thing is that if the user and login names already match then there is an "Auto Fix" setting. And if you just don't know what is mismatched there is a "Report" option too.

NOTE: This was rescued from the Google Cache. The original was dated Saturday 1st July, 2006.

Tags: <a rel="tag" href="http://technorati.com/tag/database"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=database" alt=" " />database</a> <a rel="tag" href="http://technorati.com/tag/sql+server"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+server" alt=" " />sql server</a> <a rel="tag" href="http://technorati.com/tag/backup"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=backup" alt=" " />backup</a> <a rel="tag" href="http://technorati.com/tag/restore"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=restore" alt=" " />restore</a> <a rel="tag" href="http://technorati.com/tag/detach"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=detach" alt=" " />detach</a> <a rel="tag" href="http://technorati.com/tag/attach"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=attach" alt=" " />attach</a> <a rel="tag" href="http://technorati.com/tag/microsoft"><img style="border:0;vertical-align:middle;margin-left:.4em;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=microsoft" alt=" " />microsoft</a>
