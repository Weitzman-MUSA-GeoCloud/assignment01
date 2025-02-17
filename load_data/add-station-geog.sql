/*
  i didn't end up using this anymore because the station_geogs were not matching up correctly, but i wanted to keep this useful code
*/

-- add station geography to trip data
alter table indego.trips_2021_q3
add column station_geog geography(point, 4326);

update indego.trips_2021_q3 
set station_geog = ST_SetSRID(ST_MakePoint(start_lon::float8, start_lat::float8), 4326);

select *
from indego.trips_2021_q3;

--do the same thing for 2022 data
alter table indego.trips_2022_q3
add column station_geog geography(point, 4326);

update indego.trips_2022_q3 
set station_geog = ST_SetSRID(ST_MakePoint(start_lon::float8, start_lat::float8), 4326);

select *
from indego.trips_2022_q3;