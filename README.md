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
    select count(*)
    from indego.trips_2021_q3
    ```

    **Result:** 300,432

2. [What is the percent change in trips in Q3 2022 as compared to Q3 2021?](query02.sql)
 
 select
  round(
    (
      (select count(*)::numeric from indego.trips_2022_q3)
      -
      (select count(*)::numeric from indego.trips_2021_q3)
    )
    /
    (select count(*)::numeric from indego.trips_2021_q3)
    * 100
  , 2) as perc_change;


3. [What is the average duration of a trip for 2021?](query03.sql)

select round(avg(duration)::numeric, 2) as avg_duration
from indego.trips_2021_q3;

4. [What is the average duration of a trip for 2022?](query04.sql)
select round(avg(duration)::numeric, 2) as avg_duration
from indego.trips_2022_q3;

5. [What is the longest duration trip across the two quarters?](query05.sql)
select max(duration) as max_duration
from (
  select duration from indego.trips_2021_q3
  union all
  select duration from indego.trips_2022_q3
) t;

    _Why are there so many trips of this duration?_

    **Answer:Many trips share the same maximum duration because extremely long or anomalous trips can be capped or truncated by the system at an upper limit. When many records hit that cap, they appear with the exact same maximum duration.**

6. [How many trips in each quarter were shorter than 10 minutes?](query06.sql)
select
  2021 as trip_year,
  3 as trip_quarter,
  count(*) as num_trips
from indego.trips_2021_q3
where duration < 600

union all

select
  2022 as trip_year,
  3 as trip_quarter,
  count(*) as num_trips
from indego.trips_2022_q3
where duration < 600;

7. [How many trips started on one day and ended on a different day?](query07.sql)
select
  2021 as trip_year,
  3 as trip_quarter,
  count(*) as num_trips
from indego.trips_2021_q3
where start_time::date <> end_time::date

union all

select
  2022 as trip_year,
  3 as trip_quarter,
  count(*) as num_trips
from indego.trips_2022_q3
where start_time::date <> end_time::date;

8. [Give the five most popular starting stations across all years between 7am and 9:59am.](query08.sql)

    _Hint: Use the `EXTRACT` function to get the hour of the day from the timestamp._
select
  s.id as station_id,
  s.geog as station_geog,
  t.num_trips as num_trips
from (
  select
    start_station,
    count(*) as num_trips
  from (
    select start_station, start_time from indego.trips_2021_q3
    union all
    select start_station, start_time from indego.trips_2022_q3
  ) trips
  where extract(hour from start_time) between 7 and 9
  group by start_station
) t
join indego.station_statuses s
  on s.id::text = t.start_station
order by t.num_trips desc
limit 5;

9. [List all the passholder types and number of trips for each across all years.](query09.sql)
select
  passholder_type,
  count(*) as num_trips
from (
  select passholder_type from indego.trips_2021_q3
  union all
  select passholder_type from indego.trips_2022_q3
) t
group by passholder_type
order by num_trips desc;

10. [Using the station status dataset, find the distance in meters of each station from Meyerson Hall.](query10.sql)
select
  id as station_id,
  geog as station_geog,
  round(
    st_distance(
      geog,
      st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography
    ) / 50.0
  ) * 50 as distance
from indego.station_statuses;

11. [What is the average distance (in meters) of all stations from Meyerson Hall?](query11.sql)
select
  round(
    avg(
      st_distance(
        geog,
        st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography
      )
    ) / 1000.0
  ) as avg_distance_km
from indego.station_statuses;

12. [How many stations are within 1km of Meyerson Hall?](query12.sql)
select
  count(*) as num_stations
from indego.station_statuses
where st_distance(
  geog,
  st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography
) <= 1000;

13. [Which station is furthest from Meyerson Hall?](query13.sql)
select
  id as station_id,
  name as station_name,
  round(
    st_distance(
      geog,
      st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography
    ) / 50.0
  ) * 50 as distance
from indego.station_statuses
order by st_distance(
  geog,
  st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography
) desc
limit 1;


14. [Which station is closest to Meyerson Hall?](query14.sql)
select
  id as station_id,
  name as station_name,
  round(
    st_distance(
      geog,
      st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography
    ) / 50.0
  ) * 50 as distance
from indego.station_statuses
order by st_distance(
  geog,
  st_setsrid(st_makepoint(-75.192584, 39.952415), 4326)::geography
) asc
limit 1;
