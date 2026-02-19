CREATE EXTENSION IF NOT EXISTS postgis;
CREATE SCHEMA IF NOT EXISTS indego;

-- 1) trips_2021_q3
DROP TABLE IF EXISTS indego.trips_2021_q3;
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

-- 2) trips_2022_q3
DROP TABLE IF EXISTS indego.trips_2022_q3;
CREATE TABLE indego.trips_2022_q3 (LIKE indego.trips_2021_q3);

-- 3) station_statuses
DROP TABLE IF EXISTS indego.station_statuses;
CREATE TABLE indego.station_statuses (
  id INTEGER,
  name TEXT,
  geog GEOGRAPHY(Point, 4326)
);


-- 从 raw 表抽取 id、name，并把几何转成 geography
INSERT INTO indego.station_statuses (id, name, geog)
SELECT
  (properties->>'id')::int AS id,
  properties->>'name' AS name,
  ST_SetSRID(geom, 4326)::geography AS geog
FROM indego.station_statuses_raw;

