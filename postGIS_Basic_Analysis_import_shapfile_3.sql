--view the map
select * from cb_2017_us_state_20m;

--vew few provence 
select stusps,name,geom from cb_2017_us_state_20m 
where stusps in('CA','NY','WA','TX');