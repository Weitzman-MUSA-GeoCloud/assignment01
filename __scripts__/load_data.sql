SET datestyle TO 'US';

COPY indego.trips_2021_q3 FROM 'C:\Users\seank\Downloads\indego-trips-2021-q3.csv' CSV HEADER;
COPY indego.trips_2022_q3 FROM 'C:\Users\seank\Downloads\indego-trips-2022-q3.csv' CSV HEADER;

SET datestyle TO 'European';
