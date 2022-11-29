-----How to retrieve SQL Server databases backup information?
 SQL Server Backup Information:

----This article illustrates how to retrieve SQL Server database backups information, depending upon what exactly you are looking for, this article will help you to locate desired information. Below are few scenarios.


1-     How to retrieve backup information

select * from msdb.dbo.backupset

 ---Above statement will provide you all the databases backup history, this is going to be our master table to retrieve various type of information about database backups.

2-    --- How to retrieve backup dates of all the databases including system databases?

                select database_name, backup_start_date,backup_finish_date from msdb.dbo.backupset

3-   ---   How to find out how many times backup was taken of a particular database?

                select count(1) from msdb.dbo.backupset where database_name='Your_db_name'

4-    --- How to find out latest backup of a particular user database?

select database_name, Max(backup_finish_date) as LatestBackup_Time from msdb.dbo.backupset
       where database_name='Your_database_name'
       group by database_name

5-      How to find out type (Full, Diff and Tran) of database backup?

select database_name, case type
      when 'D'
           then 'FULL'

       when 'I'
                        then 'Diff'

              when 'L'
                                    then 'tran'

end as [Type of Backup]
       from msdb.dbo.backupset


Note: You can add columns as you wish from our master table dbo.backupset
   6-    How to find out if database backup compression is ON or OFF?
    use [master]
    SELECT name, case value when 0 then 'Compression not enabled' when 1 then 'compression Enabled'
    end
      FROM sys.configurations
    WHERE name = 'backup compression default' ;
    GO
 