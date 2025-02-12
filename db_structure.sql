alter table indego.station_statuses
add geog geography;

update indego.station_statuses
set geog = wkb_geometry::geography;
