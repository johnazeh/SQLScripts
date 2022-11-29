select * from [dbo].[City]
select * from [dbo].[Customer]


SELECT * from
[dbo].[City]
inner JOIN [dbo].[Customer]
ON [dbo].[City].[Cityid] = [dbo].[Customer].[Cityid];

SELECT * from
[dbo].[City]
full JOIN [dbo].[Customer]
ON [dbo].[City].[Cityid] = [dbo].[Customer].[Cityid];
