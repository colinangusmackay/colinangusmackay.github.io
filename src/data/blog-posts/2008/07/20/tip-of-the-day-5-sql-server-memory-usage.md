---
title: "Tip of the Day #5 (SQL Server memory usage)"
slug: tip-of-the-day-5-sql-server-memory-usage
publishDate: 20 Jul 2008
description: "You can limit the amount of memory that SQL Server uses by using the sp_configure stored procedure. By limiting the amount of memory that SQL Server is..."
tags:
  - { name: "SQL Server", slug: sql-server }
---
You can limit the amount of memory that SQL Server uses by using the `sp_configure` stored procedure. By limiting the amount of memory that SQL Server is permitted to use it means that more memory is available to other applications or other instances of SQL Server. In fact books on-line recommends setting the minimum and maximum memory used on each instance of SQL Server running on the same machine as SQL Server does not make any attempts to balance memory usage across instances.

In order to use this you must be in an advanced mode. To set this up use:

```sql
EXEC sp_configure 'show advanced options', 1
RECONFIGURE WITH OVERRIDE 
```

 
Next, to make the actual change you need the following:

```sql
EXEC sp_configure 'max server memory (MB)', 512
RECONFIGURE WITH OVERRIDE 
```

 
The above example will set the maximum amount of memory the server will use to 512MB. The `RECONFIGURE WITH OVERRIDE` is necessary in order for the change to take effect immediately. If it is missed out then the change won't take place until the SQL Server is restarted.

If you want to check that the change has taken place you can use the following:

```sql
EXEC sp_configure 'max server memory (MB)' 
```

 
This will just display the current setting. You will get a result set that looks something like this:

![SQL Server 2005 memory options result set](/assets/blog/2008-07-20-tip-of-the-day-5-sql-server-memory-usage-1.webp)

The `congig_value` is the value that the SQL Server is currently configured with. However, it may not be what is currently in force. The run_value shows you what is currently in force.

![SQL Server 2005 memory options dialog](/assets/blog/2008-07-20-tip-of-the-day-5-sql-server-memory-usage-2.webp)

If you don't want to type so much SQL yourself, then you can do the same in the SQL Server Management Studio. Right-click the server in the object explorer and select "properties" from the context menu. This will bring you up a dialog with all the server level properties in it. Go to the "memory" page and you can set the values that you want there. There are a couple of radio buttons that will allow you to switch between the currently configured value and the running value. By pressing Okay the updated value is applied to the server immediately.

For more information:

- [sp_configure (Books On-Line)](http://msdn.microsoft.com/en-us/library/ms188787.aspx)
- [Configuration Options (Books On-Line)](http://msdn.microsoft.com/en-us/library/ms189631.aspx)
- [SQL Server Memory Options (Books On-Line)](http://msdn.microsoft.com/en-us/library/ms178067.aspx)
