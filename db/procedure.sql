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

DROP PROCEDURE IF EXISTS MangaVSOriginal //

CREATE PROCEDURE MangaVSOriginal()
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
    IF runtype = "Episode" THEN
WITH maxEpisodes AS (
        SELECT MAX(TV.numEpisodes) AS epCount
        FROM TV
)
SELECT TV.titleJPN, TV.numEpisodes, TV.synopsis, TV.rank, TV.startDate, TV.source
FROM maxEpisodes JOIN TV ON maxEpisodes.epCount = TV.numEpisodes;
    ELSEIF runtype = "Time" THEN
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


DELIMITER //

DROP PROCEDURE IF EXISTS MostAnimeMade //

CREATE PROCEDURE MostAnimeMade(IN runtype VARCHAR(30))
BEGIN
    IF runtype = "Episode" THEN
WITH StudioEpisodeCount AS (
        WITH TotalEpisodeCount AS (
                SELECT Animates.studioName, SUM(TV.numEpisodes) as epsMade
                FROM TV JOIN Animates ON TV.mediaID = Animates.mediaID
                WHERE TV.numEpisodes > 0
                GROUP BY Animates.studioName
                UNION
                SELECT Animates.studioName, COUNT(*) AS epsMade
                FROM Movie JOIN Animates ON Movie.mediaID = Animates.mediaID
                GROUP BY Animates.studioName
                UNION
                SELECT Animates.studioName, COUNT(*) AS epsMade
                FROM OVA JOIN Animates ON OVA.mediaID = Animates.mediaID
                GROUP BY Animates.studioName
        )
        SELECT TotalEpisodeCount.studioName, SUM(epsMade) AS totalEpisodes
        FROM TotalEpisodeCount
        GROUP BY TotalEpisodeCount.studioName
), MaxEpisodeCount AS (
        SELECT MAX(totalEpisodes) as maxEps
        FROM StudioEpisodeCount
)
SELECT StudioEpisodeCount.studioName, StudioEpisodeCount.totalEpisodes 
FROM MaxEpisodeCount JOIN StudioEpisodeCount ON MaxEpisodeCount.maxEps = StudioEpisodeCount.totalEpisodes;

    ELSEIF runtype = "Show" THEN
WITH ShowCount AS (
        SELECT Animates.studioName, COUNT(*) AS shows 
        FROM AllMedia JOIN Animates ON AllMedia.mediaID = Animates.mediaID
        GROUP BY Animates.studioName
), 
MaxShowCount AS (
        SELECT MAX(ShowCount.shows) AS showsMade
        FROM ShowCount
)
SELECT ShowCount.studioName, MaxShowCount.showsMade
FROM MaxShowCount JOIN ShowCount ON MaxShowCount.showsMade = ShowCount.shows;

    END IF;
END; //

DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS MaxAgeGroup //

CREATE PROCEDURE MaxAgeGroup()
BEGIN
WITH Ages AS (
        SELECT TIMESTAMPDIFF(year, Users.birthDate, NOW()) AS age, Users.userName
        FROM Users
        WHERE Users.birthDate IS NOT NULL
), AgeCount AS (
        SELECT Ages.age, COUNT(*) AS numPeople
        FROM Ages
        GROUP BY Ages.age
), maxNumPeople AS (
        SELECT MAX(AgeCount.numPeople) AS maxNum
        FROM AgeCount
)
SELECT AgeCount.age, AgeCount.numPeople AS numUsers
FROM AgeCount JOIN maxNumPeople ON AgeCount.numPeople = maxNumPeople.maxNum;

END; //

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS AgeGroups //

CREATE PROCEDURE AgeGroups()
BEGIN
WITH Ages AS (
        SELECT TIMESTAMPDIFF(year, Users.birthDate, NOW()) AS age, Users.userName
        FROM Users
        WHERE Users.birthDate IS NOT NULL
)
SELECT Ages.age, COUNT(*) AS numPeople
FROM Ages
WHERE Ages.age > 7 AND Ages.age < 100
GROUP BY Ages.age
ORDER BY Ages.age ASC;

END; //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS TopCategoryRating //

CREATE PROCEDURE TopCategoryRating(IN category VARCHAR(10))
BEGIN
IF category = "story" THEN
    WITH MediaRating AS (
            SELECT AllMedia.mediaID AS 'mediaID', AllMedia.titleJPN AS 'titleJPN', AVG(storyRating) AS 'story'
            FROM Reviews
            LEFT JOIN AllMedia ON AllMedia.mediaID = Reviews.mediaID
            GROUP BY mediaID
    )
    SELECT titleJPN, story AS 'avgRating'
    FROM MediaRating
    ORDER BY story DESC
    LIMIT 20;
ELSEIF category = "animation" THEN
    WITH MediaRating AS (
            SELECT AllMedia.mediaID AS 'mediaID', AllMedia.titleJPN AS 'titleJPN', AVG(animationRating) AS 'animation'
            FROM Reviews
            LEFT JOIN AllMedia ON AllMedia.mediaID = Reviews.mediaID
            GROUP BY mediaID
    )
    SELECT titleJPN, animation AS 'avgRating'
    FROM MediaRating
    ORDER BY animation DESC
    LIMIT 20;
