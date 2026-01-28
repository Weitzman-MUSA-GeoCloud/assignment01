/*
    /*
        Give the five most popular starting stations across all years between 7am
        and 9:59am.

        Your result should have 5 records with three columns, one for the station id
        (named `station_id`), one for the point geography of the station (named
        `station_geog`), and one for the number of trips that started at that
        station (named `num_trips`).
    */

    -- Enter your SQL query here

    SELECT
        stations.id AS station_id,
        stations.geog AS station_geog,
        COUNT(trips.trip_id) AS num_trips
    FROM
        (
            SELECT
                y1.start_station,
                y1.trip_id
            FROM indego.trips_2021_q3 AS y1
            WHERE EXTRACT(HOUR FROM y1.start_time) >= 7 AND EXTRACT(HOUR FROM y1.start_time) < 10
            UNION
            SELECT
                y2.start_station,
                y2.trip_id
            FROM indego.trips_2022_q3 AS y2
            WHERE EXTRACT(HOUR FROM y2.start_time) >= 7 AND EXTRACT(HOUR FROM y2.start_time) < 10
        ) AS trips
    LEFT JOIN indego.station_statuses AS stations ON stations.id::TEXT = trips.start_station
    GROUP BY
        stations.id,
        stations.geog
    HAVING
        stations.id IS NOT NULL
    ORDER BY
        num_trips DESC
    LIMIT 5;