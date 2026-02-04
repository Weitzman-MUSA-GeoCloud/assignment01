-- Create station_statuses table only (run in Assignment1 database)
-- Use this if you already have trips loaded and only need stations.

CREATE SCHEMA IF NOT EXISTS indego;
CREATE EXTENSION IF NOT EXISTS postgis;

DROP TABLE IF EXISTS indego.station_statuses;

CREATE TABLE indego.station_statuses (
    id INTEGER PRIMARY KEY,
    name TEXT,
    geog GEOGRAPHY(Point, 4326)
);

-- Then run in terminal: node load_stations.js
