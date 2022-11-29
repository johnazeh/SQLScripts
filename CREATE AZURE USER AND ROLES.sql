
CREATE USER [DBA] FOR EXTERNAL PROVIDER; -- creates a user with Azure Active Directory mapped to the App Service Principal
ALTER ROLE [db_datareader] ADD MEMBER [DBA];
ALTER ROLE [db_datawriter] ADD MEMBER [DBA]
Grant Execute to [DBA]