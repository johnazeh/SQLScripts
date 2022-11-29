--Create linked server to 1st instance
EXEC master.dbo.sp_addlinkedserver
        @server = N'jazeh\prod',
        @srvproduct=N'SQL Server'
 
--Supply login details - You could use any user with adequate permissions
EXEC master.dbo.sp_addlinkedsrvlogin
        @rmtsrvname=N'jazeh\prod',
        @useself=N'False',
        @locallogin=NULL,
        @rmtuser=N'john.azeh',
        @rmtpassword='Tumenta0101'

		--Create linked server to 2nd instance
EXEC master.dbo.sp_addlinkedserver
        @server = N'jazeh\dev',
        @srvproduct=N'SQL Server'
 
--Supply login details - You could use any user with adequate permissions
EXEC master.dbo.sp_addlinkedsrvlogin
        @rmtsrvname=N'jazeh\dev',
        @useself=N'False',
        @locallogin=NULL,
        @rmtuser=N'john.azeh',
        @rmtpassword='Tumenta0101'



		--------------------------------------
		--Create a blank table to hold the data to compare/report
SELECT @@servername AS ServerName, *
INTO DBA_TablesViews
FROM INFORMATION_SCHEMA.TABLES
WHERE 0=1;
 
--Get 1st instance data into our table
INSERT INTO DBA_TablesViews
SELECT 'jazeh\prod' as ServerName, *
FROM [jazeh\prod].[AdventureWorks2017].INFORMATION_SCHEMA.TABLES;
 
--Get 2nd instance data into our table
INSERT INTO DBA_TablesViews
SELECT 'jazeh\dev' as ServerName, *
FROM [jazeh\dev].[AdventureWorks2017_UAT].INFORMATION_SCHEMA.TABLES;
 
--This is all the collected data - summary
SELECT ServerName, COUNT(1) AS RowCnt
FROM DBA_TablesViews
GROUP BY ServerName;
 
--This is all the collected data - details
SELECT *
FROM DBA_TablesViews
ORDER BY TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ServerName;


---------------------------------------
---Note: In the Script below, replace “jazeh\dev” with the Linked Server name

--Data that exists only in first or second but not both
SELECT 'Only in first' AS Difference, a.*
FROM
(
    SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM DBA_TablesViews WHERE ServerName = 'jazeh\prod'
    EXCEPT
    SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM DBA_TablesViews WHERE ServerName = 'jazeh\dev'
) AS a
UNION ALL
SELECT 'Only in second' AS Difference, b.*
FROM
(
    --SELECTs reversed
    SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM DBA_TablesViews WHERE ServerName = 'jazeh\dev'
    EXCEPT
    SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM DBA_TablesViews WHERE ServerName = 'jazeh\prod'
) AS b;




------Instance Configuration Differences
------This is a reproduction of my other blog post but it shows the configuration differences between two instances.

-----Note: In the Script below, replace “jazeh\prod” and “jazeh\dev” with the Linked Server names


SELECT @@servername as ServerName, *
INTO DBA_Sys_Configurations
from sys.configurations
WHERE 0=1
 
--Get 1st instance sys.configurations data
INSERT INTO DBA_Sys_Configurations
SELECT 'jazeh\prod' as ServerName, *
from [jazeh\prod].MASTER.sys.configurations
 
--Get 2nd instance sys.configurations data
INSERT INTO DBA_Sys_Configurations
SELECT 'jazeh\dev' as ServerName, *
from [jazeh\dev].MASTER.sys.configurations
 
--Make sure we have data from both instances
SELECT * FROM DBA_Sys_Configurations
--Has both instance values
 
SELECT inst1.configuration_id,
    inst1.name,
    inst1.value AS Inst1Value,
    inst2.value AS Inst2Value
FROM
(
    SELECT *
    FROM DBA_Sys_Configurations
    WHERE ServerName = 'jazeh\prod'
) inst1
INNER JOIN
(
    SELECT *
    FROM DBA_Sys_Configurations
    WHERE ServerName = 'jazeh\dev'
) inst2
ON inst1.configuration_id = inst2.configuration_id
    AND (inst1.value != inst2.value
         OR inst1.value_in_use != inst2.value_in_use)



		 ----------------------------------------------------------
--DROP TABLE DBA_TableIndexes
 
--Create a blank table to hold the data to compare/report
SELECT  *
INTO DBA_TableIndexes
FROM
    (
        SELECT
            @@servername AS ServerName,
            SchemaName = s.name,
            TableName = t.name,
            IndexName = ind.name,
            IndexId = ind.index_id,
            IndexType= ind.type_desc,
            ind.*
        FROM
             [jazeh\prod].[AdventureWorks2017].sys.indexes ind
        INNER JOIN
            [jazeh\prod].[AdventureWorks2017].sys.tables t ON ind.object_id = t.object_id
            INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.schemas AS s
                ON s.[schema_id] = t.[schema_id]
        WHERE
            t.is_ms_shipped = 0
        --ORDER BY
        --   t.name, ind.name, ind.index_id
     ) a
WHERE 0=1;
 
