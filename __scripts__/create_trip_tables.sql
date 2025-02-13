create schema if not exists indego;
DROP TABLE IF EXISTS indego_trips_2021_q3;
CREATE TABLE indego_trips_2021_q3
(
  trip_id       INTEGER,
  duration      INTEGER,
  start_time    TEXT,
  end_time      TEXT,
  start_station INTEGER,
  start_lat     Real,
  start_lon     Real,
  end_station   INTEGER,
  end_lat       Real,
  end_lon       Real,
  bike_id       TEXT,
  plan_duration INTEGER,
  trip_route_cat TEXT,
  passholder    TEXT,
  bike_type      TEXT
);

COPY indego_trips_2021_q3 FROM 'C:/Users/super/Downloads/School Work/MUSA 5090/5090assignment01/indego-trips-2021-q3/indego-trips-2021-q3.csv' CSV HEADER;

SELECT * FROM indego_trips_2021_q3;

DROP TABLE IF EXISTS indego_trips_2022_q3;
CREATE TABLE indego_trips_2022_q3
(
  trip_id       INTEGER,
  duration      INTEGER,
  start_time    TEXT,
  end_time      TEXT,
  start_station INTEGER,
  start_lat     Real,
  start_lon     Real,
  end_station   INTEGER,
  end_lat       Real,
  end_lon       Real,
  bike_id       TEXT,
  plan_duration INTEGER,
  trip_route_cat TEXT,
  passholder    TEXT,
  bike_type      TEXT
);

COPY indego_trips_2022_q3 FROM 'C:/Users/super/Downloads/School Work/MUSA 5090/5090assignment01/indego-trips-2022-q3/indego-trips-2022-q3.csv' CSV HEADER;

SELECT * FROM indego_trips_2022_q3;

DROP EXTENSION postgis;

create extension if not exists postgis;



