SP_whoIsActive

select top (50)
st.text As Query,
qs.total_worker_time,
qs.execution_count

from sys.dm_exec_query_stats as qs
cross apply  sys.dm_exec_sql_text(qs.sql_handle)as st
Order by qs.total_worker_time Desc