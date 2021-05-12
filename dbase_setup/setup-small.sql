-- Team Members: Samantha Fu (sfu12) & Anthony Das (adas22)

CREATE TABLE Titles (
        titleJPN VARCHAR(255),
        titleENG VARCHAR(255) NULL,
        PRIMARY KEY (titleJPN)
);

CREATE TABLE Media (
        mediaID INT,
        PRIMARY KEY (mediaID)
);

CREATE TABLE Movie (
        mediaID INT,
        titleJPN VARCHAR(255) NOT NULL,
        synopsis VARCHAR(2000) NOT NULL,
        rank INT,
        startDate DATE NULL,
        source VARCHAR(255),
        PRIMARY KEY (mediaID),
        FOREIGN KEY (mediaID) REFERENCES Media(mediaID),
        FOREIGN KEY (titleJPN) REFERENCES Titles(titleJPN)
);

CREATE TABLE TV (
        mediaID INT,
        titleJPN VARCHAR(255) NOT NULL,
        synopsis VARCHAR(2000) NOT NULL,
        rank INT,
        startDate DATE NULL,
        endDate DATE NULL,
        source VARCHAR(255),
        status VARCHAR(255),
        numEpisodes INT,
        PRIMARY KEY (mediaID),
        FOREIGN KEY (mediaID) REFERENCES Media(mediaID),
        FOREIGN KEY (titleJPN) REFERENCES Titles(titleJPN)
);

CREATE TABLE OVA LIKE Movie;

CREATE TABLE Users (
        username VARCHAR(255),
        gender VARCHAR(255) NULL,
        location VARCHAR(255) NULL,
        birthDate DATE NULL,
        PRIMARY KEY (username)
);

CREATE TABLE Reviews (
        mediaID INT,
        username VARCHAR(255),
        overallRating INT NOT NULL,
        storyRating INT,
        animationRating INT,
        characterRating INT,
        soundRating INT,
        enjoymentRating INT,
        text VARCHAR(8000),
        PRIMARY KEY (mediaID, username),
        FOREIGN KEY (username) REFERENCES Users(username),
        FOREIGN KEY (mediaID) REFERENCES Media(mediaID)
);

CREATE TABLE SetStatus (
        mediaID INT,
        username VARCHAR(255),
        status VARCHAR(255) NOT NULL,
        rewatch INT,
        statusStartDate DATE NULL,
        statusEndDate DATE NULL,
        PRIMARY KEY (mediaID, username),
        FOREIGN KEY (mediaID) REFERENCES Media(mediaID),
        FOREIGN KEY (username) REFERENCES Users(username)
);

CREATE TABLE Genre (
        genreName VARCHAR(255),
        description VARCHAR(550) NOT NULL,
        PRIMARY KEY (genreName)
);

CREATE TABLE BelongsTo (
        genreName VARCHAR(255),
        mediaID INT,
        PRIMARY KEY (genreName, mediaID),
        FOREIGN KEY (genreName) REFERENCES Genre(genreName),
        FOREIGN KEY (mediaID) REFERENCES Media(mediaID)
);

CREATE TABLE Studio (
        studioName VARCHAR(255),
        PRIMARY KEY (studioName)
);

CREATE TABLE Animates (
        studioName VARCHAR(255),
        mediaID INT,
        PRIMARY KEY (studioName, mediaID),
        FOREIGN KEY (studioName) REFERENCES Studio(studioName),
        FOREIGN KEY (mediaID) REFERENCES Media(mediaID)
);

LOAD DATA LOCAL INFILE '/titles_small.csv'
INTO TABLE Titles 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(titleJPN, titleENG);

LOAD DATA LOCAL INFILE '/media_small.csv'
INTO TABLE Media 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/tv_small.csv'
INTO TABLE TV 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(titleJPN, rank, synopsis, source, mediaID, startDate, numEpisodes, endDate);

LOAD DATA LOCAL INFILE '/movies_small.csv'
INTO TABLE Movie 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(titleJPN, rank, synopsis, source, mediaID, startDate);

LOAD DATA LOCAL INFILE '/ova_small.csv'
INTO TABLE OVA 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(titleJPN, rank, synopsis, source, mediaID, startDate);

LOAD DATA LOCAL INFILE '/users_small.csv'
INTO TABLE Users 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(birthDate, username, location, gender);

LOAD DATA LOCAL INFILE '/reviews_small.csv'
INTO TABLE Reviews 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(mediaID, username, text, overallRating, characterRating, storyRating, animationRating, enjoymentRating, soundRating);

LOAD DATA LOCAL INFILE '/set_status_small.csv'
INTO TABLE SetStatus 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(username, mediaID, status, rewatch, statusStartDate, statusEndDate);

LOAD DATA LOCAL INFILE '/genre_small.csv'
INTO TABLE Genre 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/belongs_to_small.csv'
INTO TABLE BelongsTo 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(mediaID, genreName);

LOAD DATA LOCAL INFILE '/studio_small.csv'
INTO TABLE Studio 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/animates_small.csv'
INTO TABLE Animates 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(mediaID, studioName);


-- This view was created because many of our queries need info to
-- all types of media, so this was used for convenience

CREATE VIEW AllMedia AS
SELECT TV.mediaID, TV.titleJPN, TV.synopsis, TV.rank, TV.startDate, TV.source 
FROM TV
UNION
SELECT * FROM OVA
UNION 
SELECT * FROM Movie;