--Truncate in case this already exists
TRUNCATE TABLE DBA_TableIndexes;
 
--Get 1st instance data into our table
INSERT INTO DBA_TableIndexes
SELECT
    'jazeh\prod' AS ServerName,
    SchemaName = s.name,
    TableName = t.name,
    IndexName = ind.name,
    IndexId = ind.index_id,
    IndexType= ind.type_desc,
    ind.*
FROM
    [jazeh\prod].[AdventureWorks2017].sys.indexes ind
    INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.tables t
        ON ind.object_id = t.object_id
    INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.schemas AS s
        ON s.[schema_id] = t.[schema_id]
WHERE
    t.is_ms_shipped = 0
ORDER BY
     t.name, ind.name, ind.index_id;
 
--Get 2nd instance data into our table
INSERT INTO DBA_TableIndexes
SELECT
    'jazeh\dev' AS ServerName,
    SchemaName = s.name,
    TableName = t.name,
    IndexName = ind.name,
    IndexId = ind.index_id,
    IndexType= ind.type_desc,
    ind.*
FROM
    [jazeh\dev].[AdventureWorks2017].sys.indexes ind
    INNER JOIN [jazeh\dev].[AdventureWorks2017].sys.tables t
        ON ind.object_id = t.object_id
    INNER JOIN [jazeh\dev].[AdventureWorks2017].sys.schemas AS s
        ON s.[schema_id] = t.[schema_id]
WHERE
    t.is_ms_shipped = 0
ORDER BY
     t.name, ind.name, ind.index_id;
 
--Uncomment if needed for review/reporting
/*
--This is all the collected data - summary
SELECT ServerName, COUNT(1) AS RowCnt
FROM DBA_TableIndexes
GROUP BY ServerName;
 
--This is all the collected data - details
SELECT *
FROM DBA_TableIndexes
ORDER BY TableName, IndexName, IndexType, ServerName;
*/
 
--Data that exists only in first or second but not both
SELECT 'Only in first' AS Difference, a.*
FROM
(
    SELECT TableName, IndexName, IndexType FROM DBA_TableIndexes WHERE ServerName  = 'jazeh\prod'
    EXCEPT
    SELECT TableName, IndexName, IndexType FROM DBA_TableIndexes WHERE ServerName = 'jazeh\dev'
) AS a
UNION ALL
SELECT 'Only in second' AS Difference, b.*
FROM
(
    --SELECTs reversed
    SELECT TableName, IndexName, IndexType FROM DBA_TableIndexes WHERE ServerName = 'jazeh\dev'
    EXCEPT
    SELECT TableName, IndexName, IndexType FROM DBA_TableIndexes WHERE ServerName = 'jazeh\prod') AS b



-------------------------------------------------------------------

--DROP TABLE DBA_TableIndexColumns
 
--Create a blank table to hold the data to compare/report
SELECT  *
INTO DBA_TableIndexColumns
FROM
    (
        SELECT
            'jazeh\dev' as ServerName,
            s.name as SchemaName,
            o.name as TableName,
            i.name as IndexName,
            (
               SELECT c.name + ', '
               FROM [jazeh\prod].[AdventureWorks2017].sys.index_columns ic
                INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.columns c
                    ON ic.column_id = c.column_id
                        AND ic.object_id = c.object_id
               WHERE i.object_id = ic.object_id AND i.index_id = ic.index_id
                 AND ic.is_included_column = 0
               ORDER BY ic.index_column_id
               FOR XML PATH('')
            ) AS Key_Columns,
            (
               SELECT c.name + ', '
               FROM [jazeh\prod].[AdventureWorks2017].sys.index_columns ic
                INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.columns c
                    ON ic.column_id = c.column_id
                        AND ic.object_id = c.object_id
               WHERE i.object_id = ic.object_id AND i.index_id = ic.index_id
                 AND ic.is_included_column = 1
               ORDER BY ic.index_column_id
               FOR XML PATH('')
            ) AS IncludedColumns,
            i.type_desc as IndexType,
            i.is_unique as IsUnique,
            i.is_primary_key as IsPrimaryKey
        FROM [jazeh\prod].[AdventureWorks2017].sys.indexes i
            INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.objects o
                ON i.object_id = o.object_id
            INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.schemas AS s
                    ON o.[schema_id] = s.[schema_id]
        WHERE
            o.is_ms_shipped = 0
            AND 0=1
     ) a
WHERE 0=1;
 
--Truncate in case this already exists
TRUNCATE TABLE DBA_TableIndexColumns;
 
