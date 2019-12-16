USE [azure]
GO
/****** Object:  UserDefinedFunction [dbo].[tvfBI]    Script Date: 16/12/2019 02:29:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Makram Jandar
-- Create date: 13/12/2019 16:21:06
-- Description:	BI Function
-- =============================================
ALTER FUNCTION [dbo].[tvfBI]
    ()
RETURNS @BI TABLE
    (
        [Id]          INT           NOT NULL INDEX [IXUDFBIMDA] UNIQUE CLUSTERED ([Genre], [Director], [Actor], [Movie]),
        [Num]         INT           NOT NULL,
        [Movie]       VARCHAR(99)   NOT NULL INDEX [IXUDFBIMOV] NONCLUSTERED,
        [Year]        SMALLINT      NOT NULL,
        [Rank]        DECIMAL(4, 2) NULL,
        [Director]    VARCHAR(99)   NOT NULL INDEX [IXUDFBIDIR] NONCLUSTERED,
        [Role]        VARCHAR(99)   NOT NULL,
        [Actor]       VARCHAR(99)   NOT NULL INDEX [IXUDFBIACT] NONCLUSTERED,
        [Gender]      VARCHAR(1)    NOT NULL,
        [Apparitions] TINYINT       NOT NULL,
        [Genre]       VARCHAR(99)   NOT NULL INDEX [IXUDFBIGEN] NONCLUSTERED,
        [Prob]        DECIMAL(4, 3) NULL
    )
    BEGIN
        INSERT INTO @BI
                    SELECT
                        [BI].[Id],
                        [BI].[Num],
                        [BI].[Movie],
                        [BI].[Year],
                        [BI].[Rank],
                        [BI].[Director],
                        [BI].[Role],
                        [BI].[Actor],
                        [BI].[Gender],
                        [BI].[Apparitions],
                        [BI].[Genre],
                        [BI].[Prob]
                    FROM
                        (
                            SELECT
                                        ROW_NUMBER() OVER (ORDER BY
                                                               [AM].[id]
                                                          )               AS [Id],
                                        [AM].[id]                         AS [Num],
                                        CONVERT(VARCHAR(99), [AM].[name]) AS [Movie],
                                        [AM].[year]                       AS [Year],
                                        [AM].[rank]                       AS [Rank],
                                        [DI].[Director],
                                        CONVERT(VARCHAR(99), [AR].[role]) AS [Role],
                                        [AC].[Actor],
                                        [AC].[Gender],
                                        [AC].[Apparitions],
                                        [GE].[Genre],
                                        [DG].[prob]                       AS [Prob]
                            FROM
                                        (
                                            SELECT
                                                CONVERT(INT, CONVERT(VARCHAR(99), [movie_id])) AS [id],
                                                CONVERT(VARCHAR(99), [genre])                  AS [Genre]
                                            FROM
                                                [dbo].[analysis_movies_genres]
                                        )                       AS [GE]
                                RIGHT OUTER JOIN
                                        [dbo].[analysis_movies] AS [AM]
                                            ON [GE].[id] = [AM].[id]
                                RIGHT OUTER JOIN
                                        (
                                            SELECT
                                                [id],
                                                CONVERT(VARCHAR(42), [first_name]) + ' '
                                                + CONVERT(VARCHAR(42), [last_name]) AS [Actor],
                                                CONVERT(VARCHAR(1), [gender])       AS [Gender],
                                                [film_count]                        AS [Apparitions]
                                            FROM
                                                [dbo].[analysis_actors]
                                        )                      AS [AC]
                                    RIGHT OUTER JOIN
                                        [dbo].[analysis_roles] AS [AR]
                                            ON [AC].[id] = [AR].[actor_id]
                                            ON [AM].[id] = [AR].[movie_id]
                                RIGHT OUTER JOIN
                                        (
                                            SELECT
                                                [id],
                                                CONVERT(VARCHAR(42), [first_name]) + ' '
                                                + CONVERT(VARCHAR(42), [last_name]) AS [Director]
                                            FROM
                                                [dbo].[analysis_directors]
                                        )                                 AS [DI]
                                    RIGHT OUTER JOIN
                                        [dbo].[analysis_movies_directors] AS [MD]
                                            ON [DI].[id] = [MD].[director_id]
                                            ON [AM].[id] = [MD].[movie_id]
                                LEFT OUTER JOIN
                                        (
                                            SELECT
                                                [director_id],
                                                CONVERT(VARCHAR(99), [genre]) AS [Genre],
                                                [prob]
                                            FROM
                                                [dbo].[analysis_directors_genres]
                                        )                       AS [DG]
                                            ON [GE].[Genre] = [DG].[Genre]
                                               AND [DI].[id] = [DG].[director_id]
                        )
AS                  [BI];
        RETURN;
    END;
