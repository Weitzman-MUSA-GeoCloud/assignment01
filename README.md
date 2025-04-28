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

    I calculated the percent change by counting the trips in each year separately and then applying the formula (new-old)/old * 100, using only SELECT queries.

    ```SQL
    SELECT
    ROUND(
        ( (SELECT COUNT(*) FROM indego.trips_2022_q3) - (SELECT COUNT(*) FROM indego.trips_2021_q3) ) 
        * 100.0 / (SELECT COUNT(*) FROM indego.trips_2021_q3),
        2
    )::text || '%' AS perc_change;
    ```

    **Result:** 3.98%

3. [What is the average duration of a trip for 2021?](query03.sql)

    I calculated the average trip duration in minutes for Q3 2021 by applying the AVG() function to the duration field from the indego.trips_2021_q3 table, and rounded the result to two decimal places using the ROUND() function.
    
    ```SQL
    SELECT
    ROUND(AVG(duration), 2) AS avg_duration
    FROM indego.trips_2021_q3;
    ```

    **Result:** 18.86 mins

4. [What is the average duration of a trip for 2022?](query04.sql)

    I calculated the average trip duration in minutes for Q3 2022 by applying the AVG() function to the duration field from the indego.trips_2022_q3 table, and rounded the result to two decimal places using the ROUND() function.

    ```SQL
    SELECT
    ROUND(AVG(duration), 2) AS avg_duration
    FROM indego.trips_2022_q3;
    ```

    **Result:** 17.88 mins.

5. [What is the longest duration trip across the two quarters?](query05.sql)

    I found the maximum trip duration across both Q3 2021 and Q3 2022 by selecting the maximum duration from each table separately using MAX(), combining them with UNION ALL, and then taking the overall maximum value. The final result was rounded as an integer and named max_duration.

    ```SQL
    SELECT
    MAX(max_duration) AS max_duration
    FROM (
      SELECT MAX(duration) AS max_duration FROM indego.trips_2021_q3
      UNION ALL
      SELECT MAX(duration) AS max_duration FROM indego.trips_2022_q3
    ) AS combined_max;
    ```
    
    **Result:** 1440mins / 24 hours

    _Why are there so many trips of this duration?_

    **Answer:** The longest trip duration across the two quarters is 1440 minutes, or 24 hours. This likely reflects rental system caps, lost bikes, or trips that were not ended properly by the user.

6. [How many trips in each quarter were shorter than 10 minutes?](query06.sql)

    I counted the number of trips with a duration less than 10 minutes for each year separately, and combined the results using UNION ALL to produce two records, one for 2021 Q3 and one for 2022 Q3.
    
    ```SQL
    SELECT
    2021 AS trip_year,
    'Q3' AS trip_quarter,
    COUNT(*) AS num_trips
    FROM indego.trips_2021_q3
    WHERE duration < 10
    
    UNION ALL
    
    SELECT
    2022 AS trip_year,
    'Q3' AS trip_quarter,
    COUNT(*) AS num_trips
    FROM indego.trips_2022_q3
    WHERE duration < 10;
    ```

    **Result:** In Q3 2021, there were 124,528 trips shorter than 10 minutes. In Q3 2022, there were 137,372 trips shorter than 10 minutes. This means more short trips happened in 2022 compared to 2021.

7. [How many trips started on one day and ended on a different day?](query07.sql)

    I identified trips that started and ended on different days by casting start_time and end_time to DATE and comparing them. I counted these separately for each year and combined the results using UNION ALL.

    ```SQL
    SELECT
    2021 AS trip_year,
    'Q3' AS trip_quarter,
    COUNT(*) AS num_trips
    FROM indego.trips_2021_q3
    WHERE CAST(start_time AS DATE) <> CAST(end_time AS DATE)
    
    UNION ALL
    
    SELECT
    2022 AS trip_year,
    'Q3' AS trip_quarter,
    COUNT(*) AS num_trips
    FROM indego.trips_2022_q3
    WHERE CAST(start_time AS DATE) <> CAST(end_time AS DATE);
    ```

    **Results:** In Q3 2021, there were 2,060 trips that started on one day and ended on the next day. In Q3 2022, there were 2,060 trips like that as well.

