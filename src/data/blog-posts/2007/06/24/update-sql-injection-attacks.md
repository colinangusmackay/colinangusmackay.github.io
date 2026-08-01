---
title: "UPDATE: Sql Injection Attacks"
slug: update-sql-injection-attacks
publishDate: 24 Jun 2007
description: "As a follow up to my post on preventing SQL Injection Attacks a couple of months ago I just found this little nugget, I Made a Difference [ ^ ], and it shows..."
tags:
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
---
<!-- TODO: convert this post's content to Markdown -->

As a follow up to my post on preventing <a href="http://blog.colinmackay.net/archive/2007/06/24/77.aspx">SQL Injection Attacks</a> a couple of months ago I just found this little nugget, <a href="http://www.neward.net/ted/weblog/index.jsp?date=20030731"><em>I Made a Difference</em></a>[<a href="http://www.neward.net/ted/weblog/index.jsp?date=20030731" target="_blank">^</a>], and it shows what can be achieved if you don't secure against SQL Injection attacks - and with only 3 hours of effort. Obviously, if you have access to the source code you will be able to launch an attack much quicker.

The original link seems to have disappeared. See the <a title="Wayback Machine" href="http://www.archive.org/web/web.php" target="_blank">Wayback Machine</a> for an <a href="http://web.archive.org/web/20040202203523/http://www.neward.net/ted/weblog/index.jsp?date=20030731">archived copy</a>, or the quoted section below:
<blockquote>Two weeks ago, I taught a Guerilla .NET course for DevelopMentor in Boston. Two or three days ago, a student who listened to me rant about SQL Injection attacks during the Code Access Security module lecture sent us (myself and the other two instructors) the following. It's obviously been edited to protect the guilty:

"Hi, Ted. I want to thank you for the short primer on SQL injection attacks at the Guerrilla course in Woburn this month. We have a vendor who supplies us with electronic billing and payment services. (We send them billing data, and they present the bills to our customers and take the payments for us.) The week after the Guerrilla class I began to lose confidence in their application for various reasons, like seeing errors that included partial SQL statements, and in one case, a complete SQL statement that was accidentally left on a page from a debugging session. I told our company's business manager that I was 80% confident that I could hack into their site using SQL injection. He called the vendor, who swore up and down that after spending $83,000 on firewalls that no one could ever hack into their site, and that we should go ahead and try.

"After three hours and a Google search on SQL injection, I was running successful queries from their login page and I had their server emailing us the query results via xp_sendmail. I was also able to confirm that the SQL Server login they use for their application has sa rights. I got a list of their clients, and was able to create tables in their databases.

"The vendor promised that by the next morning everything would be fixed. So the next morning at 8:00 am I tried again. I was no longer able to get results via xp_sendmail, but I was able to shutdown their SQL Server service by sending a shutdown command. I followed that up with a friendly call to their tech support line to let them know that they needed to restart SQL Server--I didn't want to be too malicious. The guy at the other end of the line apparently had been there the entire night changing code and rolling out pages. He threatened to get on a plane, come to my office, and beat me up."

"The disturbing thing about the incident is that there is enough data in the vendor's database to allow someone to commit identity fraud or steal credit card and bank account numbers. And they are not a mom and pop shop either--their client list includes F----, D----, D----, and V----. <em>[These are names that you would recognize, dear reader.]</em> If I had been malicious I could have stolen data from any of those companies."

Hunh. Three hours and a Google search was all it took. Anybody still think firewalls are the answer? <em>"Security is a process, not a product."</em> -- Bruce Schneier, <em>Secrets and Lies</em>.</blockquote>

<em>NOTE: This was rescued from the Google Cache. The original date was Wednesday 17th November, 2004.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/sql"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql" alt=" " />sql</a> <a rel="tag" href="http://technorati.com/tag/sql+injection"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+injection" alt=" " />sql injection</a> <a rel="tag" href="http://technorati.com/tag/sql+injection+attack"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql+injection+attack" alt=" " />sql injection attack</a>
