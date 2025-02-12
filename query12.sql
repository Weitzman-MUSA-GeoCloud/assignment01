/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

WITH temporary_table AS(
SELECT
	id as station_id,
	(ST_Distance(geog, ST_MakePoint(-75.192584, 39.952415))) AS distance
FROM indego.stations_geo)
SELECT COUNT(*)
FROM temporary_table
WHERE distance < 1000;