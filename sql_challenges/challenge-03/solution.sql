--10 pt1
SELECT max(years_employed) FROM employees;
SELECT avg(years_employed), * FROM employees GROUP BY Role;
SELECT sum(years_employed), * FROM employees Group by Building;

--10 pt2
SELECT *, count(*) FROM employees where Role = "Artist";
SELECT *, count(*) FROM employees GROUP BY Role;
SELECT *, sum(years_employed) FROM employees WHERE Role = "Engineer";

-- freesql
select count(distinct shape) as number_of_shapes,
       stddev(distinct weight) as distinct_weight_stddev
from   bricks;

select shape, sum(weight) as shape_weight
from   bricks
group by shape;

select shape, sum ( weight )
from   bricks
group  by shape
having sum(weight) < 4;