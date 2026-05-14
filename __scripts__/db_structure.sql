-- RENAME COLUMNS TO MATCH ASSIGNMENT.
ALTER TABLE indego.station_statuses RENAME COLUMN station_id TO id;
ALTER TABLE indego.station_statuses RENAME COLUMN station_name TO name;
ALTER TABLE indego.station_statuses RENAME COLUMN go_live_date TO go_live_date;
ALTER TABLE indego.station_statuses RENAME COLUMN status TO active_status;

-- ADD GEOGRAPHY.
ALTER TABLE indego.station_statuses ADD COLUMN geog public.GEOGRAPHY;

-- POPULATE GEOGRAPHY FROM TRIPS DATA.
UPDATE indego.station_statuses AS station_statuses
SET
    geog = public.ST_SETSRID(public.ST_MAKEPOINT(trips.start_lon, trips.start_lat), 4326)::public.GEOGRAPHY
FROM indego.trips_2021_q3 AS trips
WHERE
    station_statuses.id = trips.start_station::INTEGER
    AND station_statuses.geog IS NULL;

UPDATE indego.station_statuses AS station_statuses
SET
    geog = public.ST_SETSRID(public.ST_MAKEPOINT(trips.start_lon, trips.start_lat), 4326)::public.GEOGRAPHY
FROM indego.trips_2022_q3 AS trips
WHERE
    station_statuses.id = trips.start_station::INTEGER
    AND station_statuses.geog IS NULL;