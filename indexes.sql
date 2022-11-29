

select id from dbo.users


select id from dbo.users
Where LastAccessDate > '1800/01/01'


select id from dbo.users WITH (INDEX =1)
Where LastAccessDate > '2014/07/01'

Order by [LastAccessDate]


select* from dbo.users
Where LastAccessDate > '2014/07/01'

Order by [LastAccessDate];
GO 100


Create Index IX_LastAccessDate_Id
ON [dbo].[Users](LastAccessDate,Id)



select id,[DisplayName],[Age] from dbo.users 
Where LastAccessDate > '2014/07/01'
Order by [LastAccessDate]


select id,[DisplayName],[Age] from dbo.users  with (INDEX =[IX_LastAccessDate_Id])
Where LastAccessDate > '2014/07/01'
Order by [LastAccessDate]

DBCC SHOW_STATISTICS('dbo.Users','IX_LastAccessDate_Id')

select id,[DisplayName],[Age] from dbo.users  
Where LastAccessDate >= '2014/07/01'
and LastAccessDate < '2014/08/01'
Order by [LastAccessDate]

select id,[DisplayName],[Age] from dbo.users with(index =IX_LastAccessDate_Id_displayName_Age) 
Where Year(LastAccessDate) = '2014'
and month (LastAccessDate) = '7'
Order by [LastAccessDate] 



Create Index IX_LastAccessDate_Id_displayName_Age
ON [dbo].[Users](LastAccessDate,Id,DisplayName)

sp_blitzindex @TableName = 'Users'

set statistics io on

ALTER TABLE [StackOverflow2010].[dbo].[Users] REBUILD;

DROP INDEX [Unknown] ON [StackOverflow2010].[dbo].[Users];