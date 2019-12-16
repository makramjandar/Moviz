USE [azure];
GO

/****** Object:  Table [dbo].[analysis_directors_genres]    Script Date: 16/12/2019 02:43:00 ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[analysis_directors_genres]
    (
        [director_id] [INT]   NULL,
        [genre]       [TEXT]  NULL,
        [prob]        [FLOAT] NULL
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO
