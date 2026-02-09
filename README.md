# Assignment 01

**Complete by February 04, 2026**

To complete this assigment you will need to do the following:
1.  Fork this repository to your own account.
2.  Clone your fork to your local machine.
3.  Complete the assignment according to the instructions below.
4.  Push your changes to your fork.
5.  Submit a pull request to the original repository. Opening your pull request will be equivalent to you submitting your assignment. You will only need to open one pull request for this assignment. **If you make additional changes to your fork, they will automatically show up in the pull request you already opened.** Your pull request should have your name in the title (e.g. `Assignment 01 - Mjumbe Poe`).

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
    SELECT COUNT(*)
    FROM indego.trips_2021_q3
    ```

    **Result:** 300,432

2. [What is the percent change in trips in Q3 2022 as compared to Q3 2021?](query02.sql)

    ```SQL
    WITH counts AS (
    SELECT
        (SELECT COUNT(*) FROM indego.trips_2022_q3) AS cnt_2022,
        (SELECT COUNT(*) FROM indego.trips_2021_q3) AS cnt_2021
    )
    SELECT ROUND(((cnt_2022::NUMERIC / cnt_2021) - 1) * 100, 2)::TEXT || '%' AS perc_change
    FROM counts;
    ```

    **Result:** 3.98%

3. [What is the average duration of a trip for 2021?](query03.sql)

    ```SQL
    SELECT ROUND(AVG(duration), 2) AS avg_duration
    FROM indego.trips_2021_q3;
    ```
    **Result:** 18.86

4. [What is the average duration of a trip for 2022?](query04.sql)
    ```SQL
    SELECT ROUND(AVG(duration), 2) AS avg_duration
    FROM indego.trips_2022_q3;
    ```
    **Result:** 17.88

5. [What is the longest duration trip across the two quarters?](query05.sql)

    ```SQL
    SELECT MAX(duration) AS max_duration
    FROM (
        SELECT * FROM indego.trips_2021_q3
        UNION ALL
        SELECT * FROM indego.trips_2022_q3
    ) AS all_trips;
    ```
    **Result:** 1440 <br>
    
    _Why are there so many trips of this duration?_
   
    **Answer:** 1440 minutes corresponds to 24hrs, which is likely the timeout period of a bike that has not been re-docked.

6. [How many trips in each quarter were shorter than 10 minutes?](query06.sql)

    ```SQL
    WITH all_trips AS (
        SELECT * FROM indego.trips_2021_q3
        UNION ALL
        SELECT * FROM indego.trips_2022_q3
    )

    SELECT
        EXTRACT(YEAR FROM start_time)::INTEGER AS trip_year,
        EXTRACT(QUARTER FROM start_time)::INTEGER AS trip_quarter,
        SUM(CASE WHEN duration < 10 THEN 1 ELSE 0 END)::INTEGER AS num_trips
    FROM all_trips
    GROUP BY trip_year, trip_quarter;
    ```
    **Result:**<br>
        2021,3,124528 <br>
        2022,3,137372

7. [How many trips started on one day and ended on a different day?](query07.sql)

    ```SQL
    WITH all_trips AS (
        SELECT * FROM indego.trips_2021_q3
        UNION ALL
        SELECT * FROM indego.trips_2022_q3
    )

    SELECT
        EXTRACT(YEAR FROM start_time)::INTEGER AS trip_year,
        EXTRACT(QUARTER FROM start_time)::INTEGER AS trip_quarter,
        SUM(CASE WHEN EXTRACT(DAY FROM start_time) != EXTRACT(DAY FROM end_time) THEN 1 ELSE 0 END)::INTEGER AS num_trips
    FROM all_trips
    GROUP BY trip_year, trip_quarter;
    ```

    **Result:**<br>
        2021, 3, 2301 <br>
        2022, 3, 2060

8. [Give the five most popular starting stations across all years between 7am and 9:59am.](query08.sql)

    _Hint: Use the `EXTRACT` function to get the hour of the day from the timestamp._

    ```SQL
    WITH all_trips AS (
        SELECT * FROM indego.trips_2021_q3
        UNION ALL
        SELECT * FROM indego.trips_2022_q3
    ),

    early_trips AS (
        SELECT *
        FROM all_trips
        WHERE EXTRACT(HOUR FROM start_time) BETWEEN 7 AND 9
    )

    SELECT
        et.start_station AS station_id,
        ss.geog AS station_geog,
        COUNT(*) AS num_trips
    FROM early_trips AS et
    LEFT JOIN indego.station_statuses AS ss
        ON et.start_station::INTEGER = ss.id
    GROUP BY
        et.start_station,
        ss.geog
    ORDER BY
        num_trips DESC
    LIMIT 5;
    ```
    **Result:**<br>
    3032, 0101000020E6100000E8305F5E80CB52C0E9F17B9BFEF84340, 1828 <br>
    3102, 0101000020E6100000963E74417DCB52C0E4F736FDD9FB4340, 1689 <br>
    3012,	0101000020E61000005A8121AB5BCB52C0FF78AF5A99F84340,	1614 <br>
    3066,	0101000020E6100000A5A0DB4B1ACB52C0A2629CBF09F94340,	1529 <br>
    3007,	0101000020E61000008EE9094B3CCA52C085949F54FBF84340,	1434


9. [List all the passholder types and number of trips for each across all years.](query09.sql)

    ```SQL
    WITH all_trips AS (
        SELECT * FROM indego.trips_2021_q3
        UNION ALL
        SELECT * FROM indego.trips_2022_q3
    )

    SELECT
        passholder_type,
        COUNT(*) AS num_trips
    FROM all_trips
    GROUP BY
        passholder_type
    ```
    **Result:** <br>
    Day Pass, 61659 <br>
    Indego30, 441856 <br>
    Indego365, 109251 <br>
    NULL, 43 <br>
    Walk-up, 2

10. [Using the station status dataset, find the distance in meters of each station from Meyerson Hall.](query10.sql)

    ```SQL
    SELECT
        id AS station_id,
        geog AS station_geog,
        ROUND(
            (indego.ST_DISTANCE(
                geog,
                indego.ST_MAKEPOINT(-75.192584, 39.952415)::indego.GEOGRAPHY
            ) / 50)::INTEGER, 0
        ) * 50 AS distance
    FROM indego.station_statuses;
    ```
    **Result:** <br>
    3208, 0101000020E6100000DC114E0B5ECC52C044C02154A9F94340, 200 <br>
    3207, 0101000020E61000003F355EBA49CC52C0D97C5C1B2AFA4340, 250 <br>
    3029, 0101000020E61000009FE5797077CC52C060764F1E16FA4340, 250 <br>
    3009, 0101000020E61000001C08C90226CC52C09869FB5756FA4340, 450 <br>
    3020, 0101000020E6100000D97C5C1B2ACC52C0764F1E166AF94340, 500
11. [What is the average distance (in meters) of all stations from Meyerson Hall?](query11.sql)
    
    ```SQL
    SELECT
        ROUND(
            (AVG(
                indego.ST_DISTANCE(
                    geog,
                    indego.ST_MAKEPOINT(-75.192584, 39.952415)::indego.GEOGRAPHY
                )
            ) / 1000)::NUMERIC, 0
        ) AS distance
    FROM indego.station_statuses;
    ```
    **Result:** 4 (rounded from 3501 meters)

12. [How many stations are within 1km of Meyerson Hall?](query12.sql)
    
    ```SQL
    SELECT COUNT(*) AS num_stations
    FROM indego.station_statuses
    WHERE indego.ST_DWITHIN(
        geog,
        indego.ST_MAKEPOINT(-75.192584, 39.952415)::indego.GEOGRAPHY,
        1000
    );
    ```
    **Result:** 18

13. [Which station is furthest from Meyerson Hall?](query13.sql)

    ```SQL
    SELECT
        id AS station_id,
        name AS station_name,
        ROUND(
            (indego.ST_DISTANCE(
                geog,
                indego.ST_MAKEPOINT(-75.192584, 39.952415)::indego.GEOGRAPHY
            ) / 50)::INTEGER, 0
        ) * 50 AS distance
    FROM indego.station_statuses
    ORDER BY distance DESC
    LIMIT 1;
    ```
    **Result:** 3432, Manayunk & Conarroe, Fairview Park, 9000

14. [Which station is closest to Meyerson Hall?](query14.sql)
    
    ```SQL
    SELECT
        id AS station_id,
        name AS station_name,
        ROUND(
            (indego.ST_DISTANCE(
                geog,
                indego.ST_MAKEPOINT(-75.192584, 39.952415)::indego.GEOGRAPHY
            ) / 50)::INTEGER, 0
        ) * 50 AS distance
    FROM indego.station_statuses
    ORDER BY distance ASC
    LIMIT 1;
    ```
    **Result:** 3208, 34th & Spruce, 200
