USE [azure];
GO

/****** Object:  Table [dbo].[analysis_movies]    Script Date: 16/12/2019 02:45:15 ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[analysis_movies]
    (
        [id]   [INT]   NULL,
        [name] [TEXT]  NULL,
        [year] [INT]   NULL,
        [rank] [FLOAT] NULL
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO
