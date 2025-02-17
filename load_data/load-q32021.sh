ogr2ogr \
-f "PostgreSQL" \
-nln "q3_2021_trips" \
-lco "SCHEMA=indego" \
-lco "GEOM_TYPE=geography" \
-lco "GEOMETRY_NAME=geog" \
-lco "OVERWRITE=yes" \
PG:"host=localhost port=5432 dbname=assignment01 user=postgres password=postgres " \
"data/indego-trips-2021-q3.csv"