-- Active: 1769627980905@@127.0.0.1@5433@assignment_01
-- Rename columns to match assignment.
alter table indego.station_statuses rename column station_id to id;
alter table indego.station_statuses rename column station_name to name;
alter table indego.station_statuses rename column go_live_date to go_live_date;
alter table indego.station_statuses rename column status to active_status;
-- Add geography.
alter table indego.station_statuses add column geog public.geography;

-- Populate geography from trips data.
update indego.station_statuses as station_statuses
set
    geog = public.st_setsrid(public.st_makepoint(trips.start_lon, trips.start_lat), 4326)::public.geography
from indego.trips_2021_q3 as trips
where
    station_statuses.id = trips.start_station::integer
    and station_statuses.geog is null;

update indego.station_statuses as station_statuses
set
    geog = public.st_setsrid(public.st_makepoint(trips.start_lon, trips.start_lat), 4326)::public.geography
from indego.trips_2022_q3 as trips
where
    station_statuses.id = trips.start_station::integer
    and station_statuses.geog is null;
