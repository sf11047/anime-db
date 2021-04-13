-- Team Members: Samantha Fu (sfu12) & Anthony Das (adas22)

CREATE VIEW AllMedia AS
SELECT TV.mediaID, TV.titleJPN, TV.synopsis, TV.rank, TV.startDate, TV.source 
FROM TV
UNION
SELECT * FROM OVA
UNION 
SELECT * FROM Movie;

SELECT * FROM AllMedia;

-- What are the most popular shows in each genre?
-- join show with its genre info, then pick max rank per genre
-- need to get mediaIDs too somehow
WITH PopularByGenre AS (
        SELECT MIN(AllMedia.rank) AS rank, BelongsTo.genreName 
        FROM AllMedia JOIN BelongsTo on AllMedia.mediaID = BelongsTo.mediaID
        GROUP BY BelongsTo.genreName)
SELECT PopularByGenre.genreName, AllMedia.mediaID, AllMedia.titleJPN, AllMedia.synopsis, AllMedia.rank, AllMedia.startDate, AllMedia.source
FROM BelongsTo JOIN AllMedia ON BelongsTo.mediaID = AllMedia.mediaID JOIN PopularByGenre ON PopularByGenre.genreName = BelongsTo.genreName AND PopularByGenre.rank = AllMedia.rank;

-- How many of the most popular shows were based on mangas as opposed to being original creations?
-- In this case, most popular could be interpreted many different ways,s o i'm going to count it as shows ranked above 1000
-- considering that there are so many shows that ranks go past 10000

SELECT AllMedia.source AS sourceType, COUNT(AllMedia.mediaID) AS numShows
FROM AllMedia
WHERE AllMedia.rank <= 1000 AND (AllMedia.source = "Manga" OR AllMedia.source = "Original")
GROUP BY AllMedia.source;

---What are the most popular animation studios?

--- What shows have been watched the most, been planned to watch the most, and been dropped the most?

SELECT * FROM SetStatus;

SELECT COUNT(SetStatus.mediaID) AS usersWIthStatus, SetStatus.mediaID, SetStatus.status
FROM SetStatus
GROUP BY SetStatus.mediaID, SetStatus.status;

-- doesn't give me right mediaID
WITH UserCounts AS (
        SELECT COUNT(SetStatus.mediaID) AS usersWIthStatus, SetStatus.mediaID, SetStatus.status
        FROM SetStatus
        GROUP BY SetStatus.mediaID, SetStatus.status
)
SELECT MAX(UserCounts.usersWithStatus) AS maxUserCount, UserCounts.status
FROM UserCounts
GROUP BY UserCounts.status;
 
-- final answer
 
WITH UserCounts AS (
        SELECT COUNT(SetStatus.mediaID) AS usersWithStatus, SetStatus.mediaID, SetStatus.status
        FROM SetStatus
        GROUP BY SetStatus.mediaID, SetStatus.status
), MaxStatusCount AS (
        SELECT MAX(UserCounts.usersWithStatus) AS maxUserCount, UserCounts.status
        FROM UserCounts
        GROUP BY UserCounts.status
)
SELECT MaxStatusCount.status, UserCounts.usersWithStatus AS usersWithStatus, AllMedia.titleJPN 
FROM MaxStatusCount JOIN UserCounts ON MaxStatusCount.status = UserCounts.status AND MaxStatusCount.maxUserCount = UserCounts.usersWithStatus
JOIN AllMedia ON UserCounts.mediaID = AllMedia.mediaID;


-- Do the most popular shows score the highest in the same review categories?
-- Again, most popular is subjective so we are just going to determine this based on
-- shows with rank less than 1000
SELECT * FROM Reviews;

SELECT * 
FROM AllMedia JOIN Reviews ON AllMedia.mediaID = Reviews.mediaID
Where AllMedia.rank <= 1000;

SELECT AVG(overallRating) AS overall, AVG(storyRating) AS story, AVG(animationRating) AS animation, AVG(characterRating) AS chara, AVG(soundRating) AS sound, AVG(enjoymentRating) AS enjoyment, AllMedia.mediaID 
FROM AllMedia JOIN Reviews ON AllMedia.mediaID = Reviews.mediaID
GROUP BY AllMedia.mediaID;

-- get highest rated category per show
WITH AvgRatings AS (
        SELECT AVG(overallRating) AS overall, AVG(storyRating) AS story, AVG(animationRating) AS animation, AVG(characterRating) AS chara, AVG(soundRating) AS sound, AVG(enjoymentRating) AS enjoyment, AllMedia.mediaID 
        FROM AllMedia JOIN Reviews ON AllMedia.mediaID = Reviews.mediaID
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
FROM AvgRatings;

-- final answer for do most popular shows score highest in same review categories
-- first get avg of ratings per category for each show then get highest rated category per show 
-- then count by ctaegory the num shows scoring higest in that category 
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

-- What are the longest running shows- by episode, and by time?
-- final for longest running by episode
WITH maxEpisodes AS (
        SELECT MAX(TV.numEpisodes) AS epCount
        FROM TV
)
SELECT TV.titleJPN, TV.numEpisodes, TV.synopsis
FROM maxEpisodes JOIN TV ON maxEpisodes.epCount = TV.numEpisodes;

-- get show by max runtime
SELECT TIMESTAMPDIFF(day, TV.startDate, TV.endDate) AS daysRun, TV.titleJPN, TV.synopsis
FROM TV 
WHERE TV.startDate IS NOT NULL AND TV.endDate IS NOT NULL
ORDER BY daysRun DESC;

-- final for longest running by time
WITH RunTime AS (
        SELECT TIMESTAMPDIFF(day, TV.startDate, TV.endDate) AS daysRun, TV.titleJPN, TV.synopsis
        FROM TV 
        WHERE TV.startDate IS NOT NULL AND TV.endDate IS NOT NULL
), MaxRunTime AS (
        SELECT MAX(RunTime.daysRun) AS runTime
        FROM RunTime
)
SELECT RunTime.daysRun, RunTime.titleJPN, RunTime.synopsis
FROM MaxRunTime JOIN RunTime ON RunTime.daysRun = MaxRunTime.runTime;

-- Which studios have the most anime made? By episode? By show?
SELECT Animates.studioName, COUNT(*) AS shows 
FROM AllMedia JOIN Animates ON AllMedia.mediaID = Animates.mediaID
GROUP BY Animates.studioName
ORDER BY COUNT(*) DESC;

-- final answer by all media count (show)
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

-- most anime made per studio by episode: lets u see list
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
ORDER BY SUM(epsMade) DESC;

-- final by episode count
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
