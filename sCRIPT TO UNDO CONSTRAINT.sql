 EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'


 EXEC sp_msforeachtable 'ALTER TABLE ? CHECK CONSTRAINT all'