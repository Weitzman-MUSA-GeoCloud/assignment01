1
select count(*)
from indego.trips_2021_q3;

2
select ROUND((
    (select count(*) from indego.trips_2022_q3) - 
    (select count(*) from indego.trips_2021_q3)) / (SELECT COUNT(*) FROM indego.trips_2021_q3) *100.0,2) AS perc_change;

3
select ROUND(avg(duration),2) from indego.trips_2021_q3 AS avg_duration;

4
select ROUND(avg(duration),2) from indego.trips_2022_q3 AS avg_duration;

5
SELECT MAX(duration) AS max_duration
FROM (
    SELECT duration FROM indego.trips_2021_q3
    UNION
    SELECT duration FROM indego.trips_2022_q3
) AS combined; --do I need to renmae this

6

CREATE TABLE count21 AS
SELECT COUNT(*) AS num_trips
FROM indego.trips_2021_q3
WHERE duration <10;

ALTER TABLE count21
ADD COLUMN trip_year INTEGER,
ADD COLUMN trip_quarter INTEGER;

UPDATE count21 SET trip_year=2021, trip_quarter=3;

CREATE TABLE count22 AS
SELECT COUNT(*) AS num_trips
FROM indego.trips_2022_q3
WHERE duration <10;


ALTER TABLE count22
ADD COLUMN trip_year INTEGER,
ADD COLUMN trip_quarter INTEGER;

UPDATE count22 SET trip_year=2022, trip_quarter=3;

CREATE TABLE query06 AS
SELECT trip_year, trip_quarter, num_trips
FROM (
    SELECT trip_year, trip_quarter, num_trips FROM count21
    UNION ALL
    SELECT trip_year, trip_quarter, num_trips FROM count22
) AS combined;


7
SELECT COUNT(*)
FROM(  SELECT * FROM indego.trips_2021_q3
    UNION ALL
    SELECT * FROM indego.trips_2022_q3
) AS combined
WHERE DATE(start_time) <> DATE(end_time);
--need to make it work in columns as required

8
CREATE TABLE query08 AS
SELECT start_station AS station_id, COUNT(*) AS num_trips
FROM (  SELECT * FROM indego.trips_2021_q3
    UNION ALL
    SELECT * FROM indego.trips_2022_q3
) AS combined
WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9
hour<=9,
GROUP BY station_id, station_geog
ORDER BY num_trips DESC
LIMIT 5;

SELECT
    query08.*,
    indego.station_statuses.geog
FROM query08
LEFT JOIN indego.station_statuses
    ON query08.station_id = indego.station_statuses.id;


9

SELECT passholder_type, COUNT(*) as num_trips
FROM (  SELECT * FROM indego.trips_2021_q3
    UNION ALL
    SELECT * FROM indego.trips_2022_q3
) AS combined
GROUP BY passholder_type;

10
SELECT station_id, geog as station_geog, 
ROUND(st_distance(geog, st_makepoint(75.192584,39.952415)::geography)/50.0)*50.0 AS distance
FROM indego.station_statuses.geog;

11
SELECT AVG(st_distance(geog, st_makepoint(75.192584,39.952415)::geography)/1000.0) AS avg_distance_km FROM indego.station_statuses;

12
SELECT COUNT(*) AS num_stations
FROM indego.station_statuses 
WHERE st_distance(geog, st_makepoint(75.192584,39.952415)::geography) < 1000.0;

13
SELECT id as station_id, name as station_name, ROUND(st_distance(geog, st_makepoint(75.192584,39.952415)::geography)/50.0)*50.0 AS distance
FROM indego.station_statuses
ORDER BY distance DESC
LIMIT 1;

14
SELECT id as station_id, name as station_name, ROUND(st_distance(geog, st_makepoint(75.192584,39.952415)::geography)/50.0)*50.0 AS distance
FROM indego.station_statuses
ORDER BY distance ASC
LIMIT 1;
