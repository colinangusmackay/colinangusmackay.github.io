---
title: "Spatial References in SQL Server 2008"
slug: spatial-references-in-sql-server-2008
publishDate: 05 Feb 2008
description: "In SQL Server 2008, each piece of spatial data must be tagged with an SRID (Spatial Reference Identifier). Geometry types can have a SRID of 0 (which means..."
tags:
  - { name: "Spatial", slug: spatial }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

In SQL Server 2008, each piece of spatial data must be tagged with an SRID (Spatial Reference Identifier). Geometry types can have a SRID of 0 (which means undefined) but geographies must have a defined SRID. By default geography types use an SRID of 4326 which equates to WGS84. Spatial operations can only occur between spatial types with the same SRID. The result of spatial operations between two pieces of data with different SRIDs is null.

The geography needs an SRID applied to it because, in order to perform calculations, it needs to know the details of the ellipsoid in use. That information is not required to perform calculations on a geometry type.

Although SRIDs are not required on geometry objects it may be useful to apply them if data using different projections is to coexist in the same database. It will provide the safety net of returning null if spatial operations are attempted between two geometries in different projections.

It is possible to find out the available SRIDs in the database by querying the system view sys.spatial_reference_systems. The view will detail the SRID (spatial_reference_id) and its attributes.

Currently, all SRIDs in the system are defined by the European Petroleum Survey Group, hence the value of the Authority (authority_name) column is “EPSG”. The WKT (well_known_text) describes the datum, ellipsoid and units of the geographic coordinate system. The Units (unit_of_measure) column describes in English the units of the projected coordinate system. Finally, the Factor (unit_conversion_factor) is the conversion factor between the units in the projected coordinate system to SI units.

For example:
<table border="0" cellspacing="0" cellpadding="5" width="100%">
<tbody>
<tr>
<td valign="top"><strong>SRID</strong></td>
<td valign="top"><strong>Authority</strong></td>
<td valign="top"><strong>WKT</strong></td>
<td valign="top"><strong>Units</strong></td>
<td valign="top"><strong>Factor</strong></td>
</tr>
<tr>
<td valign="top">4157</td>
<td valign="top">EPSG</td>
<td valign="top">GEOGCS["Mount Dillon", DATUM["Mount Dillon", ELLIPSOID["Clarke 1858", 6378293.64520876, 294.260676369261]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]</td>
<td valign="top">Clarke's Foot</td>
<td valign="top">0.304797265</td>
</tr>
<tr>
<td valign="top">4243</td>
<td valign="top">EPSG</td>
<td valign="top">GEOGCS["Kalianpur 1880", DATUM["Kalianpur 1880", ELLIPSOID["Everest (1830 Definition)", 6377299.36559538, 300.8017]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]</td>
<td valign="top">Indian Foot</td>
<td valign="top">0.304799518</td>
</tr>
<tr>
<td valign="top">4268</td>
<td valign="top">EPSG</td>
<td valign="top">GEOGCS["NAD27 Michigan", DATUM["NAD Michigan", ELLIPSOID["Clarke 1866 Michigan", 6378450.0475489, 294.978697164674]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]</td>
<td valign="top">US Survey Foot</td>
<td valign="top">0.30480061</td>
</tr>
<tr>
<td valign="top">4277</td>
<td valign="top">EPSG</td>
<td valign="top">GEOGCS["OSGB 1936", DATUM["OSGB 1936", ELLIPSOID["Airy 1830", 6377563.396, 299.3249646]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]</td>
<td valign="top">metre</td>
<td valign="top">1</td>
</tr>
<tr>
<td valign="top">4293</td>
<td valign="top">EPSG</td>
<td valign="top">GEOGCS["Schwarzeck", DATUM["Schwarzeck", ELLIPSOID["Bessel Namibia (GLM)", 6377483.86528042, 299.1528128]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]</td>
<td valign="top">German legal metre</td>
<td valign="top">1.000013597</td>
</tr>
<tr>
<td valign="top">4326</td>
<td valign="top">EPSG</td>
<td valign="top">GEOGCS["WGS 84", DATUM["World Geodetic System 1984", ELLIPSOID["WGS 84", 6378137, 298.257223563]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]</td>
<td valign="top">metre</td>
<td valign="top">1</td>
</tr>
<tr>
<td valign="top">4748</td>
<td valign="top">EPSG</td>
<td valign="top">GEOGCS["Vanua Levu 1915", DATUM["Vanua Levu 1915", ELLIPSOID["Clarke 1880 (international foot)", 6378306.3696, 293.46630765563]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]</td>
<td valign="top">foot</td>
<td valign="top">0.3048</td>
</tr>
</tbody>
</table>
&nbsp;

For more <a href="http://en.wikipedia.org/wiki/Well-known_text#Spatial_Reference_Systems" target="_blank">information about WKT</a>, Wikipedia has a good overview and acts as a jumping off point to more information.

&nbsp;
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:bc56a631-bd22-4586-bb0f-aa91605114f3" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/sql%20server%202008">sql server 2008</a>,<a rel="tag" href="http://technorati.com/tags/katmai">katmai</a>,<a rel="tag" href="http://technorati.com/tags/spatial%20reference">spatial reference</a>,<a rel="tag" href="http://technorati.com/tags/wkt">wkt</a>,<a rel="tag" href="http://technorati.com/tags/coordinate%20system">coordinate system</a>,<a rel="tag" href="http://technorati.com/tags/projection%20system">projection system</a>,<a rel="tag" href="http://technorati.com/tags/srid">srid</a>,<a rel="tag" href="http://technorati.com/tags/well%20known%20text">well known text</a></div>
