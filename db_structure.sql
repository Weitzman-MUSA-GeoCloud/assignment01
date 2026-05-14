
ALTER TABLE indego.trips_2022_q3
ADD COLUMN geog geography(Point, 4326);

ALTER TABLE indego.trips_2021_q3
ADD COLUMN geog geography(Point, 4326);

UPDATE indego.trips_2021_q3
SET geog = ST_SetSRID(
              ST_MakePoint(start_lon, start_lat),
              4326
          )::geography;

UPDATE indego.trips_2022_q3
SET geog = ST_SetSRID(
              ST_MakePoint(start_lon, start_lat),
              4326
          )::geography;


CREATE TABLE count21 AS
SELECT COUNT(*) AS num_trips
FROM indego.trips_2021_q3
WHERE duration <10;

ALTER TABLE count21
ADD COLUMN trip_year INTEGER,
ADD COLUMN trip_quarter INTEGER;

UPDATE count21 SET trip_year=2021, trip_quarter=3;

CREATE TABLE count22 AS
SELECT COUNT(*) AS num_trips
FROM indego.trips_2022_q3
WHERE duration <10;

ALTER TABLE count22
ADD COLUMN trip_year INTEGER,
ADD COLUMN trip_quarter INTEGER;

UPDATE count21 SET trip_year=2022, trip_quarter=3;

CREATE TABLE count22 AS
SELECT COUNT(*) AS num_trips
FROM indego.trips_2022_q3
WHERE duration <10;

ALTER TABLE count22
ADD COLUMN trip_year INTEGER,
ADD COLUMN trip_quarter INTEGER;

UPDATE count22 SET trip_year=2022, trip_quarter=3;
