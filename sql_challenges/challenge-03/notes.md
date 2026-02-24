SQL Aggregation – Quick Notes
Aggregate Functions

Used to summarize multiple rows into one value.

COUNT() → number of rows

SUM() → total

AVG() → average

MIN() → smallest value

MAX() → largest value

COUNT
SELECT COUNT(*) FROM movies;

Counts all rows.

SELECT COUNT(director) FROM movies;

Counts non-NULL values only.

️SUM / AVG
SELECT SUM(domestic_sales) FROM boxoffice;
SELECT AVG(rating) FROM movies;

Work on numeric columns.

Ignore NULL values.

MIN / MAX
SELECT MIN(year) FROM movies;
SELECT MAX(rating) FROM movies;

Work on numbers, dates, and text.

WHERE + Aggregates
SELECT AVG(rating)
FROM movies
WHERE year >= 2000;

WHERE filters rows before aggregation.

GROUP BY (Part 2)

Used to aggregate per category.

SELECT director, AVG(rating)
FROM movies
GROUP BY director;

Returns one result per director.

Important Rule

Every selected column must:

Be inside an aggregate function
OR

Be listed in GROUP BY

HAVING (Filter Groups)
SELECT director, COUNT(*)
FROM movies
GROUP BY director
HAVING COUNT(*) > 3;

WHERE → filters rows

HAVING → filters groups

Key Reminders

No GROUP BY → one result

With GROUP BY → one result per group

COUNT(*) ≠ COUNT(column)

Most aggregates ignore NULL