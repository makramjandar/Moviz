USE [azure];
GO

/****** Object:  Table [dbo].[analysis_movies_directors]    Script Date: 16/12/2019 02:47:13 ******/
SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE [dbo].[analysis_movies_directors]
    (
        [director_id] [INT] NULL,
        [movie_id]    [INT] NULL
    ) ON [PRIMARY];
GO
