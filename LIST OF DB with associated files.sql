SELECT * FROM sys.database_files

SELECT sd.NAME
,smf.NAME
,smf.type_desc
,(CAST(smf.size AS FLOAT) * 8096) AS SizeBytes
,(CAST(smf.size AS FLOAT) * 8096) / (1024) AS SizeKB
,(CAST(smf.size AS FLOAT) * 8096) / (1024 * 1024) AS SizeMB
,(CAST(smf.size AS FLOAT) * 8096) / (1024 * 1024 * 1024) AS SizeGB
,smf.physical_name
,sd.log_reuse_wait_desc
,sd.recovery_model_desc
,*
FROM sys.databases sd
INNER JOIN sys.master_files smf ON sd.database_id = smf.database_id
WHERE
smf.type_desc IN (
    'ROWS'
    ,'LOG'
    )
ORDER BY SizeGB DESC