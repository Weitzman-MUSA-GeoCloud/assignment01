/*
    What is the average distance (rounded to the nearest km) of all stations
    from Meyerson Hall? Your result should have a single record with a single
    column named avg_distance_km.
    有时候 PostGIS 的函数被安装到了 public 下，但你的当前连接没有搜索 public。给函数加上全路径
*/

CREATE EXTENSION postgis;
select 
    round(
        avg(
            public.st_distance(
                geog, 
                public.st_setsrid(public.st_point(-75.192584, 39.952415), 4326)::public.geography
            )
        )::numeric / 1000, 
        0
    ) as avg_distance_km
from indego.station_statuses;

select 
    round(avg(public.st_distance(geog, public.st_point(-75.192584, 39.952415)::public.geography))::numeric / 1000) as avg_distance_km
from indego.station_statuses