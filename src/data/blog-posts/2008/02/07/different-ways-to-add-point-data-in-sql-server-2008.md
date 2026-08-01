---
title: "Different ways to add point data in SQL Server 2008"
slug: different-ways-to-add-point-data-in-sql-server-2008
publishDate: 07 Feb 2008
description: "The spatial data can be added to a table by specifying the column type of geometry or geography. The exact detail of what is in the column can be varied as a..."
tags:
  - { name: "Spatial", slug: spatial }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

&nbsp;

The spatial data can be added to a table by specifying the column type of geometry or geography. The exact detail of what is in the column can be varied as a spatial column can represent a point, line string, and polygon and so on. For example, to create a table that represents the venues of developer events that I’ve been to might look like this:
<pre>CREATE TABLE Venue
(
    Id INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(256),
    Location geography
)</pre>
There are a number of different ways to insert data. Points, have the most varied set of options.

First of all there is the standard STGeomFromText:
<pre>INSERT INTO Venue
VALUES(
    'HBOS',
    geography::STGeomFromText(
        'POINT(55.9271035250276 -3.29431266523898)',4326));</pre>
The function takes two parameters; the first is the Well Known Text (WKT) representation of the geometry, in this case a point, and the second is the SRID. The example above shows the location of the <a href="http://www.sqlserverfaq.com/" target="_blank">SQL Server UG</a> events held in one of the conference rooms at HBOS’s offices in Sighthill, Edinburgh.

Next is the extended method Parse. I should mention that there are two types of methods with regards to standards. There are a group of methods that comply with the OGC standards (these are all prefixed with ST). Then there are “extended methods”. These are not standards compliant and have added, I’m guessing, in order to improve the capabilities to some extent over the standards.

An example of the Parse method:
<pre>INSERT INTO Venue
VALUES(
    'Glasgow Caledonian University',
    geography::Parse(
        'POINT(55.8659449685365 -4.25072511658072)'));</pre>
The function takes only one parameter, which is the WKT. There is no SRID, but it is set to 4326 (WGS84). The example above shows the location of the <a href="http://www.scottishdevelopers.com/" target="_blank">Scottish Developers</a> events held in the Continuing Professional Development Centre in Glasgow Caledonian University.

The next method is to use Well Known Binary (WKB). I won’t, however, be detailing the format of the binary. At present I would simply like to demonstrate that it can be done.

An example of WKB:
<pre>INSERT INTO Venue
VALUES(
    'Dundee University',
    geography::STGeomFromWKB(0x01010000000700ECFAD03A4C4001008000B5DF07C0, 4326));</pre>
The function, like its WKT counterpart, takes two parameters. The first is the binary representation of the spatial data, while the second is the SRID. The example above is the location of the North East Scotland .NET User Group who meet at Dundee University.

Next is another extended method, Point. For example:
<pre>INSERT INTO Venue
VALUES(
    'Microsoft Campus, TVP',
    geography::Point(51.4618933852762, -0.926690306514502, 4326));</pre>
The function takes three parameters, the latitude, the longitude and the SRID. The above example is the location of the Microsoft Campus at Thames Valley Park in Reading where events like <a href="http://www.developerday.co.uk/ddd" target="_blank">DDD</a> are held.

Finally, the standard function, STPointFromText, is used. For example:
<pre>INSERT INTO Venue
VALUES(
    'Microsoft Edinburgh Office',
    geography::STPointFromText('POINT(55.9523783996701 -3.2051030639559)', 4326));</pre>
The function takes WKT as did Parse and STGeomFromText, however, it is constrained to only WKT that represent points. If the WKT represents something else the method will fail. If, say, a linestring was supplied then an error message would be generated such as “Expected POINT at position 1. The input has LINES.” The example above shows the location of Microsoft’s Edinburgh office.

The result of adding all this information will produce a table with the following data:
<table border="1" cellspacing="0" cellpadding="3">
<tbody>
<tr>
<td><strong>Id</strong></td>
<td><strong>Name</strong></td>
<td><strong>Location</strong></td>
</tr>
<tr>
<td>1</td>
<td>HBOS</td>
<td>POINT (55.9271035250276 -3.29431266523898)</td>
</tr>
<tr>
<td>2</td>
<td>Glasgow Caledonian University</td>
<td>POINT (55.8659449685365 -4.25072511658072)</td>
</tr>
<tr>
<td>3</td>
<td>Dundee University</td>
<td>POINT (56.4595025684685 -2.98423195257783)</td>
</tr>
<tr>
<td>4</td>
<td>Microsoft Campus, TVP</td>
<td>POINT (51.4618933852762 -0.926690306514502)</td>
</tr>
<tr>
<td>5</td>
<td>Microsoft Edinburgh Office</td>
<td>POINT (55.9523783996701 -3.2051030639559)</td>
</tr>
</tbody>
</table>
&nbsp;

&nbsp;
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:aadac6bb-bbbd-4347-9440-7669854f6a68" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/sql%20server%202008">sql server 2008</a>,<a rel="tag" href="http://technorati.com/tags/spatial%20data">spatial data</a>,<a rel="tag" href="http://technorati.com/tags/point">point</a>,<a rel="tag" href="http://technorati.com/tags/wkt">wkt</a>,<a rel="tag" href="http://technorati.com/tags/wkb">wkb</a>,<a rel="tag" href="http://technorati.com/tags/katmai">katmai</a></div>
<div style="text-align:-webkit-auto;"></div>
&nbsp;
