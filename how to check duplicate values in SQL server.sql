

  SELECT id, COUNT(id)
FROM [dbo].[Associate]
GROUP BY Id
HAVING COUNT(id) > 1


select * from [dbo].[Associate]
where id =1921


alter table [dbo].[Campaign1]

add politics varchar(50)null