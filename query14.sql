/*
    Which station is closest to Meyerson Hall?

    Your query should return only one line, and only give the station id
    (station_id), station name (station_name), and distance (distance) from
    Meyerson Hall, rounded to the nearest 50 meters.
*/

-- Enter your SQL query here
SELECT
    id AS station_id,
    name AS station_name,
    ROUND(
        public.ST_Distance(
            geom::public.geography,
            public.ST_MakePoint(-75.192584, 39.952415)::public.geography
        ) / 50
    ) * 50 AS distance
FROM indego.station_statuses_raw
ORDER BY
    public.ST_Distance(
        geom::public.geography,
        public.ST_MakePoint(-75.192584, 39.952415)::public.geography
    ) ASC
LIMIT 1;
