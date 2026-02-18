/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
SELECT
    s.id AS station_id,
    s.name AS station_name,
    round(
        st_distance(
            s.geog,
            st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography,
            TRUE
        ) / 50.0
    ) * 50 AS distance
FROM indego.station_statuses AS s
ORDER BY
    st_distance(
        s.geog,
        st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography,
        TRUE
    ) ASC
LIMIT 1
