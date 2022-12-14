SELECT 'ALTER DATABASE [' + NAME + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
ALTER DATABASE [' + NAME + '] SET READ_ONLY WITH NO_WAIT
ALTER DATABASE [' + NAME + '] SET MULTI_USER
GO'
FROM sys.databases
/*Setting database id > 4 excludes the system databases*/
WHERE database_id > 4


Use [Group06DB]
ALTER DATABASE [Group06DB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE  
ALTER DATABASE [Group06DB] SET READ_ONLY WITH NO_WAIT  
ALTER DATABASE [Group06DB] SET READ_WRITE WITH NO_WAIT
ALTER DATABASE [Group06DB] SET MULTI_USER  GO

ALTER DATABASE [demodb] SET SINGLE_USER WITH ROLLBACK IMMEDIATE  
ALTER DATABASE [demodb] SET READ_ONLY WITH NO_WAIT  
ALTER DATABASE [demodb] SET MULTI_USER  GO