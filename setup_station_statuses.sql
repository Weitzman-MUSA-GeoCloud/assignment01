
CREATE SCHEMA IF NOT EXISTS indego;
CREATE EXTENSION IF NOT EXISTS postgis;

DROP TABLE IF EXISTS indego.station_statuses;

CREATE TABLE indego.station_statuses (
    id INTEGER PRIMARY KEY,
    name TEXT,
    geog GEOGRAPHY(Point, 4326)
);


