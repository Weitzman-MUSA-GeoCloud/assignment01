DROP TABLE IF EXISTS indego.trips_2021_q3;
DROP TABLE IF EXISTS indego.trips_2022_q3;

CREATE TABLE indego.trips_2021_q3 (
    trip_id TEXT PRIMARY KEY,
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

CREATE TABLE indego.trips_2022_q3 (
    trip_id TEXT PRIMARY KEY,
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


COPY indego.trips_2021_q3
FROM '/data/trips_2021_q3.csv'
WITH (FORMAT csv, HEADER TRUE);

COPY indego.trips_2022_q3
FROM '/data/trips_2022_q3.csv'
WITH (FORMAT csv, HEADER TRUE);
