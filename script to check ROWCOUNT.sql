select top (1000)*

from AdventureWorks2017.HumanResources.Employee

select top (1000)*

from AdventureWorks2017.[HumanResources].[EmployeeDepartmentHistory]


select @@rowcount as NumofRows


-----COUNTING NUMBER OF COLUMN 
SELECT
  COUNT(*)
FROM [AdventureWorks2017].[Person].[Person]

---ANOTHER METHOD TO COUNT ROWS
SELECT
  dm_db_partition_stats.row_count
FROM sys.dm_db_partition_stats
INNER JOIN sys.objects
ON objects.object_id = dm_db_partition_stats.object_id
WHERE objects.is_ms_shipped = 0
AND objects.type_desc = 'USER_TABLE'
AND objects.name = '[Person].[Person]'
AND dm_db_partition_stats.index_id IN (0,1);
