-- Team Members: Samantha Fu (sfu12) & Anthony Das (adas22)

-- INSERT
-- New Status (referecing mediaID in Media for an existing user). Case 1
-- Existing Foreign Keys: mediaID (31764) username (finchan)
INSERT INTO SetStatus(mediaID, username, status, rewatch)
VALUES (31764, 'finchan', 'watching', 0);

-- New Show + User + Status (referencing a mediaID not already in Media for a new user). Case 2
-- New Foreign Keys: mediaID (42897) username(newuser)
-- Create new mediaID foriegn key
INSERT INTO Media(mediaID)
VALUES (42897);

-- Good idea to also add some more info for show
INSERT INTO Titles(titleJPN)
VALUES('Horimiya');

INSERT INTO TV(mediaID, titleJPN, synopsis)
VALUES (42897, 'Horimiya', "On the surface, the thought of Kyouko Hori and Izumi Miyamura getting along would be the last thing in people's minds. After all, Hori has a perfect combination of beauty and brains, while Miyamura appears meek and distant to his fellow classmates. However, a fateful meeting between the two lays both of their hidden selves bare. Even though she is popular at school, Hori has little time to socialize with her friends due to housework. On the other hand, Miyamura lives under the noses of his peers, his body bearing secret tattoos and piercings that make him look like a gentle delinquent. Having opposite personalities yet sharing odd similarities, the two quickly become friends and often spend time together in Hori's home. As they both emerge from their shells, they share with each other a side of themselves concealed from the outside world.");

-- Create new username foriegn key
INSERT INTO Users(username, gender)
VALUES ('newuser', 'non-binary');

-- Create status with new foriegn keys
INSERT INTO SetStatus(mediaID, username, status, rewatch)
VALUES (42897, 'newuser', 'watching', 0);


-- DELETE
-- Remove Existing Status. Case 1
DELETE FROM SetStatus
WHERE username LIKE 'finchan' AND mediaID = 31764;

-- Remove a user and their data. Case 2
-- Delete reviews, no data here
DELETE FROM Reviews
WHERE username LIKE 'newuser';

-- Delete Status
DELETE FROM SetStatus
WHERE username LIKE 'newuser';

-- Delete User
DELETE FROM Users
WHERE username LIKE 'newuser';