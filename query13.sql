/*
    Which station is furthest from Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
SELECT 
    s.id as station_id,
    s.name as station_name,
    round(
        st_distance(
            s.geog,
            st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography,
            TRUE
        ) /50.0
    )*50 as distance
FROM indego.station_statuses as s 
ORDER BY 
    ST_Distance(
    s.geog,
    ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography,
    TRUE
  ) DESC
LIMIT 1

