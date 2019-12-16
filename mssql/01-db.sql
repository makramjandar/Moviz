USE [master];
GO

/****** Object:  Database [azure]    Script Date: 16/12/2019 02:51:49 ******/
CREATE DATABASE [azure] CONTAINMENT = NONE
    ON PRIMARY
           (
               NAME = N'azure_Data',
               FILENAME = N'/var/opt/mssql/data\azure.mdf',
               SIZE = 8192KB,
               MAXSIZE = UNLIMITED,
               FILEGROWTH = 1024KB
           )
    LOG ON
        (
            NAME = N'azure_Log',
            FILENAME = N'/var/opt/mssql/data\azure.ldf',
            SIZE = 8192KB,
            MAXSIZE = 2048GB,
            FILEGROWTH = 10%
        )
    WITH CATALOG_COLLATION=DATABASE_DEFAULT;
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
    BEGIN
        EXEC [azure].[sys].[sp_fulltext_database]
            @action = 'enable';
    END;
GO

ALTER DATABASE [azure]
    SET
        ANSI_NULL_DEFAULT OFF;
GO

ALTER DATABASE [azure]
    SET
        ANSI_NULLS OFF;
GO

ALTER DATABASE [azure]
    SET
        ANSI_PADDING OFF;
GO

ALTER DATABASE [azure]
    SET
        ANSI_WARNINGS OFF;
GO

ALTER DATABASE [azure]
    SET
        ARITHABORT OFF;
GO

ALTER DATABASE [azure]
    SET
        AUTO_CLOSE OFF;
GO

ALTER DATABASE [azure]
    SET
        AUTO_SHRINK OFF;
GO

ALTER DATABASE [azure]
    SET
        AUTO_UPDATE_STATISTICS ON;
GO

ALTER DATABASE [azure]
    SET
        CURSOR_CLOSE_ON_COMMIT OFF;
GO

ALTER DATABASE [azure]
    SET
        CURSOR_DEFAULT GLOBAL;
GO

ALTER DATABASE [azure]
    SET
        CONCAT_NULL_YIELDS_NULL OFF;
GO

ALTER DATABASE [azure]
    SET
        NUMERIC_ROUNDABORT OFF;
GO

ALTER DATABASE [azure]
    SET
        QUOTED_IDENTIFIER OFF;
GO

ALTER DATABASE [azure]
    SET
        RECURSIVE_TRIGGERS OFF;
GO

ALTER DATABASE [azure]
    SET
        ENABLE_BROKER;
GO

ALTER DATABASE [azure]
    SET
        AUTO_UPDATE_STATISTICS_ASYNC OFF;
GO

ALTER DATABASE [azure]
    SET
        DATE_CORRELATION_OPTIMIZATION OFF;
GO

ALTER DATABASE [azure]
    SET
        TRUSTWORTHY OFF;
GO

ALTER DATABASE [azure]
    SET
        ALLOW_SNAPSHOT_ISOLATION ON;
GO

ALTER DATABASE [azure]
    SET
        PARAMETERIZATION SIMPLE;
GO

ALTER DATABASE [azure]
    SET
        READ_COMMITTED_SNAPSHOT ON;
GO

ALTER DATABASE [azure]
    SET
        HONOR_BROKER_PRIORITY OFF;
GO

ALTER DATABASE [azure]
    SET
        RECOVERY FULL;
GO

ALTER DATABASE [azure]
    SET
        MULTI_USER;
GO

ALTER DATABASE [azure]
    SET
        PAGE_VERIFY CHECKSUM;
GO

ALTER DATABASE [azure]
    SET
        DB_CHAINING OFF;
GO

ALTER DATABASE [azure]
    SET
        FILESTREAM
            (
                NON_TRANSACTED_ACCESS = OFF
            );
GO

ALTER DATABASE [azure]
    SET
        TARGET_RECOVERY_TIME = 60 SECONDS;
GO

ALTER DATABASE [azure]
    SET
        DELAYED_DURABILITY = DISABLED;
GO

ALTER DATABASE [azure]
    SET
        QUERY_STORE = ON;
GO

ALTER DATABASE [azure]
    SET
        QUERY_STORE
            (
                OPERATION_MODE = READ_WRITE,
                CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30),
                DATA_FLUSH_INTERVAL_SECONDS = 900,
                INTERVAL_LENGTH_MINUTES = 60,
                MAX_STORAGE_SIZE_MB = 100,
                QUERY_CAPTURE_MODE = AUTO,
                SIZE_BASED_CLEANUP_MODE = AUTO,
                MAX_PLANS_PER_QUERY = 200,
				WAIT_STATS_CAPTURE_MODE = ON
            );
GO

ALTER DATABASE [azure]
    SET
        READ_WRITE;
GO


