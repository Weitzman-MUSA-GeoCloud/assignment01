-- view table
SELECT *
FROM indego.q3_2021_trips;

-- get column names
SELECT COLUMN_NAME
   FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_NAME = N'q3_2021_trips';

-- alter table to match description in readme for assignment01
/*
trip_id TEXT
duration INTEGER
start_time TIMESTAMP
end_time TIMESTAMP
start_station TEXT
start_lat FLOAT
start_lon FLOAT
end_station TEXT
end_lat FLOAT
end_lon FLOAT
bike_id TEXT
plan_duration INTEGER
trip_route_category TEXT
passholder_type TEXT
bike_type TEXT
*/

/*
  steps:
  remove ogc_fid
  make sure datatypes are correct
*/
ALTER TABLE indego.q3_2021_trips
DROP COLUMN ogc_fid;

SHOW timezone;

ALTER TABLE indego.q3_2021_trips
    ALTER COLUMN trip_id TYPE TEXT,
    ALTER COLUMN duration TYPE INTEGER USING (duration::INTEGER),
    --ALTER COLUMN start_time TYPE TIMESTAMP WITH TIME ZONE,
    --ALTER COLUMN end_time TYPE TIMESTAMP,
    ALTER COLUMN start_station TYPE TEXT,
    ALTER COLUMN start_lat TYPE NUMERIC USING NULLIF(start_lat, '')::NUMERIC,
    ALTER COLUMN start_lon TYPE NUMERIC USING NULLIF(start_lon, '')::NUMERIC,
    ALTER COLUMN end_station TYPE TEXT,
    ALTER COLUMN end_lat TYPE NUMERIC USING NULLIF(end_lat, '')::NUMERIC,
    ALTER COLUMN end_lon TYPE NUMERIC USING NULLIF(end_lon, '')::NUMERIC,
    ALTER COLUMN bike_id TYPE TEXT,
    ALTER COLUMN plan_duration TYPE INTEGER USING (plan_duration::INTEGER),
    ALTER COLUMN trip_route_category TYPE TEXT,
    ALTER COLUMN passholder_type TYPE TEXT,
    ALTER COLUMN bike_type TYPE TEXT;

/* 
  i got close to figuring this out, but i realized it would just be easier to do this in pgAdmin 4
  specifically having trouble with converting lat/lon variables to floats (can do numeric, but can't figure out floats)
  and start_time end_time conversion to timestamp is panning out to be annoying as well
*/
-- repeat steps for q3_2022_trips
ALTER TABLE indego.q3_2022_trips
DROP COLUMN ogc_fid;