USE MASTER
GO
EXEC xp_readerrorlog 0, 1, N'Logging SQL Server messages in file'
GO


use Master

exec xp_readerrorlog 0, 1, N'Logging SQL server messages in file'