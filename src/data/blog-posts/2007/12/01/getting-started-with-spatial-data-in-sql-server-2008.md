---
title: "Getting started with Spatial Data in SQL Server 2008"
slug: getting-started-with-spatial-data-in-sql-server-2008
publishDate: 01 Dec 2007
description: "THIS POST REFERS TO THE NOVEMBER 2007 CTP (CTP 5) OF SQL SERVER 2008 This post is probably going to be a wee bit random. After the running around over the last..."
tags:
  - { name: "Spatial", slug: spatial }
  - { name: "SQL", slug: sql }
  - { name: "SQL Server", slug: sql-server }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

<strong>THIS POST REFERS TO THE NOVEMBER 2007 CTP (CTP 5) OF SQL SERVER 2008</strong>

This post is probably going to be a wee bit random. After the running around over the last couple of weeks with the <a href="http://msdn2.microsoft.com/en-gb/default.aspx" target="_blank">MSDN</a> event (<a href="http://msdn2.microsoft.com/en-gb/bb905504.aspx" target="_blank">Sharepoint for Developers</a>) in Edinburgh, trying to get the <a href="http://developerdayscotland.com/main/Default.aspx" target="_blank">Developer Day Scotland website</a> up, an invite to a <a href="http://www.vbug.co.uk/" target="_blank">VBUG</a> event in Reading, the Community Leaders Day at the <a href="http://www.iod.co.uk" target="_blank">IoD</a>, <a href="http://www.developerday.co.uk" target="_blank">DDD6</a> and the <a href="http://technet.microsoft.com/en-gb/default.aspx" target="_blank">TechNet</a> event of <a href="http://blogs.technet.com/andrew/" target="_blank">Andrew Fryer</a>'s <a href="http://technet.microsoft.com/en-gb/bb945096.aspx" target="_blank">8 Reasons to migrate to SQL Server 2008</a> I've finally got round to trying <a href="http://msdn2.microsoft.com/en-gb/sql/bb851668.aspx" target="_blank">CTP5 of SQL Server 2008</a>. I actually installed it in a virtual machine within hours of it becoming available for download, but it is only now I'm getting round to trying it out.

First off lets start with the way spatial data is held in SQL Server. There are two spatial types, geometry and geography. Although they sounds very close there is a fair difference between then and it is probably best not to confuse them. However, both types are very well named.

Geometry is a simple two-dimensional grid with X,Y coordinates. The British National Grid is an example of this. I would guess geometry would be most useful in systems where data comes in a specific planar/flat-earth projection, or where mapping of small areas (such as the internals of a building) are needed. Lengths and areas for geometry are easy to work out. The coordinates will have a unit of measurement attached, for instance the National Grid in the UK is in metres, so the distance between any two points can be worked out by simple Pythagorean maths and the result returned in the same unit of measurement as the coordinates.

Geography fits the spatial data on a sphere with lat/long coordinates. This is a better choice for international data or for countries where the land mass is simply too big to fit in one planar projection. However, it is important to realise that lat/long is still projected. There are various schemes for fitting a lat/long position to a place on the earth. It is important to know which is being used otherwise data from different sources may not match up. It is not so simple to calculate distances and areas on a geography type as the distance between two coordinates changes depending on where those coordinates are. For example, a line that is 5º from east to west is smaller the closer to the pole it gets with the largest distance at the equator.

According to the documentation geography also has some other limitations. No geography object may be greater in size that a hemisphere. When loading data into the database it will generate an ArgumentException if tried, and if the result of an spatial operation results in a geography greater than a single hemisphere then the result will be null.

Finally, before getting on with some code, a note on SRID (Spatial Reference Identifier). Each piece of spatial data must be tagged with an SRID. Geometry types can have a SRID of 0 (which means undefined) but geographies must have a defined SRID. By default geography types use an SRID of 4326 which equates to WGS84. Spatial operations can only occur between spatial types with the same SRID. The result of spatial operations between two pieces of data with different SRIDs is null.

With that brief introduction to geometry and geography how do you create data in the database.
<pre>CREATE TABLE Town
(
    TownId int NOT NULL,
    Name nvarchar(256),
    TownGeom geometry)</pre>
To populate the column there are a number of ways of getting the data in. Currently SQL Server supports WKT (Well Known Text), WKB (Well Known Binary) and GML (Geographic Markup Language). For other data types converters will need to be written. The following example shows WKT:
<pre>INSERT Town
VALUES(1, 'Pitcardine',
       geometry::STGeomFromText(
       'POLYGON ((0 0, 370 0, 370 160, 200 250, 0 250, 0 0))', 0));</pre>
It is also possible to use the more precise method STPolyFromText. Naturally the parser will be more strict about what WKT it accepts when using the more specialised methods. For example if the WKT for a line string is sent to the STPolyFromText method the error would look like this:
<pre>Msg 6522, Level 16, State 1, Line 2
A .NET Framework error occurred during execution of user defined routine or aggregate 'geometry':
System.FormatException: 24142: Expected POLYGON at position 1. The input has LINESTR.
System.FormatException:
   at Microsoft.SqlServer.Types.OpenGisWktReader.RecognizeToken(String token)
   at Microsoft.SqlServer.Types.OpenGisWktReader.ParsePolygonTaggedText()
   at Microsoft.SqlServer.Types.OpenGisWktReader.ReadPolygon()
   at Microsoft.SqlServer.Types.SqlGeometry.STPolyFromText(SqlChars polygonTaggedText, Int32 srid)
.</pre>
At present it doesn't seem to be possible to return the column as GML as the method isn't found. The documentation for the method doesn't work either so I suspect it is a feature that isn't ready yet.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:0f4f0c22-1299-4328-acef-e9e63e983c5a" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/sql%20server">sql server</a>,<a rel="tag" href="http://technorati.com/tags/katmai">katmai</a>,<a rel="tag" href="http://technorati.com/tags/sql%20server%202008">sql server 2008</a>,<a rel="tag" href="http://technorati.com/tags/spatial%20data">spatial data</a>,<a rel="tag" href="http://technorati.com/tags/wkt">wkt</a></div>
