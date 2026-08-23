---
title: "Creating a data dictionary with SQL Server and MediaWiki – Part three: inbound references"
slug: creating-a-data-dictionary-with-sql-server-and-mediawiki-part-three-inbound-references
publishDate: 16 Jun 2012
description: "In my previous posts (parts one and two ), I showed how to generate mediawiki markup to generate lists of tables and columns that can be used as the starting..."
tags:
  - { name: "data dictionary", slug: data-dictionary }
  - { name: "documentation", slug: documentation }
  - { name: "MediaWiki", slug: mediawiki }
  - { name: "SQL", slug: sql }
---
In my previous posts (parts [one](/2012/06/14/creating-a-data-dictionary-with-sql-server-and-mediawiki-part-one-a-list-of-tables/ "Creating a data dictionary with SQL Server and Media Wiki - Part one: a list of tables") and [two](/2012/06/15/creating-a-data-dictionary-with-sql-server-and-mediawiki-part-two-a-list-of-columns/ "Creating a data dictionary with SQL Server and MediaWiki – Part two: a list of columns")), I showed how to generate mediawiki markup to generate lists of tables and columns that can be used as the starting blocks of a data dictionary. In this post I continue that by showing how to generate a list of inbound links (i.e. a list of other tables that reference this one)

### The script

At the top of the script are three parameters that you need to set to suit your needs. The `@catalogue` is the name of the database, the `@schema` and `@table` are the names of the destination schema and table.

```sql
-- Edit these parameters to suit your needs.
DECLARE @catalogue SYSNAME = 'AdventureWorks';
DECLARE @schema SYSNAME = 'Production'
DECLARE @table SYSNAME = 'Product'

DECLARE @fk_catalogue SYSNAME;
DECLARE @fk_schema SYSNAME;
DECLARE @fk_table_name SYSNAME;
DECLARE @fk_column_name SYSNAME;

SET NOCOUNT ON

PRINT '{| class="wikitable sortable"
|-
! scope="col" | Schema
! scope="col" | Table
! scope="col" | Column
! scope="col" class="unsortable" | Notes
'

DECLARE fk_cursor CURSOR FOR
SELECT FK.TABLE_CATALOG, FK.TABLE_SCHEMA, FK.TABLE_NAME, CU.COLUMN_NAME
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK
    ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME
INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK
    ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU
    ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
WHERE PK.TABLE_SCHEMA = @schema
AND PK.TABLE_NAME = @table
AND PK.TABLE_CATALOG = @catalogue
ORDER BY FK.TABLE_SCHEMA, FK.TABLE_NAME, CU.COLUMN_NAME

OPEN fk_cursor

FETCH NEXT FROM fk_cursor
INTO @fk_catalogue, @fk_schema, @fk_table_name, @fk_column_name

WHILE @@FETCH_STATUS = 0
BEGIN

PRINT '|-
| '+ @fk_schema+'
| [[' + @fk_catalogue + '.'+@fk_schema+'.'+@fk_table_name + '|'+ @fk_table_name+']]
| '+ @fk_column_name + '
|
'

FETCH NEXT FROM fk_cursor
INTO @fk_catalogue, @fk_schema, @fk_table_name, @fk_column_name
END
PRINT '|}'

CLOSE fk_cursor;
DEALLOCATE fk_cursor;
SET NOCOUNT OFF
```

### How it renders

This is how the resulting mediawiki code renders in the browser.

![Rendering of inbound references](/assets/blog/2012-06-16-creating-a-data-dictionary-with-sql-server-and-mediawiki-part-three-inbound-references-1.webp)
