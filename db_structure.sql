-- Enable PostGIS
create extension if not exists postgis;

-- Create schema
create schema if not exists indego;

-- Trips tables
drop table if exists indego.trips_2021_q3;
create table indego.trips_2021_q3 (
  trip_id text,
  duration integer,
  start_time timestamp,
  end_time timestamp,
  start_station text,
  start_lat double precision,
  start_lon double precision,
  end_station text,
  end_lat double precision,
  end_lon double precision,
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
  start_lat double precision,
  start_lon double precision,
  end_station text,
  end_lat double precision,
  end_lon double precision,
  bike_id text,
  plan_duration integer,
  trip_route_category text,
  passholder_type text,
  bike_type text
);

-- Stations table 
drop table if exists indego.station_statuses;
create table indego.station_statuses (
  id integer,
  name text,
  geog geography(point, 4326)
);

