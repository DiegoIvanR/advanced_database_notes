-- 6
SELECT * FROM movies LEFT JOIN Boxoffice ON Movies.Id = Boxoffice.Movie_id;
SELECT * FROM movies LEFT JOIN Boxoffice ON movies.Id = Boxoffice.Movie_id Where Boxoffice.International_sales > Boxoffice.Domestic_sales;
SELECT movies.title, Boxoffice.rating FROM movies JOIN Boxoffice ON movies.Id = Boxoffice.Movie_id ORDER BY Boxoffice.Rating DESC

-- 7
SELECT DISTINCT Building FROM employees INNER JOIN Buildings ON Buildings.Building_name = Employees.Building;
SELECT Building_name, Capacity FROM Buildings;
SELECT DISTINCT building_name, role FROM Buildings LEFT JOIN Employees ON Buildings.Building_name = Employees.Building;

-- DataLemur
SELECT pages.page_id FROM pages
LEFT JOIN page_likes
ON pages.page_id = page_likes.page_id
WHERE page_likes.user_id IS NULL
ORDER BY pages.page_id;
