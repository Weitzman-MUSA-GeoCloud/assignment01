-- Active: 1769627980905@@127.0.0.1@5433@assignment_01
create schema if not exists indego;

create extension if not exists postgis;

drop table if exists indego.trips_2021_q3;

create table indego.trips_2021_q3 (
    trip_id text,
    duration integer,
    start_time timestamp,
    end_time timestamp,
    start_station text,
    start_lat float,
    start_lon float,
    end_station text,
    end_lat float,
    end_lon float,
    bike_id text,
    plan_duration integer,
    trip_route_category text,
    passholder_type text,
    bike_type text
);

drop table if exists indego.trips_2022_q3;

create table indego.trips_2022_q3 (
    trip_id text,
    duration integer,
    start_time timestamp,
    end_time timestamp,
    start_station text,
    start_lat float,
    start_lon float,
    end_station text,
    end_lat float,
    end_lon float,
    bike_id text,
    plan_duration integer,
    trip_route_category text,
    passholder_type text,
    bike_type text
);

-- Drop and create station_statuses table.
drop table if exists indego.station_statuses;

create table indego.station_statuses (
    station_id integer,
    station_name text,
    go_live_date date,
    status text
);

-- Load trip data for 2021 Q3 in psql.
-- \copy indego.trips_2021_q3 FROM 'C:\Users\Tess\Desktop\UPenn\UPenn_SS26\MUSA_5090-001_Geospatial_Cloud_Computing\assignment01\indego-trips-2021-q3\indego-trips-2021-q3.csv' CSV HEADER

-- Load trip data for 2022 Q3 in psql.
-- \copy indego.trips_2022_q3 FROM 'C:\Users\Tess\Desktop\UPenn\UPenn_SS26\MUSA_5090-001_Geospatial_Cloud_Computing\assignment01\indego-trips-2022-q3\indego-trips-2022-q3.csv' CSV HEADER

-- Load station statuses in psql. Geography will be added later.
-- \copy indego.station_statuses FROM 'C:\Users\Tess\Desktop\UPenn\UPenn_SS26\MUSA_5090-001_Geospatial_Cloud_Computing\assignment01\indego-trips-2021-q3\indego-stations-2021-q3.csv' CSV HEADER
