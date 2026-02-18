CREATE EXTENSION IF NOT EXISTS postgis;
CREATE SCHEMA IF NOT EXISTS indego;

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


CREATE TABLE indego.trips_2022_q3 (
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

CREATE TABLE indego.station_statuses (
    id INTEGER,
    name TEXT,
    geog GEOGRAPHY(Point, 4326)
);

SELECT COUNT(*) FROM indego.trips_2021_q3;

SELECT COUNT(*) FROM indego.trips_2022_q3;

DROP TABLE IF EXISTS indego.station_statuses_raw;

CREATE TABLE indego.station_statuses_raw (
  id INTEGER,
  name TEXT,
  lon DOUBLE PRECISION,
  lat DOUBLE PRECISION
);

SELECT COUNT(*) FROM indego.station_statuses_raw;

TRUNCATE indego.station_statuses;

INSERT INTO indego.station_statuses (id, name, geog)
SELECT
  id,
  name,
  ST_SetSRID(ST_MakePoint(lon, lat), 4326)::geography
FROM indego.station_statuses_raw;

SELECT COUNT(*) FROM indego.station_statuses;

SELECT id, name, ST_AsText(geog) AS geog
FROM indego.station_statuses
LIMIT 5;


CREATE EXTENSION IF NOT EXISTS postgis;

SHOW SEARCH_PATH