8. [Give the five most popular starting stations across all years between 7am and 9:59am.](query08.sql)

    _Hint: Use the `EXTRACT` function to get the hour of the day from the timestamp._

    I combined trips from Q3 2021 and Q3 2022 using UNION ALL, then filtered trips where the start time hour is between 7 and 9 using EXTRACT(HOUR FROM start_time). I joined the trips with the live_stations table on station_id to get station location. Finally, I grouped by station and ordered by trip count to find the top 5.

    ```SQL
    SELECT
    ls.station_id,
    ls.geog AS station_geog,
    COUNT(*) AS num_trips
    FROM (
    SELECT * FROM indego.trips_2021_q3
    UNION ALL
    SELECT * FROM indego.trips_2022_q3
    ) AS full_trips
    INNER JOIN indego.live_stations ls
    ON full_trips.start_station = ls.station_id
    WHERE EXTRACT(HOUR FROM full_trips.start_time) BETWEEN 7 AND 9
    GROUP BY ls.station_id, ls.geog
    ORDER BY num_trips DESC
    LIMIT 5;
    ```

    **Results:** The top 5 starting stations during 7–9:59 AM were stations 3102, 3012, 3032, 3007, and 3054. All stations now have valid station_geog geography points.

9. [List all the passholder types and number of trips for each across all years.](query09.sql)

    I combined the two quarters with UNION ALL to stack all the trips together, then grouped by passholder_type to count how many trips each type made.

    ```SQL
    SELECT 
    passholder_type,
    COUNT(*) AS num_trips
    FROM (
    SELECT passholder_type FROM indego.trips_2021_q3
    UNION ALL
    SELECT passholder_type FROM indego.trips_2022_q3
    ) AS all_trips
    GROUP BY passholder_type
    ORDER BY num_trips DESC;
    ```

    **Results:** The most common passholder types were Indego30 (449,816 trips), Indego365 (126,584 trips), and Day Pass (48,272 trips). There were also 86 trips without a recorded passholder type (NULL).

10. [Using the station status dataset, find the distance in meters of each station from Meyerson Hall.](query10.sql)

I calculated each station’s distance from Meyerson Hall using ST_Distance on the geog column, cast to geography type. I rounded the results to the nearest 50 meters.

```SQL
SELECT
    station_id,
    geog AS station_geog,
    ROUND(
        ST_Distance(
            geog::geography,
            ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)
        ) / 50
    ) * 50 AS distance
FROM indego.live_stations
ORDER BY distance ASC;
```

**Results:** Most stations are within a few hundred meters of Meyerson Hall, with the closest station about 100 meters away. Distances increase steadily beyond 500 meters.

11. [What is the average distance (in meters) of all stations from Meyerson Hall?](query11.sql)

I used ST_Distance to calculate each station’s distance from Meyerson Hall, then averaged all distances using AVG(). I divided by 1000 to convert meters to kilometers and rounded to the nearest km.

```SQL
SELECT
    ROUND(
        AVG(
            ST_Distance(
                geog::geography,
                ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)
            )
        ) / 1000
    ) AS avg_distance_km
FROM indego.live_stations;
```

**Results:** 3 km

12. [How many stations are within 1km of Meyerson Hall?](query12.sql)

I used ST_Distance to find stations within 1000 meters of Meyerson Hall. I then counted them using COUNT(*).

```SQL
SELECT
    COUNT(*) AS num_stations
FROM indego.live_stations
WHERE
    ST_Distance(
        geog::geography,
        ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)
    ) <= 1000;
```

**Results:** 17 stations

13. [Which station is furthest from Meyerson Hall?](query13.sql)

I calculated the distance from Meyerson Hall to each station using ST_Distance, rounded to the nearest 50 meters, and selected the station with the maximum distance using ORDER BY ... DESC LIMIT 1.

```SQL
SELECT
    station_id,
    station_name,
    ROUND(
        ST_Distance(
            geog::geography,
            ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)
        ) / 50
    ) * 50 AS distance
FROM indego.live_stations
ORDER BY distance DESC
LIMIT 1;
```

**Results:** Manayunk Bridge (station_id 3323) at 8.9 km

14. [Which station is closest to Meyerson Hall?](query14.sql)

The query calculates the distance between each station and Meyerson Hall using the ST_Distance function. It rounds the result to the nearest 50 meters and returns the station with the shortest distance. 

```SQL
SELECT 
    ls.station_id, 
    ls.station_name, 
    ROUND(ST_Distance(ls.geog, ST_SetSRID(ST_MakePoint(-75.192584, 39.952415), 4326)) / 50) * 50 AS distance
FROM 
    indego.live_stations AS ls
ORDER BY 
    distance ASC
LIMIT 1;
```

**Results:** 34th & Spruce with a distance of 200 meters