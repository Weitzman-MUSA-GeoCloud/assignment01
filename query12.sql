/*
    How many stations are within 1km of Meyerson Hall?

    Your query should have a single record with a single attribute, the number
    of stations (num_stations).
*/

-- Enter your SQL query here
SELECT
    count(*) as num_stations
FROM
    indego.station_statuses as s
WHERE 
    st_distance(
                s.geog,
                st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography,
                TRUE
             ) < 1000