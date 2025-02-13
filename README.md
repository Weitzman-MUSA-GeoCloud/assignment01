# Assignment 01

**Complete by February 12, 2025**

## Datasets

* Indego Bikeshare station status data
* Indego Trip data
  - Q3 2021
  - Q3 2022

All data is available from [Indego's Data site](https://www.rideindego.com/about/data/).

For any questions that refer to Meyerson Hall, use latitude `39.952415` and longitude `-75.192584` as the coordinates for the building.

Load all three datasets into a PostgreSQL database schema named `indego` (the name of your database is not important). Your schema should have the following structure:

> This structure is important -- particularly the **table names** and the **lowercase field names**; if your queries are not built to work with this structure then _your assignment will fail the tests_.

* **Table**: `indego.trips_2021_q3`  
  **Fields**:
    * `trip_id TEXT`
    * `duration INTEGER`
    * `start_time TIMESTAMP`
    * `end_time TIMESTAMP`
    * `start_station TEXT`
    * `start_lat FLOAT`
    * `start_lon FLOAT`
    * `end_station TEXT`
    * `end_lat FLOAT`
    * `end_lon FLOAT`
    * `bike_id TEXT`
    * `plan_duration INTEGER`
    * `trip_route_category TEXT`
    * `passholder_type TEXT`
    * `bike_type TEXT`

* **Table**: `indego.trips_2022_q3`  
  **Fields**: (same as above)

* **Table**: `indego.station_statuses`  
  **Fields** (at a minimum -- there may be many more):
    * `id INTEGER`
    * `name TEXT` (or `CHARACTER VARYING`)
    * `geog GEOGRAPHY`
    * ...

## Questions

Write a query to answer each of the questions below.
* Your queries should produce results in the format specified.
* Write your query in a SQL file corresponding to the question number (e.g. a file named _query06.sql_ for the answer to question #6).
* Each SQL file should contain a single `SELECT` query.
* Any SQL that does things other than retrieve data (e.g. SQL that creates indexes or update columns) should be in the _db_structure.sql_ file.
* Some questions include a request for you to discuss your methods. Update this README file with your answers in the appropriate place.


1. [How many bike trips in Q3 2021?](query01.sql)

    This file is filled out for you, as an example.

    ```SQL
    select count(*)
    from indego.trips_2021_q3
    ```

    **Result:** 300,432

2. [What is the percent change in trips in Q3 2022 as compared to Q3 2021?](query02.sql)

    ```SQL
    SELECT
        (
            ROUND(
                (
                    (c2022.count_2022 - c2021.count_2021)::DECIMAL
                    / c2021.count_2021 * 100
                ),
                2
            )::TEXT || '%'
        ) AS perc_change
    FROM
        (SELECT COUNT(*) AS count_2021 FROM indego.trips_2021_q3) AS c2021,
        (SELECT COUNT(*) AS count_2022 FROM indego.trips_2022_q3) AS c2022;    ```

    **Result:** 3.98%

3. [What is the average duration of a trip for 2021?](query03.sql)

    ```SQL
    SELECT ROUND(AVG(duration)::numeric, 2) AS avg_duration
    FROM indego.trips_2021_q3;
    ```

    **Result:** 18.86 minutes.

4. [What is the average duration of a trip for 2022?](query04.sql)

    ```SQL
    SELECT ROUND(AVG(duration)::numeric, 2) AS avg_duration
    FROM indego.trips_2022_q3;
    ```

    **Result:** 17.88 minutes.

5. [What is the longest duration trip across the two quarters?](query05.sql)

    ```SQL
    SELECT MAX(duration) AS max_duration
    FROM (
        SELECT duration FROM indego.trips_2021_q3
        UNION ALL
        SELECT duration FROM indego.trips_2022_q3
    ) AS combined;
    ```

    **Result:** 1,440 minutes.

    _Why are there so many trips of this duration?_

    **Answer:** This is probably the upper limit for Indego to count its bike trip durations (1,440 minutes = 1 day).

6. [How many trips in each quarter were shorter than 10 minutes?](query06.sql)

    ```SQL
    SELECT
        2021 AS trip_year,
        3 AS trip_quarter,
        COUNT(*) AS num_trips
    FROM indego.trips_2021_q3
    WHERE duration < 10

    UNION ALL

    SELECT
        2022,
        3,
        COUNT(*)
    FROM indego.trips_2022_q3
    WHERE duration < 10;
    ```

    **Result:** In 2021 Q3 there were 124,528 trips; in 2022 Q3 there were 137,372 trips.

7. [How many trips started on one day and ended on a different day?](query07.sql)

    ```SQL
    SELECT
        2021 AS trip_year,
        3 AS trip_quarter,
        COUNT(*) AS num_trips
    FROM indego.trips_2021_q3
    WHERE DATE(start_time) != DATE(end_time)

    UNION ALL

    SELECT
        2022 AS trip_year,
        3 AS trip_quarter,
        COUNT(*) AS num_trips
    FROM indego.trips_2022_q3
    WHERE DATE(start_time) != DATE(end_time);
    ```

    **Result:** In 2021 Q3 there were 2,301 trips; in 2022 Q3 there were 2,060 trips.

8. [Give the five most popular starting stations across all years between 7am and 9:59am.](query08.sql)

    _Hint: Use the `EXTRACT` function to get the hour of the day from the timestamp._

    ```SQL
    SELECT
        indego.station_statuses.id AS station_id,
        indego.station_statuses.geog AS station_geog,
        COUNT(*) AS num_trips
    FROM (
        SELECT * FROM indego.trips_2021_q3
        UNION ALL
        SELECT * FROM indego.trips_2022_q3
    ) AS all_trips
    INNER JOIN indego.station_statuses
        ON all_trips.start_station = indego.station_statuses.id::text
    WHERE EXTRACT(HOUR FROM all_trips.start_time) BETWEEN 7 AND 9
    GROUP BY indego.station_statuses.id, indego.station_statuses.geog
    ORDER BY COUNT(*) DESC
    LIMIT 5;
    ```

    **Result:** Station ID 3032, 3102, 3012, 3066, 3007.

9. [List all the passholder types and number of trips for each across all years.](query09.sql)

    ```SQL
    SELECT
        passholder_type,
        COUNT(*) AS num_trips
    FROM (
        SELECT passholder_type
        FROM indego.trips_2021_q3

        UNION ALL

        SELECT passholder_type
        FROM indego.trips_2022_q3
    ) AS all_passholders
    GROUP BY passholder_type
    ORDER BY passholder_type;
    ```

    **Result:** Day Pass: 61,659 trips; Indego30: 441,856 trips; Indego365: 109,251 trips; No Record: 43 trips; Walk-Up: 2 trips.

10. [Using the station status dataset, find the distance in meters of each station from Meyerson Hall.](query10.sql)

    ```SQL
    SELECT
        station_statuses.id AS station_id,
        station_statuses.geog AS station_geog,
        ROUND(
            ST_DISTANCE(
                indego.station_statuses.geog,
                ST_SETSRID(ST_MAKEPOINT(-75.192584, 39.952415), 4326)::geography
            ) / 50
        ) * 50 AS distance
    FROM indego.station_statuses
    ORDER BY distance DESC;
    ```

11. [What is the average distance (in meters) of all stations from Meyerson Hall?](query11.sql)

    ```SQL
    SELECT
        ROUND(
            AVG(
                ST_DISTANCE(
                    indego.station_statuses.geog,
                    ST_SETSRID(ST_MAKEPOINT(-75.192584, 39.952415), 4326)::geography
                 ) / 1000.0
             )
         ) AS avg_distance_km
    FROM indego.station_statuses;
    ```

    **Result:** 3,000

12. [How many stations are within 1km of Meyerson Hall?](query12.sql)

    ```SQL
    SELECT COUNT(*) AS num_stations
    FROM indego.station_statuses
    WHERE (ST_DISTANCE(
        indego.station_statuses.geog,
        ST_SETSRID(ST_MAKEPOINT(-75.192584, 39.952415), 4326)::geography
    ) < 1000)
    ```

    **Result:** 17

13. [Which station is furthest from Meyerson Hall?](query13.sql)

    ```SQL
    SELECT
        station_statuses.id AS station_id,
        station_statuses.name AS station_name,
        ROUND(
            ST_DISTANCE(
                indego.station_statuses.geog,
                ST_SETSRID(ST_MAKEPOINT(-75.192584, 39.952415), 4326)::geography
            ) / 50
        ) * 50 AS distance
    FROM indego.station_statuses
    ORDER BY distance DESC
    LIMIT 1;
    ```

    **Result:** Manayunk Bridge Station.

14. [Which station is closest to Meyerson Hall?](query14.sql)

    ```SQL
    SELECT
       station_statuses.id AS station_id,
       station_statuses.name AS station_name,
       ROUND(
            ST_DISTANCE(
                indego.station_statuses.geog,
                ST_SETSRID(ST_MAKEPOINT(-75.192584, 39.952415), 4326)::geography
            ) / 50
        ) * 50 AS distance
    FROM indego.station_statuses
    ORDER BY distance ASC
    LIMIT 1;
    ```

    **Result:** 34th & Spruce Station.
