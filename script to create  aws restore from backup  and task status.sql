
-----restore DB from s3 bucket 

exec msdb.dbo.rds_restore_database
@restore_db_name='AdventureWorks2014',
@s3_arn_to_restore_from='arn:aws:s3:::johnazeh-s3/AdventureWorks2014 (1).bak'

-----sp to task status
exec msdb.dbo.rds_task_status

-----To enable Backup Compression in AWS RDS for SQL Server (Not available to SQL Server Express) execute the following stored procedure:

EXEC rdsadmin..rds_set_configuration 'S3 backup compression', 'true'

------To Backup a Database in AWS RDS for SQL Server, you call the rds_backup_database stored procedure:

exec msdb.dbo.rds_backup_database 
        @source_db_name='AdventureWorks2014', 
        @s3_arn_to_backup_to='arn:aws:s3:::johnazeh-s3/AdventureWorks2014_100421.bak',
        @overwrite_S3_backup_file=1;


		exec msdb.dbo.rds_task_status