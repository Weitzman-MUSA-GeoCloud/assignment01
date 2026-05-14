CREATE EXTENSION IF NOT EXISTS postgis;

create schema if not exists indego;

drop table if exists indego.stations;
create table indego.stations(
    id INTEGER,
    name TEXT,
    geog GEOGRAPHY
	);

drop table if exists indego.trips_2022_q3;
create table indego.trips_2022_q3(
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

drop table if exists indego.trips_2021_q3;
create table indego.trips_2021_q3(
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



CREATE EXTENSION IF NOT EXISTS postgis;
ogr2ogr -f "PostgreSQL" `
  PG:"host=127.0.0.1 port=5433 dbname=assignment1 user=postgres password=C4lim0nt9" `
  "C:\Users\tjama\Cloud_Computing\Assignment_1\assignment01\data\indego-stations-status.geojson" `
  -nln stations `
  -lco SCHEMA=indego ` 
  -lco GEOMETRY_NAME=geom `
  -lco FID=id `
  -lco OVERWRITE=yes `
  -nlt PROMOTE_TO_MULTI 

ogr2ogr -f "PostgreSQL" \
  -nln "stations" \
  -lco "SCHEMA=indego" \
  -lco "GEOM_TYPE=geography" \
  -lco "GEOMETRY_NAME=geog" \
  -lco "OVERWRITE=yes" \
  PG:"host=127.0.0.1 port=5433 dbname=assignment1 user=postgres password=C4lim0nt9" \
  /c/Users/tjama/Cloud_Computing/Assignment_1/assignment01/data/indego-stations-status.geojson