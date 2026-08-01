---
title: "Inserting geometry through a .NET Application"
slug: inserting-geometry-through-a-net-application
publishDate: 06 Dec 2007
description: "THIS POST REFERS TO THE NOVEMBER 2007 CTP (CTP 5) OF SQL SERVER 2008 Following from my previous posts ( Getting started with Spatial Data in SQL Server 2008 ,..."
tags:
  - { name: ".NET", slug: net }
  - { name: "ADO.NET", slug: ado-net }
  - { name: "CTP/Beta", slug: ctp-beta }
  - { name: "Spatial", slug: spatial }
  - { name: "SQL Server", slug: sql-server }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
<!-- TODO: convert this post's content to Markdown -->

<strong>THIS POST REFERS TO THE NOVEMBER 2007 CTP (CTP 5) OF SQL SERVER 2008</strong>

Following from my previous posts (<a href="http://blog.colinmackay.net/archive/2007/12/01/1261.aspx">Getting started with Spatial Data in SQL Server 2008</a>, <a href="http://blog.colinmackay.net/archive/2007/12/02/1275.aspx">Spatial Data in a .NET application</a>) on the new spatial features of SQL Server 2008 I've been looking at how to get spatial data into SQL Server from a .NET application. This has not been as easy as expected.

I suspect I just have not found the right piece of documentation because my eventual solution isn't one I'm entirely happy with.

I was unable to add a SqlGeometry as a parameter to the collection of parameters on the SqlCommand object in my .NET application. The SqlGeometry does not appear in the enumeration for SQL Server data types. My first thought was to put the data through as binary as I vaguely remember reading something about using binary in something I read recently, but I couldn't quite remember where. However, when I created the geometry object in .NET then used .STAsBinary() on it so the parameter object would accept it the INSERT failed. The exception message was:
<pre>A .NET Framework error occurred during execution of user defined routine or aggregate 'geometry':
System.FormatException: One of the identified items was in an invalid format.
System.FormatException:
   at Microsoft.SqlServer.Types.GeometryData.Read(BinaryReader r)
   at Microsoft.SqlServer.Types.SqlGeometry.Read(BinaryReader r)
   at SqlGeometry::.DeserializeValidate(IntPtr , Int32 )
.
The statement has been terminated.</pre>
&nbsp;

Yes, that was the MESSAGE from the exception. The stack trace above comes from within SQL Server itself. There is a separate stack track for my application. (I'm guessing if you are familiar with CLR stored procedures you may have seen this sort of thing before. I've not used the CLR code in SQL Server before, so it is a new experience)

The solution I found was to mark the parameter as an NVarChar, skip the creation of an SqlGeometry object and use a string containing the WKT (Well Known Text) representation. For example:
<pre>cmd.Parameters.Add("@Point", SqlDbType.NVarChar) = "POINT (312500 791500)";</pre>
I mentioned earlier that I'm not all that happy with this solution. That is because if I already have an SqlGeometry object I don't want to have to convert it to a human readable format and have SQL Server parse it back again. Human Readable formats tend not to be the most efficient way of representing data and the geometry type already has a more efficient (as I understand it) format. Although in this case I bypassed the creation of an SqlGeometry object in my code, I can foresee cases where I might have created an SqlGeometry object through various operations and would have produced a fairly complex object. In those cases I wouldn't want the additional overhead formatting it into WKT, passing it over the network and parsing it on the other side.

If I find a better solution I will post it.
<div id="scid:0767317B-992E-4b12-91E0-4F059A8CECA8:18fe215b-75a3-47dd-89ff-14cb843ad66a" class="wlWriterSmartContent" style="display:inline;margin:0;padding:0;">Technorati Tags: <a rel="tag" href="http://technorati.com/tags/katmai">katmai</a>,<a rel="tag" href="http://technorati.com/tags/sql%20server%202008">sql server 2008</a>,<a rel="tag" href="http://technorati.com/tags/spatial%20data">spatial data</a>,<a rel="tag" href="http://technorati.com/tags/SqlGeometry">SqlGeometry</a></div>
