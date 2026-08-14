# IPL SQL Analysis

## Requirements

* MySQL 8.0+
* MySQL Workbench 8.0.36
* `matches.csv`
* `deliveries.csv`

## Setup

Create and select the database:

```sql
CREATE DATABASE ipl_db;
USE ipl_db;
```

Create the `matches` and `deliveries` tables using the provided schema.

Enable CSV import if required:

```sql
SET GLOBAL local_infile = 1;
```

Check that it is enabled:

```sql
SHOW VARIABLES LIKE 'local_infile';
```

Import the CSV files:

```sql
LOAD DATA LOCAL INFILE '/path/matches.csv'
INTO TABLE matches
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

```sql
LOAD DATA LOCAL INFILE '/path/deliveries.csv'
INTO TABLE deliveries
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

Replace `/path/` with the actual location of the CSV files on your system.

## Analysis

The project answers the following questions:

1. Number of matches played per year.
2. Number of matches won by each team.
3. Extra runs conceded by each team in 2016.
4. Top 10 economical bowlers in 2015.

The SQL queries for these questions are available in `queries.sql`.

## Run

1. Create the database.
2. Create the `matches` and `deliveries` tables.
3. Import both CSV files.
4. Run the queries from `queries.sql`.

