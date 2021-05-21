USE [master]
GO
/****** Object:  Database [Karma]    Script Date: 23/05/2017 11:19:00 ******/
CREATE DATABASE [Karma]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Karma', FILENAME = N'D:\rdsdbdata\DATA\Karma.mdf' , SIZE = 62464KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Karma_log', FILENAME = N'D:\rdsdbdata\DATA\Karma_log.ldf' , SIZE = 321088KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Karma] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Karma].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Karma] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Karma] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Karma] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Karma] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Karma] SET ARITHABORT OFF 
GO
ALTER DATABASE [Karma] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Karma] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Karma] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Karma] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Karma] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Karma] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Karma] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Karma] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Karma] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Karma] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Karma] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Karma] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Karma] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Karma] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Karma] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Karma] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Karma] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Karma] SET RECOVERY FULL 
GO
ALTER DATABASE [Karma] SET  MULTI_USER 
GO
ALTER DATABASE [Karma] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Karma] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Karma] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Karma] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Karma] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Karma', N'ON'
GO
USE [Karma]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCalcDistanceMiles]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fnCalcDistanceMiles] (@Lat1 decimal(8,4), @Long1 decimal(8,4), @Lat2 decimal(8,4), @Long2 decimal(8,4))
returns decimal (8,4) as
begin
declare @d decimal(28,10)
-- Convert to radians
set @Lat1 = @Lat1 / 57.2958
set @Long1 = @Long1 / 57.2958
set @Lat2 = @Lat2 / 57.2958
set @Long2 = @Long2 / 57.2958
-- Calc distance
set @d = (Sin(@Lat1) * Sin(@Lat2)) + (Cos(@Lat1) * Cos(@Lat2) * Cos(@Long2 - @Long1))
-- Convert to miles
if @d <> 0
begin
set @d = 3958.75 * Atan(Sqrt(1 - power(@d, 2)) / @d);
end
return @d
end 
GO
/****** Object:  Table [dbo].[Absence]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Absence](
	[Id] [uniqueidentifier] NOT NULL,
	[SupervisorId] [uniqueidentifier] NOT NULL,
	[AbsenceTypeId] [uniqueidentifier] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_Absence_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_Absence_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Absence_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_Absence] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AbsenceType]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AbsenceType](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_AbsenceType_Id]  DEFAULT (newid()),
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_AbsenceType_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_AbsenceType_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_AbsenceType_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_AbsenceType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Borough]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Borough](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Borough_Id]  DEFAULT (newid()),
	[Name] [nvarchar](max) NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_Borough_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_Borough_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Borough_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Borough] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InventoryItem]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryItem](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_InventoryItem_Id]  DEFAULT (newid()),
	[Description] [nvarchar](max) NOT NULL,
	[Count] [int] NOT NULL,
	[Required] [int] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[ProjectId] [uniqueidentifier] NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_InventoryItem_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_InventoryItem_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_InventoryItem_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_InventoryItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Postcode]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Postcode](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Postcode] [nvarchar](9) NOT NULL,
	[Latitude] [decimal](8, 6) NOT NULL,
	[Longitude] [decimal](9, 6) NOT NULL,
 CONSTRAINT [PK_Postcode] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Project]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Project_Id]  DEFAULT (newid()),
	[Name] [nvarchar](255) NOT NULL,
	[Address1] [nvarchar](255) NOT NULL,
	[Address2] [nvarchar](255) NOT NULL,
	[Address3] [nvarchar](255) NULL,
	[Address4] [nvarchar](255) NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[ProjectTypeId] [uniqueidentifier] NOT NULL,
	[BoroughId] [uniqueidentifier] NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_Project_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_Project_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Project_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[ProjectCode] [nvarchar](50) NOT NULL,
	[PostcodeId] [int] NOT NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectFlag]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectFlag](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProjectFlag_Id]  DEFAULT (newid()),
	[Name] [nvarchar](max) NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_ProjectFlag_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_ProjectFlag_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectFlag_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_ProjectFlag] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectProjectFlag]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectProjectFlag](
	[ProjectId] [uniqueidentifier] NOT NULL,
	[ProjectFlagId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ProjectProjectFlag] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC,
	[ProjectFlagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectScheduledDay]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectScheduledDay](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProjectScheduledDay_Id]  DEFAULT (newid()),
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[ProjectId] [uniqueidentifier] NOT NULL,
	[Supervisor1Id] [uniqueidentifier] NOT NULL,
	[Supervisor2Id] [uniqueidentifier] NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_ProjectScheduledDay_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_ProjectScheduledDay_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectScheduledDay_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[DayOfWeek] [tinyint] NOT NULL,
 CONSTRAINT [PK_ProjectScheduledDay] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectType]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectType](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProjectType_Id]  DEFAULT (newid()),
	[Name] [nvarchar](max) NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_ProjectType_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_ProjectType_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ProjectType_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_ProjectType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Role]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Role_Id]  DEFAULT (newid()),
	[Name] [nvarchar](max) NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_Role_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_Role_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Role_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schedule](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Schedule_Id]  DEFAULT (newid()),
	[ProjectID] [uniqueidentifier] NOT NULL,
	[Date] [date] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[Supervisor1Id] [uniqueidentifier] NULL,
	[SubSupervisor1Id] [uniqueidentifier] NULL,
	[Supervisor2Id] [uniqueidentifier] NULL,
	[SubSupervisor2Id] [uniqueidentifier] NULL,
	[Notes] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_Schedule_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Schedule_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[AdHoc] [bit] NOT NULL,
 CONSTRAINT [Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ScheduleFlag]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleFlag](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ScheduleFlag_Id]  DEFAULT (newid()),
	[Name] [nvarchar](max) NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_ScheduleFlag_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_ScheduleFlag_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_ScheduleFlag_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_ScheduleFlag] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ScheduleScheduleFlag]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleScheduleFlag](
	[ScheduleId] [uniqueidentifier] NOT NULL,
	[ScheduleFlagId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ScheduleScheduleFlag] PRIMARY KEY CLUSTERED 
(
	[ScheduleId] ASC,
	[ScheduleFlagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Supervisor]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supervisor](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_Supervisor_Id]  DEFAULT (newid()),
	[Surname] [nvarchar](max) NOT NULL,
	[Forename] [nvarchar](max) NOT NULL,
	[Address1] [nvarchar](255) NOT NULL,
	[Address2] [nvarchar](255) NOT NULL,
	[Address3] [nvarchar](255) NULL,
	[Address4] [nvarchar](255) NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[ContractedHours] [decimal](5, 3) NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_Supervisor_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_Supervisor_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_Supervisor_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
	[PostcodeId] [int] NOT NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[Notes] [nvarchar](max) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[PhoneNumber2] [nvarchar](max) NULL,
 CONSTRAINT [PK_Supervisor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SupervisorDay]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorDay](
	[SupervisorId] [uniqueidentifier] NOT NULL,
	[DayOfWeek] [tinyint] NOT NULL,
 CONSTRAINT [PK_SupervisorDay] PRIMARY KEY CLUSTERED 
(
	[SupervisorId] ASC,
	[DayOfWeek] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Id] [uniqueidentifier] NOT NULL CONSTRAINT [DF_User_Id]  DEFAULT (newid()),
	[Surname] [nvarchar](max) NOT NULL,
	[Forename] [nvarchar](max) NOT NULL,
	[AdUsername] [nvarchar](max) NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_User_IsDeleted]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](max) NOT NULL CONSTRAINT [DF_User_CreatedBy]  DEFAULT (user_name()),
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_User_CreatedDate]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](max) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[vw_SupervisorSchedules]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SupervisorSchedules]
AS
/* Supervisor Schedules */
/* Supervisor 1 Schedules*/
SELECT S.Id, FullName = S.Forename + ' ' + S.Surname, S.StartDate, S.EndDate, PC.Longitude, PC.Latitude, P.ProjectCode, ScheduleDate = Sc.Date, SupervisorSlot = '1'
FROM Schedule Sc INNER JOIN
	 Supervisor S ON Sc.Supervisor1Id = S.Id INNER JOIN
	 Postcode PC ON PC.Id = S.PostcodeId INNER JOIN
	 Project P ON P.Id = Sc.ProjectID LEFT OUTER JOIN
	 Supervisor Sub ON Sc.SubSupervisor1Id = Sub.Id
WHERE
	P.IsDeleted <> 1 AND
	Sc.IsDeleted <> 1 AND
	S.IsDeleted <> 1 AND
	(
		Sc.SubSupervisor1Id IS NULL OR Sub.IsDeleted = 1
	)
UNION ALL
/* Supervisor 2 Schedules*/
SELECT S.Id, FullName = S.Forename + ' ' + S.Surname, S.StartDate, S.EndDate, PC.Longitude, PC.Latitude, P.ProjectCode, ScheduleDate = Sc.Date, SupervisorSlot = '2'
FROM Schedule Sc INNER JOIN
	 Supervisor S ON Sc.Supervisor2Id = S.Id INNER JOIN
	 Postcode PC ON PC.Id = S.PostcodeId INNER JOIN
	 Project P ON P.Id = Sc.ProjectID LEFT OUTER JOIN
	 Supervisor Sub ON Sc.SubSupervisor2Id = Sub.Id
WHERE
	P.IsDeleted <> 1 AND
	Sc.IsDeleted <> 1 AND
	S.IsDeleted <> 1 AND
	(
		Sc.SubSupervisor2Id IS NULL OR Sub.IsDeleted = 1
	)
UNION ALL
/* Sub Supervisor 1 Schedules*/
SELECT S.Id, FullName = S.Forename + ' ' + S.Surname, S.StartDate, S.EndDate, PC.Longitude, PC.Latitude, P.ProjectCode, ScheduleDate = Sc.Date, SupervisorSlot = 'Sub1'
FROM Schedule Sc INNER JOIN
	 Supervisor S ON Sc.SubSupervisor1Id = S.Id INNER JOIN
	 Postcode PC ON PC.Id = S.PostcodeId INNER JOIN
	 Project P ON P.Id = Sc.ProjectID
WHERE
	P.IsDeleted <> 1 AND
	Sc.IsDeleted <> 1 AND
	S.IsDeleted <> 1
UNION ALL
/* Sub Supervisor 2 Schedules*/
SELECT S.Id, FullName = S.Forename + ' ' + S.Surname, S.StartDate, S.EndDate, PC.Longitude, PC.Latitude, P.ProjectCode, ScheduleDate = Sc.Date, SupervisorSlot = 'Sub2'
FROM Schedule Sc INNER JOIN
	 Supervisor S ON Sc.SubSupervisor2Id = S.Id INNER JOIN
	 Postcode PC ON PC.Id = S.PostcodeId INNER JOIN
	 Project P ON P.Id = Sc.ProjectID
WHERE
	P.IsDeleted <> 1 AND
	Sc.IsDeleted <> 1 AND
	S.IsDeleted <> 1

GO
/****** Object:  UserDefinedFunction [dbo].[fn_supervisorSchedulesByDate]    Script Date: 23/05/2017 11:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fn_supervisorSchedulesByDate] 
(	
	-- Add the parameters for the function here
	@Date AS DATE
)
RETURNS TABLE 
AS
RETURN 
(
	/* Supevisor's Scheduled Projects by @Date */
	SELECT SupervisorID = S.ID, SP.ProjectCodes, IsScheduledDay = COALESCE(SS.ScheduledDay, SP.ScheduledDay), PC.Latitude, PC.Longitude, S.Notes
	FROM
	(
		SELECT ID, [Date] = ScheduleDate, ScheduledDay = 0,
			STUFF((
				SELECT ', ' + [ProjectCode]
				FROM vw_SupervisorSchedules 
				WHERE ID = Results.ID AND ScheduleDate = Results.ScheduleDate
				FOR XML PATH(''),TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') ProjectCodes
		FROM vw_SupervisorSchedules Results
		WHERE 
			ScheduleDate = @Date
		GROUP BY ID, ScheduleDate
	) SP FULL OUTER JOIN
	/* Supevisor's Scheduled Days by @Date */
	(
		SELECT S.ID, ScheduledDay = 1
		FROM 
			Supervisor S INNER JOIN 
			SupervisorDay SD ON SD.SupervisorId = S.Id
		WHERE
			S.IsDeleted <> 1 AND
			S.StartDate <= @Date AND
			SD.DayOfWeek = ( @@datefirst - 1 + datepart(weekday, @Date) ) % 7 AND 
			(S.EndDate IS NULL OR S.EndDate >= @Date)
	) SS
		ON SP.ID = SS.ID LEFT OUTER JOIN 
	Supervisor S
		ON S.Id = SP.Id OR S.Id = SS.Id INNER JOIN 
	Postcode PC 
		ON PC.Id = S.PostcodeId




)



GO
ALTER TABLE [dbo].[Absence]  WITH CHECK ADD  CONSTRAINT [FK_Absence_AbsenceType] FOREIGN KEY([AbsenceTypeId])
REFERENCES [dbo].[AbsenceType] ([Id])
GO
ALTER TABLE [dbo].[Absence] CHECK CONSTRAINT [FK_Absence_AbsenceType]
GO
ALTER TABLE [dbo].[Absence]  WITH CHECK ADD  CONSTRAINT [FK_Absence_Supervisor] FOREIGN KEY([SupervisorId])
REFERENCES [dbo].[Supervisor] ([Id])
GO
ALTER TABLE [dbo].[Absence] CHECK CONSTRAINT [FK_Absence_Supervisor]
GO
ALTER TABLE [dbo].[InventoryItem]  WITH CHECK ADD  CONSTRAINT [FK_InventoryItem_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[InventoryItem] CHECK CONSTRAINT [FK_InventoryItem_Project]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_Borough] FOREIGN KEY([BoroughId])
REFERENCES [dbo].[Borough] ([Id])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_Borough]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_Postcode] FOREIGN KEY([PostcodeId])
REFERENCES [dbo].[Postcode] ([Id])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_Postcode]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_ProjectType] FOREIGN KEY([ProjectTypeId])
REFERENCES [dbo].[ProjectType] ([Id])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_ProjectType]
GO
ALTER TABLE [dbo].[ProjectProjectFlag]  WITH CHECK ADD  CONSTRAINT [FK_ProjectProjectFlag_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[ProjectProjectFlag] CHECK CONSTRAINT [FK_ProjectProjectFlag_Project]
GO
ALTER TABLE [dbo].[ProjectProjectFlag]  WITH CHECK ADD  CONSTRAINT [FK_ProjectProjectFlag_ProjectFlag] FOREIGN KEY([ProjectFlagId])
REFERENCES [dbo].[ProjectFlag] ([Id])
GO
ALTER TABLE [dbo].[ProjectProjectFlag] CHECK CONSTRAINT [FK_ProjectProjectFlag_ProjectFlag]
GO
ALTER TABLE [dbo].[ProjectScheduledDay]  WITH CHECK ADD  CONSTRAINT [FK_ProjectScheduledDay_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[ProjectScheduledDay] CHECK CONSTRAINT [FK_ProjectScheduledDay_Project]
GO
ALTER TABLE [dbo].[ProjectScheduledDay]  WITH CHECK ADD  CONSTRAINT [FK_ProjectScheduledDay_Supervisor1] FOREIGN KEY([Supervisor1Id])
REFERENCES [dbo].[Supervisor] ([Id])
GO
ALTER TABLE [dbo].[ProjectScheduledDay] CHECK CONSTRAINT [FK_ProjectScheduledDay_Supervisor1]
GO
ALTER TABLE [dbo].[ProjectScheduledDay]  WITH CHECK ADD  CONSTRAINT [FK_ProjectScheduledDay_Supervisor2] FOREIGN KEY([Supervisor2Id])
REFERENCES [dbo].[Supervisor] ([Id])
GO
ALTER TABLE [dbo].[ProjectScheduledDay] CHECK CONSTRAINT [FK_ProjectScheduledDay_Supervisor2]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_Project] FOREIGN KEY([ProjectID])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_Project]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_SubSupervisor1] FOREIGN KEY([SubSupervisor1Id])
REFERENCES [dbo].[Supervisor] ([Id])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_SubSupervisor1]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_SubSupervisor2] FOREIGN KEY([SubSupervisor2Id])
REFERENCES [dbo].[Supervisor] ([Id])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_SubSupervisor2]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_Supervisor1] FOREIGN KEY([Supervisor1Id])
REFERENCES [dbo].[Supervisor] ([Id])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_Supervisor1]
GO
ALTER TABLE [dbo].[Schedule]  WITH CHECK ADD  CONSTRAINT [FK_Schedule_Supervisor2] FOREIGN KEY([Supervisor2Id])
REFERENCES [dbo].[Supervisor] ([Id])
GO
ALTER TABLE [dbo].[Schedule] CHECK CONSTRAINT [FK_Schedule_Supervisor2]
GO
ALTER TABLE [dbo].[ScheduleScheduleFlag]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleScheduleFlag_Schedule] FOREIGN KEY([ScheduleId])
REFERENCES [dbo].[Schedule] ([Id])
GO
ALTER TABLE [dbo].[ScheduleScheduleFlag] CHECK CONSTRAINT [FK_ScheduleScheduleFlag_Schedule]
GO
ALTER TABLE [dbo].[ScheduleScheduleFlag]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleScheduleFlag_ScheduleFlag] FOREIGN KEY([ScheduleFlagId])
REFERENCES [dbo].[ScheduleFlag] ([Id])
GO
ALTER TABLE [dbo].[ScheduleScheduleFlag] CHECK CONSTRAINT [FK_ScheduleScheduleFlag_ScheduleFlag]
GO
ALTER TABLE [dbo].[Supervisor]  WITH CHECK ADD  CONSTRAINT [FK_Supervisor_Postcode] FOREIGN KEY([PostcodeId])
REFERENCES [dbo].[Postcode] ([Id])
GO
ALTER TABLE [dbo].[Supervisor] CHECK CONSTRAINT [FK_Supervisor_Postcode]
GO
ALTER TABLE [dbo].[SupervisorDay]  WITH CHECK ADD  CONSTRAINT [FK_SupervisorDay_Supervisor] FOREIGN KEY([SupervisorId])
REFERENCES [dbo].[Supervisor] ([Id])
GO
ALTER TABLE [dbo].[SupervisorDay] CHECK CONSTRAINT [FK_SupervisorDay_Supervisor]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_Role]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SupervisorSchedules'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SupervisorSchedules'
GO
USE [master]
GO
ALTER DATABASE [Karma] SET  READ_WRITE 
GO
