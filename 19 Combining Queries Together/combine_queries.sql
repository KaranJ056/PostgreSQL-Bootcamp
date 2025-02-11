-- Combining Queries together with the UNION

-- UNION operator combines result sets returned from two or more SELECT statement
-- - To be able to use UNION;
-- 		The order and number of the columns in the select List of all queries must be the same.
-- 		The data types must be compatible too.

-- SYNTAX:
/*
SELECT col1, col2
FROM t1
UNION
SELECT col1, col2
FROM t2
*/

SELECT * FROM table_left_products;

SELECT *
FROM table_left_products
UNION
SELECT *
FROM table_right_products
ORDER BY 1;

-- Do we get duplicate from UNION? NO

-- What to do if we want duplicate records?
-- Use all with UNION
SELECT *
FROM table_left_products
UNION ALL
SELECT *
FROM table_right_products
ORDER BY 1;

-- Combine directors and actors table:
-- Can we use UNION with ORDER BY? YES
SELECT 
	CONCAT(first_name, ' ', last_name) "Full Name", 
	date_of_birth "DoB",
	'directors' "Table Name"
FROM directors
UNION
SELECT 
	CONCAT(first_name, ' ', last_name) "Full Name", 
	date_of_birth "DoB",
	'actors' "Table Name"
FROM actors
ORDER BY "Full Name";

-- Lets combine all directors where nationality are American, Chinese and Japanese 
-- with a11 female actors.

SELECT 
	CONCAT(first_name, ' ', last_name) "Full Name", 
	date_of_birth "DoB",
	'directors' "Table Name"
FROM directors
WHERE 
	nationality IN ('American', 'Japanese', 'Chinese')
UNION
SELECT 
	CONCAT(first_name, ' ', last_name) "Full Name", 
	date_of_birth "DoB",
	'actors' "Table Name"
FROM actors
WHERE
	gender = 'F'
ORDER BY "Full Name";

-- Select the first name and last name of all directors and actors 
-- which are born after 1990.
SELECT 
	CONCAT(first_name, ' ', last_name) "Full Name", 
	date_of_birth "DoB",
	'directors' "Table Name"
FROM directors
WHERE 
	date_of_birth > '1990-12-31'
UNION
SELECT 
	CONCAT(first_name, ' ', last_name) "Full Name", 
	date_of_birth "DoB",
	'actors' "Table Name"
FROM actors
WHERE
	date_of_birth > '1990-12-31'
ORDER BY "Full Name";

-- Select the first name and last name of all directors and actors 
-- where their first names starts with 'A'
SELECT 
	CONCAT(first_name, ' ', last_name) "Full Name", 
	date_of_birth "DoB",
	'directors' "Table Name"
FROM directors
WHERE 
	first_name LIKE 'A%'
UNION
SELECT 
	CONCAT(first_name, ' ', last_name) "Full Name", 
	date_of_birth "DoB",
	'actors' "Table Name"
FROM actors
WHERE
	first_name LIKE 'A%'
ORDER BY "Full Name";

----#####################################################################

-- UNION tables with different no. of columns

-- We have 
-- table_1: add_date, col1, col2, col3
-- table_1: add_date, col1, col2, col3, col4, col5

SELECT
	col1, 
	col2, 
	col3, 
	NULL col4, 
	NULL col5
FROM table_1
UNION
SELECT
	col1, 
	col2, 
	col3, 
	col4, 
	col5
FROM table_2;

--#####################################################################

-- Combining Queries with INTERSECT

-- INTERSECT returns any rows that are present in BOTH result sets.
-- - To be able to use UNION;
-- 		The order and number of the columns in the select List of all queries must be the same.
-- 		The data types must be compatible too.

-- SYNTAX:
/*
SELECT col1, col2
FROM t1
INTERSECT
SELECT col1, col2
FROM t2
*/

SELECT
	*
FROM table_left_products
INTERSECT
SELECT
	*
FROM table_right_products
ORDER BY 1;

SELECT
	first_name,
	last_name,
	date_of_birth
FROM directors
INTERSECT
SELECT
	first_name,
	last_name,
	date_of_birth
FROM actors;

--#####################################################################

-- Combining Queries with the EXCEPT

-- EXCEPT operator returns the rows from the first query that 
-- don't appear  in the o/p of second qurery
-- - To be able to use UNION;
-- 		The order and number of the columns in the select List of all queries must be the same.
-- 		The data types must be compatible too.

-- SYNTAX:
/*
SELECT col1, col2
FROM t1
EXCEPT
SELECT col1, col2
FROM t2
*/

SELECT *
FROM table_right_products
EXCEPT
SELECT *
FROM table_left_products;

SELECT
	first_name,
	last_name,
	date_of_birth
FROM directors
EXCEPT
SELECT
	first_name,
	last_name,
	date_of_birth
FROM actors;