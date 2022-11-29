select instant_file_initialization_enabled ,* from sys.dm_server_services
where servicename like 'SQL Server%'