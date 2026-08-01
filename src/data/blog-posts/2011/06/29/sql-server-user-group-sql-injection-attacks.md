---
title: "SQL Server User Group: SQL Injection Attacks"
slug: sql-server-user-group-sql-injection-attacks
publishDate: 29 Jun 2011
description: "Examples The examples were run against a copy of the Adventure Works database. Basic Demo (ASP.NET MVC / C# / Visual Studio 2010) Second Order Demo (WinForms /..."
tags:
  - { name: "SQL Injection Attack", slug: sql-injection-attack }
---
<!-- TODO: convert this post's content to Markdown -->

<p><img style="background-image:none;padding-left:0;padding-right:0;display:block;float:none;margin-left:auto;margin-right:auto;padding-top:0;border-width:0;" border="0" src="http://static.colinmackay.co.uk/presentations/sql-server-ug/2011/2011-06-29-Presentation-Opening-Slide-640.jpg"></p> <h3></h3> <h3>Examples</h3> <p>The examples were run against a copy of the Adventure Works database.</p> <ul> <li><a href="http://s3-eu-west-1.amazonaws.com/colinmackay.co.uk/presentations/sql-server-ug/2011/2011-06-29-basic-attack.zip">Basic Demo</a> (ASP.NET MVC / C# / Visual Studio 2010)  <li><a href="http://s3-eu-west-1.amazonaws.com/colinmackay.co.uk/presentations/sql-server-ug/2011/2011-06-29-second-order-attack.zip">Second Order Demo</a> (WinForms / C'# / Visual Studio 2010)</li></ul> <h3>Required Tables</h3> <p>For the Second Order Demo you need the following table added to the Adventure Works database:</p><pre>CREATE TABLE [dbo].[FavouriteSearch](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](128) NOT NULL,
	[searchTerm] [nvarchar](1024) NOT NULL
) ON [PRIMARY]

GO
</pre>
<h3>Stored Procedure with dynamic SQL</h3>
<p>This is the stored procedure from the last demo which shows the Stored Procedure dynamically building a SQL statement that is susceptible to a SQL Injection Attack.</p><pre>CREATE procedure [dbo].[SearchProducts]
(
  @searchId int
)
AS
BEGIN

  DECLARE @searchTerm NVARCHAR(1024)
  SELECT @searchTerm = searchTerm FROM FavouriteSearch WHERE id = @searchId

  DECLARE @sql NVARCHAR(2000) =
  'SELECT ProductID, Name, ProductNumber, ListPrice
  FROM Production.Product
  WHERE DiscontinuedDate IS NULL
  AND ListPrice &gt; 0.0
  AND Name LIKE ''%'+@searchTerm+'%''';

  EXEC (@sql);

END
</pre>
<p>&nbsp;</p>
<h3>Slide Deck</h3>
<p>The <a title="SQL Injection Attacks and tips on how to prevent them (Slide Deck)" href="http://s3-eu-west-1.amazonaws.com/colinmackay.co.uk/presentations/sql-server-ug/2011/2011-06-29-SQL-Injection-Attacks-SQL-Server-UG.pdf">slide deck is available for download</a>.</p>
<h3>Further Reading</h3>
<p>During the talk I mentioned this <a href="http://colinmackay.co.uk/blog/2007/06/24/update-sql-injection-attacks/">lesson from history (why firewalls are not enough)</a>, I also showed XKCD’s famous <a href="http://xkcd.com/327/">“Bobby Tables”</a> cartoon, and also a link to further information on <a href="http://colinmackay.co.uk/blog/2009/09/21/if-you-really-must-do-dynamic-sql/">dynamic SQL in Stored Procedures</a>. More information about the badly displayed error messages can be found amongst two blog posts: <a href="http://colinmackay.co.uk/blog/2009/05/16/what-not-to-develop/">What not to develop</a>, and a <a title="How raw error messages help attackers" href="http://colinmackay.co.uk/blog/2009/08/22/follow-up-on-what-not-to-develop/">follow up some months later</a>.</p>
<p>I wrote an article on SQL Injection Attacks that you can <a title="SQL Injection Attacks and some tips on how to prevent them" href="http://colinmackay.co.uk/blog/2005/04/23/sql-injection-attacks-and-some-tips-on-how-to-prevent-them/">read here</a>.</p>
