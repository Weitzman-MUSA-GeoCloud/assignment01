-- here is the code for loading data on pgAdmin 4
drop table if exists indego.trips_2021_q3;
create table indego.trips_2021_q3
(
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

copy indego.trips_2021_q3
from '/Users/akiradisandro/Documents/MUSA/Spring25/MUSA_CloudComputing/assignment01/data/indego-trips-2021-q3.csv'
with (format csv, header true);

-- same thing but for 2022 data
drop table if exists indego.trips_2022_q3;
create table indego.trips_2022_q3
(
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

copy indego.trips_2022_q3
from '/Users/akiradisandro/Documents/MUSA/Spring25/MUSA_CloudComputing/assignment01/data/indego-trips-2022-q3.csv'
with (format csv, header true);