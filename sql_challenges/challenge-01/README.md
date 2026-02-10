solutions:
# 1
SELECT title FROM movies;
SELECT director FROM movies;
SELECT title, director FROM movies;
SELECT title, year FROM movies;
SELECT * FROM movies;

# 2
SELECT * FROM movies WHERE id == 6;
SELECT * FROM movies WHERE year >= 2000 and year <= 2010;
SELECT * FROM movies WHERE year NOT BETWEEN 2000 AND 2010;
SELECT tITLE, yeAR FROM movieS ORDER BY YEAR ASC LIMIT 5;

# 3
SELECT * FROM movies WHERE Title LIKE "Toy Story%";
SELECT * FROM movies WHERE Director = "John Lasseter";
SELECT * FROM movies WHERE Director != "John Lasseter";
SELECT * FROM movies WHERE Title LIKE "WALL-%";

# 4
SELECT DISTINCT Director FROM movies ORDER BY Director;
SELECT * FROM movies ORDER BY YEAR DESC LIMIT 4;
SELECT * FROM movies ORDER BY Title ASC LIMIT 5;
SELECT * FROM movies ORDER BY Title ASC LIMIT 5 OFFSET 5;

# 5
SELECT * FROM north_american_cities WHERE Country = "Canada";
SELECT * FROM north_american_cities WHERE Country = "United States" ORDER BY Latitude DESC;
SELECT * FROM north_american_cities WHERE Longitude < -87.629798 ORDER BY Longitude ASC;
SELECT * FROM north_american_cities WHERE Country = "Mexico" ORDER BY Population DESC Limit 2;
SELECT * FROM north_american_cities WHERE Country = "United States" ORDER BY Population DESC Limit 2 OFFSET 2;