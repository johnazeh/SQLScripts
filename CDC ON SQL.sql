/*================================================================================
TITLE: Change Data Capture Bug Reproduction
--------------------------------------------------------------------------------
 
HISTORY:
--------------------------------------------------------------------------------
Date:         Developer:                   Description:
--------------------------------------------------------------------------------
2015-05-02    Mr. Fox SQL (Rolf Tesmer)    Created
--------------------------------------------------------------------------------
 
NOTES:
--------------------------------------------------------------------------------
Disclaimer: https://mrfoxsql.wordpress.com/notes-and-disclaimers/
================================================================================*/
 
-- CREATE database -- Ensure it is FULL recovery mode
CREATE DATABASE BreakCDCDB
GO
 
-- use the database
USE BreakCDCDB
GO
execute dbo.sp_changedbowner @loginame = N'sa'
GO
 
-- enable cdc on DB
execute sys.sp_cdc_enable_db
GO
 
-- create CDC table with TEXT datatype
-- by default SQL stores TEXT off row
CREATE TABLE dbo.CDCTable
(
     [id]     INT IDENTITY(1, 1) NOT NULL
     , [col1] TEXT NULL -- will later change data type to VARCHAR(max)
)
GO 
 
-- enable table for CDC capture
-- This will create the system tracking table [cdc].[dbo_CDCTable_CT]
-- This will create and start the following 2x SQL Agent jobs (ENSURE SQL AGENT IS RUNNING)
-- * cdc.BreakCDCDB_capture --> job to read from the SQL DB log file and look for transactions against the [CDCTable], then copy those transactions to [cdc].[dbo_CDCTable_CT]
-- * cdc.BreakCDCDB_cleanup --> job to cleanup old data in the [cdc].[dbo_CDCTable_CT]
execute sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'CDCTable', @role_name = 'cdc_reader'
GO
 
-- insert some TEXT data in the CDC table to prove CDC works
insert into dbo.CDCTable select 'TEST DATA'
select *, DATALENgth(col1) as RowLength from dbo.CDCTable
GO
-- read from the CDC tracking table to see the inserted row, and check the error table for errors
select * from cdc.dbo_CDCTable_CT
select * from sys.dm_cdc_errors
GO
 
-- update some TEXT data in the CDC table to prove CDC works for true LOB values
declare @LargeValue varchar(max) = 'LARGEVALUE'
update dbo.CDCTable set col1 = REPLICATE(@LargeValue, 1000) -- big update over 8000
select *, DATALENgth(col1) as RowLength from dbo.CDCTable
GO
-- read from the CDC tracking table to see the updated row, and check the error table for errors
-- NOTE: CDC does not track the before image ($operation = 3) for TEXT columns
select * from cdc.dbo_CDCTable_CT
select * from sys.dm_cdc_errors
GO
 
-- ALTER table schema definition from TEXT to VARCHAR(MAX)
-- by default SQL stores VARCHAR(MAX) in row
-- NOTE: This will work but is risky. Any changes from this point that push the LoB value off row will break CDC
ALTER TABLE dbo.CDCTable ALTER COLUMN col1 VARCHAR(max)
GO
select * from cdc.ddl_history
GO
 
-- *** THIS WILL NOT BREAK CDC ***
-- insert some VARCHAR(max) data in the CDC table to prove CDC works
insert into dbo.CDCTable select 'TEST DATA'
select *, DATALENgth(col1) as RowLength from dbo.CDCTable
GO
-- read from the CDC tracking table to see the inserted row, and check the error table for errors
select * from cdc.dbo_CDCTable_CT
select * from sys.dm_cdc_errors
GO
 
-- *** THIS WILL BREAK CDC ***
-- update some VARCHAR(max) data in the CDC table to a value to push off page
declare @LargeValue varchar(max) = 'LARGEVALUE'
update dbo.CDCTable set col1 = REPLICATE(@LargeValue, 1000) -- big update over 8000
select *, DATALENgth(col1) as RowLength from dbo.CDCTable
GO
-- read from the CDC tracking table to see the inserted row, and check the error table for errors
select * from cdc.dbo_CDCTable_CT
select * from sys.dm_cdc_errors
GO
 
-- AFTER CDC IS BROKEN NOTHING EVER FLOWS THROUGH CDC AS THE LOG READER CRASHES ON THE BROKEN LOG RECORD
insert into dbo.CDCTable select 'NEW TEST DATA'
select *, DATALENgth(col1) as RowLength from dbo.CDCTable
GO
-- read from the CDC tracking table to see the inserted row, and check the error table for errors
select * from cdc.dbo_CDCTable_CT
select * from sys.dm_cdc_errors
GO



---solution 
—--- Stop and disable cdc capture job

—---- Take a backup of the cdc data in an user table

SELECT * INTO [dbo].[Backup_dbo_CDCTable_CT] FROM [cdc].[dbo_CDCTable_CT];

---- Disable cdc for that tracked table (dbo.employee), it will drop the related cdc system table ([cdc].[dbo_employee_CT])
Begin
exec sys.sp_cdc_disable_table 
@source_schema = 'dbo',
@source_name = 'CDCTable',
@capture_instance = '[cdc].[dbo_CDCTable_CT]'
--@role_name = null
END

execute sys.sp_cdc_enable_db
GO


—-- Enable cdc again for the tracked table

BEGIN
exec sys.sp_cdc_enable_table
@source_schema = 'dbo',
@source_name = 'CDCTable',
@role_name = 'cdc_reader'
END

-----— Copy the cdc data back to the new cdc table created in the previous step

INSERT INTO [cdc].[dbo_CDCTable_CT] SELECT * FROM [dbo].[Backup_dbo_CDCTable_CT]


-----— Drop the backup table

DROP TABLE [dbo].[Backup_dbo_CDCTable_CT]


—----- Enable and run the cdc captue job