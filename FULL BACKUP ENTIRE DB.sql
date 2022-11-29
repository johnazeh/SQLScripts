DECLARE @name VARCHAR(MAX)    
DECLARE @path VARCHAR(MAX)   
DECLARE @fileName VARCHAR(MAX)     
DECLARE @fileDate VARCHAR(25) 
   
 
SET @path = 'F:\SQL_BACKUPS_FILES\'    
      
SET @fileDate =REPLACE((SELECT CONVERT(VARCHAR(20),GETDATE(),112)),'/','_')  
   
DECLARE db_cursor CURSOR READ_ONLY FOR    
SELECT name   
FROM master.dbo.sysdatabases   
WHERE name NOT IN ('master','model','msdb','tempdb')    
   
OPEN db_cursor     
FETCH NEXT FROM db_cursor INTO @name     
   
WHILE @@FETCH_STATUS = 0     
BEGIN     
   SET @fileName = @path + @name + '_' + @fileDate + '.BAK'    
   BACKUP DATABASE @name TO DISK = @fileName    
   
   FETCH NEXT FROM db_cursor INTO @name     
END    
   
CLOSE db_cursor     
DEALLOCATE db_cursor 