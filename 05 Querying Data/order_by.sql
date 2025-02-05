-- using ORDER BY to sert records

-- SYNTAX:
/*
SELECT 
	col_list
FROM table_name
ORDER BY 
	sort_expression1 [ASC | DESC],
	sort_expression2 [ASC | DESC],
	.....
*/

-- sort expression can be a column or a n expression

-- 1. Sort based on a single col
--    Sort all movie_records by their release_date in  ASC order
--    NOTE: Default order is ASC
SELECT 
	* 
FROM movies
ORDER BY 
	release_date ASC;

-- 2. Sort based on multiple columns
-- 	  Sort all movie_records based on release_date in descending order
--    And movie_name in ascending order
SELECT
	* 
FROM movies
ORDER BY
	release_date DESC,
	movie_name ASC;

--####################################################################

-- using ORDER BY with alias col name

-- 1. Get first_name, last_name from actors
SELECT
	first_name,
	last_name
FROM actors;

-- 2. Get last_name as Surname
SELECT
	last_name Surname
FROM actors;

-- 3. Sort rows by last name
SELECT
	first_name,
	last_name Surname
FROM actors
ORDER BY
	last_name;

-- 4. Use alias in ORDER BY
SELECT
	first_name,
	last_name Surname
FROM actors
ORDER BY
	Surname;

--####################################################################

-- Use ORDER BY to sort row by expression

-- 1. Calculate length of the actor name with LENGTH function
SELECT 
	LENGTH(first_name),
	first_name
FROM actors;

-- 2. Sort rows by length of the actor name with LENGTH function in 
-- 	  descending order 
SELECT 
	LENGTH(first_name),
	first_name
FROM actors
ORDER BY
	LENGTH DESC;

--####################################################################

-- using ORDER BY for a coumn name or column number

-- Sort all records by first_name asc, birth_date desc
SELECT
	*
FROM actors
ORDER BY
	first_name ASC,
	date_of_birth DESC;

-- Use column number instead of column name for sorting
SELECT
	first_name name,
	last_name surname,
	date_of_birth DoB
FROM actors
ORDER BY
	1 ASC,
	3 DESC;

--####################################################################

-- using order by with NULL values

-- SYNTAX:
/*
SELECT 
	col_list
FROM table_name
ORDR_BY
	sort_expression1 [ASC | DESC] [NULLS FIRST | NULLS LAST];
*/

CREATE TABLE demo_string (num INT);

INSERT INTO demo_string
VALUES
(1),
(21),
(2),
(7),
(NULL),
(34),
(3),
(NULL);

SELECT * FROM demo_string;

SELECT * FROM demo_string
ORDER BY num DESC NULLS LAST;

DROP TABLE demo_string;