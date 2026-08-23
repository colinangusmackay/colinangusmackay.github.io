---
title: "Optimising clustered indexes in SQL Server 2008"
slug: optimising-clustered-indexes-in-sql-server-2008
publishDate: 06 Aug 2012
description: "I've just found a script on another blog to go through all the clustered indexes in a SQL Server database and rebuild them in order to reduce fragmentation and..."
tags:
  - { name: "SQL Server", slug: sql-server }
  - { name: "SQL Server 2008", slug: sql-server-2008 }
---
I've just found a script on another blog to go through all the clustered indexes in a SQL Server database and rebuild them in order to reduce fragmentation and improve the disk IO needed to get the data. The [original script](http://www.keepitsimpleandfast.com/2008/12/optimize-index-structure.html) didn't take into account tables in different schemas so I updated it. I also added some metrics to it so I could get a sense of how long the operation takes on each table.
The script can take quite a while to run. On my database it took over 6 minutes just to initially run the query to work out what needed rebuilding, and each index can take several seconds (or possibly more if you have a lot of data) on its own.
The new script is here:

```sql
SET NOCOUNT ON
DECLARE @Schema SYSNAME;
DECLARE @Table SYSNAME;
DECLARE @Index SYSNAME;
DECLARE @Rebuild NVARCHAR(4000)
DECLARE @StartTime DATETIME = GETUTCDATE();

PRINT (CONVERT(NVARCHAR(100), GETUTCDATE(), 113) + ' : Rebuild all indexes with over 10% fragmentation.')

DECLARE DB CURSOR FOR 
SELECT SS.name [schema], SO.Name [table], SI.Name [index]
FROM SYS.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED')
INNER JOIN SYS.objects SO ON SO.object_id=SYS.dm_db_index_physical_stats.object_id
INNER JOIN SYS.schemas SS ON SO.schema_id=SS.schema_id
INNER JOIN SYS.indexes SI ON SI.index_id=SYS.dm_db_index_physical_stats.index_id AND 
SI.object_id=sys.dm_db_index_physical_stats.object_id 
-- Begin select only clustered indexes Index_id = 1
AND SI.Index_id = 1
-- End select only clustered indexes Index_id = 1
WHERE avg_fragmentation_in_percent > 10.0 AND SYS.dm_db_index_physical_stats.index_id > 0
ORDER BY SO.Name 

OPEN DB
FETCH NEXT FROM DB INTO @Schema, @Table, @Index
WHILE @@FETCH_STATUS = 0
BEGIN
  SET @Rebuild = 'ALTER INDEX ' + @Index + ' ON ' + @Schema + '.' + @Table + ' REBUILD'

  PRINT (CONVERT(NVARCHAR(100), GETUTCDATE(), 113) + ' : ' + @Rebuild)

  -- Comment out the following line to see what tables would be affected without rebuilding the indexes
  EXEC SP_EXECUTESQL @Rebuild

  FETCH NEXT FROM DB INTO @Schema, @Table, @Index
END
CLOSE DB
DEALLOCATE DB

DECLARE @Duration DATETIME = GETUTCDATE() - @StartTime;
PRINT (CONVERT(NVARCHAR(100), GETUTCDATE(), 113) + ' : Finished. Duration = '+CONVERT(NVARCHAR(100), @Duration, 114))

SET NOCOUNT OFF
```
