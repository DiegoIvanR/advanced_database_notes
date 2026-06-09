-- Review update
-- freesql
select b.*,
       count(*) over (
         partition by shape
       ) bricks_per_shape,
       median ( weight ) over (
         partition by weight
       ) median_weight_per_shape
from   bricks b
order  by shape, weight, brick_id;

select b.brick_id, b.weight,
       round ( avg ( weight ) over (
         order by BRICK_ID
       ), 2 ) running_average_weight
from   bricks b
order  by brick_id;

select b.*,
       min ( colour ) over (
         order by brick_id
         range between 2 preceding and 1 preceding
       ) first_colour_two_prev,
       count (*) over (
         order by weight
         range between current row and 1 following
       ) count_values_this_and_next
from   bricks b
order  by weight;

with totals as (
  select b.*,
         sum(weight) over (
           partition by shape
         ) weight_per_shape,
         sum(weight) over (
           order by brick_id
         ) running_weight_by_id
  from bricks b
)
select * from totals
where weight_per_shape > 4 and running_weight_by_id > 4
order by brick_id;

-- data lemur
select department_name, name, salary from (select *, dense_rank(*) 
over(partition by employee.department_id 
order by salary DESC) salary_rank
from employee
left join department
  on employee.department_id = department.department_id) t

where salary_rank <= 3
ORDER BY department_name, salary DESC, name;