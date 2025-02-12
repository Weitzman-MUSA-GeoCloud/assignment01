CREATE SCHEMA IF NOT EXISTS indego;
CREATE EXTENSION IF NOT EXISTS postgis;

-- Trips 2021
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

-- Trips 2022
DROP TABLE IF EXISTS indego.trips_2022_q3;

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

-- Stations
DROP TABLE IF EXISTS indego.station_statuses;

CREATE TABLE indego.station_statuses (
    id INTEGER,
    name TEXT,
    install_date TEXT,
    status TEXT,
    latitude FLOAT,
    longitude FLOAT,
    geog GEOGRAPHY(POINT)
);

-- Load trip data
COPY indego.trips_2021_q3 
FROM 'C:\Data\indego\indego-trips-2021-q3.csv' 
WITH CSV HEADER;

COPY indego.trips_2022_q3 
FROM 'C:\Data\indego\indego-trips-2022-q3.csv' 
WITH CSV HEADER;

-- Load station data
COPY indego.station_statuses (id, name, install_date, status)
FROM 'C:\Data\indego\indego-stations-2021-10-01.csv' 
WITH CSV HEADER;

-- Update station coordinates from trips data
WITH station_coords AS (
    SELECT DISTINCT 
        start_station,
        start_lat,
        start_lon
    FROM indego.trips_2021_q3
    WHERE start_lat IS NOT NULL 
    AND start_lon IS NOT NULL
)
UPDATE indego.station_statuses ss
SET 
    latitude = sc.start_lat,
    longitude = sc.start_lon
FROM station_coords sc 
WHERE ss.id::text = sc.start_station;

-- Update geography column
UPDATE indego.station_statuses
SET geog = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;


-- Verify the data
SELECT 
    id,
    name,
    latitude,
    longitude,
    geog::text
FROM indego.station_statuses
WHERE latitude IS NOT NULL
ORDER BY id
LIMIT 5;