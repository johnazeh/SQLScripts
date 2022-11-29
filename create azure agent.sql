--Connect to the new job database specified when creating the Elastic Job agent

-- Create a database master key if one does not already exist, using your own password.  
CREATE MASTER KEY ENCRYPTION BY PASSWORD='Tumenta1';  
  
-- Create two database scoped credentials.  
-- The credential to connect to the Azure SQL logical server, to execute jobs
CREATE DATABASE SCOPED CREDENTIAL job_credential WITH IDENTITY = 'student',
    SECRET = 'Password1';
GO
-- The credential to connect to the Azure SQL logical server, to refresh the database metadata in server
CREATE DATABASE SCOPED CREDENTIAL refresh_credential WITH IDENTITY = 'student',
    SECRET = 'Password1';
GO