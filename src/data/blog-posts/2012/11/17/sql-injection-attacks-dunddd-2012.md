---
title: "SQL Injection Attacks - DunDDD 2012"
slug: sql-injection-attacks-dunddd-2012
publishDate: 17 Nov 2012
description: "Examples The examples were run against a copy of the Adventure Works database. Basic Demo (ASP.NET MVC / C# / Visual Studio 2010) Second Order Demo (WinForms /..."
tags:
  - { name: "DDD", slug: ddd }
  - { name: "DDD Scotland", slug: ddd-scotland }
  - { name: "DunDDD", slug: dunddd }
  - { name: "presentation", slug: presentation }
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
---
<!-- TODO: convert this post's content to Markdown -->

<img style="display:block;float:none;margin-left:auto;margin-right:auto" src="http://static.colinmackay.co.uk/presentations/dunddd/2012/2012-11-17-DunDDD-Cover-500.png">
<h3>Examples</h3>
The examples were run against a copy of the Adventure Works database.
<ul>
 	<li><a href="http://s3-eu-west-1.amazonaws.com/colinmackay.co.uk/presentations/sql-server-ug/2011/2011-06-29-basic-attack.zip">Basic Demo</a> (ASP.NET MVC / C# / Visual Studio 2010)</li>
 	<li><a href="http://s3-eu-west-1.amazonaws.com/colinmackay.co.uk/presentations/sql-server-ug/2011/2011-06-29-second-order-attack.zip">Second Order Demo</a> (WinForms / C’# / Visual Studio 2010)</li>
</ul>
<h3>Required Tables</h3>
For the Second Order Demo you need the following table added to the Adventure Works database:
<pre>CREATE TABLE [dbo].[FavouriteSearch](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](128) NOT NULL,
	[searchTerm] [nvarchar](1024) NOT NULL
) ON [PRIMARY]

GO</pre>
<h3>Slide Deck</h3>
The <a title="SQL Injection Attacks @ DunDDD 2012" href="http://static.colinmackay.co.uk/presentations/dunddd/2012/2012-11-17-SQL-Injection-Attacks-DunDDD2012.pdf" target="_blank">slide deck is available for download</a> in PDF format.
<h3>Further Reading</h3>
<img style="display:inline;float:right" align="right" src="http://static.colinmackay.co.uk/presentations/dunddd/2012/2012-11-17-ErrorMessages-320.png">During the talk I mentioned a <a href="http://colinmackay.co.uk/2007/06/24/update-sql-injection-attacks/">lesson from history on why firewalls are not enough</a>.

I also showed XKCD’s famous <a href="http://xkcd.com/327/">“Bobby Tables”</a> cartoon, and also a link to further information on <a href="http://colinmackay.co.uk/2009/09/21/if-you-really-must-do-dynamic-sql/">dynamic SQL in Stored Procedures</a>.

More information about the badly displayed error messages can be found amongst two blog posts: <a href="http://colinmackay.co.uk/2009/05/16/what-not-to-develop/">What not to develop</a>, and a <a href="http://colinmackay.co.uk/2009/08/22/follow-up-on-what-not-to-develop/">follow up some months later</a>.

I wrote a fuller article on SQL Injection Attacks that you can <a title="SQL Injection Attacks and some tips on how to prevent them" href="http://colinmackay.co.uk/2005/04/23/sql-injection-attacks-and-some-tips-on-how-to-prevent-them/">read here</a> although it is a few years old now, it is still relevant given that SQL Injection Attacks remain at the top of the OWASP list of vulnerabilities.
