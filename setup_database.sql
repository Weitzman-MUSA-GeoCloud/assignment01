-- Setup script for Assignment1 database
-- Run this in pgAdmin 4 Query Tool connected to your Assignment1 database

-- Create the indego schema
CREATE SCHEMA IF NOT EXISTS indego;

-- Enable PostGIS extension (required for geography calculations)
CREATE EXTENSION IF NOT EXISTS postgis;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS indego.trips_2021_q3;
DROP TABLE IF EXISTS indego.trips_2022_q3;
DROP TABLE IF EXISTS indego.station_statuses;

-- Create trips_2021_q3 table
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

-- Create trips_2022_q3 table
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

-- Create station_statuses table (required for query08 and queries 10–14)
CREATE TABLE indego.station_statuses (
    id INTEGER PRIMARY KEY,
    name TEXT,
    geog GEOGRAPHY(Point, 4326)
);

-- Load station data by running: node load_stations.js
