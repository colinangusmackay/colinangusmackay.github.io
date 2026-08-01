---
title: "Spatial Data in a .NET application"
slug: spatial-data-in-a-net-application
publishDate: 02 Dec 2007
description: "THIS POST REFERS TO THE NOVEMBER 2007 CTP (CTP 5) OF SQL SERVER 2008 Following from my last post about Getting Started with Spatial Data in SQL Server 2008 in..."
tags:
  - { name: "ADO.NET", slug: ado-net }
  - { name: "Spatial", slug: spatial }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

<strong>THIS POST REFERS TO THE NOVEMBER 2007 CTP (CTP 5) OF SQL SERVER 2008</strong>

Following from my last post about <a href="http://blog.colinmackay.net/archive/2007/12/01/1261.aspx" target="_blank">Getting Started with Spatial Data in SQL Server 2008</a> in the database, how about actually using it in an application? Since that is where most data will end up at some point, it must be possible to use the spatial data in an application some how.

So, using the Town table created before and populated with our fictional village of Pitcardine I wrote this very simple program to see what actually came through ADO.NET to the end application.
<pre>static void Main(string[] args)
{
    SqlConnection connection =
        new SqlConnection("Server=(local);"+
            "database=SpatialSandbox;Trusted_Connection=Yes;");
    SqlCommand command =
        new SqlCommand("SELECT * FROM Town", connection);
    connection.Open();
    using (SqlDataReader reader = command.ExecuteReader())
    {
        while (reader.Read())
        {
            for (int i = 0; i &lt; reader.FieldCount; i++)
            {
                object value = reader.GetValue(i);
                Console.WriteLine("{0} ({1}) = {2}",
                    reader.GetName(i), value.GetType(), value);
            }
        }
    }

    Console.ReadLine();
}</pre>
The result was:
<pre>TownId (System.Int32) = 1
Name (System.String) = Pitcardine
TownGeom (Microsoft.SqlServer.Types.SqlGeometry) = POLYGON ((0 0, 370 0, 370 160
, 200 250, 0 250, 0 0))
TownGeomText (System.String) = POLYGON ((0 0, 370 0, 370 160, 200 250, 0 250, 0
0))</pre>
At this point I'm looking around to find the assembly that I can reference in my .NET application. After some looking I found it in C:MSSQLMSSQL10.MSSQLSERVERMSSQLBinn however that directory is not guaranteed as it depends on your SQL Server installation. It would be nice if the assembly showed up in the .NET tab in the Add Reference dialog rather than require the developer to hunt it down. (I'm guessing that this is due to the CTP nature of the product I'm currently using)

Once the column value can be accessed as an SqlGeometry object in the code it becomes possible to query the object. However, the results are pretty much all SQL data types. For example:
<pre>SqlGeometry geometry = (SqlGeometry)reader.GetValue(2);
SqlDouble sqlArea = geometry.STArea();
double area = sqlArea.Value; // could also cast to double</pre>
Note that STArea() is a method, not a property as you might expect in this sort of scenario. I suspect that each time it is called the area is worked out which may be an expensive operation hence keeping the method syntax.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:74283f2b-1f25-4bfa-966e-f539d089976e" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/sql%20server%202008">sql server 2008</a>,<a rel="tag" href="http://technorati.com/tags/katmai">katmai</a>,<a rel="tag" href="http://technorati.com/tags/c#">c#</a>,<a rel="tag" href="http://technorati.com/tags/spatial%20data">spatial data</a>,<a rel="tag" href="http://technorati.com/tags/geometry">geometry</a>,<a rel="tag" href="http://technorati.com/tags/SqlGeometry">SqlGeometry</a></div>
