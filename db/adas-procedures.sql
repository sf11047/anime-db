-- To be combined with procedure later. Leaving seperate to avoid merge conflicts.

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

DELIMITER ;