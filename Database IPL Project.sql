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
SELECT bowler,
       ROUND(SUM(total_runs - bye_runs - legbye_runs) * 6 /
       SUM(wide_runs = 0 AND noball_runs = 0), 2) AS economy
FROM deliveries
JOIN matches ON deliveries.match_id = matches.id
WHERE matches.season = 2016
GROUP BY bowler
ORDER BY economy
LIMIT 10;
