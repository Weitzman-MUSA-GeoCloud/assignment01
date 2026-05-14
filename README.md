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
    select count(*) as num_trips
    from indego.trips_2021_q3
    ```

    **Result:** 300,432

2. [What is the percent change in trips in Q3 2022 as compared to Q3 2021?](query02.sql)
   
   ```SQL
   select 
    round(
        ((select count(*)::numeric from indego.trips_2022_q3) - 
         (select count(*)::numeric from indego.trips_2021_q3)) * 100.0 / 
        (select count(*)::numeric from indego.trips_2021_q3), 
        2
    )::text || '%' as perc_change
   ```
   
   **Result:** 3.98%


3. [What is the average duration of a trip for 2021?](query03.sql)
   
   ```SQL
   select 
    round(avg(duration)::numeric, 2) as avg_duration
   from indego.trips_2021_q3
   ```
   
   **Result:** 18.86

4. [What is the average duration of a trip for 2022?](query04.sql)

   ```SQL
   select 
    round(avg(duration)::numeric, 2) as avg_duration
   from indego.trips_2022_q3
   ```
   
   **Result:** 17.88

5. [What is the longest duration trip across the two quarters?](query05.sql)

   ```SQL
   select 
    max(duration) as max_duration
   from (
    select duration from indego.trips_2021_q3
    union all
    select duration from indego.trips_2022_q3
  ) as all_trips
   ```
   
   **Result:** 1440

    _Why are there so many trips of this duration?_

    **Answer:** The longest duration is 1440 minutes (24 hours). This is likely the maximum allowed rental period for the bike share system, representing a day pass or the system's rental time limit. Many users likely hit this maximum duration, either intentionally (using a day pass) or unintentionally (forgetting to return the bike), which explains why there are so many trips of exactly this duration.

6. [How many trips in each quarter were shorter than 10 minutes?](query06.sql)

   ```SQL
   select 
    2021 as trip_year,
    3 as trip_quarter,
    count(*) as num_trips
    from indego.trips_2021_q3
    where duration < 10
    union all
    select 
    2022 as trip_year,
    3 as trip_quarter,
    count(*) as num_trips
    from indego.trips_2022_q3
    where duration < 10
   ```
   
   **Result:** 2021 3 124528, 2022 3 137372

7. [How many trips started on one day and ended on a different day?](query07.sql)

   ```SQL
   select 
    2021 as trip_year,
    3 as trip_quarter,
    count(*) as num_trips
    from indego.trips_2021_q3
    where date(start_time) != date(end_time)
    union all
    select 
    2022 as trip_year,
    3 as trip_quarter,
    count(*) as num_trips
    from indego.trips_2022_q3
    where date(start_time) != date(end_time)
   ```
   
   **Result:** 2021	3	2301
               2022	3	2060

8. [Give the five most popular starting stations across all years between 7am and 9:59am.](query08.sql)

    _Hint: Use the `EXTRACT` function to get the hour of the day from the timestamp._

   ```SQL
   select 
    s.id as station_id,
    s.geog as station_geog,
    count(*) as num_trips
    from (
    select start_station, start_time
    from indego.trips_2021_q3
    union all
    select start_station, start_time
    from indego.trips_2022_q3
    ) as all_trips
    join indego.station_statuses s on s.id::text = all_trips.start_station
    where extract(hour from start_time) >= 7 
    and extract(hour from start_time) < 10
    group by s.id, s.geog
    order by num_trips desc
    limit 5
   ```
   
   **Result:** 
   3032	0101000020E6100000E8305F5E80CB52C0E9F17B9BFEF84340	1828
   3102	0101000020E6100000963E74417DCB52C0E4F736FDD9FB4340	1689
   3012	0101000020E61000005A8121AB5BCB52C0FF78AF5A99F84340	1614
   3066	0101000020E6100000A5A0DB4B1ACB52C0A2629CBF09F94340	1529
   3007	0101000020E61000008EE9094B3CCA52C085949F54FBF84340	1434

9. [List all the passholder types and number of trips for each across all years.](query09.sql)

   ```SQL
   select 
    passholder_type,
    count(*) as num_trips
    from (
    select passholder_type from indego.trips_2021_q3
    union all
    select passholder_type from indego.trips_2022_q3
    ) as all_trips
    group by passholder_type
    order by passholder_type
   ```
   
   **Result:** 
   Day Pass	61659
   Indego30	441856
   Indego365	109251
   NULL	43
   Walk-up	2

10. [Using the station status dataset, find the distance in meters of each station from Meyerson Hall.](query10.sql)

   ```SQL
   select 
    id as station_id,
    geog as station_geog,
    round(st_distance(geog, st_point(-75.192584, 39.952415)::geography)::numeric / 50) * 50 as distance
   from indego.station_statuses
   order by distance
   ```
   
   **Result:** 
3208	0101000020E6100000DC114E0B5ECC52C044C02154A9F94340	200
3029	0101000020E61000009FE5797077CC52C060764F1E16FA4340	250
3207	0101000020E61000003F355EBA49CC52C0D97C5C1B2AFA4340	250
3009	0101000020E61000001C08C90226CC52C09869FB5756FA4340	450
3020	0101000020E6100000D97C5C1B2ACC52C0764F1E166AF94340	500
3038	0101000020E6100000C39E76F86BCC52C02F698CD651F94340	550
3336	0101000020E61000004DD6A88768CC52C07407B13385FA4340	550
3159	0101000020E610000029E8F692C6CC52C068D0D03FC1F94340	600
3249	0101000020E6100000D99942E735CC52C07B6649809AFA4340	600
3422	0101000020E6100000D9EBDD1FEFCB52C09161156F64FA4340	650
3160	0101000020E61000003815A930B6CC52C08A592F8672FA4340	700
3184	0101000020E61000009F02603C83CC52C04C6C3EAE0DF94340	800
3022	0101000020E61000005969520ABACB52C0276BD44334FA4340	850
3265	0101000020E6100000514EB4AB90CC52C0821C9430D3FA4340	850
3152	0101000020E6100000A96A82A8FBCC52C0A1BE654E97F94340	900
3006	0101000020E610000065DF15C1FFCC52C027A089B0E1F94340	900
3259	0101000020E6100000ADDD76A1B9CC52C03468E89FE0FA4340	1000
3162	0101000020E6100000E7FBA9F1D2CB52C05BD3BCE314F94340	1000
3161	0101000020E61000003D61890794CB52C018213CDA38FA4340	1050
3163	0101000020E6100000A8E3310395CB52C0FDD98F1491F94340	1050
3365	0101000020E6100000A4E4D53906CC52C082CAF8F719FB4340	1100
3035	0101000020E610000075CDE49B6DCC52C01EC4CE143AFB4340	1150
3303	0101000020E61000009A779CA223CD52C08A1F63EE5AFA4340	1150
3062	0101000020E6100000F67AF7C77BCB52C0F6622827DAF94340	1150
3256	0101000020E610000093E34EE960CB52C0F59CF4BEF1F94340	1250
3389	0101000020E6100000CFDA6D179ACB52C094A46B26DFF84340	1300
3061	0101000020E6100000535C55F65DCB52C0A01A2FDD24FA4340	1300
3032	0101000020E6100000E8305F5E80CB52C0E9F17B9BFEF84340	1350
3298	0101000020E6100000C8CD70033ECD52C04CE0D6DD3CF94340	1350
3165	0101000020E61000006C09F9A067CB52C058AD4CF8A5FA4340	1400
3248	0101000020E61000002F6EA301BCCB52C04D4A41B797F84340	1400
3067	0101000020E6100000ED815660C8CC52C08FDFDBF467FB4340	1450
3024	0101000020E6100000DA8F149161CD52C0E1B4E0455FF94340	1500
3074	0101000020E6100000569A94826ECD52C0910A630B41FA4340	1500
3252	0101000020E6100000DC114E0B5ECC52C0556AF6402BF84340	1500
3263	0101000020E61000000C93A98251CD52C009F9A067B3FA4340	1500
3212	0101000020E61000003659A31EA2CB52C0AC730CC85EFB4340	1550
3156	0101000020E6100000BE4D7FF623CB52C0834C327216FA4340	1600
3168	0101000020E6100000D7DD3CD521CB52C036B05582C5F94340	1600
3104	0101000020E6100000DFF8DA334BCC52C0B28009DCBAFB4340	1600
3012	0101000020E61000005A8121AB5BCB52C0FF78AF5A99F84340	1700
3382	0101000020E6100000F05014E813CB52C0E162450DA6F94340	1700
3057	0101000020E610000004E275FD82CB52C0734BAB2171FB4340	1700
3321	0101000020E61000002CB7B41A12CB52C0F54A598638FA4340	1700
3437	0101000020E61000002254A9D903CD52C02367614F3BF84340	1700
3078	0101000020E6100000D061BEBC00CB52C0E78C28ED0DFA4340	1750
3209	0101000020E61000008B4F01309ECD52C0B6F3FDD478F94340	1750
3014	0101000020E61000001A69A9BC1DCB52C0A6B8AAECBBFA4340	1750
3066	0101000020E6100000A5A0DB4B1ACB52C0A2629CBF09F94340	1800
3392	0101000020E610000066834C3272CC52C0C02154A9D9F74340	1800
3187	0101000020E6100000971C774A07CB52C04A0C022B87FA4340	1800
3349	0101000020E61000000B0C59DDEACB52C04030478FDFF74340	1850
3301	0101000020E61000003BC780ECF5CA52C0A1DB4B1AA3F94340	1850
3294	0101000020E6100000DB6D179AEBCA52C0C425C79DD2F94340	1900
3397	0101000020E6100000B3B5BE4868CB52C0AA7D3A1E33F84340	1900
3118	0101000020E6100000AB21718FA5CD52C0DFFDF15EB5FA4340	1900
3236	0101000020E61000009A081B9E5ECB52C0168733BF9AFB4340	1950
3315	0101000020E6100000D3C1FA3F87CD52C05BB1BFEC9EF84340	1950
3441	0101000020E610000001F6D1A92BCB52C0D734EF3845FB4340	1950
3333	0101000020E61000000D71AC8BDBCA52C08A8EE4F21FFA4340	1950
3116	0101000020E61000003BE466B801CB52C05019FF3EE3FA4340	1950
3114	0101000020E6100000C156091687CB52C079E9263108F84340	1950
3054	0101000020E6100000A5BDC11726CB52C03333333333FB4340	1950
3240	0101000020E6100000166A4DF38ECD52C0F3C81F0C3CFB4340	2000
3021	0101000020E6100000AD174339D1CA52C0C3D32B6519FA4340	2000
3359	0101000020E6100000F4E0EEACDDCA52C00CEA5BE674F94340	2000
3182	0101000020E6100000376C5B94D9CA52C0D95A5F24B4F94340	2000
3102	0101000020E6100000963E74417DCB52C0E4F736FDD9FB4340	2000
3340	0101000020E6100000A80018CFA0CB52C04EEE77280AFC4340	2050
3342	0101000020E6100000371AC05B20CB52C0A54E401361FB4340	2050
3063	0101000020E610000017B7D100DECA52C0A29C685721F94340	2050
3060	0101000020E6100000FB22A12DE7CA52C0C9AB730CC8FA4340	2050
3119	0101000020E610000048F949B54FCD52C016DEE522BEFB4340	2050
3297	0101000020E61000009BAC510FD1CA52C09F5912A0A6FA4340	2100
3251	0101000020E610000083FA96395DCC52C0ACCABE2B82F74340	2100
3205	0101000020E610000069520ABABDCA52C0D95F764F1EFA4340	2100
3296	0101000020E6100000ADDD76A1B9CA52C036B05582C5F94340	2150
3203	0101000020E61000003E05C07806CB52C06A87BF266BF84340	2150
3112	0101000020E61000008716D9CEF7CD52C0679B1BD313FA4340	2200
3381	0101000020E6100000478FDFDBF4CD52C013F241CF66F94340	2200
3064	0101000020E610000030D80DDB16CB52C08048BF7D1DF84340	2250
3287	0101000020E6100000527E52EDD3CD52C0B01BB62DCAF84340	2250
3051	0101000020E6100000B020CD5834CB52C0CF6BEC12D5FB4340	2250
3201	0101000020E610000018265305A3CA52C03C1405FA44FA4340	2300
3280	0101000020E6100000617138F3ABCD52C0475A2A6F47F84340	2300
3010	0101000020E6100000F44F70B1A2CA52C077DB85E63AF94340	2350
3125	0101000020E6100000143FC6DCB5CA52C0062FFA0AD2F84340	2350
3253	0101000020E610000015C616821CCC52C01E8A027D22F74340	2400
3255	0101000020E61000007407B13385CA52C0CB10C7BAB8F94340	2400
3053	0101000020E61000009DBAF2599ECB52C0ECDD1FEF55F74340	2400
3247	0101000020E6100000EF0390DAC4CD52C0331B649291FB4340	2400
3318	0101000020E6100000780B24287ECA52C0E0D6DD3CD5F94340	2450
3410	0101000020E61000006E861BF0F9CD52C0A3409FC893F84340	2500
3235	0101000020E6100000742497FF90CA52C07B14AE47E1FA4340	2500
3113	0101000020E6100000983446EBA8CC52C0E960FD9FC3FC4340	2500
3374	0101000020E6100000E8305F5E80CB52C03FC6DCB584FC4340	2500
3040	0101000020E61000001F4B1FBAA0CA52C09ED2C1FA3FFB4340	2550
3300	0101000020E6100000F8DF4A766CCA52C0910A630B41FA4340	2550
3058	0101000020E61000008D7F9F71E1CA52C0EBFF1CE6CBFB4340	2550
3086	0101000020E610000006D847A7AECA52C05C035B2558F84340	2600

11. [What is the average distance (in meters) of all stations from Meyerson Hall?](query11.sql)

   ```SQL
   select 
    round(avg(public.st_distance(geog, public.st_point(-75.192584, 39.952415)::public.geography))::numeric / 1000) as avg_distance_km
    from indego.station_statuses
   ```
   
   **Result:** 4


12. [How many stations are within 1km of Meyerson Hall?](query12.sql)

   ```SQL
   select 
    count(*) as num_stations
    from indego.station_statuses
    where public.st_distance(geog, public.st_point(-75.192584, 39.952415)::public.geography) <= 1000
   ```
   
   **Result:** 18

13. [Which station is furthest from Meyerson Hall?](query13.sql)

   ```SQL
   select 
    id as station_id,
    name as station_name,
    round(public.st_distance(geog, public.st_point(-75.192584, 39.952415)::public.geography)::numeric / 50) * 50 as distance
    from indego.station_statuses
    order by distance desc
    limit 1
   ```
   
   **Result:** 
   3432	Manayunk & Conarroe, Fairview Park	9000

14. [Which station is closest to Meyerson Hall?](query14.sql)

   ```SQL
   select 
    id as station_id,
    name as station_name,
    round(public.st_distance(geog, public.st_point(-75.192584, 39.952415)::public.geography)::numeric / 50) * 50 as distance
    from indego.station_statuses
    order by distance asc
    limit 1
   ```
   
   **Result:** 3208	34th & Spruce	200
