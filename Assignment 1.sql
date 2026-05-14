-- Active: 1769627711682@@127.0.0.1@5432@week03
create schema indego;


set search_path=public

psql --host localhost --port 5432 --username postgres --dbname week03 --command "\copy indego_stations FROM "C:\Users\antho\OneDrive\Documents\GitHub\MUSA 5090\indego_stations.json"

ogr2ogr - "PostgreSQL" -nln "neighborhoods" -lco "SCHEMA=phl" -lco "GEOM_TYPE geography" -lco "GEOMETRY_NAME=geog" -lco "OVERWRITE=yes" `
PG:"host=localhost port=5432 dbname=week03 user=postgres password=postgres"`
C:\Users\antho\OneDrive\Documents\GitHub\MUSA 5090\assignment01-MUSA-5090\phl.json

in bash: postgres=# docker run --name postgis-container -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 -v pgdata:/var/lib/postgresql/data postgis/postgis 
------------------------------------------------
--              BEGIN KARL'S NOTES            --
------------------------------------------------
Anthony will always add (NOT replace) this bit as part of the provided 'docker run' command, right after 'docker run' : '-v "C:\Users\antho\OneDrive\Documents\GitHub\MUSA 5090\pg-mount:/pg-mount"'


e.g. I ran this in powershell, and you can copy and paste it and adapt if you needed
to adapt it just ensure you keep the second to last line and replace everything else with the command your professor gave you

docker run --name postgis-container `
  -e POSTGRES_PASSWORD=postgres `
  -p 5432:5432 `
  -v pgdata:/var/lib/postgresql/data `
  -v "C:\Users\antho\OneDrive\Documents\GitHub\MUSA 5090\pg-mount:/pg-mount" `
  -d postgis/postgis

if you want to check if this volume setup worked, then you can try running these commands one by one:
docker exec -it postgis-container bash
cd pg-mount 
ls

if the second command above fails then the volume was not added properly
if the third command above returns an empty line, make sure you have files in the pg-mount folder and then run it again. if it is still returning empty, also need to change 

to open the database inside the container run this in bash: docker exec -it postgis-container psql -U postgres

------------------------------------------------
--              END KARL'S NOTES              --
------------------------------------------------


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

\copy indego_stations2122(station_id, station_name, "day of go_live_date", status)
FROM 'assignment01/indego-stations-2021-10-01.csv'
CSV HEADER;
--run in psql


DROP TABLE IF EXISTS indego.trips_2022_q3;

CREATE TABLE indego.trips_2022_q3(
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

copy indego.trips_2022_q3(trip_id, duration, start_time, end_time, start_station, start_lat, start_lon, end_station, end_lat, end_lon, bike_id, plan_duration, trip_route_category, passholder_type, bike_type)
FROM 'pg-mount/indego-trips-2022-q3.csv'
CSV HEADER;

SELECT * FROM indego.trips_2022_q3
LIMiT 5;