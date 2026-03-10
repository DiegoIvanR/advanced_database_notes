-- Review update
SQLBolt Study Notes: Lessons 1–5

This guide covers the fundamental SQL keywords and syntax used for retrieving, filtering, and organizing data from a single database table.

Lesson 1: SELECT Queries 101

The foundation of every SQL query. It tells the database which columns you want and which table to look in.

SELECT: Identifies the specific columns to retrieve.

FROM: Identifies the table where the data is stored.

* (Wildcard): A shorthand to select every column available in the table.

Example:

-- Retrieve the title and year of all movies
SELECT title, release_year 
FROM movies;

-- Retrieve every column from the movies table
SELECT * FROM movies;


Lesson 2: Queries with Constraints (Part 1)

Used to filter rows based on specific numeric conditions or exact matches.

WHERE: Filters the results to only include rows that satisfy a given condition.

Operators:

=, !=, <, <=, >, >= (Standard comparisons)

BETWEEN ... AND ... (Inclusive range for numbers)

AND / OR (Combine multiple conditions)

Example:

-- Find movies released between 2000 and 2010
SELECT title FROM movies 
WHERE release_year BETWEEN 2000 AND 2010;

-- Find movies directed by "John Lasseter"
SELECT * FROM movies 
WHERE director = "John Lasseter";


Lesson 3: Queries with Constraints (Part 2)

Focuses on "fuzzy" text matching and checking against lists of values.

LIKE: Searches for a pattern within a string.

%: Matches zero or more characters.

_: Matches exactly one character.

IN (...): Checks if a value exists within a comma-separated list.

NOT: Reverses a condition (e.g., NOT LIKE, NOT IN).

Example:

-- Find movies with "Toy" anywhere in the title
SELECT title FROM movies 
WHERE title LIKE "%Toy%";

-- Find movies directed by specific directors
SELECT title, director FROM movies 
WHERE director IN ("John Lasseter", "Andrew Stanton", "Pete Docter");


Lesson 4: Filtering and Sorting Results

Controls the order of the data and limits the amount of data returned.

DISTINCT: Removes duplicate rows so only unique values are returned.

ORDER BY: Sorts the results by a specific column.

ASC: Ascending (A-Z, 1-10) - Default.

DESC: Descending (Z-A, 10-1).

LIMIT: Restricts the result set to a specific number of rows.

OFFSET: Skips a specific number of rows before starting to return data.

Example:

-- List all unique directors alphabetically
SELECT DISTINCT director FROM movies 
ORDER BY director ASC;

-- Get the 3rd and 4th newest movies
SELECT title FROM movies 
ORDER BY release_year DESC 
LIMIT 2 OFFSET 2;


Lesson 5: Review - Simple SELECT Queries

A recap of how to structure a full query using all the keywords above. Note that while they are written in this order, the database often executes FROM and WHERE before SELECT.

Standard Query Structure:

SELECT DISTINCT column, another_column, …
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC
LIMIT num_limit OFFSET num_offset;


Example Summary Query:

SELECT title, director
FROM movies
WHERE release_year > 2000
  AND director != "John Lasseter"
ORDER BY title DESC
LIMIT 5;
