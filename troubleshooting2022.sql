
----use to check queries in the cache .

select * from sys.dm_exec_cached_plans
cross apply sys.dm_exec_query_plan(plan_handle)
cross apply sys.dm_exec_sql_text (plan_handle)


select db_name(dbid) as dbname,
count(dbid) as numberofconnection,
loginame as LoginName 
from sys.sysprocesses
Where dbid>4
group by 

dbid,loginame


---show statistics 

select sp.stats_id,
name,
rows,
rows_sampled,
last_updated,
steps,
Unfiltered_rows,
Modification_counter
from sys.stats as stat
Cross apply sys.dm_db_stats_properties(stat.object_id,stat.stats_id) as sp
where stat.object_id = Object_id('[Person].[Address]')

----Compartable than sql server 2012 add at the end of query
option (use hint('force_lecacy_cardinality_estimation'));