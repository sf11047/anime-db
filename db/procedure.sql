DELIMITER //

DROP PROCEDURE IF EXISTS PopByGenre //

CREATE PROCEDURE PopByGenre(IN genre VARCHAR(30))
BEGIN
    IF genre = "ALL" THEN
WITH PopularByGenre AS (
        SELECT MIN(AllMedia.rank) AS rank, BelongsTo.genreName 
        FROM AllMedia JOIN BelongsTo on AllMedia.mediaID = BelongsTo.mediaID
        GROUP BY BelongsTo.genreName)
SELECT PopularByGenre.genreName, AllMedia.mediaID, AllMedia.titleJPN, AllMedia.synopsis, AllMedia.rank, AllMedia.startDate, AllMedia.source
FROM BelongsTo JOIN AllMedia ON BelongsTo.mediaID = AllMedia.mediaID JOIN PopularByGenre ON PopularByGenre.genreName = BelongsTo.genreName AND PopularByGenre.rank = AllMedia.rank;
    ELSEIF EXISTS(SELECT genre FROM Genre WHERE genre = Genre.genreName) THEN
WITH PopularByGenre AS (
        SELECT MIN(AllMedia.rank) AS rank, BelongsTo.genreName 
        FROM AllMedia JOIN BelongsTo on AllMedia.mediaID = BelongsTo.mediaID
        GROUP BY BelongsTo.genreName)
SELECT PopularByGenre.genreName, AllMedia.mediaID, AllMedia.titleJPN, AllMedia.synopsis, AllMedia.rank, AllMedia.startDate, AllMedia.source
FROM BelongsTo JOIN AllMedia ON BelongsTo.mediaID = AllMedia.mediaID JOIN PopularByGenre ON PopularByGenre.genreName = BelongsTo.genreName AND PopularByGenre.rank = AllMedia.rank WHERE PopularByGenre.genreName = genre;
    END IF;
END; //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS PopularSource //

CREATE PROCEDURE PopularSource()
BEGIN
SELECT AllMedia.source AS sourceType, COUNT(AllMedia.mediaID) AS numShows
FROM AllMedia
WHERE AllMedia.rank <= 1000 AND (AllMedia.source = "Manga" OR AllMedia.source = "Original")
GROUP BY AllMedia.source;
END; //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS PopularStudios //

CREATE PROCEDURE PopularStudios()
BEGIN
SELECT AVG(AllMedia.rank) AS avgShowRank, Animates.studioName 
FROM AllMedia JOIN Animates ON AllMedia.mediaID = Animates.mediaID
WHERE AllMedia.rank IS NOT NULL
GROUP BY Animates.studioName
ORDER BY avgShowRank ASC
LIMIT 50;
END; //

DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS PopularByStatus //

CREATE PROCEDURE PopularByStatus(IN stat VARCHAR(30))
BEGIN
    IF stat = "All" THEN
WITH UserCounts AS (
        SELECT COUNT(SetStatus.mediaID) AS usersWithStatus, SetStatus.mediaID, SetStatus.status
        FROM SetStatus
        GROUP BY SetStatus.mediaID, SetStatus.status
), MaxStatusCount AS (
        SELECT MAX(UserCounts.usersWithStatus) AS maxUserCount, UserCounts.status
        FROM UserCounts
        GROUP BY UserCounts.status
)
SELECT MaxStatusCount.status, UserCounts.usersWithStatus AS usersWithStatus, AllMedia.titleJPN, AllMedia.synopsis, AllMedia.rank, AllMedia.source, AllMedia.startDate 
FROM MaxStatusCount JOIN UserCounts ON MaxStatusCount.status = UserCounts.status AND MaxStatusCount.maxUserCount = UserCounts.usersWithStatus
JOIN AllMedia ON UserCounts.mediaID = AllMedia.mediaID
WHERE MaxStatusCount.status != "0";
    ELSE
    WITH UserCounts AS (
        SELECT COUNT(SetStatus.mediaID) AS usersWithStatus, SetStatus.mediaID, SetStatus.status
        FROM SetStatus
        GROUP BY SetStatus.mediaID, SetStatus.status
), MaxStatusCount AS (
        SELECT MAX(UserCounts.usersWithStatus) AS maxUserCount, UserCounts.status
        FROM UserCounts
        GROUP BY UserCounts.status
)
SELECT MaxStatusCount.status, UserCounts.usersWithStatus AS usersWithStatus, AllMedia.titleJPN, AllMedia.synopsis, AllMedia.rank, AllMedia.source, AllMedia.startDate 
FROM MaxStatusCount JOIN UserCounts ON MaxStatusCount.status = UserCounts.status AND MaxStatusCount.maxUserCount = UserCounts.usersWithStatus
JOIN AllMedia ON UserCounts.mediaID = AllMedia.mediaID
WHERE MaxStatusCount.status != "0" AND MaxStatusCount.status = stat;
    END IF;
END; //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS HighestReviewCategory //

CREATE PROCEDURE HighestReviewCategory()
BEGIN
WITH BestCategory AS (
        WITH AvgRatings AS (
                SELECT AVG(overallRating) AS overall, AVG(storyRating) AS story, AVG(animationRating) AS animation, AVG(characterRating) AS chara, AVG(soundRating) AS sound, AVG(enjoymentRating) AS enjoyment, AllMedia.mediaID 
                FROM AllMedia JOIN Reviews ON AllMedia.mediaID = Reviews.mediaID
                WHERE AllMedia.rank <= 1000
                GROUP BY AllMedia.mediaID
        )
        SELECT CASE GREATEST(overall, story, animation, chara, sound, enjoyment)
                  WHEN overall THEN 'overall'
                  WHEN story THEN 'story'
                  WHEN animation THEN 'animation'
                  WHEN chara THEN 'chara'
                  WHEN sound THEN 'sound'
                  WHEN enjoyment THEN 'enjoyment'
               END AS category, AvgRatings.mediaID
        FROM AvgRatings
)
SELECT COUNT(*) AS numShows, BestCategory.category
FROM BestCategory
GROUP BY BestCategory.category;
END; //

DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS LongestRunning //

CREATE PROCEDURE LongestRunning(IN runtype VARCHAR(30))
BEGIN
    IF runtype = "episode" THEN
WITH maxEpisodes AS (
        SELECT MAX(TV.numEpisodes) AS epCount
        FROM TV
)
SELECT TV.titleJPN, TV.numEpisodes, TV.synopsis, TV.rank, TV.startDate, TV.source
FROM maxEpisodes JOIN TV ON maxEpisodes.epCount = TV.numEpisodes;
    ELSEIF runtype = "time" THEN
WITH RunTime AS (
        SELECT TIMESTAMPDIFF(day, TV.startDate, TV.endDate) AS daysRun, TV.titleJPN, TV.synopsis, TV.source, TV.rank, TV.startDate
        FROM TV 
        WHERE TV.startDate IS NOT NULL AND TV.endDate IS NOT NULL
), MaxRunTime AS (
        SELECT MAX(RunTime.daysRun) AS runTime
        FROM RunTime
)
SELECT RunTime.daysRun, RunTime.titleJPN, RunTime.synopsis, RunTime.source, RunTime.startDate, RunTime.rank
FROM MaxRunTime JOIN RunTime ON RunTime.daysRun = MaxRunTime.runTime;
    END IF;
END; //

DELIMITER ;