--Get 1st instance data into our table
INSERT INTO DBA_TableIndexColumns
SELECT
    'jazeh\prod' as ServerName,
    s.name as SchemaName,
    o.name as TableName,
    i.name as IndexName,
    (
        SELECT c.name + ', '
        FROM [jazeh\prod].[AdventureWorks2017].sys.index_columns ic
        INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.columns c
            ON ic.column_id = c.column_id
                AND ic.object_id = c.object_id
        WHERE i.object_id = ic.object_id AND i.index_id = ic.index_id
            AND ic.is_included_column = 0
        ORDER BY ic.index_column_id
        FOR XML PATH('')
    ) AS Key_Columns,
    (
        SELECT c.name + ', '
        FROM [jazeh\prod].[AdventureWorks2017].sys.index_columns ic
        INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.columns c
            ON ic.column_id = c.column_id
                AND ic.object_id = c.object_id
        WHERE i.object_id = ic.object_id AND i.index_id = ic.index_id
            AND ic.is_included_column = 1
        ORDER BY ic.index_column_id
        FOR XML PATH('')
    ) AS IncludedColumns,
    i.type_desc as IndexType,
    i.is_unique as IsUnique,
    i.is_primary_key as IsPrimaryKey
FROM [jazeh\prod].[AdventureWorks2017].sys.indexes i
    INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.objects o
        ON i.object_id = o.object_id
    INNER JOIN [jazeh\prod].[AdventureWorks2017].sys.schemas AS s
            ON o.[schema_id] = s.[schema_id]
WHERE
    o.is_ms_shipped = 0;
 
--Get 2nd instance data into our table
INSERT INTO DBA_TableIndexColumns
SELECT
    'jazeh\dev' as ServerName,
    s.name as SchemaName,
    o.name as TableName,
    i.name as IndexName,
    (
        SELECT c.name + ', '
        FROM [jazeh\dev].[AdventureWorks2017].sys.index_columns ic
        INNER JOIN [jazeh\dev].[AdventureWorks2017].sys.columns c
            ON ic.column_id = c.column_id
                AND ic.object_id = c.object_id
        WHERE i.object_id = ic.object_id AND i.index_id = ic.index_id
            AND ic.is_included_column = 0
        ORDER BY ic.index_column_id
        FOR XML PATH('')
    ) AS Key_Columns,
    (
        SELECT c.name + ', '
        FROM [jazeh\dev].[AdventureWorks2017].sys.index_columns ic
        INNER JOIN [jazeh\dev].[AdventureWorks2017].sys.columns c
            ON ic.column_id = c.column_id
                AND ic.object_id = c.object_id
        WHERE i.object_id = ic.object_id AND i.index_id = ic.index_id
            AND ic.is_included_column = 1
        ORDER BY ic.index_column_id
        FOR XML PATH('')
    ) AS IncludedColumns,
    i.type_desc as IndexType,
    i.is_unique as IsUnique,
    i.is_primary_key as IsPrimaryKey
FROM [jazeh\dev].[AdventureWorks2017].sys.indexes i
    INNER JOIN [jazeh\dev].[AdventureWorks2017].sys.objects o
        ON i.object_id = o.object_id
    INNER JOIN [jazeh\dev].[AdventureWorks2017].sys.schemas AS s
            ON o.[schema_id] = s.[schema_id]
WHERE
    o.is_ms_shipped = 0;
 
--Uncomment if needed for review/reporting
/*
--This is all the collected data - summary
SELECT ServerName, COUNT(1) AS RowCnt
FROM DBA_TableIndexColumns
GROUP BY ServerName;
 
--This is all the collected data - details
SELECT *
FROM DBA_TableIndexColumns
ORDER BY SchemaName, TableName, IndexName, Key_Columns, IncludedColumns, ServerName;
*/
 
--Tables with index column differences
SELECT COALESCE(a.[SchemaName],b.[SchemaName]) AS SchemaName,
        COALESCE(a.[TableName],b.[TableName]) AS TableName,
        CASE WHEN a.TableName IS NULL
            THEN 'Index is only in DB2'
            WHEN b.TableName IS NULL
            THEN 'Index is only in DB1'
            ELSE 'Index is in both with differences'
        END AS Diff,
        a.Key_Columns AS DB1KeyColumns,
        b.Key_Columns AS DB2KeyColumns,
        a.IncludedColumns AS DB1IncludedColumns, b.IncludedColumns AS DB2IncludedColumns,
        a.IndexType AS DB1IndexType, b.IndexType AS DB2IndexType,
        a.IsUnique AS DB1IsUnique, b.IsUnique AS DB2IsUnique,
        a.IsPrimaryKey AS DB1IsPrimaryKey, b.IsPrimaryKey AS DB2IsPrimaryKey
FROM
    (
        SELECT * FROM DBA_TableIndexColumns WHERE ServerName = 'jazeh\prod'
    ) a
    FULL JOIN
    (
        SELECT * FROM DBA_TableIndexColumns WHERE ServerName = 'jazeh\dev'
    ) b
    ON a.[SchemaName] = b.[SchemaName]
        AND a.[TableName] = b.[TableName]
        AND a.[IndexName] = b.[IndexName]
WHERE
    a.IndexType  b.IndexType
    OR COALESCE(a.Key_Columns,'~')  COALESCE(b.Key_Columns,'~')
    OR COALESCE(a.IncludedColumns,'~')  COALESCE(b.IncludedColumns,'~')
    OR a.IsUnique  b.IsUnique
    OR a.IsPrimaryKey  b.IsPrimaryKey
ORDER BY
    a.[SchemaName], a.[TableName], a.IndexName;
