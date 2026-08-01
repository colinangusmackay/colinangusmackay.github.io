---
title: "Protecting Tables from SQL Injection Attack"
slug: protecting-tables-from-sql-injection-attack
publishDate: 24 Jun 2007
description: "A recent question in a forum that I view asked about how to ensure that even if one layer of security was compromised that the table would only ever return one..."
tags:
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
---
<!-- TODO: convert this post's content to Markdown -->

A <a href="http://www.codeproject.com/script/comments/forums.asp?msg=1005871&amp;forumid=1725#xx1005871xx">recent question in a forum </a>that I view asked about how to ensure that even if one layer of security was compromised that the table would only ever return one row at a time so that an attacker would have to do more work to get a list of the users and passwords out of the database.

The way I see it, the best solution is not just to set up constraints, assuming that your database can add a constraint to only ever return the first row in a query, but to protect the table by not granting access to it directly. Then set up stored procedures to perform all the operations that you permit on the table. That way, if an attacker should get through the "outer defences" they cannot access the tables directly, and must use the stored procedures.

For example, say you have a database that has the user details for a website, this includes the user name and password. You don't want an attacker to get a list of passwords or even one password. So you design the stored procedures so that you can pass a password in, but it will never put a password in a result set. The stored procedures for registering and authenticating a user for the website might be:
<ul>
	<li><code>RegisterUser</code></li>
	<li><code>VerifyCredentials</code></li>
	<li><code>ChangePassword</code></li>
</ul>
<code>RegisterUser</code> takes the user name and password as parameters (possibly along with other information that would be useful for your website) and returns the <code>UserID</code>

<code>VerifyCredentials</code> would be used for logging into the site by accepting the user name and the password. If there was a match the <code>UserID</code> is returned, if not then a NULL value.

<code>ChangePassword</code> would take the <code>UserID</code>, the old password and the new password. If the userID and password match the password can be changed. A value that indicates success or failure is returned.

As you can see that the password is always contained in the database and is never exposed. The stored procedure could potentially generate a salted hash of the original password too so that should some layer of the database security be compromised that the password is still not readable.

You must also be careful when you call the stored procedure and ensure that you use parameterised queries. SQL Injection attacks are also possible when calling stored procedures if they are called by building up a SQL statement dynamically and executing it.

<em>NOTE: This was rescued from the <a title="Google" href="http://www.google.co.uk" target="_blank">Google</a> cache. The original date was Thursday, 6th January, 2005.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/sql"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql" alt=" " />sql</a> <a rel="tag" href="http://technorati.com/tag/sql+injection"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+injection" alt=" " />sql injection</a> <a rel="tag" href="http://technorati.com/tag/sql+injection+attack"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+injection+attack" alt=" " />sql injection attack</a> <a rel="tag" href="http://technorati.com/tag/sql+server"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+server" alt=" " />sql server</a> <a rel="tag" href="http://technorati.com/tag/password"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=password" alt=" " />password</a> <a rel="tag" href="http://technorati.com/tag/hashed+password"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=hashed+password" alt=" " />hashed password</a> <a rel="tag" href="http://technorati.com/tag/salted+hashed+password"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=salted+hashed+password" alt=" " />salted hashed password</a>

<hr />Original comments:

Salted hash is a pretty tricky thing to do in SQL Server 2000, but should be very simple in SQL 2005 with a CLR function that wraps System.Security.Cryptography. For the moment you should probably hash the password on the client, i.e. in the web application code.

The downside, of course, to salted hashes is that you can't ever tell the user what their password was. You have to have a facility to allow them to reset their password by supplying some other information instead (the 'password reset question' technique).
<div class="postfoot">1/10/2005 12:04 AM | <a id="Comments_ascx_CommentList_ctl00_NameLink" title="PingBack/TrackBack" href="http://mikedimmick.blogspot.com/" target="_blank">Mike Dimmick</a></div>
