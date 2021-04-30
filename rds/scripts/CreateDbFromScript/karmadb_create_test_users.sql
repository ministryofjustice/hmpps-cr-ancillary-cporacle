USE [Karma]
GO

DECLARE @myid uniqueidentifier  
SET @myid = NEWID()  
PRINT 'Value of @myid is: '+ CONVERT(varchar(255), @myid)  

DECLARE @RoleId uniqueidentifier 
SELECT @RoleId = Id FROM dbo.Role WHERE Name = 'Admin';
PRINT 'Value of @RoleId is: '+ CONVERT(varchar(255), @RoleId)  

DECLARE @CurrentUser VARCHAR(255)
SELECT @CurrentUser=  CURRENT_USER
PRINT 'Value of @CurrentUser is: '+ @CurrentUser 

-- Update HOSTNAME with the Name of the test windows client - Normally the IIS AppServer
INSERT INTO [dbo].[User]
           ([Id]
           ,[Surname]
           ,[Forename]
           ,[AdUsername]
           ,[RoleId]
           ,[IsDeleted]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate])
     VALUES
           (
		   @myid
           ,'TestUser'
           ,'Administrator'
           ,'HOSTNAME\Administrator'
           ,@RoleId
           ,0
           ,@CurrentUser 
           ,GETDATE()
           ,@CurrentUser 
           ,GETDATE()
	)
GO
SELECT * 
FROM dbo.[User]
GO