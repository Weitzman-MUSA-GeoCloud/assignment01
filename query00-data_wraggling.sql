-- 1. Just in case to set the environment
set search_path to public

select * from indego.trips_2021_q3;

select * from indego.trips_2022_q3;

select * from indego.stations_geo;

select * from indego.stations;

-- 2.wraggling the data

--- (1) deal with the null or " " in the data

---- a. start_time / end_time

SELECT start_time
FROM indego.trips_2021_q3
WHERE start_time !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$';
UPDATE indego.trips_2021_q3
SET start_time = TO_TIMESTAMP(start_time, 'MM/DD/YYYY HH24:MI')
WHERE start_time ~ '^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}$';
UPDATE indego.trips_2021_q3
SET start_time = NULL
WHERE start_time = '';
ALTER TABLE indego.trips_2021_q3
ALTER COLUMN start_time TYPE TIMESTAMP WITH TIME ZONE
USING start_time AT TIME ZONE 'America/New_York';

SELECT end_time
FROM indego.trips_2021_q3
WHERE end_time !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$';
UPDATE indego.trips_2021_q3
SET end_time = TO_TIMESTAMP(end_time, 'MM/DD/YYYY HH24:MI')
WHERE end_time ~ '^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}$';
UPDATE indego.trips_2021_q3
SET end_time = NULL
WHERE end_time = '';
ALTER TABLE indego.trips_2021_q3
ALTER COLUMN end_time TYPE TIMESTAMP WITH TIME ZONE
USING end_time AT TIME ZONE 'America/New_York';


---- b. lat / lon 
SELECT start_lat 
FROM indego.trips_2021_q3
WHERE start_lat = '';
SELECT start_lat 
FROM indego.trips_2021_q3
WHERE start_lat ~ '[^0-9.-]';
UPDATE indego.trips_2021_q3
SET start_lat = NULL
WHERE start_lat = '';
UPDATE indego.trips_2021_q3
SET start_lat = NULL
WHERE start_lat ~ '[^0-9.-]';
ALTER TABLE indego.trips_2021_q3
ALTER COLUMN start_lat TYPE DOUBLE PRECISION USING start_lat::DOUBLE PRECISION;

SELECT start_lon
FROM indego.trips_2021_q3
WHERE start_lon = '';
SELECT start_lon 
FROM indego.trips_2021_q3
WHERE start_lon ~ '[^0-9.-]';
UPDATE indego.trips_2021_q3
SET start_lon = NULL
WHERE start_lon = '';
UPDATE indego.trips_2021_q3
SET start_lon = NULL
WHERE start_lon ~ '[^0-9.-]';
ALTER TABLE indego.trips_2021_q3
ALTER COLUMN start_lon TYPE DOUBLE PRECISION USING start_lon::DOUBLE PRECISION;

SELECT end_lat
FROM indego.trips_2021_q3
WHERE end_lat = '';
SELECT end_lat 
FROM indego.trips_2021_q3
WHERE end_lat ~ '[^0-9.-]';
UPDATE indego.trips_2021_q3
SET end_lat = NULL
WHERE end_lat = '';
UPDATE indego.trips_2021_q3
SET end_lat = NULL
WHERE end_lat ~ '[^0-9.-]';
ALTER TABLE indego.trips_2021_q3
ALTER COLUMN end_lat TYPE DOUBLE PRECISION USING end_lat::DOUBLE PRECISION;

SELECT end_lon
FROM indego.trips_2021_q3
WHERE end_lon = '';
SELECT end_lon 
FROM indego.trips_2021_q3
WHERE end_lon ~ '[^0-9.-]';
UPDATE indego.trips_2021_q3
SET end_lon = NULL
WHERE end_lon = '';
UPDATE indego.trips_2021_q3
SET end_lon = NULL
WHERE end_lon ~ '[^0-9.-]';
ALTER TABLE indego.trips_2021_q3
ALTER COLUMN end_lon TYPE DOUBLE PRECISION USING end_lon::DOUBLE PRECISION;


--- (2) convert the types of the columns

alter table indego.trips_2021_q3
alter column trip_id type text,
alter column duration type INTEGER using duration::integer,
alter column start_time type TIMESTAMP using start_time::TIMESTAMP,
alter column end_time type TIMESTAMP using end_time::TIMESTAMP,
alter column start_station type TEXT,
alter column start_lat type DOUBLE PRECISION using start_lat::DOUBLE PRECISION,
alter column start_lon type DOUBLE PRECISION using start_lon::DOUBLE PRECISION,
alter column end_station type TEXT,
alter column end_lat type DOUBLE PRECISION using end_lat::DOUBLE PRECISION,
alter column end_lon type DOUBLE PRECISION using end_lon::DOUBLE PRECISION,
alter column bike_id type TEXT,
alter column plan_duration type INTEGER using duration::integer,
alter column trip_route_category type TEXT,
alter column passholder_type type text,
alter column bike_type type TEXT;

--- (3) select the columns
CREATE TABLE indego.trips_2021_q3_new AS
SELECT trip_id, duration, start_time, end_time, start_station, 
       start_lat, start_lon, end_station, end_lat, end_lon, 
       bike_id, plan_duration, trip_route_category, 
       passholder_type, bike_type
FROM indego.trips_2021_q3;

SELECT * FROM indego.trips_2021_q3_new LIMIT 10;

DROP TABLE indego.trips_2021_q3;

ALTER TABLE indego.trips_2021_q3_new RENAME TO indego.trips_2021_q3;


