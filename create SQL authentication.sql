

create user [john.azeh] from external provider
-----use master
create login john with password ='Tumenta01'

CREATE USER [john]
FROM LOGIN [john]
WITH DEFAULT_SCHEMA=dbo;


-- add user to database role(s) (i.e. db_owner)
ALTER ROLE db_owner ADD MEMBER [john];