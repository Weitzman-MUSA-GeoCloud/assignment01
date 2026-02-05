create extension if not exists postgis;

create schema if not exists indego;

alter table if exists indego.station_statuses
  alter column geog type geography
  using geog::geography;
