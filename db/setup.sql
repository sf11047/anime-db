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
        synopsis VARCHAR(5000) NOT NULL,
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
        synopsis VARCHAR(5000) NOT NULL,
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
        username VARBINARY(255),
        gender VARCHAR(255) NULL,
        location VARCHAR(255) NULL,
        birthDate DATE NULL,
        PRIMARY KEY (username)
);

CREATE TABLE Reviews (
        mediaID INT,
        username VARBINARY(255),
        overallRating INT NOT NULL,
        storyRating INT,
        animationRating INT,
        characterRating INT,
        soundRating INT,
        enjoymentRating INT,
        text LONGTEXT,
        PRIMARY KEY (mediaID, username),
        FOREIGN KEY (username) REFERENCES Users(username),
        FOREIGN KEY (mediaID) REFERENCES Media(mediaID)
);

CREATE TABLE SetStatus (
        mediaID INT,
        username VARBINARY(255),
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
        description VARCHAR(1000) NOT NULL,
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

LOAD DATA LOCAL INFILE '/titles.csv'
INTO TABLE Titles 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(titleJPN, titleENG);

LOAD DATA LOCAL INFILE '/media.csv'
INTO TABLE Media 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/tv.csv'
INTO TABLE TV 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(titleJPN, rank, synopsis, source, numEpisodes, mediaID, startDate, endDate);

LOAD DATA LOCAL INFILE '/movie.csv'
INTO TABLE Movie 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(titleJPN, rank, synopsis, source, mediaID, startDate);

LOAD DATA LOCAL INFILE '/ova.csv'
INTO TABLE OVA 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(titleJPN, rank, synopsis, source, mediaID, startDate);

LOAD DATA LOCAL INFILE '/users.csv'
INTO TABLE Users 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(birthDate, username, location, gender);

LOAD DATA LOCAL INFILE '/genre.csv'
INTO TABLE Genre 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/belongs_to.csv'
INTO TABLE BelongsTo 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(mediaID, genreName);

LOAD DATA LOCAL INFILE '/studio.csv'
INTO TABLE Studio 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/animates.csv'
INTO TABLE Animates 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(mediaID, studioName);

LOAD DATA LOCAL INFILE '/set_status.csv'
INTO TABLE SetStatus 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(mediaID, username, statusStartDate, statusEndDate, rewatch, status);

LOAD DATA LOCAL INFILE '/reviews.csv'
INTO TABLE Reviews 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(mediaID, username, text, overallRating, characterRating, storyRating, animationRating, enjoymentRating, soundRating);