SELECT
    fk.name 'FK Name',
    tp.name 'Parent table',
    cp.name, cp.column_id,
    tr.name 'Refrenced table',
    cr.name, cr.column_id
FROM 
    sys.foreign_keys fk
INNER JOIN 
    sys.tables tp ON fk.parent_object_id = tp.object_id
INNER JOIN 
    sys.tables tr ON fk.referenced_object_id = tr.object_id
INNER JOIN 
    sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
INNER JOIN 
    sys.columns cp ON fkc.parent_column_id = cp.column_id AND fkc.parent_object_id = cp.object_id
INNER JOIN 
    sys.columns cr ON fkc.referenced_column_id = cr.column_id AND fkc.referenced_object_id = cr.object_id
ORDER BY
    tp.name, cp.column_id


	select * from [dbo].[CountryInfo]
	where ID = 2001 




SELECT [first_name],[last_name],[ID],[city],[phone1],[email]
FROM [dbo].[USCA]
WHERE [ID] = 2135 


Select [dbo].[USCA].[ID], [dbo].[CountryInfo].[CountryName]
FROM [dbo].[USCA], 
INNER JOIN [dbo].[CountryInfo]
 ON USCA.ID = CountryInfo.ID;


 SELECT [dbo].[USCA].[first_name],[dbo].[USCA].[last_name],[dbo].[CountryInfo].[CountryName],[CountryInfo].[ID]
FROM [dbo].[USCA]
FULL OUTER JOIN [dbo].[CountryInfo] ON [dbo].[USCA].ID=[dbo].[CountryInfo].ID
ORDER BY [dbo].[USCA].[first_name];






----Full outer join both tables with selected columns 

Select [dbo].[USCA].[first_name],[dbo].[USCA].[last_name],[dbo].[USCA].[city],[dbo].[CountryInfo].[CountryName],[CountryInfo].[ID]
From[dbo].[USCA]
Full outer join [dbo].[CountryInfo] on [dbo].[USCA].[ID] =[dbo].[CountryInfo].[ID]
Order by [dbo].[USCA].[last_name]



------if you are trying to retrieve information for a particular person 
select [ID],[first_name],[last_name] from[dbo].[USCA]
where ID = 2003



