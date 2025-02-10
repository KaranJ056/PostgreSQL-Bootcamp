-- RIGHT JOINs in PostgreSQL

-- Returns every rows from RIGHT table and rows that match values in the joined column from 
-- the left table
-- When a right table row doesn't have a match in the left table, the result shows no value
-- from the left table.

-- SYNTAX:
/*
SELECT
	t1.col1,
	t2.col2
FROM t1
RIGHT JOIN t2 ON t1.col1 = t2.col1
*/

SELECT
	*
FROM table_left_products l
RIGHT JOIN table_right_products r USING (prod_id);

-- Let's run RIGHT JOINs on movies database
-- List all the movies with di rectors first and last names, and movie name
-- What is the right table1 or table2?

SELECT 
	d.first_name,
	d.last_name,

	m.movie_name
FROM directors d
RIGHT JOIN movies m USING (director_id)
ORDER BY first_name, last_name;

-- Count movies for each directors
SELECT 
	d.director_id "Director ID",
	d.first_name || ' ' || d.last_name "Full Name",

	COUNT(m.movie_id)
FROM movies m
RIGHT JOIN directors d USING (director_id)
GROUP BY "Director ID", "Full Name"
ORDER BY
	COUNT DESC;