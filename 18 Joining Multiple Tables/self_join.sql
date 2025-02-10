-- SELF JOINs in PostgreSQL

-- It allows you to compare rows within the SAME table.
-- Normal Use Case :
-- - Query Hierarchical data or
-- - To compare rows within the same table

-- SYNTAX:
/*
SE:ECT
	col_list
FROM table_name t1
INNER JOIN table_name t2 ON t1.col1 = t2.col1
*/

SELECT
	*
FROM table_left_products t1
INNER JOIN table_left_products t2 USING (prod_id);

-- Find all pairs of movies that have same movie length
SELECT
	m1.movie_name "Movie Name",
	m2.movie_name "Movie Name",
	m1,movie_length "Length (+)"
FROM movies m1
INNER JOIN movies m2 ON m1.movie_length = m2.movie_length
AND m1.movie_name <> m2.movie_name
ORDER BY 1;

-- Querry hierarchical data on directors and movies

SELECT 
	t1.movie_name "Movie Name",
	t2.director_id "Director ID"
FROM movies t1
INNER JOIN movies t2 ON t1.movie_id = t2.director_id
ORDER BY
	2;