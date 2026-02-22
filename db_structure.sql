CREATE EXTENSION IF NOT EXISTS postgis;

CREATE SCHEMA IF NOT EXISTS indego;

DROP TABLE IF EXISTS indego.trips_2021_q3;
DROP TABLE IF EXISTS indego.trips_2022_q3;
DROP TABLE IF EXISTS indego.station_statuses;

CREATE TABLE indego.trips_2021_q3 (
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

CREATE TABLE indego.trips_2022_q3 (LIKE indego.trips_2021_q3 INCLUDING ALL);

CREATE TABLE indego.station_statuses (
    id INTEGER,
    name TEXT, -- noqa
    geog GEOGRAPHY
);
