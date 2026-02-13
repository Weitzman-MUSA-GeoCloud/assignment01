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

    ```SQL
    select count(*)
    from indego.trips_2021_q3
    ```

    **Result:** 300,432

2. [What is the percent change in trips in Q3 2022 as compared to Q3 2021?](query02.sql)

    ```SQL
    SELECT 
    round(
        ((
            (SELECT count(*) FROM indego.trips_2022_q3)::numeric - 
            (SELECT count(*) FROM indego.trips_2021_q3)::numeric
        ) / (SELECT count(*) FROM indego.trips_2021_q3)::numeric) * 100, 
    2) || '%' AS perc_change;
    ```

    **Result:** 3.98%

3. [What is the average duration of a trip for 2021?](query03.sql)

    ```SQL
    select count(*)
    from indego.trips_2021_q3
    ```

    **Result:** 18.86

4. [What is the average duration of a trip for 2022?](query04.sql)

    ```SQL
    select count(*)
    from indego.trips_2022_q3
    ```

    **Result:** 17.88

5. [What is the longest duration trip across the two quarters?](query05.sql)

    ```SQL
    SELECT GREATEST(
        (SELECT max(duration) FROM indego.trips_2021_q3),
        (SELECT max(duration) FROM indego.trips_2022_q3)
    ) AS max_duration;
    ```

    **Result:** 1,440. The 'longest duration' seen in the data likely represents the system's maximum time limit (1,440 minutes/24 hours). Trips of this length are usually not instances of actual continuous riding. Instead, they are typically caused by improper docking (failure to secure the bike in the dock) or stolen/lost bikes, which causes the trip timer to run continuously until the system automatically terminates the record at the cutoff limit.

6. [How many trips in each quarter were shorter than 10 minutes?](query06.sql)

    ```SQL
    SELECT 
        2021 AS trip_year, 
        3 AS trip_quarter, 
        count(*) AS num_trips
    FROM indego.trips_2021_q3 
    WHERE duration < 10

    UNION ALL

    SELECT 
        2022 AS trip_year, 
        3 AS trip_quarter, 
        count(*) AS num_trips
    FROM indego.trips_2022_q3 
    WHERE duration < 10;
    ```

    **Result:** 2021 Q3: 124,528 / 2022 Q3: 137,372

7. [How many trips started on one day and ended on a different day?](query07.sql)

    ```SQL
    SELECT 
        2021 AS trip_year, 
        3 AS trip_quarter, 
        count(*) AS num_trips
    FROM indego.trips_2021_q3 
    WHERE start_time::date != end_time::date

    UNION ALL

    SELECT 
        2022 AS trip_year, 
        3 AS trip_quarter, 
        count(*) AS num_trips
    FROM indego.trips_2022_q3 
    WHERE start_time::date != end_time::date;
    ```

    **Result:** 2021 Q3: 2,301 / 2022 Q3: 2,060

8. [Give the five most popular starting stations across all years between 7am and 9:59am.](query08.sql)

    ```SQL
    WITH all_trips AS (
        SELECT start_station, start_time FROM indego.trips_2021_q3
        UNION ALL
        SELECT start_station, start_time FROM indego.trips_2022_q3
    )
    SELECT
        t.start_station AS station_id,
        s.geog AS station_geog,
        count(*) AS num_trips
    FROM all_trips t
    LEFT JOIN indego.station_statuses s
        ON t.start_station::integer = s.id
    WHERE EXTRACT(HOUR FROM t.start_time) >= 7 
    AND EXTRACT(HOUR FROM t.start_time) < 10
    GROUP BY t.start_station, s.geog
    ORDER BY num_trips DESC
    LIMIT 5;
    ```

    **Result:** 3032, 3102, 3012, 3066, 3007

    _Hint: Use the `EXTRACT` function to get the hour of the day from the timestamp._

9. [List all the passholder types and number of trips for each across all years.](query09.sql)

    ```SQL
    WITH all_trips AS (
        SELECT passholder_type FROM indego.trips_2021_q3
        UNION ALL
        SELECT passholder_type FROM indego.trips_2022_q3
    )
    SELECT 
        passholder_type,
        count(*) AS num_trips
    FROM all_trips
    GROUP BY passholder_type
    ORDER BY num_trips DESC;
    ```

    **Result:** Indego30: 441,856; Indego365: 109,251; Day Pass: 61,659; NULL: 43; Walk-up: 2

10. [Using the station status dataset, find the distance in meters of each station from Meyerson Hall.](query10.sql)

    ```SQL
    SELECT
        id AS station_id,
        geog AS station_geog,
        round(ST_Distance(geog, ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography) / 50) * 50 AS distance
    FROM indego.station_statuses;
    ```

11. [What is the average distance (in meters) of all stations from Meyerson Hall?](query11.sql)

    ```SQL
    SELECT 
        round(avg(ST_Distance(geog, ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography)) / 1000) AS avg_distance_km
    FROM indego.station_statuses;
    ```

    **Result:** 4,000m

12. [How many stations are within 1km of Meyerson Hall?](query12.sql)

    ```SQL
    SELECT count(*) AS num_stations
    FROM indego.station_statuses
    WHERE ST_DWithin(
        geog,
        ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography,
        1000
    );
    ```

    **Result:** 18

13. [Which station is furthest from Meyerson Hall?](query13.sql)

    ```SQL
    SELECT 
        id AS station_id,
        name AS station_name,
        round(ST_Distance(geog, ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography) / 50) * 50 AS distance
    FROM indego.station_statuses
    ORDER BY distance DESC
    LIMIT 1;
    ```

    **Result:** Manayunk & Conarroe, Fairview Park (9,000m)

14. [Which station is closest to Meyerson Hall?](query14.sql)

    ```SQL
    SELECT 
        id AS station_id,
        name AS station_name,
        round(ST_Distance(geog, ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)::geography) / 50) * 50 AS distance
    FROM indego.station_statuses
    ORDER BY distance ASC
    LIMIT 1;
    ```
    
    **Result:** 34th & Spruce (200m)
