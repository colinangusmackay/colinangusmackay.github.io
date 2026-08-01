---
title: "Spatial Operations in SQL Server 2008 (Katmai) - Union and Convex Hull"
slug: spatial-operations-in-sql-server-2008-katmai-union-and-convex-hull
publishDate: 15 Dec 2007
description: "CODE EXAMPLES IN THIS POST WORK WITH THE NOVEMBER 2007 CTP (CTP 5) OF SQL SERVER 2008. Say you would like to create a polygon out of a group of points. One way..."
tags:
  - { name: "Spatial", slug: spatial }
  - { name: "SQL", slug: sql }
  - { name: "SQL Server", slug: sql-server }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

<strong>CODE EXAMPLES IN THIS POST WORK WITH THE NOVEMBER 2007 CTP (CTP 5) OF SQL SERVER 2008.</strong>

Say you would like to create a polygon out of a group of points. One way of doing this is to union the points together then create a convex hull from those points. A convex hull is a polygon that contains all the points of the geometries that it is made from. "The convex hull may be easily visualized by imagining an elastic band stretched open to encompass the given object; when released, it will assume the shape of the required convex hull." [<a href="http://en.wikipedia.org/wiki/Convex_hull" target="_blank">Wikipedia:Convex Hull</a>]

It is possible to create a convex hull from just two points, however in this case you will end up with a linestring rather than a polygon because a polygon requires a minimum of 3 points.
<pre>DECLARE @a geometry
DECLARE @b geometry

SELECT @a = geometry::STGeomFromText('POINT(0 0)',0),
       @b = geometry::STGeomFromText('POINT(10 10)', 0);

SELECT @a.STUnion(@b).STConvexHull().ToString();</pre>
Results in: LINESTRING (10 10, 0 0)

With an additional point a polygon can be created.
<pre>DECLARE @a geometry
DECLARE @b geometry
DECLARE @c geometry

SELECT @a = geometry::STGeomFromText('POINT(0 0)',0),
       @b = geometry::STGeomFromText('POINT(10 10)', 0),
       @c = geometry::STGeomFromText('POINT(20 0)', 0);

SELECT @a.STUnion(@b).STUnion(@c).STConvexHull().ToString();</pre>
Results in: POLYGON ((20 0, 10 10, 0 0, 20 0))

What you'll notice is that the polygon has 4 points, but we only gave 3 to start with. That is because the first and last point in the polygon are the same.

If you were to look at the geometry that had been created with just the union operations before the convex hull was made then you'll see it is a MultiPoint: MULTIPOINT ((10 10), (20 0), (0 0))

<a title="graph1 by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/2112836837/"><img style="margin:0 0 5px 10px;" src="http://farm3.static.flickr.com/2131/2112836837_979ac13673_o.png" alt="graph1" width="369" height="264" align="right" /></a>Unioning different types of geometry together, such as a point, linestring and polygon (see figure on the right) will, if the geometries don't overlap, result in a GeometryCollection. For instance the code:
<pre>DECLARE @a geometry
DECLARE @b geometry
DECLARE @c geometry

SELECT @a = geometry::STGeomFromText(
            'POLYGON ((25 5, 15 15, 5 5, 25 5))',0),
       @b = geometry::STGeomFromText(
            'POINT(5 10)', 0),
       @c = geometry::STGeomFromText(
            'LINESTRING(20 20, 30 5)', 0);

SELECT  @a.STUnion(@b).STUnion(@c).ToString();</pre>
&nbsp;

Will result in the following: GEOMETRYCOLLECTION (POINT (5 10), LINESTRING (20 20, 30 5), POLYGON ((5 5, 25 5, 15 15, 5 5)))

Moving the point to a position within the polygon, such as POINT(15 10) will result in a geometry collection that does not contain a separate point. As the point is within the boundary of the polygon it does not need to be separately listed in the geometry collection. The actual geometry looks like this: GEOMETRYCOLLECTION (LINESTRING (20 20, 30 5), POLYGON ((5 5, 25 5, 15 15, 5 5)))

<a title="graph2 by Colin  Angus Mackay, on Flickr" href="http://www.flickr.com/photos/colinangusmackay/2112866321/"><img style="margin:0 10px 95px 0;" src="http://farm3.static.flickr.com/2417/2112866321_82ae9ebf55_o.png" alt="graph2" width="331" height="179" align="left" /></a>Moving the linestring to travel from 5,10 to 30,10 (through the polygon) results in a geometry collection with two linestrings (see figure on the left). One that runs from 5,10 to the boundary of the polygon at 10,10 and the second that runs from the  boundary of the polygon at 20,10 to the original end point at 30,10. The resulting MultiGeometry looks like this: GEOMETRYCOLLECTION (LINESTRING (30 10, 20 10), LINESTRING (10 10, 5 10), POLYGON ((5 5, 25 5, 20 10, 15 15, 10 10, 5 5)))
<pre>DECLARE @a geometry
DECLARE @b geometry
DECLARE @c geometry

SELECT @a = geometry::STGeomFromText(
            'POLYGON ((25 5, 15 15, 5 5, 25 5))',0),
       @b = geometry::STGeomFromText(
            'POINT(15 10)', 0),
       @c = geometry::STGeomFromText(
            'LINESTRING(5 10, 30 10)', 0);

SELECT @a.STUnion(@b).STUnion(@c).ToString();</pre>
Other posts in this series:
<ul>
	<li><a title="Getting Started with Spatial Data in SQL Server 2008" href="http://blog.colinmackay.net/archive/2007/12/01/1261.aspx">Getting Started with Spatial Data in SQL Server 2008</a></li>
	<li><a href="http://blog.colinmackay.net/archive/2007/12/02/1275.aspx">Spatial Data in a .NET application</a></li>
	<li><a href="http://blog.colinmackay.net/archive/2007/12/06/1314.aspx">Inserting geometry through a .NET Application</a></li>
</ul>
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:5df25f0d-ccd9-4e31-9c73-54a019d1d30f" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/SQL%20Server%202008">SQL Server 2008</a>,<a rel="tag" href="http://technorati.com/tags/Katmai">Katmai</a>,<a rel="tag" href="http://technorati.com/tags/Spatial%20data">Spatial data</a>,<a rel="tag" href="http://technorati.com/tags/STUnion">STUnion</a>,<a rel="tag" href="http://technorati.com/tags/STConvexHull">STConvexHull</a>,<a rel="tag" href="http://technorati.com/tags/geometry">geometry</a>,<a rel="tag" href="http://technorati.com/tags/geography">geography</a></div>
