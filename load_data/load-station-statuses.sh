ogr2ogr \
-f "PostgreSQL" \
-nln "station_statuses" \
-lco "SCHEMA=indego" \
-lco "GEOM_TYPE=geography" \
-lco "GEOMETRY_NAME=geog" \
-lco "OVERWRITE=yes" \
PG:"host=localhost port=5432 dbname=assignment01 user=postgres password=postgres " \
"data/indego-station-status_20250210.geojson"