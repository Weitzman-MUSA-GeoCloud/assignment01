# Assignment 01

**Complete by February 04, 2026**

To complete this assigment you will need to do the following: 1. Fork this repository to your own account. 2. Clone your fork to your local machine. 3. Complete the assignment according to the instructions below. 4. Push your changes to your fork. 5. Submit a pull request to the original repository. Opening your pull request will be equivalent to you submitting your assignment. You will only need to open one pull request for this assignment. **If you make additional changes to your fork, they will automatically show up in the pull request you already opened.** Your pull request should have your name in the title (e.g. `Assignment 01 - Mjumbe Poe`).

## Datasets

-   Indego Bikeshare station status data
-   Indego Trip data
    -   Q3 2021
    -   Q3 2022

All data is available from [Indego's Data site](https://www.rideindego.com/about/data/).

For any questions that refer to Meyerson Hall, use latitude `39.952415` and longitude `-75.192584` as the coordinates for the building.

Load all three datasets into a PostgreSQL database schema named `indego` (the name of your database is not important). Your schema should have the following structure:

> This structure is important -- particularly the **table names** and the **lowercase field names**; if your queries are not built to work with this structure then *your assignment will fail the tests*.

-   **Table**: `indego.trips_2021_q3`\
    **Fields**:

    -   `trip_id TEXT`
    -   `duration INTEGER`
    -   `start_time TIMESTAMP`
    -   `end_time TIMESTAMP`
    -   `start_station TEXT`
    -   `start_lat FLOAT`
    -   `start_lon FLOAT`
    -   `end_station TEXT`
    -   `end_lat FLOAT`
    -   `end_lon FLOAT`
    -   `bike_id TEXT`
    -   `plan_duration INTEGER`
    -   `trip_route_category TEXT`
    -   `passholder_type TEXT`
    -   `bike_type TEXT`

-   **Table**: `indego.trips_2022_q3`\
    **Fields**: (same as above)

-   **Table**: `indego.station_statuses`\
    **Fields** (at a minimum -- there may be many more):

    -   `id INTEGER`
    -   `name TEXT` (or `CHARACTER VARYING`)
    -   `geog GEOGRAPHY`
    -   ...

## Questions

Write a query to answer each of the questions below. \* Your queries should produce results in the format specified. \* Write your query in a SQL file corresponding to the question number (e.g. a file named *query06.sql* for the answer to question #6). \* Each SQL file should contain a single `SELECT` query. \* Any SQL that does things other than retrieve data (e.g. SQL that creates indexes or update columns) should be in the *db_structure.sql* file. \* Some questions include a request for you to discuss your methods. Update this README file with your answers in the appropriate place.

1.  [How many bike trips in Q3 2021?](query01.sql)

    This file is filled out for you, as an example.

    ``` sql
    select count(*)
    from indego.trips_2021_q3
    ```

    **Result:** 300,432 trips.

2.  [What is the percent change in trips in Q3 2022 as compared to Q3 2021?](query02.sql)

    ``` sql
    select
    round(
        ((select count(*) from indego.trips_2022_q3) - (select count(*) from indego.trips_2021_q3)) * 100.0
        / (select count(*) from indego.trips_2021_q3), 2
    )::text || '%' as perc_change;
    ```

    **Result:** 3.98%.

3.  [What is the average duration of a trip for 2021?](query03.sql)

    ``` sql
    select round(avg(duration), 2) as avg_duration
    from indego.trips_2021_q3;
    ```

    **Result:** 18.86 minutes.

4.  [What is the average duration of a trip for 2022?](query04.sql)

    ``` sql
    select round(avg(duration), 2) as avg_duration
    from indego.trips_2022_q3;
    ```

    **Result:** 17.88 minutes.

5.  [What is the longest duration trip across the two quarters?](query05.sql)

    *Why are there so many trips of this duration?*

    ``` sql
    select max(duration) as max_duration
    from (
        select duration from indego.trips_2021_q3
        union
        select duration from indego.trips_2022_q3
    ) as all_durations;
    ```

    **Result:** 1,440 minutes, which is exactly a day. There's probably a duration cap that Indego imposes on their side. However, on the rider's side, it could be because the user didn't re-place the bike correctly, forgot to return a bike, the device meant to track the time was broken, or other.

6.  [How many trips in each quarter were shorter than 10 minutes?](query06.sql)

    ``` sql
    select
        extract(year from start_time) as trip_year,
        extract(quarter from start_time) as trip_quarter,
        count(*) as num_trips
    from
        indego.trips_2021_q3
    where
        duration < 10
    group by
        trip_year,
        trip_quarter
    union
    select
        extract(year from start_time) as trip_year,
        extract(quarter from start_time) as trip_quarter,
        count(*) as num_trips
    from
        indego.trips_2022_q3
    where
        duration < 10
    group by
        trip_year,
        trip_quarter;
    ```

    **Result:** 124,528 in 2021 and 137,372 in 2022.

AI used to help with query. Free model Claude Haiku 4.5.

Prompt: Don't give me answer. My query was working earlier for one of the years, but when I duplicate query for other year to create one query there's error. Provide hint for next step plus link to documentation.

(I was missing UNION to combine the two queries.)

7.  [How many trips started on one day and ended on a different day?](query07.sql)

    ``` sql
    select
        extract(year from start_time) as trip_year,
        extract(quarter from start_time) as trip_quarter,
        count(*) as num_trips
    from indego.trips_2021_q3
    where
        start_time::date <> end_time::date
    group by
        trip_year,
        trip_quarter
    union
    select
        extract(year from start_time) as trip_year,
        extract(quarter from start_time) as trip_quarter,
        count(*) as num_trips
    from indego.trips_2022_q3
    where
        start_time::date <> end_time::date
    group by
        trip_year,
        trip_quarter;
    ```

    **Result:** 2,301 in 2021 and 2,060 in 2022.

8.  [Give the five most popular starting stations across all years between 7am and 9:59am.](query08.sql)

    *Hint: Use the `EXTRACT` function to get the hour of the day from the timestamp.*

    ``` sql
    select
        start_station as station_id,
        st_makepoint(start_lon, start_lat)::public.geography as station_geog,
        count(trip_id) as num_trips
    from (
        select * from indego.trips_2021_q3
        union all
        select * from indego.trips_2022_q3
    ) as all_trips
    where
        extract(hour from start_time) >= 7
        and extract(hour from start_time) < 10
    group by
        start_station,
        st_makepoint(start_lon, start_lat)::public.geography
    order by
        num_trips desc
    limit 5;
    ```

    **Result:**

| station_id | station_geog                                       | num_trips |
|------------|----------------------------------------------------|-----------|
| 3032       | 0101000020E6100000E8305F5E80CB52C0B96DDFA3FEF84340 | 960       |
| 3102       | 0101000020E6100000963E74417DCB52C0E4F736FDD9FB4340 | 956       |
| 3012       | 0101000020E6100000A1478C9E5BCB52C0CFF4126399F84340 | 901       |
| 3032       | 0101000020E6100000E8305F5E80CB52C0B96DDFA3FEF84340 | 868       |
| 3066       | 0101000020E6100000ED66463F1ACB52C0A2629CBF09F94340 | 818       |

9.  [List all the passholder types and number of trips for each across all years.](query09.sql)

    ``` sql
    select
        passholder_type,
        count(trip_id) as num_trips
    from (
        select * from indego.trips_2021_q3
        union all
        select * from indego.trips_2022_q3
    ) as all_trips
    group by
        passholder_type;
    ```

    **Result:**

| passholder_type | num_trips |
|-----------------|-----------|
| Day Pass        | 61659     |
| Indego30        | 441856    |
| Indego365       | 109251    |
| NULL            | 43        |
| Walk-up         | 2         |

AI used to help with query. Free model Claude Haiku 4.5.

Prompt:

Don't give me answer. Looks like distinct passholder types are being duplicated due to different years. Is there a function that can help? Give a hint for next step plus link to documentation.

(Use UNION ALL instead of UNION.)

10. [Using the station status dataset, find the distance in meters of each station from Meyerson Hall.](query10.sql)

    ``` sql
    select
        id as station_id,
        geog as station_geog,
        round(public.st_distance(
            geog,
            public.st_setsrid(public.st_makepoint(-75.192584, 39.952415), 4326)::public.geography
        ) / 50) * 50 as distance
    from indego.station_statuses;
    ```

    **Result:**

| station_id | station_geog                                       | distance |
|------------|----------------------------------------------------|----------|
| 3023       | NULL                                               | NULL     |
| 3027       | NULL                                               | NULL     |
| 3036       | NULL                                               | NULL     |
| 3048       | NULL                                               | NULL     |
| 3095       | NULL                                               | NULL     |
| 3103       | NULL                                               | NULL     |
| 3105       | NULL                                               | NULL     |
| 3109       | NULL                                               | NULL     |
| 3122       | NULL                                               | NULL     |
| 3129       | NULL                                               | NULL     |
| 3195       | NULL                                               | NULL     |
| 3155       | 0101000020E610000063B83A00E2C952C0D9243FE257F84340 | 3550     |
| 3053       | 0101000020E61000008578245E9ECB52C04BE658DE55F74340 | 2400     |
| 3202       | 0101000020E6100000ADDD76A1B9CA52C036B05582C5F94340 | 2150     |
| 3069       | 0101000020E6100000F6B704E09FC952C0FC8D76DCF0F74340 | 4000     |
| 3101       | 0101000020E61000008BFCFA2136CA52C0815D4D9EB2F84340 | 3000     |
| 3071       | 0101000020E61000008CA2073E06CC52C052465C001AFB4340 | 1100     |
| 3004       | 0101000020E6100000D3BEB9BF7ACA52C0E945ED7E15FA4340 | 2450     |
| 3043       | 0101000020E6100000064B75012FCB52C03A3B191C25F74340 | 2850     |
| 3170       | 0101000020E6100000F296AB1F9BCB52C0E275FD82DDF84340 | 1300     |
| 3010       | 0101000020E6100000AD8905BEA2CA52C0A65F22DE3AF94340 | 2350     |
| 3066       | 0101000020E6100000ED66463F1ACB52C0A2629CBF09F94340 | 1800     |
| 3046       | 0101000020E6100000C040102043C952C07427D87F9DF94340 | 4100     |
| 3162       | 0101000020E6100000A0353FFED2CB52C05BD3BCE314F94340 | 1000     |
| 3062       | 0101000020E610000026FF93BF7BCB52C025E7C41EDAF94340 | 1150     |
| 3068       | 0101000020E6100000B1FB8EE1B1CA52C016DEE522BEF74340 | 2900     |
| 3086       | 0101000020E6100000365CE49EAECA52C08B87F71C58F84340 | 2600     |
| 3039       | 0101000020E610000025CFF57D38CA52C02AC6F99B50FC4340 | 3500     |
| 3028       | 0101000020E61000007F8461C092C952C061A92EE065F84340 | 3900     |
| 3063       | 0101000020E610000017B7D100DECA52C07218CC5F21F94340 | 2050     |
| 3102       | 0101000020E6100000963E74417DCB52C0E4F736FDD9FB4340 | 2000     |
| 3052       | 0101000020E6100000ADC266800BCA52C091F0BDBF41F94340 | 3100     |
| 3061       | 0101000020E610000023D8B8FE5DCB52C0A01A2FDD24FA4340 | 1300     |
| 3190       | 0101000020E610000022179CC1DFCA52C06ABE4A3E76F94340 | 2000     |
| 3032       | 0101000020E6100000E8305F5E80CB52C0B96DDFA3FEF84340 | 1350     |
| 3204       | 0101000020E6100000BC07E8BE9CCA52C0FC1A498270FB4340 | 2650     |
| 3014       | 0101000020E61000000327DBC01DCB52C005C1E3DBBBFA4340 | 1750     |
| 3078       | 0101000020E6100000B81FF0C000CB52C0469561DC0DFA4340 | 1750     |
| 3029       | 0101000020E610000040DD408177CC52C060764F1E16FA4340 | 250      |
| 3045       | 0101000020E61000009738F24064CA52C05794128255F94340 | 2650     |
| 3075       | 0101000020E610000000E5EFDE51CA52C091B41B7DCCFB4340 | 3150     |
| 3209       | 0101000020E61000002C47C8409ECD52C0876F61DD78F94340 | 1750     |
| 3058       | 0101000020E610000045B9347EE1CA52C01B84B9DDCBFB4340 | 2550     |
| 3074       | 0101000020E61000006EDC627E6ECD52C0C18EFF0241FA4340 | 1500     |
| 3009       | 0101000020E6100000344A97FE25CC52C069E55E6056FA4340 | 450      |
| 3112       | 0101000020E6100000E61E12BEF7CD52C00893E2E313FA4340 | 2200     |
| 3120       | 0101000020E610000048DDCEBEF2CB52C0DB334B02D4FC4340 | 2600     |
| 3161       | 0101000020E61000006DE525FF93CB52C0E99C9FE238FA4340 | 1050     |
| 3007       | 0101000020E6100000D5AF743E3CCA52C05610035DFBF84340 | 2900     |
| 3099       | 0101000020E610000021EA3E00A9C952C08811C2A38DF74340 | 4100     |
| 3166       | 0101000020E61000005776C1E09AC852C04128EFE368FC4340 | 5400     |
| 3154       | 0101000020E610000084B7072120CA52C0ED815660C8FA4340 | 3050     |
| 3012       | 0101000020E6100000A1478C9E5BCB52C0CFF4126399F84340 | 1700     |
| 3104       | 0101000020E6100000983270404BCC52C0B28009DCBAFB4340 | 1600     |
| 3157       | 0101000020E6100000081EDFDE35CA52C0D68EE21C75F64340 | 4100     |
| 3234       | 0101000020E61000001475E61E12CB52C025CFF57D38FA4340 | 1700     |
| 3056       | 0101000020E61000005567B5C01ECA52C0A532C51C04FD4340 | 4000     |
| 3025       | 0101000020E610000048C5FF1D51CA52C034BC5983F7F74340 | 3150     |
| 3203       | 0101000020E61000000F81238106CB52C09A0B5C1E6BF84340 | 2150     |
| 3208       | 0101000020E610000023D8B8FE5DCC52C0153C855CA9F94340 | 200      |
| 3033       | 0101000020E6100000FCE1E7BF07CA52C04BC8073D9BF94340 | 3100     |
| 3067       | 0101000020E6100000ED815660C8CC52C0605B3FFD67FB4340 | 1450     |
| 3114       | 0101000020E610000091D26C1E87CB52C01AE1ED4108F84340 | 1950     |
| 3115       | 0101000020E61000006CEEE87FB9CA52C0E38DCC237FFC4340 | 3100     |
| 3124       | 0101000020E6100000492EFF21FDC852C01B66683C11FA4340 | 4450     |
| 3055       | 0101000020E61000002638F581E4C952C08751103CBEF94340 | 3250     |
| 3035       | 0101000020E61000005D8B16A06DCC52C0EE3F321D3AFB4340 | 1150     |
| 3047       | 0101000020E6100000333509DE90C952C0ED2DE57CB1F94340 | 3700     |
| 3021       | 0101000020E61000007D93A641D1CA52C0F357C85C19FA4340 | 2000     |
| 3022       | 0101000020E610000089EDEE01BACB52C0276BD44334FA4340 | 850      |
| 3064       | 0101000020E610000018963FDF16CB52C08048BF7D1DF84340 | 2250     |
| 3150       | 0101000020E6100000C158DFC0E4CA52C08B170B43E4F64340 | 3250     |
| 3164       | 0101000020E61000006E3315E291CA52C032923D42CDF64340 | 3550     |
| 3054       | 0101000020E61000007539252026CB52C0D42AFA4333FB4340 | 1950     |
| 3110       | 0101000020E6100000DC2DC901BBC852C0C976BE9F1AFB4340 | 4900     |
| 3059       | 0101000020E610000089B48D3F51CA52C05E2EE23B31FB4340 | 2900     |
| 3236       | 0101000020E61000009A081B9E5ECB52C0168733BF9AFB4340 | 1950     |
| 3013       | 0101000020E610000040DD408177C952C0B1C22D1F49FB4340 | 4000     |
| 3037       | 0101000020E6100000E754320054CA52C0ACC8E88024FA4340 | 2650     |
| 3088       | 0101000020E6100000A9A44E4013C952C0F4A8F8BF23FC4340 | 4750     |
| 3100       | 0101000020E6100000A96BED7DAAC952C00E9F7422C1F64340 | 4500     |
| 3210       | 0101000020E610000044C2F7FE06CA52C062122EE411FE4340 | 4750     |
| 3049       | 0101000020E61000005567B5C01EC952C0395FECBDF8F84340 | 4350     |
| 3182       | 0101000020E6100000F0A5F0A0D9CA52C009DFFB1BB4F94340 | 2000     |
| 3034       | 0101000020E6100000FBC9181F66CA52C0679DF17D71F74340 | 3350     |
| 3040       | 0101000020E6100000070951BEA0CA52C06E4E250340FB4340 | 2550     |
| 3251       | 0101000020E61000005376FA415DCC52C0DB4E5B2382F74340 | 2100     |
| 3024       | 0101000020E61000007B87DBA161CD52C011397D3D5FF94340 | 1500     |
| 3121       | 0101000020E61000004301DBC188CB52C0DBDC989EB0FC4340 | 2650     |
| 3152       | 0101000020E6100000D9EE1EA0FBCC52C000C79E3D97F94340 | 900      |
| 3051       | 0101000020E6100000809C306134CB52C06F63B323D5FB4340 | 2250     |
| 3235       | 0101000020E6100000742497FF90CA52C0AB984A3FE1FA4340 | 2500     |
| 3211       | 0101000020E61000008EEA7420EBCA52C0E066F16261FC4340 | 2850     |
| 3169       | 0101000020E61000003DD7F7E120C952C0D7A6B1BD16FA4340 | 4250     |
| 3153       | 0101000020E6100000ADA415DF50C852C05C3D27BD6FFC4340 | 5800     |
| 3156       | 0101000020E61000008EC9E2FE23CB52C02444F98216FA4340 | 1600     |
| 3168       | 0101000020E61000008F17D2E121CB52C036B05582C5F94340 | 1600     |
| 3006       | 0101000020E610000065DF15C1FFCC52C0C89750C1E1F94340 | 900      |
| 3200       | 0101000020E61000001172DEFFC7CA52C0543A58FFE7FC4340 | 3300     |
| 3238       | 0101000020E6100000FFCC203EB0C952C0C0E95DBC1FF94340 | 3600     |
| 3072       | 0101000020E6100000D2E28C614EC952C004E8F7FD9BF74340 | 4500     |
| 3116       | 0101000020E61000000B60CAC001CB52C05019FF3EE3FA4340 | 1950     |
| 3057       | 0101000020E6100000ED9FA70183CB52C0734BAB2171FB4340 | 1700     |
| 3098       | 0101000020E6100000ADA1D45E44CA52C083A5BA8097F74340 | 3400     |
| 3241       | 0101000020E6100000BA2EFCE07CCE52C0A94A5B5CE3F94340 | 2900     |
| 3030       | 0101000020E610000081936DE00ECA52C0B1BFEC9E3CF84340 | 3350     |
| 3167       | 0101000020E61000002C11A8FE41CA52C042075DC2A1F94340 | 2750     |
| 3248       | 0101000020E61000002F6EA301BCCB52C01EC6A4BF97F84340 | 1400     |
| 3158       | 0101000020E610000018B49080D1CA52C040DD408177F64340 | 3600     |
| 3233       | 0101000020E6100000535E2BA1BBC952C05D3123BC3DFA4340 | 3450     |
| 3160       | 0101000020E6100000D80C7041B6CC52C0BADDCB7D72FA4340 | 700      |
| 3026       | 0101000020E61000005A643BDF4FC952C05E64027E8DF84340 | 4200     |
| 3244       | 0101000020E6100000D8BB3FDEABCA52C0583A1F9E25F84340 | 2700     |
| 3165       | 0101000020E61000006C09F9A067CB52C02829B000A6FA4340 | 1400     |
| 3206       | 0101000020E6100000C32B499EEBCA52C0C425C79DD2F94340 | 1900     |
| 3212       | 0101000020E61000003659A31EA2CB52C0DBF7A8BF5EFB4340 | 1550     |
| 3060       | 0101000020E610000042E90B21E7CA52C0F92F1004C8FA4340 | 2050     |
| 3243       | 0101000020E6100000C11C3D7E6FC952C0A94A5B5CE3FD4340 | 5200     |
| 3245       | 0101000020E6100000BE16F4DE18CA52C08C84B69C4BFD4340 | 4200     |
| 3050       | 0101000020E610000046072461DFC952C00D33349E08FA4340 | 3300     |
| 3163       | 0101000020E6100000C02500FF94CB52C0CE55F31C91F94340 | 1050     |
| 3125       | 0101000020E6100000FCFCF7E0B5CA52C035B39602D2F84340 | 2350     |
| 3108       | 0101000020E61000001EC6A4BF97CA52C0AC71361D01FA4340 | 2300     |
| 3240       | 0101000020E6100000CFA3E2FF8ECD52C0234DBC033CFB4340 | 2000     |
| 3197       | 0101000020E610000025EA059FE6CA52C07D96E7C1DDF54340 | 4000     |
| 3117       | 0101000020E61000004BE658DE55CE52C0588E90813CFD4340 | 3950     |
| 3185       | 0101000020E6100000147B681F2BCA52C0E272BC02D1F94340 | 2900     |
| 3123       | 0101000020E6100000501C40BFEFCA52C06C5A290472FD4340 | 3600     |
| 3118       | 0101000020E61000000B2AAA7EA5CD52C0DFFDF15EB5FA4340 | 1900     |
| 3073       | 0101000020E610000068D0D03FC1C952C057B2632310FB4340 | 3550     |
| 3107       | 0101000020E61000000E84640113CC52C09E5C5320B3FD4340 | 3300     |
| 3077       | 0101000020E610000022DE3AFF76CA52C04B3ACAC16CFC4340 | 3300     |
| 3011       | 0101000020E6100000B5C5353E93CC52C0B6F5D37FD6FA4340 | 850      |
| 3192       | 0101000020E61000009702D2FE07C952C03A3B191C25FB4340 | 4550     |
| 3187       | 0101000020E6100000C7A0134207CB52C079909E2287FA4340 | 1800     |
| 3159       | 0101000020E6100000E2218C9FC6CC52C068D0D03FC1F94340 | 600      |
| 3017       | 0101000020E6100000344DD87E32C952C0A88C7F9F71FD4340 | 5200     |
| 3111       | 0101000020E61000000B2AAA7EA5CD52C05DA9674128FD4340 | 3300     |
| 3226       | 0101000020E61000001172DEFFC7C852C0448655BC91FD4340 | 5700     |
| 3018       | 0101000020E6100000950ED6FF39CA52C0E3FDB8FDF2F94340 | 2800     |
| 3201       | 0101000020E610000030682101A3CA52C00C90680245FA4340 | 2300     |
| 3020       | 0101000020E6100000C13A8E1F2ACC52C047CB811E6AF94340 | 500      |
| 3016       | 0101000020E610000025EA059FE6C952C0FD2FD7A205FC4340 | 3700     |
| 3065       | 0101000020E610000062DC0DA2B5C952C045A165DD3FFC4340 | 4050     |
| 3097       | 0101000020E61000001363997E89C852C0505260014CFD4340 | 5850     |
| 3005       | 0101000020E6100000556D37C137C952C08542041C42F94340 | 4200     |
| 3041       | 0101000020E6100000A27A6B60ABC852C034BC5983F7FB4340 | 5200     |
| 3019       | 0101000020E61000000C7558E196C952C0C1374D9F1DFA4340 | 3650     |
| 3188       | 0101000020E6100000FF05820019CB52C0CCB22781CDF34340 | 5550     |
| 3246       | 0101000020E6100000DCF126BF45CE52C083C30B2252F94340 | 2650     |
| 3070       | 0101000020E6100000CBBBEA01F3C852C0E86C01A1F5FA4340 | 4600     |
| 3096       | 0101000020E6100000471FF30181CB52C046072461DFFE4340 | 4450     |
| 3184       | 0101000020E610000087C0914083CC52C0AC74779D0DF94340 | 800      |
| 3249       | 0101000020E6100000081EDFDE35CC52C07B6649809AFA4340 | 600      |
| 3031       | 0101000020E6100000D9EBDD1FEFC952C01FBDE13E72FD4340 | 4450     |
| 3205       | 0101000020E610000052103CBEBDCA52C03868AF3E1EFA4340 | 2100     |
| 3119       | 0101000020E61000000133DFC14FCD52C016DEE522BEFB4340 | 2050     |
| 3207       | 0101000020E610000028F38FBE49CC52C0A9F8BF232AFA4340 | 250      |
| 3106       | 0101000020E61000000F7BA180EDCB52C0CBBBEA01F3FE4340 | 4400     |
| 3093       | 0101000020E610000069FD2D01F8CB52C0ABB019E082FE4340 | 4000     |
| 3015       | 0101000020E6100000F7B182DF86C952C0CCEEC9C342F94340 | 3800     |
| 3183       | 0101000020E6100000D1949D7E50CB52C0DCBB067DE9F14340 | 7050     |
| 3008       | 0101000020E6100000B4CBB73EACC952C0A6B6D4415EFD4340 | 4650     |
| 3237       | 0101000020E61000003D7D04FEF0CA52C079EBFCDB65F54340 | 4350     |
| 3247       | 0101000020E6100000D7C1C1DEC4CD52C0D3122BA391FB4340 | 2400     |
| 3186       | 0101000020E61000006D1E87C1FCCA52C0F584251E50F24340 | 6850     |
| 3113       | 0101000020E6100000DFFAB0DEA8CC52C0E960FD9FC3FC4340 | 2500     |
| 3181       | 0101000020E61000002C0E677E35CB52C0ADDD76A1B9F24340 | 6400     |
| 3196       | 0101000020E6100000E25AED612FCB52C0A1478C9E5BFE4340 | 4150     |
| 3252       | 0101000020E610000023D8B8FE5DCC52C0556AF6402BF84340 | 1500     |
| 3253       | 0101000020E61000005DA9674128CC52C001309E4143F74340 | 2300     |
| 3255       | 0101000020E61000002D41464085CA52C09C8C2AC3B8F94340 | 2400     |
| 3256       | 0101000020E6100000C367EBE060CB52C0F59CF4BEF1F94340 | 1250     |
| 3254       | 0101000020E61000005E82531F48CA52C0B1A4DC7D8EFD4340 | 4200     |
| 3250       | 0101000020E6100000E754320054C952C0118DEE2076FA4340 | 4050     |
| 3213       | 0101000020E6100000B519A721AACA52C0361D01DC2CF84340 | 2700     |
| 3214       | 0101000020E6100000DB15FA6019CA52C04A61DEE34CFD4340 | 4200     |
| 3038       | 0101000020E6100000931ADA006CCC52C000E5EFDE51F94340 | 550      |
| 3000       | NULL                                               | NULL     |

11. [What is the average distance (in meters) of all stations from Meyerson Hall?](query11.sql)

    ``` sql
    select round(avg(distance) / 1000) as avg_distance_km
    from (
        select
            round(public.st_distance(
                geog,
                public.st_setsrid(public.st_makepoint(-75.192584, 39.952415), 4326)::public.geography
            ) / 50) * 50 as distance
        from indego.station_statuses
        where geog is not null
    ) as distances;
    ```

    **Result:** 3

12. [How many stations are within 1km of Meyerson Hall?](query12.sql)

    ``` sql
    select count(*) as num_stations
    from indego.station_statuses
    where
        geog is not null
        and public.st_distance(
            geog,
            public.st_setsrid(public.st_makepoint(-75.192584, 39.952415), 4326)::public.geography
        ) <= 1000;
    ```

    **Result:** 15

13. [Which station is furthest from Meyerson Hall?](query13.sql)

    ``` sql
    select
        id as station_id,
        name as station_name,
        round(public.st_distance(
            geog,
            public.st_setsrid(public.st_makepoint(-75.192584, 39.952415), 4326)::public.geography
        ) / 50) * 50 as distance
    from indego.station_statuses
    where geog is not null
    order by distance desc
    limit 1;
    ```

    **Result:** Station 3183 \@ 15th & Kitty Hawk with distance 7,050m.

14. [Which station is closest to Meyerson Hall?](query14.sql)

    ``` sql
    select
        id as station_id,
        name as station_name,
        round(public.st_distance(
            geog,
            public.st_setsrid(public.st_makepoint(-75.192584, 39.952415), 4326)::public.geography
        ) / 50) * 50 as distance
    from indego.station_statuses
    where geog is not null
    order by distance
    limit 1;
    ```

    **Result:** Station 3208 \@ 34th & Spruce with distance 200m.
