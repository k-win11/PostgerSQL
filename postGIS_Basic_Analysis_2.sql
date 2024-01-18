drop table if exists ukplaces;

--Create new table 
CREATE TABLE UKPlaces (
  sensor_id VARCHAR(50) PRIMARY KEY NOT NULL,
  name TEXT,
  longitude VARCHAR(50),
  latitude VARCHAR(50),
  country TEXT,
  sensorLocation GEOMETRY
);

--Data insert into  UNPlaces table
INSERT INTO UKPlaces (sensor_id, name, longitude, latitude, country, sensorLocation) VALUES 
('S1', 'York', -1.080278, 53.958332, 'UK', ST_GeomFromText('POINT(-1.080278 53.958332)',4326)),
('S2', 'Worcester', -2.220000, 52.192001, 'UK', ST_GeomFromText('POINT(-2.220000 52.192001)',4326)),
('S3', 'Winchester', -1.308000, 51.063202, 'UK', ST_GeomFromText('POINT(-0.138702 51.063202)',4326)),
('S4', 'Wells', -2.647000, 51.209000, 'UK', ST_GeomFromText('POINT(-2.647000 51.209000)',4326)),
('S5', 'Wakefield', -1.490000, 53.680000, 'UK', ST_GeomFromText('POINT(-1.490000 53.680000)',4326)),
('S6', 'Truro', -5.051000, 50.259998, 'UK', ST_GeomFromText('POINT(-5.051000 50.259998)',4326)),
('S7', 'Sunderland', -1.381130, 54.906101, 'UK', ST_GeomFromText('POINT(-1.381130 54.906101)',4326));


--view table
SELECT * FROM UKPlaces;

--slect two sensore city 
SELECT sensorLocation FROM UKPlaces 
WHERE name='Wells' or name='Truro';

--1.find distance b\w city 
SELECT ST_Distance(geometry(a.sensorLocation),(b.sensorLocation)) FROM UKPlaces a,UKPlaces b
WHERE a.name='Wells' AND b.name='Truro';
--o\p given in degree

--2.find distance b\w city 
SELECT ST_Distance(geography(a.sensorLocation),(b.sensorLocation)) FROM UKPlaces a,UKPlaces b
WHERE a.name='Wells' AND b.name='Truro';
--o\p given in meter

--find location under 250km at point location 
SELECT name
FROM UKPlaces
WHERE ST_DWithin(
    sensorLocation,
    ST_GeomFromText('POINT(-0.138702 51.501220)', 4326)::geography,
    250000);

--plot the line between these two places
SELECT ST_Distance(geography(a.sensorLocation), geography(b.sensorLocation)), 
       ST_MakeLine(a.sensorLocation, b.sensorLocation)
FROM UKPlaces a, UKPlaces b
WHERE a.name='Winchester' AND b.name='Wells';

--

