CREATE EVENT SESSION [Wait_time] ON SERVER 
ADD EVENT sqlos.wait_info(
    ACTION(sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(62)))
ADD TARGET package0.ring_buffer
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


