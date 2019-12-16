USE [azure];
GO

/****** Object:  Table [dbo].[analysis_movies_genres]    Script Date: 16/12/2019 02:48:39 ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[analysis_movies_genres]
    (
        [movie_id] [TEXT] NULL,
        [genre]    [TEXT] NULL
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];
GO
