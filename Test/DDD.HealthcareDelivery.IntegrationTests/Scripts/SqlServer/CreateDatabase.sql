/****** Object:  Database [Test]    Script Date: 16/08/2017 12:09:20 ******/
USE [master]
GO
IF EXISTS(SELECT * FROM [sys].[databases] where [name] = 'Test')
begin
ALTER DATABASE [Test] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE [Test]
end
GO
CREATE DATABASE [Test]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Test', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Test.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Test_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Test_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Test] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Test].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Test] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Test] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Test] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Test] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Test] SET ARITHABORT OFF 
GO
ALTER DATABASE [Test] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Test] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Test] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Test] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Test] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Test] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Test] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Test] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Test] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Test] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Test] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Test] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Test] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Test] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Test] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Test] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Test] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Test] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Test] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Test] SET  MULTI_USER 
GO
ALTER DATABASE [Test] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Test] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Test] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Test] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Test]
GO
/****** Object:  Sequence [dbo].[EventId]    Script Date: 16/08/2017 12:09:20 ******/
CREATE SEQUENCE [dbo].[EventId] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO
/****** Object:  Sequence [dbo].[PrescMedicationId]    Script Date: 16/08/2017 12:09:20 ******/
CREATE SEQUENCE [dbo].[PrescMedicationId] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
/****** Object:  Sequence [dbo].[PrescriptionId]    Script Date: 16/08/2017 12:09:20 ******/
CREATE SEQUENCE [dbo].[PrescriptionId] 
 AS [int]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -2147483648
 MAXVALUE 2147483647
 CACHE 
GO
/****** Object:  StoredProcedure [dbo].[spClearDatabase]    Script Date: 16/08/2017 12:09:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spClearDatabase]
AS
BEGIN
	SET NOCOUNT ON
	EXEC sys.sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
	EXEC sys.sp_MSforeachtable 'DELETE FROM ?'
	EXEC sys.sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL'
	EXEC sys.sp_MSforeachtable 'IF OBJECTPROPERTY(object_id(''?''), ''TableHasIdentity'') = 1 DBCC CHECKIDENT (''?'', RESEED, 0)'
	DECLARE @restartseq nvarchar(max)
	DECLARE rcursor CURSOR 
	FOR 
	SELECT
	  'ALTER SEQUENCE '
	+  QUOTENAME(schema_name(schema_id))
	+  '.'
	+  QUOTENAME(name)
	+  ' RESTART'
	FROM sys.sequences
	OPEN rcursor
	FETCH NEXT FROM rcursor INTO @restartseq
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		EXEC sp_executesql @restartseq
		FETCH NEXT FROM rcursor INTO @restartseq
	END
	CLOSE rcursor
	DEALLOCATE rcursor
	END

GO
/****** Object:  Table [dbo].[Event]    Script Date: 16/08/2017 12:09:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Event](
	[EventId] [bigint] NOT NULL DEFAULT (NEXT VALUE FOR [EventId]),
	[EventType] [varchar](250) NOT NULL,
	[Version] [tinyint] NOT NULL,
	[OccurredOn] [datetime2](3) NOT NULL,
	[Body] [varchar](max) NOT NULL,
	[BodyFormat] [varchar](20) NOT NULL,
	[StreamId] [varchar](50) NOT NULL,
	[StreamType] [varchar](50) NOT NULL,
	[IssuedBy] [varchar](100) NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PrescMedication]    Script Date: 16/08/2017 12:09:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PrescMedication](
	[PrescMedicationId] [int] NOT NULL DEFAULT (NEXT VALUE FOR [PrescMedicationId]),
	[PrescriptionId] [int] NOT NULL,
	[MedicationType] [varchar](20) NOT NULL,
	[NameOrDesc] [varchar](1024) NOT NULL,
	[Posology] [varchar](1024) NULL,
	[Quantity] [tinyint] NULL,
	[Code] [varchar](20) NULL,
 CONSTRAINT [PK_PrescMedication] PRIMARY KEY CLUSTERED 
(
	[PrescMedicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Prescription]    Script Date: 16/08/2017 12:09:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Prescription](
	[PrescriptionId] [int] NOT NULL,
	[PrescriptionType] [varchar](5) NOT NULL,
	[Status] [char](3) NOT NULL,
	[Language] [char](2) NOT NULL,
	[CreatedOn] [smalldatetime] NOT NULL,
	[DeliverableAt] [date] NULL,
	[PrescriberId] [int] NOT NULL,
	[PrescriberType] [varchar](20) NOT NULL,
	[PrescriberLastName] [varchar](50) NOT NULL,
	[PrescriberFirstName] [varchar](50) NOT NULL,
    [PrescriberDisplayName] [varchar](100) NOT NULL,
	[PrescriberLicenseNum] [varchar](25) NOT NULL,
	[PrescriberSSN] [varchar](25) NULL,
	[PrescriberSpeciality] [varchar](50) NULL,
	[PrescriberPhone1] [varchar](20) NULL,
	[PrescriberPhone2] [varchar](20) NULL,
	[PrescriberEmail1] [varchar](50) NULL,
	[PrescriberEmail2] [varchar](50) NULL,
	[PrescriberWebSite] [varchar](255) NULL,
	[PrescriberStreet] [varchar](50) NULL,
	[PrescriberHouseNum] [varchar](10) NULL,
	[PrescriberBoxNum] [varchar](10) NULL,
	[PrescriberPostCode] [varchar](10) NULL,
	[PrescriberCity] [varchar](50) NULL,
	[PrescriberCountry] [char](2) NULL,
	[PatientId] [int] NOT NULL,
	[PatientFirstName] [varchar](50) NOT NULL,
	[PatientLastName] [varchar](50) NOT NULL,
	[PatientSex] [varchar](2) NOT NULL,
	[PatientSSN] [varchar](25) NULL,
	[PatientBirthdate] [date] NULL,
	[EncounterId] [int],
 CONSTRAINT [PK_Prescription] PRIMARY KEY CLUSTERED 
(
	[PrescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [IX_PrescriptionId]    Script Date: 16/08/2017 12:09:20 ******/
CREATE NONCLUSTERED INDEX [IX_PrescriptionId] ON [dbo].[PrescMedication]
(
	[PrescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PrescMedication]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.PrescMedication_dbo.Prescription_PrescriptionId] FOREIGN KEY([PrescriptionId])
REFERENCES [dbo].[Prescription] ([PrescriptionId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PrescMedication] CHECK CONSTRAINT [FK_dbo.PrescMedication_dbo.Prescription_PrescriptionId]
GO
USE [master]
GO
ALTER DATABASE [Test] SET  READ_WRITE 
GO
