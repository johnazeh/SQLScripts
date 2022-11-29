
----First step create a table to store trigger results 
CREATE TABLE [dbo].[Check_info](
	[first_name] [nvarchar](50) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[company_name] [nvarchar](50) NOT NULL,
	[address] [nvarchar](50) NOT NULL,
	[city] [nvarchar](50) NOT NULL,
	[county] [nvarchar](50) NULL,
	[state] [nvarchar](50) NOT NULL,
	[zip] [nchar](10) NOT NULL,
	[phone1] [nvarchar](50) NOT NULL,
	[phone2] [nvarchar](50) NOT NULL,
	[email] [nvarchar](50) NOT NULL,
	[web] [nvarchar](50) NOT NULL,
	[ID] [int] NOT NULL,
	updated_at DATETIME NOT NULL,
    operation CHAR(3) NOT NULL,
  CHECK(operation = 'INS' or operation='DEL')
);


----create trigger 

CREATE TRIGGER [Check.trg_info]

ON [dbo].[USCA]

AFTER INSERT, DELETE
AS
BEGIN
SET NOCOUNT ON;

INSERT INTO [dbo].[Check_info](
        [first_name],
	[last_name],
	[company_name] ,
	[address],
	[city],
	[county],
	[state],
	[zip],
	[phone1],
	[phone2],
	[email] ,
	[web], 
	[ID],        updated_at, 
        operation
    )
    SELECT
        i.[first_name],
	[last_name],
[company_name],
[address],
[city],
[county],
[state],
[zip],
[phone1],
[phone2],
[email],
[web],
i.[ID], 

        GETDATE(),
        'INS'
    FROM
        inserted i
    UNION ALL
    SELECT
        d.[first_name],
	[last_name],
	[company_name] ,
	[address],
	[city],
	[county],
	[state],
	[zip],
	[phone1],
	[phone2],
	[email] ,
	web, 
      d.[ID],  
	  GETDATE(),
        'DEL'
    FROM
        deleted d;
END

-----test trigger 

select * from [dbo].[Check_info]


select * from [dbo].[USCA]

Alter table [dbo].[USCA] 
add Country varchar(50)

insert into USCA values ('JOHN','MIKE','ABC','AD1234','YAOUNDE','NULL','AB','12365','78080','','','','','Canada')


Delete from USCA where ID =  0

Alter table [dbo].[USCA] 
DROP Country 
