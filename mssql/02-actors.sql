USE [azure];
GO

/****** Object:  Table [dbo].[analysis_actors]    Script Date: 16/12/2019 02:40:19 ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[analysis_actors]
    (
        [id]         [INT]  NULL,
        [first_name] [TEXT] NULL,
        [last_name]  [TEXT] NULL,
        [gender]     [TEXT] NULL,
        [film_count] [INT]  NULL
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO
