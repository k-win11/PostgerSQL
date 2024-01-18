--view full table 
select * from geometries;

-- Point  coordinats check
select ST_X(geom),ST_Y(geom) 
from geometries
where name='Point';

-- compute Simple line Length check
select ST_asText(geom),ST_Length(geom) 
from geometries
where name='Simple line';

-- compute Linestring Length check
select ST_asText(geom),ST_Length(geom) 
from geometries
where name='Linestring';

-- compute line Length & start and end point 
select ST_asText(geom),
		ST_Length(geom),
		ST_asText(ST_StartPoint(geom)),
		ST_asText(ST_EndPoint(geom))
from geometries
where name='Linestring';

--compute area of the Polygone,Square,Rectangle
select name, ST_asText(geom),ST_Area(geom),geom
from geometries
where name like 'Polygon%' or name like 'Square' or name like 'Rectangle';
