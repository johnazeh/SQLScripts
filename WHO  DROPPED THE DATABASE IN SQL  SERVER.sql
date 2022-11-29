SELECT
Operation,
SUSER_SNAME([Transaction SID]) As UserName,
[Transaction Name],
[Begin Time],
[SPID],
Description
FROM fn_dblog (NULL, NULL)
WHERE [Transaction Name] = 'dbdestroy'