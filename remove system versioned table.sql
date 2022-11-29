ALTER TABLE [dbo].[CampaignInstance] SET (SYSTEM_VERSIONING = OFF)
GO
ALTER TABLE [dbo].[CampaignInstance]
DROP PERIOD FOR SYSTEM_TIME
GO
DROP TABLE  [dbo].[Associate]
DROP TABLE [dbo].[AssociateHistory]


