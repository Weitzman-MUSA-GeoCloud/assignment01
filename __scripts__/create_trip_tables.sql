create schema if not exists indego;

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

SET datestyle = 'MDY';
copy indego.trips_2021_q3
from 'C:\Users\19397\Documents\GitHub\MUSA_509\musa509_assignment01\data\indego-trips-2021-q3.csv'
with (format csv, header true);

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

copy indego.trips_2022_q3
from 'C:\Users\19397\Documents\GitHub\MUSA_509\musa509_assignment01\data\indego-trips-2022-q3.csv'
with (format csv, header true);

create extension if not exists postgis;
