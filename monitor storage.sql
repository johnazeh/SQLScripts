CREATE DATABASE [monitoring]
GO

USE monitoring
GO


-------I created a schema called "monitoring", for the sake of keeping things organized and clean.

CREATE SCHEMA [monitoring]
GO

+----I also created a table called monitoring.thresholds that determines when there is an issue and loaded a value for testing.

CREATE TABLE [monitoring].[thresholds](
	[item] [varchar](50) NULL,
	[warning_value] [char](3) NULL
) ON [PRIMARY]
GO

INSERT INTO [monitoring].[thresholds]
VALUES ( 'disk_space', 80 ) -- 80% or less free

GO


-----Here is the code for the stored procedure.
CREATE PROCEDURE [Monitoring].[disk_space] 
 
AS
BEGIN
   SET NOCOUNT ON;
 
   DECLARE @query VARCHAR(MAX);
   DECLARE @threshold CHAR(3);
 
   SET @threshold = (SELECT warning_value FROM Monitoring.Thresholds WHERE item = 'disk_space');
 
   SET @query = '
   DECLARE @xp_cmdshell bit
   DECLARE @flipped bit
 
   SET @flipped = 0
 
   /* Check if xp_cmdshell is enabled or not */
   SELECT @xp_cmdshell = (CONVERT(INT, ISNULL(value, value_in_use)))
   FROM  sys.configurations
   WHERE  name = '+CHAR(39)+'xp_cmdshell'+CHAR(39)+';
 
   IF @xp_cmdshell = 0
   BEGIN
      EXEC SP_CONFIGURE '+CHAR(39)+'show advanced options'+CHAR(39)+', 1
      RECONFIGURE 
      EXEC SP_CONFIGURE '+CHAR(39)+'xp_cmdshell'+CHAR(39)+', 1
      RECONFIGURE
      SET @flipped = 1
   END
 
   DECLARE @SQL NVARCHAR(1000)
 
   CREATE TABLE #DrvLetter (Drive VARCHAR(500))
   CREATE TABLE #DrvInfo (
      Drive VARCHAR(500) null,
      [MB free] DECIMAL(20,2),
      [MB TotalSize] DECIMAL(20,2),
      [Volume Name] VARCHAR(64)
     )
 
   INSERT INTO #DrvLetter
   EXEC xp_cmdshell '+CHAR(39)+'wmic volume where drivetype="3" get caption, freespace, capacity, label'+CHAR(39)+'
   DELETE FROM #DrvLetter WHERE drive IS NULL OR len(drive) < 4 OR Drive LIKE '+CHAR(39)+'%Capacity%'+CHAR(39)+' OR Drive LIKE  '+CHAR(39)+'%\\%\Volume%'+CHAR(39)+'
 
   DECLARE @STRLine VARCHAR(8000)
   DECLARE @Drive varchar(500)
   DECLARE @TotalSize REAL
   DECLARE @Freesize REAL
   DECLARE @VolumeName VARCHAR(64)
   
   WHILE EXISTS(SELECT 1 FROM #DrvLetter)
   BEGIN
      SET ROWCOUNT 1
      SELECT @STRLine = drive FROM #DrvLetter
      
      /* Get TotalSize */
      SET @TotalSize= CAST(LEFT(@STRLine,CHARINDEX('+CHAR(39)+' '+CHAR(39)+',@STRLine)) AS REAL)/1024/1024
   
      /* Remove Total Size */
      SET @STRLine = REPLACE(@STRLine, LEFT(@STRLine,CHARINDEX('+CHAR(39)+' '+CHAR(39)+',@STRLine)),'+CHAR(39)+CHAR(39)+')
      SET @Drive = LEFT(LTRIM(@STRLine),CHARINDEX('+CHAR(39)+' '+CHAR(39)+',LTRIM(@STRLine)))
      SET @STRLine = RTRIM(LTRIM(REPLACE(LTRIM(@STRLine), LEFT(LTRIM(@STRLine),CHARINDEX('+CHAR(39)+' '+CHAR(39)+',LTRIM(@STRLine))),'+CHAR(39)+CHAR(39)+')))
      SET @Freesize = LEFT(LTRIM(@STRLine),CHARINDEX('+CHAR(39)+' '+CHAR(39)+',LTRIM(@STRLine)))
      SET @STRLine = RTRIM(LTRIM(REPLACE(LTRIM(@STRLine), LEFT(LTRIM(@STRLine),CHARINDEX('+CHAR(39)+' '+CHAR(39)+',LTRIM(@STRLine))),'+CHAR(39)+CHAR(39)+')))
      SET @VolumeName = @STRLine
      
      INSERT INTO #DrvInfo
      SELECT @Drive, @Freesize/1024/1024 , @TotalSize, @VolumeName
 
      DELETE FROM #DrvLetter
      END
 
      SET ROWCOUNT 0
 
      /* POPULATE TEMP TABLE WITH LOGICAL DISKS */
      SET @SQL ='+CHAR(39)+'wmic /FailFast:ON logicaldisk where (drivetype ="3" and volumename!="RECOVERY" AND volumename!="System Reserved") get deviceid,volumename  /Format:csv'+CHAR(39)+'
      
      if object_id('+CHAR(39)+'tempdb..#output1'+CHAR(39)+') is not null drop table #output1
      CREATE TABLE #output1 (Col1 VARCHAR(2048))
      INSERT INTO #output1
      EXEC master..xp_cmdshell @SQL
      
      DELETE #output1 where ltrim(col1) is null or len(col1) = 1 or Col1 like '+CHAR(39)+'Node,DeviceID,VolumeName%'+CHAR(39)+'
 
      if object_id('+CHAR(39)+'tempdb..#logicaldisk'+CHAR(39)+') is not null drop table #logicaldisk
      CREATE TABLE #logicaldisk (DeviceID varchar(128),VolumeName varchar(256))
 
      DECLARE @NodeName varchar(128)
      SET @NodeName = (SELECT TOP 1 LEFT(Col1, CHARINDEX('+CHAR(39)+','+CHAR(39)+',Col1)) FROM #output1)
 
      /* Clean up server name */
      UPDATE #output1 SET Col1 = REPLACE(Col1, @NodeName, '+CHAR(39)+CHAR(39)+')
 
      INSERT INTO #logicaldisk
      SELECT LEFT(Col1, CHARINDEX('+CHAR(39)+','+CHAR(39)+',Col1)-2),  SUBSTRING(COL1, CHARINDEX('+CHAR(39)+','+CHAR(39)+',Col1)+1, LEN(col1))
      FROM #output1
 
      UPDATE dr
      SET dr.[Volume Name] = ld.VolumeName
      FROM #DrvInfo dr RIGHT OUTER JOIN #logicaldisk ld ON left(dr.Drive,1) = ld.DeviceID
      WHERE LEN([Volume Name]) = 1
 
      CREATE TABLE #DBInfo2 ( 
      ServerName VARCHAR(100),  
      DatabaseName VARCHAR(100),  
      FileSizeMB INT,  
      LogicalFileName sysname,  
      PhysicalFileName NVARCHAR(520),  
      Status sysname,  
      Updateability sysname,  
      RecoveryMode sysname,  
      FreeSpaceMB INT,  
      FreeSpacePct VARCHAR(7),  
      FreeSpacePages INT,  
      PollDate datetime)  
 
      DECLARE @command VARCHAR(5000)  
      
      DECLARE @instance VARCHAR(100)
      SELECT @instance = CONVERT(VARCHAR(100),SERVERPROPERTY(''ServerName''))
      
      SELECT @command = '+CHAR(39)+'Use [?] 
      SELECT  
      '+CHAR(39)+'+'+CHAR(39)+CHAR(39)+CHAR(39)+CHAR(39)+'+'+'@instance'+'+'+CHAR(39)+CHAR(39)+CHAR(39)+CHAR(39)+'+'+CHAR(39)+' AS ServerName,  
      '+CHAR(39)+CHAR(39)+'?'+CHAR(39)+CHAR(39)+' AS DatabaseName,
      CAST(sysfiles.size/128.0 AS int) AS FileSize,
      sysfiles.name AS LogicalFileName, sysfiles.filename AS PhysicalFileName,
      CONVERT(sysname,DatabasePropertyEx('+CHAR(39)+CHAR(39)+'?'+CHAR(39)+CHAR(39)+','+CHAR(39)+CHAR(39)+'Status'+CHAR(39)+CHAR(39)+')) AS Status,
      CONVERT(sysname,DatabasePropertyEx('+CHAR(39)+CHAR(39)+'?'+CHAR(39)+CHAR(39)+','+CHAR(39)+CHAR(39)+'Updateability'+CHAR(39)+CHAR(39)+')) AS Updateability,
      CONVERT(sysname,DatabasePropertyEx('+CHAR(39)+CHAR(39)+'?'+CHAR(39)+CHAR(39)+','+CHAR(39)+CHAR(39)+'Recovery'+CHAR(39)+CHAR(39)+')) AS RecoveryMode,
      CAST(sysfiles.size/128.0 - CAST(FILEPROPERTY(sysfiles.name, '+CHAR(39)+CHAR(39) +'SpaceUsed'+CHAR(39)+CHAR(39)+') AS int)/128.0 AS int) AS FreeSpaceMB,
      CAST(100 * (CAST (((sysfiles.size/128.0 -CAST(FILEPROPERTY(sysfiles.name, '+CHAR(39)+CHAR(39)+'SpaceUsed'+CHAR(39)+CHAR(39)+') AS int)/128.0)/(sysfiles.size/128.0)) AS decimal(4,2))) AS varchar(8)) + '+CHAR(39)+CHAR(39)+CHAR(39)+CHAR(39)+' AS FreeSpacePct
      FROM dbo.sysfiles' + CHAR(39) + '
   
      INSERT INTO #DBInfo2 (
      ServerName,  
        DatabaseName,  
        FileSizeMB,  
        LogicalFileName,  
        PhysicalFileName,  
        Status,  
        Updateability,  
        RecoveryMode,  
        FreeSpaceMB,  
        FreeSpacePct)  
 
      EXEC sp_MSForEachDB @command  
 
      SELECT  
         db.ServerName Instance,
         db.DatabaseName AS DBName,  
         db.PhysicalFileName AS PhysicalFileLocation, 
           CASE
            WHEN LEN(dr.drive) = 3 THEN LEFT(dr.drive,1)+'+CHAR(39)+':\'+CHAR(39)+'
            ELSE dr.drive+'+CHAR(39)+':\'+CHAR(39)+'
             END AS Drive, 
             db.FileSizeMB AS DBFileSizeMB,
             dr.[MB TotalSize] AS TotalSpaceInMB,
             dr.[MB free] AS FreeSpaceInMB,  
             CAST((dr.[MB free]/dr.[MB TotalSize]) * 100 AS NUMERIC(5,2)) AS PercentFreeSpace
      FROM #DBInfo2 db
      JOIN #DrvInfo dr ON LEFT(db.PhysicalFileName,LEN(dr.drive)) =  LEFT(dr.drive,LEN(dr.drive)) 
      WHERE db.DatabaseName not in (
      SELECT DatabaseName
      FROM #DBInfo2 DB
      JOIN (SELECT drive FROM #DrvInfo WHERE LEN(drive) > 3) DR 
        ON LEFT(db.PhysicalFileName, LEN(drive)) = DR.drive) 
       AND CAST((dr.[MB free]/dr.[MB TotalSize]) * 100 AS NUMERIC(5,2)) < '+@threshold+'
      UNION ALL
      SELECT  
         db.ServerName Instance,
           db.DatabaseName AS DBName,  
           db.PhysicalFileName AS PhysicalFileLocation, 
           CASE
            WHEN LEN(dr.drive) = 3 THEN LEFT(dr.drive,1)+'+CHAR(39)+':\'+CHAR(39)+'
            ELSE dr.drive+'+CHAR(39)+':\'+CHAR(39)+'
           END AS Drive, 
           db.FileSizeMB AS DBFileSizeMB,
           dr.[MB TotalSize] AS TotalSpaceInMB,
           dr.[MB free] AS FreeSpaceInMB,  
           CAST((dr.[MB free]/dr.[MB TotalSize]) * 100 AS NUMERIC(5,2)) AS PercentFreeSpace
      FROM #DBInfo2 db
      JOIN #DrvInfo dr ON LEFT(db.PhysicalFileName,LEN(dr.drive)) =  LEFT(dr.drive,LEN(dr.drive))
      WHERE LEN(dr.drive) > 3 AND CAST((dr.[MB free]/dr.[MB TotalSize]) * 100 AS NUMERIC(5,2)) < '+@threshold+'
   
      DROP TABLE #DBInfo2
      DROP TABLE #logicaldisk
      DROP TABLE #DrvLetter
      DROP TABLE #DrvInfo
 
      IF @flipped = 1
      BEGIN
         EXEC SP_CONFIGURE '+CHAR(39)+'xp_cmdshell'+CHAR(39)+', 0
         RECONFIGURE
      END
 
      EXEC SP_CONFIGURE '+CHAR(39)+'show advanced options'+CHAR(39)+', 0
      GO
      RECONFIGURE
      GO';
 
   SELECT @query AS tsql;
END
 
GO
PowerShell Script to Collect Free Disk Space for Databases
Here's the code that fetches the disks information against the set of instances that you specify.

The script invokes the stored procedure described above.
By separating the SP from the PowerShell script, you end up with more manageable code in both sides by not having everything crammed into one single script.
$server = "XXX"
$inventoryDB = "XXX"
 
#Create the DiskSpace Table if it doesn't exist in your centralized instance 
#You can remove the 'Monitoring' schema if you want.
$diskSpaceTableCreationQuery = "
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'DiskSpace' AND xtype = 'U')
CREATE TABLE [Monitoring].[DiskSpace](
   [Instance] [nvarchar](50) NULL,
   [DBName] [nvarchar](255) NULL,
   [PhysicalFileLocation] [nvarchar](500) NULL,
   [Drive] [nvarchar](50) NULL,
   [DBFileSizeMB] [int] NULL,
   [TotalSpaceInMB] [int] NULL,
   [FreeSpaceInMB] [int] NULL,
   [PercentFreeSpace] [float] NULL
) ON [PRIMARY]
"
Invoke-Sqlcmd -Query $diskSpaceTableCreationQuery -Database $inventoryDB -ServerInstance $server
 
#Clean the DiskSpace table
Invoke-Sqlcmd -Query "TRUNCATE TABLE Monitoring.DiskSpace" -Database $inventoryDB -ServerInstance $server
 
#Create the thresholds Table if it doesn't exist in your centralized instance
$thresholdsTableCreationQuery = " 
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'thresholds' AND xtype = 'U')
CREATE TABLE [Monitoring].[thresholds](
   [id] [tinyint] IDENTITY(1,1) NOT NULL,
   [item] [varchar](25) NOT NULL,
   [warning_value] [tinyint] NOT NULL,
   [critical_value] [tinyint] NOT NULL,
 CONSTRAINT [PK_thresholds] PRIMARY KEY CLUSTERED 
(
   [id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
"
Invoke-Sqlcmd -Query $thresholdsTableCreationQuery -Database $inventoryDB -ServerInstance $server
 
#Insert the threshold value to set the upper cap that the SP will use to limit the result set (the value won't be inserted if it already exists.
#This is designed this way so that you can use this table to store threshold values for other purposes (CPU, RAM, etc.)
$thresholdValueInsertQuery = "
IF NOT EXISTS (SELECT item FROM Monitoring.thresholds 
               WHERE item = 'disk_space')
BEGIN
   INSERT INTO Monitoring.thresholds VALUES ('disk_space', 50, 10)
END
"
Invoke-Sqlcmd -Query $thresholdvalueInsertQuery -Database $inventoryDB -ServerInstance $server
 
#Fetch all the instances with the respective SQL Server Version
<#
   This is an example of the result set that your query must return
   ##################################################
   # name                     # instance            #
   ##################################################
   # server1.domain.net,45000 # server1             #
   # server1.domain.net,45001 # server1\MSSQLSERVER1#
   # server2.domain.net,45000 # server2             #
   # server3.domain.net,45000 # server3             #
   # server4.domain.net       # server4\MSSQLSERVER2#
   ################################################## 
#>
 
#If you don't have such table in your environment, the following block of code will create it for you. You just simply have to make sure to populate it accordingly.
$instancesTableCreationQuery = "
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'instances' AND xtype = 'U')
CREATE TABLE instances(
   [name] [nvarchar](128) NULL,
   [instance] [nvarchar](128) NULL
) ON [PRIMARY]
"
Invoke-Sqlcmd -Query $instancesTableCreationQuery -Database $inventoryDB -ServerInstance $server
 
$instanceLookupQuery = "SELECT name, instance FROM instances"
 
$instances = Invoke-Sqlcmd -ServerInstance $server -Database $inventoryDB -Query $instanceLookupQuery
 
#For each instance, grab the disk space information
foreach ($instance in $instances){
   $diskSpaceQuery = Invoke-Sqlcmd -ServerInstance $server -Database $inventoryDB -Query "EXEC Monitoring.disk_space" -MaxCharLength 8000
   
   #Go grab the disks information for the instance
   Write-Host "Fetching Disk information for instance" $instance.instance
    $results = Invoke-Sqlcmd -Query $diskSpaceQuery.tsql -ServerInstance $instance.name -ErrorAction Stop -querytimeout 30
 
   #Perform the INSERT in the DiskSpace table only if it returned at least 1 row
   if($results.Length -ne 0){
      #Build the insert statement
      $insert = "INSERT INTO Monitoring.DiskSpace VALUES"
      foreach($result in $results){
         $insert += "
         (
         '"+$result.Instance+"',
         '"+$result.DBName+"',
         '"+$result.PhysicalFileLocation+"',
         '"+$result.Drive+"',
         "+$result.DBFileSizeMB+",
         "+$result.TotalSpaceInMB+",
         "+$result.FreeSpaceInMB+",
         "+$result.PercentFreeSpace+"
         ),
         "
      }
 #Store the results in the local DiskSpace table in your central instance
      Invoke-Sqlcmd -Query $insert.Substring(0,$insert.LastIndexOf(','))-ServerInstance $server -Database $inventoryDB
   } 
}
Write-Host "Done!"