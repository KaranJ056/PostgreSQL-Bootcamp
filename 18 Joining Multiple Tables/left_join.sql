-- LEFT JOINs in PostgreSQL

-- Returns every rows from LEFT table and rows that match values in the joined column from 
-- the right table
-- When a left table row doesn't have a match in the right table, the result shows no value
-- from the right table.

-- SYNTAX:
/*
SELECT
	t1.col1,
	t2.col2
FROM t1
LEFT JOIN t2 ON t1.col1 = t2.col1
*/

CREATE TABLE table_left_products (
	prod_id SERIAL PRIMARY KEY,
	prod_name VARCHAR(10)
);

CREATE TABLE table_right_products (
	prod_id SERIAL PRIMARY KEY,
	prod_name VARCHAR(10)
);

INSERT INTO table_left_products (prod_id, prod_name)
VALUES
(1, 'Computer'),
(2, 'Mopuse'),
(3, 'Keyboard'),
(5, 'Pen');

INSERT INTO table_right_products (prod_id, prod_name)
VALUES
(1, 'Computer'),
(2, 'Mopuse'),
(3, 'Keyboard'),
(5, 'Pen'),
(4, 'Mics'),
(6, 'Monitors');

SELECT * FROM table_left_products;
SELECT * FROM table_right_products;

SELECT * 
FROM table_left_products l
LEFT JOIN table_right_products r USING (prod_id);

-- List all the movies with directors first name and last name and movies name
SELECT
	m.movie_name, 

	d.first_name,
	d.last_name
FROM directors d
LEFT JOIN movies m USING (director_id)
ORDER BY movie_name;

SELECT
	m.movie_name, 

	d.first_name,
	d.last_name
FROM movies m
LEFT JOIN directors d USING (director_id)
ORDER BY movie_name;

-- Can we add where condition in LEFT JOIN? 
-- Say get list of english and chinese movies only

SELECT 
	* 
FROM movies m
LEFT JOIN directors d USING (director_id)
WHERE 
	m.movie_lang IN ('English', 'Chinese');

-- Count movis for all directors
SELECT
	d.director_id "Director ID",
	d.first_name || ' ' || d.last_name "Full Name",
	COUNT(m.movie_id) "Total Movies"
FROM directors d
LEFT JOIN movies m USING (director_id)
GROUP BY
	d.director_id
ORDER BY
	1 NULLS LAST;

-- Get all movies with age certification where director's nationalities in American, Japanese, Chinese
SELECT 
	m.movie_name "movie Name",
	m.age_certificate,
	
	d.first_name || ' ' || d.last_name "Full Name",
	d.nationality
FROM directors d
LEFT JOIN movies m USING (director_id)
WHERE 
	d.nationality IN ('American', 'Japanese', 'Chinese')
ORDER BY
	d.nationality;

-- Get all the total revenues done by each films for each di rectors

SELECT 
	d.director_id "Director ID",
	d.first_name || ' ' || d.last_name "Full Name",

	SUM(r.revenues_domestic + r.revenues_international) "Total Revenue"
FROM directors d
LEFT JOIN movies m USING (director_id)
LEFT JOIN movies_revenues r ON m.movie_id = r.movie_id
GROUP BY
	"Director ID", "Full Name"
HAVING
	SUM(r.revenues_domestic + r.revenues_international) > 0
ORDER BY
	"Total Revenue" DESC NULLS LAST