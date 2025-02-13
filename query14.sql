/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/
<<<<<<< HEAD

=======
>>>>>>> ecb232b9506762c67f221864e43782df964a27bc
SELECT
    station_statuses.id AS station_id,
    station_statuses.name AS station_name,
    ROUND(
        ST_DISTANCE(
            station_statuses.geog,
            ST_SETSRID(ST_MAKEPOINT(-75.192584, 39.952415), 4326)
        )
        / 50
    )
    * 50 AS distance
FROM
    indego.station_statuses
ORDER BY
    distance ASC
LIMIT 1;
