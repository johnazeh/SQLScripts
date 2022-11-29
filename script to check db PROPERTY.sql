select 
 sysDB.database_id,
 sysDB.Name as 'Database Name',
 syslogin.Name as 'DB Owner',
 sysDB.state_desc,
 sysDB.recovery_model_desc,
 sysDB.collation_name, 
 sysDB.user_access_desc,
 sysDB.compatibility_level, 
 sysDB.is_read_only,
 sysDB.is_auto_close_on,
 sysDB.is_auto_shrink_on,
 sysDB.is_auto_create_stats_on,
 sysDB.is_auto_update_stats_on,
 sysDB.is_fulltext_enabled,
 sysDB.is_trustworthy_on
from sys.databases sysDB
INNER JOIN sys.syslogins syslogin ON sysDB.owner_sid = syslogin.sid