USE [azure];
GO

/****** Object:  Table [dbo].[analysis_roles]    Script Date: 16/12/2019 02:49:40 ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[analysis_roles]
    (
        [actor_id] [INT]  NULL,
        [movie_id] [INT]  NULL,
        [role]     [TEXT] NULL
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO
