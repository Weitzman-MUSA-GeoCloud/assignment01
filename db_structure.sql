-- Active: 1738713087812@@localhost@5432@assignment01@indego

/*
Setting up the database:
- status
- trips_2021_q3
- trips_2022_q3
*/

DROP TABLE IF EXISTS indego.trips_2021_q3;
DROP TABLE IF EXISTS indego.trips_2022_q3;

CREATE TABLE trips_2021_q3 (
    trip_id TEXT,
    duration INTEGER,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    start_station TEXT,
    start_lat FLOAT,
    start_lon FLOAT,
    end_station TEXT,
    end_lat FLOAT,
    end_lon FLOAT,
    bike_id TEXT,
    plan_duration INTEGER,
    trip_route_category TEXT,
    passholder_type TEXT,
    bike_type TEXT
);

CREATE TABLE trips_2022_q3 (
    trip_id TEXT,
    duration INTEGER,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    start_station TEXT,
    start_lat FLOAT,
    start_lon FLOAT,
    end_station TEXT,
    end_lat FLOAT,
    end_lon FLOAT,
    bike_id TEXT,
    plan_duration INTEGER,
    trip_route_category TEXT,
    passholder_type TEXT,
    bike_type TEXT
);

-- Run this in the psql terminal (from left pane)
\copy indego.trips_2021_q3 
FROM '/Users/bairun/Documents/GitHub/assignment01-cloud/data/trips_2021_q3.csv' 
WITH (FORMAT CSV, HEADER TRUE);

\copy indego.trips_2022_q3 
FROM '/Users/bairun/Documents/GitHub/assignment01-cloud/data/trips_2022_q3.csv' 
WITH (FORMAT CSV, HEADER TRUE);
