---
title: "Spatial References in SQL Server 2008"
slug: spatial-references-in-sql-server-2008
publishDate: 05 Feb 2008
description: "In SQL Server 2008, each piece of spatial data must be tagged with an SRID (Spatial Reference Identifier). Geometry types can have a SRID of 0 (which means..."
tags:
  - { name: "Spatial", slug: spatial }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
In SQL Server 2008, each piece of spatial data must be tagged with an SRID (Spatial Reference Identifier). Geometry types can have a SRID of 0 (which means undefined) but geographies must have a defined SRID. By default geography types use an SRID of 4326 which equates to WGS84. Spatial operations can only occur between spatial types with the same SRID. The result of spatial operations between two pieces of data with different SRIDs is null.

The geography needs an SRID applied to it because, in order to perform calculations, it needs to know the details of the ellipsoid in use. That information is not required to perform calculations on a geometry type.

Although SRIDs are not required on geometry objects it may be useful to apply them if data using different projections is to coexist in the same database. It will provide the safety net of returning null if spatial operations are attempted between two geometries in different projections.

It is possible to find out the available SRIDs in the database by querying the system view sys.spatial_reference_systems. The view will detail the SRID (spatial_reference_id) and its attributes.

Currently, all SRIDs in the system are defined by the European Petroleum Survey Group, hence the value of the Authority (authority_name) column is “EPSG”. The WKT (well_known_text) describes the datum, ellipsoid and units of the geographic coordinate system. The Units (unit_of_measure) column describes in English the units of the projected coordinate system. Finally, the Factor (unit_conversion_factor) is the conversion factor between the units in the projected coordinate system to SI units.

For example:

|  |  |  |  |  |
|----|----|----|----|----|
| **SRID** | **Authority** | **WKT** | **Units** | **Factor** |
| 4157 | EPSG | `GEOGCS["Mount Dillon", DATUM["Mount Dillon", ELLIPSOID["Clarke 1858", 6378293.64520876, 294.260676369261]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]` | Clarke's Foot | 0.304797265 |
| 4243 | EPSG | `GEOGCS["Kalianpur 1880", DATUM["Kalianpur 1880", ELLIPSOID["Everest (1830 Definition)", 6377299.36559538, 300.8017]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]` | Indian Foot | 0.304799518 |
| 4268 | EPSG | `GEOGCS["NAD27 Michigan", DATUM["NAD Michigan", ELLIPSOID["Clarke 1866 Michigan", 6378450.0475489, 294.978697164674]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]` | US Survey Foot | 0.30480061 |
| 4277 | EPSG | `GEOGCS["OSGB 1936", DATUM["OSGB 1936", ELLIPSOID["Airy 1830", 6377563.396, 299.3249646]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]` | metre | 1 |
| 4293 | EPSG | `GEOGCS["Schwarzeck", DATUM["Schwarzeck", ELLIPSOID["Bessel Namibia (GLM)", 6377483.86528042, 299.1528128]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]` | German legal metre | 1.000013597 |
| 4326 | EPSG | `GEOGCS["WGS 84", DATUM["World Geodetic System 1984", ELLIPSOID["WGS 84", 6378137, 298.257223563]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]` | metre | 1 |
| 4748 | EPSG | `GEOGCS["Vanua Levu 1915", DATUM["Vanua Levu 1915", ELLIPSOID["Clarke 1880 (international foot)", 6378306.3696, 293.46630765563]], PRIMEM["Greenwich", 0], UNIT["Degree", 0.0174532925199433]]` | foot | 0.3048 |


For more [information about WKT](http://en.wikipedia.org/wiki/Well-known_text#Spatial_Reference_Systems), Wikipedia has a good overview and acts as a jumping off point to more information.

And, for general information about map projections, the USGS has an excellent publication, [Map Projections - A Working Manual](https://pubs.usgs.gov/pp/1395/report.pdf) (PDF)

### 🔄 Follow up notes - 16th August 2026

What is a **German Legal Metre**?

Up until the 1960s the definition of a metre was a physical object. It was the distance between two marks on a specific bar made of a platinum-iridium bar at 0℃. This bar was (and still is) kept in a vault jus outside Paris. Since it would be difficult to constantly bring things to Paris to get them measured, 30 identical (almost) bars were created so each country had a legal copy. But, since creating 30 identical bars was impossible, the bars the Germans got (bar number 18 to Berlin in Prussia, and bar number 7 to Munich in Bavaria) were slightly larger than the one in Paris by a hair's width. Since these bars were the standard and the one German law points to when it says "one metre", that's where a German Legal Metre comes from.

The official 1889 declaration admitted that the bars were slightly off and all lie within 0.01mm of each other.

By the 1960s, when a metre was redefined as a count of Krypton-86 light wavelengths, and then in the 1980s redefined as the distance light travels in 1/299,792,485ths of a second. So a metre is now tied to a universal physical constant instead of a metal bar in a vault.