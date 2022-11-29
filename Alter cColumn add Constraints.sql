

ALTER TABLE [dbo].[Persons1]
ADD CONSTRAINT UC_Person1 UNIQUE (LastName);
  

  DROP INDEX [CIX_Persons1_LastName] ON [dbo].[Persons1];