ELSEIF category = "character" THEN
    WITH MediaRating AS (
            SELECT AllMedia.mediaID AS 'mediaID', AllMedia.titleJPN AS 'titleJPN', AVG(characterRating) AS 'characterR'
            FROM Reviews
            LEFT JOIN AllMedia ON AllMedia.mediaID = Reviews.mediaID
            GROUP BY mediaID
    )  
    SELECT titleJPN, characterR AS 'avgRating'
    FROM MediaRating
    ORDER BY characterR DESC
    LIMIT 20;
END IF;
END; //

DROP PROCEDURE IF EXISTS MostRewatched //

CREATE PROCEDURE MostRewatched()
BEGIN
WITH Rewatched AS (
        SELECT AllMedia.mediaID AS 'mediaID', titleJPN, count(rewatch) AS 'rewatchCount'
        FROM SetStatus
        LEFT JOIN AllMedia ON AllMedia.mediaID = SetStatus.mediaID
        WHERE rewatch = 1
        GROUP BY mediaID)
SELECT mediaID, titleJPN, rewatchCount
FROM Rewatched
ORDER BY rewatchCount DESC
LIMIT 20;
END;//

DROP PROCEDURE IF EXISTS PopularSource //

CREATE PROCEDURE PopularSource()
BEGIN
WITH Sources AS (
        SELECT source, count(source) AS 'sourceCount'
        FROM AllMedia
        WHERE source NOT LIKE "Unknown"
        GROUP BY source)
SELECT source, sourceCount
FROM Sources
WHERE sourceCount = (SELECT MAX(sourceCount) FROM Sources);
END;//

DROP PROCEDURE IF EXISTS PlanVSComplete //

CREATE PROCEDURE PlanVSComplete(IN opt VARCHAR(10))
BEGIN
IF opt = "plan" THEN
    WITH Completed AS (
            SELECT username, count(status) AS 'cc'
            FROM SetStatus
            WHERE status LIKE "completed"
            GROUP BY username
            ),
    Plan AS (
            SELECT username, count(status) AS 'pc'
            FROM SetStatus
            WHERE status LIKE "plan to watch"
            GROUP BY username)
    SELECT count(Completed.username) AS 'count'
    FROM Plan
    LEFT JOIN Completed ON Completed.username = Plan.username
    WHERE cc < pc OR cc IS NULL;
ELSEIF opt = "completed" THEN
    WITH Completed AS (
            SELECT username, count(status) AS 'cc'
            FROM SetStatus
            WHERE status LIKE "completed"
            GROUP BY username
            ),
    Plan AS (
            SELECT username, count(status) AS 'pc'
            FROM SetStatus
            WHERE status LIKE "plan to watch"
            GROUP BY username)
    SELECT count(Completed.username) AS 'count'
    FROM Completed
    LEFT JOIN Plan ON Completed.username = Plan.username
    WHERE cc > pc OR pc IS NULL;
END IF;
END;//

DROP PROCEDURE IF EXISTS MultiShows //

CREATE PROCEDURE MultiShows(IN opt VARCHAR(10))
BEGIN
IF opt = "avg" THEN
        WITH Watching AS (
                SELECT username, count(status) AS 'watching'
                FROM SetStatus
                WHERE status LIKE "watching"
                GROUP BY username)
        SELECT avg(watching) AS 'out'
        FROM Watching;
ELSEIF opt = "max" THEN
        WITH Watching AS (
                SELECT username, count(status) AS 'watching'
                FROM SetStatus
                WHERE status LIKE "watching"
                GROUP BY username)
        SELECT max(watching) AS 'out'
        FROM Watching;
ELSEIF opt = "min" THEN
        WITH Watching AS (
                SELECT username, count(status) AS 'watching'
                FROM SetStatus
                WHERE status LIKE "watching"
                GROUP BY username)
        SELECT min(watching) AS 'out'
        FROM Watching;
END IF;
END;//

DROP PROCEDURE IF EXISTS TopGenresPop //

CREATE PROCEDURE TopGenresPop(IN opt VARCHAR(10))
BEGIN
IF opt = "shows" THEN
        WITH GenreCount AS (
                SELECT genreName, count(mediaID) AS 'count'
                FROM BelongsTo
                GROUP BY genreName)
        SELECT genreName, count AS 'count'
        FROM GenreCount
        ORDER BY count DESC
        LIMIT 5;
ELSEIF opt = "viewers" THEN
        WITH ShowCount AS (
                SELECT mediaID, count(username) AS 'countS'
                FROM SetStatus
                WHERE status LIKE "completed" OR status LIKE "watching" OR status LIKE "on hold"
                GROUP BY mediaID
        ),
        GenreCount AS (
                SELECT genreName, sum(countS) AS 'count'
                FROM ShowCount
                LEFT JOIN BelongsTo ON BelongsTo.mediaID = ShowCount.mediaID
                GROUP BY genreName
        )
        SELECT genreName, count AS 'count'
        FROM GenreCount
        WHERE genreName IS NOT NULL
        ORDER BY count DESC
        LIMIT 5;
END IF;
END;//

DROP PROCEDURE IF EXISTS NewShowsYear //

CREATE PROCEDURE NewShowsYear()
BEGIN
        SELECT year(startDate) AS 'year', count(year(startDate)) AS 'count'
        FROM AllMedia
        WHERE startDate IS NOT NULL
        GROUP BY year(startDate)
        ORDER BY year DESC;
END;//

DELIMITER ;




