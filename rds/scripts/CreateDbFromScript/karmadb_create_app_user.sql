
USE [master]
GO
-- Replace the Login Username & Password with the values from SSM ParameterStore
-- Login    - /cr-unpaid-work-dev/cr/cporacle/rds/cporacle_app_username	
--          replace all 'cporacle_app' with the username
-- Password - /cr-unpaid-work-dev/cr/cporacle/rds/cporacle_app_password	
--          replace XXXX with the password
-- (update key names to environment specific keyname

CREATE LOGIN [cporacle_app] WITH PASSWORD=N'XXXX', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
USE [Karma]
GO
CREATE USER [cporacle_app] FOR LOGIN [cporacle_app]
GO
USE [Karma]
GO
ALTER ROLE [db_owner] ADD MEMBER [cporacle_app]
GO

