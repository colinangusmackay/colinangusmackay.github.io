---
title: "Tip of the Day: A DateOnly function in SQL Server"
slug: tip-of-the-day-a-dateonly-function-in-sql-server
publishDate: 09 May 2013
description: "It occurs to me that I've probably written several versions of this function in various installations on SQL Sever over the last 10+ years (10 years 2 months,..."
tags: []
---
<!-- TODO: convert this post's content to Markdown -->

It occurs to me that I've probably written several versions of this function in various installations on SQL Sever over the last 10+ years (10 years 2 months, 26 days - to be exact) since I started using SQL Server. I should really put it somewhere that I can refer to it easily and not have to re-write it again. (So why not put it in my blog?)

It's a simple little thing that takes a <code>DATETIME</code> and returns the same but without the time elements, basically, it returns the date only.

<pre>CREATE FUNCTION [dbo].[DateOnly]
(
  @DateTime DATETIME
)
RETURNS DATETIME
AS
BEGIN
  RETURN 
    DATEADD(MILLISECOND, -DATEPART(MILLISECOND, @DateTime),
      DATEADD(SECOND, -DATEPART(SECOND, @DateTime),
        DATEADD(MINUTE, -DATEPART(MINUTE, @DateTime), 
          DATEADD(HOUR, -DATEPART(HOUR, @DateTime), @DateTime))));
END</pre>
