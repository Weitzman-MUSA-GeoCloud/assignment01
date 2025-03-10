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
      num_trips_2021,
      num_trips_2022,
      ROUND(( (num_trips_2022 - num_trips_2021) * 100.0 / num_trips_2021),2) ::text ||'%' as perc_change
    from (
      select 
          (select count(*) from indego.trips_2021_q3) as num_trips_2021,
          (select count(*) from indego.trips_2022_q3) as num_trips_2022
    ) as trip_counts;
    ```

    **Result:** 3.98%

3. [What is the average duration of a trip for 2021?](query03.sql)

    ```SQL
    select round(avg(duration),2) ::text ||'min' as avg_duration
    from indego.trips_2021_q3
    ```

    **Result:** 18.86min

4. [What is the average duration of a trip for 2022?](query04.sql)

    ```SQL
    select round(avg(duration),2) ::text ||'min' as avg_duration
    from indego.trips_2022_q3
    ```

    **Result:** 17.88min

5. [What is the longest duration trip across the two quarters?](query05.sql)

    ```SQL
    select max(duration) ::text ||'min' as max_duration
    from (
      select duration from indego.trips_2021_q3
      UNION ALL
      select duration from indego.trips_2021_q3
    ) as duration_two_quarters
    ```

    **Result:** 1440min

    _Why are there so many trips of this duration?_

    **Answer:** Maybe it is because that some people may forget to lock it when they return the bikes. And I also checked the whole list of duration, which shows a lot of '1440'. I guess this might be because the bike will automatically be locked and go to the end after the trip have been 1440 min.

6. [How many trips in each quarter were shorter than 10 minutes?](query06.sql)

    ```SQL
    SELECT
    '2021' as trip_year,
    'Q3' as trip_quarter,
    count(*) as num_trips
    from indego.trips_2021_q3
    where duration < 10
    
    union ALL
    
    SELECT
    '2022' as trip_year,
    'Q3' as trip_quarter,
    count(*) as num_trips
    from indego.trips_2022_q3
    where duration < 10
    ```

    **Result:** 2021,Q3,124528; 2022,Q3,137372

7. [How many trips started on one day and ended on a different day?](query07.sql)

    ```SQL
    select 
      '2021' as trip_year,
     'Q3' as trip_quarter,
      count(*) as num_trips
    from indego.trips_2021_q3
    where date(start_time)<>date(end_time)

    union ALL

    select
      '2022' as trip_year,
      'Q3' as trip_quarter,
      count(*) as num_trips
    from indego.trips_2022_q3
    where date(start_time) <> date(end_time)
    
    ```

    **Result:** 2021,Q3,2301; 2022,Q3,2060


8. [Give the five most popular starting stations across all years between 7am and 9:59am.](query08.sql)

    ```SQL
    select 
      sta.id as station_id,
      sta.geog as station_geog,
      count(*) as num_trips
    from (
        select start_time, start_station from indego.trips_2021_q3
        union ALL
        select start_time, start_station from indego.trips_2022_q3
    ) as trips
    right join indego.stations_geo as sta
    on trips.start_station = cast(sta.id as text)
    where cast((extract(hour from start_time)) as INTEGER) between 7 and 9
    group by sta.id, sta.geog
    order by num_trips desc
    limit 5;
    ```

    **Result:** 3032	0101000020E6100000E8305F5E80CB52C0E9F17B9BFEF84340	1828;
    3102	0101000020E6100000963E74417DCB52C0E4F736FDD9FB4340	1689;
    3012	0101000020E61000005A8121AB5BCB52C0FF78AF5A99F84340	1614;
    3066	0101000020E6100000A5A0DB4B1ACB52C0A2629CBF09F94340	1529;
    3007	0101000020E61000008EE9094B3CCA52C085949F54FBF84340	1434.

    _Hint: Use the `EXTRACT` function to get the hour of the day from the timestamp._

9. [List all the passholder types and number of trips for each across all years.](query09.sql)

    ```SQL
    select 
      passholder_type,
      count(*) as num_trips
    from (
      select passholder_type from indego.trips_2021_q3
      union all 
      select passholder_type from indego.trips_2022_q3
      ) as combined_trips
    group by passholder_type
    order by num_trips DESC

    ```

    **Result:** Indego30 441856, Indego365 109251, Day Pass 61659, NULL 43, Walk-up 2

10. [Using the station status dataset, find the distance in meters of each station from Meyerson Hall.](query10.sql)

    ```SQL
    select 
      sta.id as station_id,
      sta.geog as station_geog,
    round(st_distance(
        st_setsrid(st_makepoint(-75.192584,39.952415),4326)::geography,
        sta.geog
    )/50)*50 as distance
    from indego.stations_geo as sta
    ```

11. [What is the average distance (in meters) of all stations from Meyerson Hall?](query11.sql)

    ```SQL
    select
    round(
        avg(
            st_distance(
                st_setsrid(st_makepoint(-75.192584,39.952415),4326)::geography,
                sta.geog
                ))
        /1000) as avg_distance_km
    from indego.stations_geo as sta
    ```

    **Result:** 3
    
12. [How many stations are within 1km of Meyerson Hall?](query12.sql)

    ```SQL
    select
    count(*) as num_stations
    from indego.stations_geo as sta
    where st_dwithin (st_setsrid(st_makepoint(-75.192584,39.952415),4326)::geography,sta.geog,1000)
    ```

    **Result:** 17

13. [Which station is furthest from Meyerson Hall?](query13.sql)

    ```SQL
    select
    sta.id as station_id,
    sta.name as station_name,
    round(
        st_distance(
            st_setsrid(
                st_makepoint(-75.192584,39.952415),4326)::geography,
                sta.geog)/50)*50 as distance
    from indego.stations_geo as sta
    order by distance DESC
    limit 1;
    ```

    **Result:** 3323	Manayunk Bridge	8900

14. [Which station is closest to Meyerson Hall?](query14.sql)

    ```SQL
    select
      sta.id as station_id,
      sta.name as station_name,
      round(
          st_distance(
              st_setsrid(st_makepoint(-75.192584,39.952415),4326)::geography,
              sta.geog
          )/50
      )*50 as distance
    from indego.stations_geo as sta
    order by distance ASC
    limit 1;
    ```

    **Result:** 3208	34th & Spruce	200
