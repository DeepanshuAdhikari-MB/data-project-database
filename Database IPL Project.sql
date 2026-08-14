CREATE USER 'ipl_user'@'localhost'
IDENTIFIED BY 'ipl123';

SELECT user, host
FROM mysql.user
WHERE user = 'ipl_user';

CREATE DATABASE ipl_db;
GRANT ALL PRIVILEGES
ON ipl_db.*
TO 'ipl_user'@'localhost';
SHOW GRANTS FOR 'ipl_user'@'localhost';

DROP DATABASE ipl_db;
DROP USER 'ipl_user'@'localhost';


CREATE DATABASE ipl_database;
USE ipl_database;
CREATE TABLE matches (
    id INT PRIMARY KEY,
    season INT,
    city VARCHAR(100),
    date DATE,
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(50),
    result VARCHAR(50),
    dl_applied INT,
    winner VARCHAR(100),
    win_by_runs INT,
    win_by_wickets INT,
    player_of_match VARCHAR(100),
    venue VARCHAR(200),
    umpire1 VARCHAR(100),
    umpire2 VARCHAR(100),
    umpire3 VARCHAR(100)
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
LOAD DATA LOCAL INFILE '/home/deepanshu-adhikari/Downloads/archive/matches.csv'
INTO TABLE matches
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM matches;

CREATE TABLE deliveries (
    match_id INT,
    inning INT,
    batting_team VARCHAR(100),
    bowling_team VARCHAR(100),
    overs INT,
    ball INT,
    batsman VARCHAR(100),
    non_striker VARCHAR(100),
    bowler VARCHAR(100),
    is_super_over INT,
    wide_runs INT,
    bye_runs INT,
    legbye_runs INT,
    noball_runs INT,
    penalty_runs INT,
    batsman_runs INT,
    extra_runs INT,
    total_runs INT,
    player_dismissed VARCHAR(100),
    dismissal_kind VARCHAR(100),
    fielder VARCHAR(100)
);

LOAD DATA LOCAL INFILE '/home/deepanshu-adhikari/Downloads/archive/deliveries.csv'
INTO TABLE deliveries
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM deliveries;

-- Number of matches played per year of all the years in IPL.-- 
SELECT season, COUNT(season)
AS Total_matches FROM matches
GROUP BY season
ORDER BY season;


-- Number of matches won of all teams over all the years of IPL.
SELECT winner, COUNT(winner)
AS total_win FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY total_win DESC;


-- For the year 2016 get the extra runs conceded per team.
SELECT d.bowling_team,
    SUM(d.extra_runs) AS extra_runs_conceded
FROM deliveries d
JOIN matches m
    ON d.match_id = m.id
WHERE m.season = 2016
GROUP BY d.bowling_team
ORDER BY extra_runs_conceded DESC;

-- For the year 2015 get the top economical bowlers.
SELECT d.bowler,
    SUM(d.total_runs- d.bye_runs- d.legbye_runs) AS runs_conceded,
    SUM(
        CASE
            WHEN d.wide_runs = 0
             AND d.noball_runs = 0
            THEN 1
            ELSE 0
        END
    ) AS legal_deliveries,
    ROUND(
        (
            SUM(d.total_runs- d.bye_runs- d.legbye_runs) * 6.0
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN d.wide_runs = 0
                     AND d.noball_runs = 0
                    THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS economy
FROM deliveries d
JOIN matches m
    ON d.match_id = m.id
WHERE m.season = 2015
GROUP BY d.bowler
ORDER BY economy ASC
LIMIT 10;



 

