---
title: "Different ways to add point data in SQL Server 2008"
slug: different-ways-to-add-point-data-in-sql-server-2008
publishDate: 07 Feb 2008
description: "The spatial data can be added to a table by specifying the column type of geometry or geography. The exact detail of what is in the column can be varied as a..."
tags:
  - { name: "Spatial", slug: spatial }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- ISSUE: link (http://www.sqlserverfaq.com/): Network is unreachable (www.sqlserverfaq.com:80) -->
<!-- ISSUE: link (http://www.developerday.co.uk/ddd): nodename nor servname provided, or not known (www.developerday.co.uk:80) -->

The spatial data can be added to a table by specifying the column type of geometry or geography. The exact detail of what is in the column can be varied as a spatial column can represent a point, line string, and polygon and so on. For example, to create a table that represents the venues of developer events that I’ve been to might look like this:

```sql
CREATE TABLE Venue
(
    Id INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(256),
    Location geography
)
```

There are a number of different ways to insert data. Points, have the most varied set of options.
First of all there is the standard `STGeomFromText`:

```sql
INSERT INTO Venue
VALUES(
    'HBOS',
    geography::STGeomFromText(
        'POINT(55.9271035250276 -3.29431266523898)',4326));
```

The function takes two parameters; the first is the Well Known Text (WKT) representation of the geometry, in this case a point, and the second is the SRID. The example above shows the location of the **SQL Server User Group** events held in one of the conference rooms at HBOS’s offices in Sighthill, Edinburgh.

Next is the extended method `Parse`. I should mention that there are two types of methods with regards to standards. There are a group of methods that comply with the OGC standards (these are all prefixed with ST). Then there are “extended methods”. These are not standards compliant and have added, I’m guessing, in order to improve the capabilities to some extent over the standards.

An example of the Parse method:

```sql
INSERT INTO Venue
VALUES(
    'Glasgow Caledonian University',
    geography::Parse(
        'POINT(55.8659449685365 -4.25072511658072)'));
```

The function takes only one parameter, which is the WKT. There is no SRID, but it is set to 4326 (WGS84). The example above shows the location of the **Scottish Developers** events held in the Continuing Professional Development Centre in Glasgow Caledonian University.

The next method is to use Well Known Binary (WKB). I won’t, however, be detailing the format of the binary. At present I would simply like to demonstrate that it can be done.

An example of WKB:

```sql
INSERT INTO Venue
VALUES(
    'Dundee University',
    geography::STGeomFromWKB(0x01010000000700ECFAD03A4C4001008000B5DF07C0, 4326));
```

The function, like its WKT counterpart, takes two parameters. The first is the binary representation of the spatial data, while the second is the SRID. The example above is the location of the **North East Scotland .NET User Group** who meet at Dundee University.

Next is another extended method, Point. For example:

```sql
INSERT INTO Venue
VALUES(
    'Microsoft Campus, TVP',
    geography::Point(51.4618933852762, -0.926690306514502, 4326));
```

The function takes three parameters, the latitude, the longitude and the SRID. The above example is the location of the Microsoft Campus at Thames Valley Park in Reading where events like **DDD** are held.

Finally, the standard function, STPointFromText, is used. For example:

```sql
INSERT INTO Venue
VALUES(
    'Microsoft Edinburgh Office',
    geography::STPointFromText('POINT(55.9523783996701 -3.2051030639559)', 4326));
```

The function takes WKT as did `Parse` and `STGeomFromText`, however, it is constrained to only WKT that represent points. If the WKT represents something else the method will fail. If, say, a linestring was supplied then an error message would be generated such as “Expected POINT at position 1. The input has LINES.” The example above shows the location of Microsoft’s Edinburgh office.

The result of adding all this information will produce a table with the following data:

|  |  |  |
|----|----|----|
| **Id** | **Name** | **Location** |
| 1 | HBOS | POINT (55.9271035250276 -3.29431266523898) |
| 2 | Glasgow Caledonian University | POINT (55.8659449685365 -4.25072511658072) |
| 3 | Dundee University | POINT (56.4595025684685 -2.98423195257783) |
| 4 | Microsoft Campus, TVP | POINT (51.4618933852762 -0.926690306514502) |
| 5 | Microsoft Edinburgh Office | POINT (55.9523783996701 -3.2051030639559) |
