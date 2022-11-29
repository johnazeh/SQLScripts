USE MASTER

declare databases cursor for select name from sysdatabases where name not in ('master', 'tempdb', 'msdb', 'model', ...any other databases you do not want detached)

declare @db sysname

declare @sql varchar (5000)

open databases

fetch next from databases into @db

while @@fetch_status = 0

begin

-- not 100% sure of the detach db syntax 'coz I do not have access to SQL where I am - it might be incorrect

set @sql = 'sp_detach_db ' + @db

exec (@sql)

fetch next from databases into @db

end

close databases

deallocate databases