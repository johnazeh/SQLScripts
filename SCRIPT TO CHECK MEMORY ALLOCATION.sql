----hOW TO VIEW TOTAL  SERVER MEMORY 
SELECT total_physical_memory_kb / 1024 AS MemoryMb 
FROM sys.dm_os_sys_memory


---To view SQLs allocation we can query the sys.configurations table to see how SQL has been configured:
SELECT name, value_in_use FROM sys.configurations 
WHERE name LIKE 'max server memory%'


-----sEE HOW SQL SERVER IS USING MEMORY
 
SELECT TOP(5) [type] AS [ClerkType],
SUM(pages_kb) / 1024 AS [SizeMb]
FROM sys.dm_os_memory_clerks WITH (NOLOCK)
GROUP BY [type]
ORDER BY SUM(pages_kb) DESC