--- do the same thing with trips_2022_q3
--- (1) deal with the null or " " in the data

---- a. start_time / end_time

SELECT start_time
FROM indego.trips_2022_q3
WHERE start_time !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$';
UPDATE indego.trips_2022_q3
SET start_time = TO_TIMESTAMP(start_time, 'MM/DD/YYYY HH24:MI')
WHERE start_time ~ '^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}$';
UPDATE indego.trips_2022_q3
SET start_time = NULL
WHERE start_time = '';
ALTER TABLE indego.trips_2022_q3
ALTER COLUMN start_time TYPE TIMESTAMP WITH TIME ZONE
USING start_time AT TIME ZONE 'America/New_York';

SELECT end_time
FROM indego.trips_2022_q3
WHERE end_time !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$';
UPDATE indego.trips_2022_q3
SET end_time = TO_TIMESTAMP(end_time, 'MM/DD/YYYY HH24:MI')
WHERE end_time ~ '^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}$';
UPDATE indego.trips_2022_q3
SET end_time = NULL
WHERE end_time = '';
ALTER TABLE indego.trips_2022_q3
ALTER COLUMN end_time TYPE TIMESTAMP WITH TIME ZONE
USING end_time AT TIME ZONE 'America/New_York';


---- b. lat / lon 
SELECT start_lat 
FROM indego.trips_2022_q3
WHERE start_lat = '';
SELECT start_lat 
FROM indego.trips_2022_q3
WHERE start_lat ~ '[^0-9.-]';
UPDATE indego.trips_2022_q3
SET start_lat = NULL
WHERE start_lat = '';
UPDATE indego.trips_2022_q3
SET start_lat = NULL
WHERE start_lat ~ '[^0-9.-]';
ALTER TABLE indego.trips_2022_q3
ALTER COLUMN start_lat TYPE DOUBLE PRECISION USING start_lat::DOUBLE PRECISION;

SELECT start_lon
FROM indego.trips_2022_q3
WHERE start_lon = '';
SELECT start_lon 
FROM indego.trips_2022_q3
WHERE start_lon ~ '[^0-9.-]';
UPDATE indego.trips_2022_q3
SET start_lon = NULL
WHERE start_lon = '';
UPDATE indego.trips_2022_q3
SET start_lon = NULL
WHERE start_lon ~ '[^0-9.-]';
ALTER TABLE indego.trips_2022_q3
ALTER COLUMN start_lon TYPE DOUBLE PRECISION USING start_lon::DOUBLE PRECISION;

SELECT end_lat
FROM indego.trips_2022_q3
WHERE end_lat = '';
SELECT end_lat 
FROM indego.trips_2022_q3
WHERE end_lat ~ '[^0-9.-]';
UPDATE indego.trips_2022_q3
SET end_lat = NULL
WHERE end_lat = '';
UPDATE indego.trips_2022_q3
SET end_lat = NULL
WHERE end_lat ~ '[^0-9.-]';
ALTER TABLE indego.trips_2022_q3
ALTER COLUMN end_lat TYPE DOUBLE PRECISION USING end_lat::DOUBLE PRECISION;

SELECT end_lon
FROM indego.trips_2022_q3
WHERE end_lon = '';
SELECT end_lon 
FROM indego.trips_2022_q3
WHERE end_lon ~ '[^0-9.-]';
UPDATE indego.trips_2022_q3
SET end_lon = NULL
WHERE end_lon = '';
UPDATE indego.trips_2022_q3
SET end_lon = NULL
WHERE end_lon ~ '[^0-9.-]';
ALTER TABLE indego.trips_2022_q3
ALTER COLUMN end_lon TYPE DOUBLE PRECISION USING end_lon::DOUBLE PRECISION;


--- (2) convert the types of the columns

alter table indego.trips_2022_q3
alter column trip_id type text,
alter column duration type INTEGER using duration::integer,
alter column start_time type TIMESTAMP using start_time::TIMESTAMP,
alter column end_time type TIMESTAMP using end_time::TIMESTAMP,
alter column start_station type TEXT,
alter column start_lat type DOUBLE PRECISION using start_lat::DOUBLE PRECISION,
alter column start_lon type DOUBLE PRECISION using start_lon::DOUBLE PRECISION,
alter column end_station type TEXT,
alter column end_lat type DOUBLE PRECISION using end_lat::DOUBLE PRECISION,
alter column end_lon type DOUBLE PRECISION using end_lon::DOUBLE PRECISION,
alter column bike_id type TEXT,
alter column plan_duration type INTEGER using duration::integer,
alter column trip_route_category type TEXT,
alter column passholder_type type text,
alter column bike_type type TEXT;

--- (3) select the columns
CREATE TABLE indego.trips_2022_q3_new AS
SELECT trip_id, duration, start_time, end_time, start_station, 
       start_lat, start_lon, end_station, end_lat, end_lon, 
       bike_id, plan_duration, trip_route_category, 
       passholder_type, bike_type
FROM indego.trips_2022_q3;

SELECT * FROM indego.trips_2022_q3_new LIMIT 10;

DROP TABLE indego.trips_2022_q3;

ALTER TABLE indego.trips_2022_q3_new RENAME TO indego.trips_2022_q3;

-- 3. station_geo
select * from stations_geo;

alter table stations_geo
alter column "name" type TEXT;

create table indego.stations as
select "id", "name", geog from indego.stations_geo;

select * from stations;