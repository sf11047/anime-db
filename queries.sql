-- Team Members: Samantha Fu (sfu12) & Anthony Das (adas22)

-- This view was created because many of our queries need info to
-- all types of media, so this was used for convenience

CREATE VIEW AllMedia AS
SELECT TV.mediaID, TV.titleJPN, TV.synopsis, TV.rank, TV.startDate, TV.source 
FROM TV
UNION
SELECT * FROM OVA
UNION 
SELECT * FROM Movie;

-- 1. What are the most popular shows in each genre?
-- In this case, popularity is judged by the rank attribute
WITH PopularByGenre AS (
        SELECT MIN(AllMedia.rank) AS rank, BelongsTo.genreName 
        FROM AllMedia JOIN BelongsTo on AllMedia.mediaID = BelongsTo.mediaID
        GROUP BY BelongsTo.genreName)
SELECT PopularByGenre.genreName, AllMedia.mediaID, AllMedia.titleJPN, AllMedia.synopsis, AllMedia.rank, AllMedia.startDate, AllMedia.source
FROM BelongsTo JOIN AllMedia ON BelongsTo.mediaID = AllMedia.mediaID JOIN PopularByGenre ON PopularByGenre.genreName = BelongsTo.genreName AND PopularByGenre.rank = AllMedia.rank;

-- 2. How many of the most popular shows were based on mangas as opposed to being original creations?
-- Most popular shows is ambigious wording, so in this case I am going to count it as
-- any show whose rank is less than 1000 (considering that ranks go beyond 12000)
SELECT AllMedia.source AS sourceType, COUNT(AllMedia.mediaID) AS numShows
FROM AllMedia
WHERE AllMedia.rank <= 1000 AND (AllMedia.source = "Manga" OR AllMedia.source = "Original")
GROUP BY AllMedia.source;

-- 3. What are the most popular animation studios?
-- Most popular here is subjective, so in this case we will average rankings
-- for all shows per studio, and list the top 50
SELECT AVG(AllMedia.rank) AS avgShowRank, Animates.studioName 
FROM AllMedia JOIN Animates ON AllMedia.mediaID = Animates.mediaID
WHERE AllMedia.rank IS NOT NULL
GROUP BY Animates.studioName
ORDER BY avgShowRank ASC
LIMIT 50;

-- 4. What shows have been watched the most, been planned to watch the most, and been dropped the most?
-- Ties are not broken and instead both listed (each status gets the show with the most users having selected that status)
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

-- 5. Do the most popular shows score the highest in the same review categories?
-- Again, most popular is subjective so we will count this as shows ranked 1000 or less
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

-- 6. What are the longest running shows- by episode, and by time?
-- 6a. Longest running by episode
WITH maxEpisodes AS (
        SELECT MAX(TV.numEpisodes) AS epCount
        FROM TV
)
SELECT TV.titleJPN, TV.numEpisodes, TV.synopsis
FROM maxEpisodes JOIN TV ON maxEpisodes.epCount = TV.numEpisodes;

-- 6b. Longest runnning by time
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

-- 7. Which studios have the most anime made? By episode? By show?
-- 7a. Most anime made by media count
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

-- 7b. Most anime made by episode count
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

-- 8. Number of anime viewers grouped by age? Which age group has most viewers?
-- 8a. Number of anime viewers grouped by age
WITH Ages AS (
        SELECT TIMESTAMPDIFF(year, Users.birthDate, NOW()) AS age, Users.userName
        FROM Users
        WHERE Users.birthDate IS NOT NULL
)
SELECT Ages.age, COUNT(*) AS numPeople
FROM Ages
GROUP BY Ages.age;

-- 8b. Age group with most viewers
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


