-- Create schema
CREATE SCHEMA IF NOT EXISTS indego;

-- Drop tables if they already exist
DROP TABLE IF EXISTS indego.trips_2021_q3;
DROP TABLE IF EXISTS indego.trips_2022_q3;
DROP TABLE IF EXISTS indego.station_statuses;

-- Trips table (2021 Q3)
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

-- Trips table (2022 Q3) with the same structure
CREATE TABLE indego.trips_2022_q3 (LIKE indego.trips_2021_q3 INCLUDING ALL);

-- Station statuses (minimum required fields)
CREATE TABLE indego.station_statuses (
  id INTEGER,
  name TEXT,
  geog GEOGRAPHY(POINT, 4326)
);