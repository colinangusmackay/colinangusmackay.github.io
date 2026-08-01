---
title: "Normalising the data model"
slug: normalising-the-data-model
publishDate: 23 Jun 2007
description: "Sometimes I see on forums someone who is trying to get some SQL statement to wield data in a particular way but the data model is just thwarting their..."
tags:
  - { name: "data design", slug: data-design }
  - { name: "Database", slug: database }
  - { name: "SQL", slug: sql }
---
<!-- TODO: convert this post's content to Markdown -->

Sometimes I see on forums someone who is trying to get some SQL statement to wield data in a particular way but the data model is just thwarting their attempts, or if they do get something to work the SQL statement that does the job is horrendously complex. This tends to happen because the data is not normalised (or "normalized" if you are using the American spelling) to the third normal form. Denormalised data models tend to happen for two reasons. Firstly, because the modeller is inexperienced and does not realise the faux pas they have made in the model, and, secondly, because the modeller has found the a properly normalised data model just doesn't have the performance needed to do the job required.
<h3>The Scenario</h3>
In the example scenario that I am going to present an private education company is looking to build a system that helps track their tutors and students. So as not to be overwhelming I am only going to concentrate on one aspect of the system - the tutor. A tutor may be multilingual and can teach in a variety of languages and they may also be able to teach a number of subjects. The Tutor table has joins to a table for languages and a table for the subjects. The model looks like this:

<a title="Photo Sharing" href="http://www.flickr.com/photos/colinangusmackay/605442080/"><img src="http://farm2.static.flickr.com/1083/605442080_746890c3a4_o.gif" border="0" alt="The denormalised data model" width="500" height="432" /></a>
<small>Partially denormalised data model</small>

As you can see there are 3 joins from Tutors to Languages and 4 joins from Subjects to Tutors. This makes joins between these tables particularly complex. For example, to find out the languages that a tutor speaks then a query like this would have to be formed.
<pre>SELECT  l1.Name AS LanguageName1,
        l2.Name as LanguageName2,
        l3.Name as LanguageName3
FROM Tutors AS t
LEFT OUTER JOIN Languages AS l1 ON l1.LanguageID = t.Language1
LEFT OUTER JOIN Languages AS l2 ON l2.LanguageID = t.Language2
LEFT OUTER JOIN Languages AS l3 ON l3.LanguageID = t.Language3
WHERE t.TutorID = @TutorID</pre>
So, what happens if the tutor is fluent in more than three languages? Either the system cannot accept the fourth language it will have to be changed to accommodate it. If the latter option is chosen imagine the amount of work needed to make that change.

A similar situation occurs with the join to the Subjects table.
<h3>Solution</h3>
A better way to handle this sort of situation is with a many-to-many join. Many database systems cannot directly create a many-to-many join between two tables and must create an intermediate table. For those database systems that appear to be able to model a many-to-many join directly (GE-Smallworld comes to mind) what is actually happening is that an intermediate table is being created in the background that isn't normally visible and the database takes care of this automatically.

The resulting data model will look like this

<a title="Photo Sharing" href="http://www.flickr.com/photos/colinangusmackay/605442104/"><img src="http://farm2.static.flickr.com/1311/605442104_7bc4a36664_o.gif" border="0" alt="The normalised data model" width="500" height="309" /></a>
<small>Normalised data model</small>

This allows a tutor to be able to register any number of languages or subjects. It also means that any joins on the data are easier as there are no duplicate joins for each Language or Subject. The above SELECT statement can be rewritten as:
<pre>SELECT  l.Name AS LanguageName
FROM Tutors AS t
INNER JOIN TutorLanguage as tl ON tl.TutorID = t.TutorID
INNER JOIN Languages as l ON tl.LanguageID = l.LanguageID
WHERE t.TutorID = @TutorID</pre>
This will result in one row being returned for each language rather than all the languages being returned into one row. It is possible to pivot the results back to one row, but currently in SQL Server 2000 that would add more complexity to the query than I am willing to discuss in this article. If you want to know how to pivot results in SQL Server 2000 then see the page on <a href="http://msdn.microsoft.com/library/default.asp?url=/library/en-us/acdata/ac_8_qd_14_04j7.asp">Cross-Tab Reports</a> in the SQL Server books-online. SQL Server 2005 will allow PIVOTed results directly. For more information between the SQL Server 2000 and 2005 way of doing things see: <a href="http://www.windowsitpro.com/Article/ArticleID/42901/42901.html">Pivot (or Unpivot) Your Data - Windows IT Pro</a>
<h3>Migrating existing data</h3>
Naturally, if you have existing data using the denormalised schema and you want to migrate it to the normalised schema then you will need to be careful about the order in which changes are made lest you lose your data.
<ol>
	<li>Create the intermediate table.</li>
	<li>Change any stored procedures using the denormalised schema to the normalised schema.
<ul>
	<li>You may also need to change code outside the database. If you find yourself needing to do this then I strongly recommend that you read about <a href="http://blogs.wdevs.com/colinangusmackay/archive/2004/10/01/716.aspx">the benefits of stored procedures</a>.</li>
</ul>
</li>
	<li>Perform an insert for each of the denormalised joins into the intermediate table</li>
	<li>Remove the old joins.</li>
</ol>
If possible the above should be scripted so that the database changes occur as quickly as possible as, depending on your situation, you may have to take your production system off-line while making the change. Testing the changes in a development environment first should ensure that the scripts are written well and don't fall over when being run on the production database.

To move the denormalised Language joins to the normalised schema some SQL like this can be used.
<pre>INSERT INTO TutorLanguage
    SELECT TutorID, Language1 AS LanguageID
    FROM Tutors
    WHERE Language1 IS NOT NULL
UNION
    SELECT TutorID, Language2 AS LanguageID
    FROM Tutors
    WHERE Language2 IS NOT NULL
UNION
    SELECT TutorID, Language3 AS LanguageID
    FROM Tutors
    WHERE Language3 IS NOT NULL</pre>
It can, of course, be written as a series of individual INSERT INTO...SELECT statements rather that a large UNIONed SELECT

<em>NOTE: This was rescued from the <a title="Google" href="http://www.google.co.uk" target="_blank">Google</a> Cache. The original date was Sunday 3rd April 2005.</em>

Tags: <a rel="tag" href="http://technorati.com/tag/database"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=database" alt=" " />database</a> <a rel="tag" href="http://technorati.com/tag/data+model"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=data+model" alt=" " />data model</a> <a rel="tag" href="http://technorati.com/tag/normalisation"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=normalisation" alt=" " />normalisation</a> <a rel="tag" href="http://technorati.com/tag/normalization"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=normalization" alt=" " />normalization</a> <a rel="tag" href="http://technorati.com/tag/denormalised"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=denormalised" alt=" " />denormalised</a> <a rel="tag" href="http://technorati.com/tag/denormalized"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=denormalized" alt=" " />denormalized</a> <a rel="tag" href="http://technorati.com/tag/normalised"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=normalised" alt=" " />normalised</a> <a rel="tag" href="http://technorati.com/tag/normalized"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=normalized" alt=" " />normalized</a> <a rel="tag" href="http://technorati.com/tag/join"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=join" alt=" " />join</a> <a rel="tag" href="http://technorati.com/tag/sql"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=sql" alt=" " />sql</a> <a rel="tag" href="http://technorati.com/tag/er+diagram"><img style="margin-left:.4em;vertical-align:middle;border-width:0;" src="http://static.technorati.com/static/img/pub/icon-utag-16x13.png?tag=er+diagram" alt=" " />er diagram</a>
