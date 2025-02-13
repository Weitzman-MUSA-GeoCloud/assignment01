/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/
<<<<<<< HEAD

=======
>>>>>>> ecb232b9506762c67f221864e43782df964a27bc
SELECT COUNT(*) AS num_stations
FROM
    indego.station_statuses
WHERE
    ST_DISTANCE(station_statuses.geog, ST_SETSRID(ST_MAKEPOINT(-75.192584, 39.952415), 4326)) <= 1000;
