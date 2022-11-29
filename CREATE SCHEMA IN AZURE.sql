----use master
CREATE LOGIN test 
WITH PASSWORD = 'SuperSecret!'

----Use database
CREATE USER [test] 
FOR LOGIN [test] 
WITH DEFAULT_SCHEMA = dbo; 
  
-- add user to role(s) in db 
ALTER ROLE db_datareader ADD MEMBER [test]; 
ALTER ROLE db_datawriter ADD MEMBER [test]; 


 