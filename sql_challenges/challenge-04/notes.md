-- Review update
A window function performs a calculation across a set of rows related to the current row — without collapsing rows (unlike GROUP BY).

Basic Syntax
function_name(expression)
OVER (
    PARTITION BY column
    ORDER BY column
)

PARTITION BY → splits data into groups

ORDER BY → defines order inside each group

Frame clause (ROWS BETWEEN ...) → defines row range (optional)

Ranking Functions
ROW_NUMBER()

Unique sequence, no ties.

ROW_NUMBER() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
)

Use when: you need exactly K rows per group.

RANK()

Ties share rank, gaps appear.

Example: 1, 2, 2, 4

Use when: ranking position matters.

DENSE_RANK()

Ties share rank, no gaps.

Example: 1, 2, 2, 3

Use when: top K values including ties.

Aggregate Window Functions
Partition Total
SUM(salary) OVER (PARTITION BY department_id)
Running Total
SUM(salary) OVER (
    PARTITION BY department_id
    ORDER BY salary
)
LAG / LEAD
Previous row
LAG(salary) OVER (
    PARTITION BY department_id
    ORDER BY salary
)
Next row
LEAD(salary) OVER (
    PARTITION BY department_id
    ORDER BY salary
)
Window vs GROUP BY
Window Function	GROUP BY
Keeps all rows	Collapses rows
Allows ranking	Aggregates only
Combines detail + aggregate	No row-level detail
Common Interview Pattern: Top K Per Group
WITH ranked AS (
  SELECT *,
         DENSE_RANK() OVER (
             PARTITION BY department_id
             ORDER BY salary DESC
         ) AS rnk
  FROM employee
)
SELECT *
FROM ranked
WHERE rnk <= 3;