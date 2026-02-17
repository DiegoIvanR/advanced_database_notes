SQLBolt Study Notes: Lessons 6–7

This section introduces how to perform calculations on data and how to combine data from multiple tables using JOINs.

Lesson 6: Multi-table Queries with JOINs

When data is stored across multiple tables, we use JOIN to combine related rows based on a shared column.

Why JOIN?

Relational databases split data into separate tables to reduce duplication. JOIN allows us to reconnect that data when querying.

Key Concepts

INNER JOIN (default JOIN)
Returns only rows where there is a match in both tables.

ON
Specifies the condition that links the tables together.

Basic Syntax
SELECT column, another_column
FROM table1
JOIN table2
  ON table1.column = table2.column;

Example

Assume:

movies table contains movie info

boxoffice table contains revenue data

Both share a common movie_id

-- Get movie titles and their domestic sales
SELECT movies.title, boxoffice.domestic_sales
FROM movies
JOIN boxoffice
  ON movies.id = boxoffice.movie_id;

Important Notes

The JOIN condition must correctly match related columns.

You can select columns from either table.

Always qualify columns with table names when they exist in both tables.

Lesson 7: OUTER JOINs

Outer joins return rows even when there is no match in the other table.

Types of OUTER JOINs

LEFT JOIN (LEFT OUTER JOIN)
Returns all rows from the left table, and matched rows from the right table.
If no match exists, NULL values appear for the right table columns.

RIGHT JOIN (RIGHT OUTER JOIN)
Returns all rows from the right table, and matched rows from the left table.

FULL JOIN (FULL OUTER JOIN)
Returns all rows from both tables, matched where possible.

LEFT JOIN Syntax
SELECT column, another_column
FROM table1
LEFT JOIN table2
  ON table1.column = table2.column;

Example
-- Get all movies and their box office data (if available)
SELECT movies.title, boxoffice.domestic_sales
FROM movies
LEFT JOIN boxoffice
  ON movies.id = boxoffice.movie_id;


If a movie has no box office record, it will still appear — but sales will be NULL.

Comparing JOIN Types
JOIN Type	Returns
INNER JOIN	Only matching rows
LEFT JOIN	All left rows + matches
RIGHT JOIN	All right rows + matches
FULL JOIN	All rows from both tables
Execution Order Reminder

Even though written in this order:

SELECT columns
FROM table1
JOIN table2
ON condition
WHERE condition
ORDER BY column;


The database typically processes:

FROM

JOIN

ON

WHERE

SELECT

ORDER BY

LIMIT

Summary

Lesson 6 introduced how to combine tables using INNER JOIN.
Lesson 7 expanded this with OUTER JOINs to include unmatched rows.

Together, these lessons allow you to:

Combine related data across tables

Preserve unmatched rows when necessary

Perform more powerful relational queries