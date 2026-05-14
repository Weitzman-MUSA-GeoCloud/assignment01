-- Load data into Assignment1 database
-- CSV uses date format "M/D/YYYY H:MM" which COPY cannot parse directly.
-- Step 1: Copy into staging tables (timestamps as TEXT), then insert into real tables.
--
-- 重要：请 全选整份文件 (Ctrl+A) 后一次性执行，不要只运行单条语句。
-- COPY 在服务器端读文件，路径必须在运行 PostgreSQL 的电脑上存在。

-- ========== 2021 Q3 ==========
-- Staging table (same columns but start_time/end_time as TEXT)
DROP TABLE IF EXISTS indego.trips_2021_q3_staging;
CREATE TABLE indego.trips_2021_q3_staging (
    trip_id TEXT,
    duration INTEGER,
    start_time TEXT,
    end_time TEXT,
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

COPY indego.trips_2021_q3_staging
FROM 'E:\MUSA\MUSA 5090\MUSA-5090-assignment01\datasets\indego-trips-2021-q3\indego-trips-2021-q3.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO indego.trips_2021_q3 (
    trip_id, duration, start_time, end_time,
    start_station, start_lat, start_lon, end_station, end_lat, end_lon,
    bike_id, plan_duration, trip_route_category, passholder_type, bike_type
)
SELECT
    trip_id,
    duration,
    TO_TIMESTAMP(start_time, 'FMMM/FMDD/YYYY FMHH24:MI'),
    TO_TIMESTAMP(end_time, 'FMMM/FMDD/YYYY FMHH24:MI'),
    start_station, start_lat, start_lon, end_station, end_lat, end_lon,
    bike_id, plan_duration, trip_route_category, passholder_type, bike_type
FROM indego.trips_2021_q3_staging;

DROP TABLE indego.trips_2021_q3_staging;

-- ========== 2022 Q3 ==========
DROP TABLE IF EXISTS indego.trips_2022_q3_staging;
CREATE TABLE indego.trips_2022_q3_staging (
    trip_id TEXT,
    duration INTEGER,
    start_time TEXT,
    end_time TEXT,
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

COPY indego.trips_2022_q3_staging
FROM 'E:\MUSA\MUSA 5090\MUSA-5090-assignment01\datasets\indego-trips-2022-q3\indego-trips-2022-q3.csv'
DELIMITER ','
CSV HEADER;

INSERT INTO indego.trips_2022_q3 (
    trip_id, duration, start_time, end_time,
    start_station, start_lat, start_lon, end_station, end_lat, end_lon,
    bike_id, plan_duration, trip_route_category, passholder_type, bike_type
)
SELECT
    trip_id,
    duration,
    TO_TIMESTAMP(start_time, 'FMMM/FMDD/YYYY FMHH24:MI'),
    TO_TIMESTAMP(end_time, 'FMMM/FMDD/YYYY FMHH24:MI'),
    start_station, start_lat, start_lon, end_station, end_lat, end_lon,
    bike_id, plan_duration, trip_route_category, passholder_type, bike_type
FROM indego.trips_2022_q3_staging;

DROP TABLE indego.trips_2022_q3_staging;

-- Note: For station_statuses, load the GeoJSON via ogr2ogr or pgAdmin import.
