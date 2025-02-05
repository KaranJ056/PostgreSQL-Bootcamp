-- THERE ARE MAILNY THREE TYPES OF OPERATORS ARE AVAILABLE

-- 1. Comparison Operators
		-- =
		-- >
		-- <
		-- >=
		-- <=
		-- <>
-- 2. Logical Operators
		-- AND
		-- OR
		-- LIKE
		-- IN
		-- BETWEEN
-- 3. Arithmatic Operators
		-- =
		-- -
		-- *
		-- /
		-- %

-- Operators are special kwywords in SQL we use in conjuction with SQL clauses

--######################################################################

-- WHERE clause
-- To select specific rows based on conditions

-- WHERE with AND | OR

-- 1.Single Condition
-- Get all English language movies

SELECT
	movie_name,
	movie_lang
FROM movies
WHERE 
	movie_lang = 'English';


-- 2.Multiple movies
-- Get all english movies and age certificate is 18
SELECT * FROM movies
WHERE movie_lang = 'English' AND age_certificate = '18';

-- Get all movies of english or chinese language
SELECT * FROM movies
WHERE movie_lang = 'English' OR movie_lang = 'Chinese'
ORDER BY movie_lang;

-- Combining AND, OR
-- Get all English and Chinese movies and age certificate = 12
SELECT * FROM movies
WHERE
	(movie_lang = 'English' OR movie_lang = 'Chinese')
	AND age_certificate = '12';

-- can we use WHERE before FROM? NO
SELECT *
WHERE movie_lang = 'English' OR movie_lang = 'Chinese'
FROM movies
ORDER BY movie_lang;

-- can we use WHERE after ORDER BY? NO
SELECT *
FROM movies
ORDER BY movie_lang
WHERE movie_lang = 'English' OR movie_lang = 'Chinese';

-- WHERE can only be excecuted after FROM and before ORDER BY
-- FROM
-- WHERE
-- ORDER BY

--######################################################################

-- Order of execution of AND, OR operators

-- AND operator is preocessed first and OR operator is processed second

-- Can we use col aliases with WHERE clause? NO
SELECT 
	first_name "Name",
	last_name "Surname",
	date_of_birth "DoB"
FROM actors
WHERE last_name = 'Allen';

--######################################################################

-- Order of execution of WHERE clause
-- FROM | WHERE | SELECT | ORDER BY

--######################################################################

-- Using Comparison Operators
-- generaly used with numerical data types but can be used with any data type

-- get movies of length > 100
SELECT * FROM movies
WHERE movie_length > 100;

SELECT * FROM movies
WHERE movie_length >= 112;

SELECT * FROM movies
WHERE movie_length <= 100;

-- Get all movies released in or after 2000

SELECT * FROM movies
WHERE release_date >= '2000-01-01'
ORDER BY release_date;

-- Can we use numerical data with quotes? YES

--######################################################################

-- Using LIMIT and OFFSET

-- SYNTAX:
/*
SELECT 
	col_list
FROM table_name
ORDER BY col_name
LIMIT number;
*/	

-- Get top 5 moovies by length
SELECT
	*
FROM movies
ORDER BY 
	movie_length DESC
LIMIT 5;

-- Get the top 5 oldest american directors
SELECT
	*
FROM directors
WHERE nationality = 'American'
ORDER BY date_of_birth
LIMIT 5;

-- Get top 10 youngest female actress
SELECT 
	* 
FROM actors
WHERE 
	gender = 'F'
ORDER BY date_of_birth DESC
LIMIT 10;

-- Using OFFSET
-- LIMIT number OFFSET fromnumber

-- List 5 movies starting from the fourth one ordered by movie_id
SELECT
	*
FROM movies
ORDER BY movie_id
LIMIT 5 OFFSET 4;

--######################################################################

-- Using FETCH
-- Used to fetch portion of rows returned by a query
-- Introduced in SQL 2008


-- SYNTAX:
/*
SELECT col_lis FROM table_name
WHERE condition
ORDER BY expression [ASC | DESC] [NULLS LAST |  NULLS FIRST]
OFFSET start { ROW | ROWS }
FETCH { FIRST | NEXT } [ row_count ] { ROOW | ROWS } ONLY
*/

-- OFFSET start => mustbe 0 or positive [default 0]
-- If start > num of rows returned. No rows are returned

-- get first row of movies table
SELECT
	* 
FROM movies
FETCH FIRST 1 ROW ONLY;

SELECT
	* 
FROM movies
FETCH FIRST 5 ROW ONLY;

-- get top 5 biggest movies by movie length
SELECT
	* 
FROM movies
ORDER BY movie_length DESC
FETCH FIRST 5 ROWS ONLY;

--######################################################################

-- Using IN, NOT IN

-- Used to  check if value is present or not in a list
-- Returns true or false

-- SYNTAX:
-- value IN(value1, value2, ...)
-- value NOT IN(value1, value2, ...)

-- Get all movies for english, chinese and german language
-- Alternate way using OR operator
SELECT 
	*
FROM movies
WHERE 
	movie_lang IN ('English', 'Chinese', 'German')
ORDER BY 
	movie_lang;

SELECT * FROM movies
WHERE age_certificate IN ('12', 'PG');

--######################################################################

-- Using BETWEEN, NOT BETWEEN

-- Used to get values between and not in between in given range

-- SYNTAX:
-- value BETWEEN low AND high
-- value NOT BETWEEN low AND high

SELECT * FROM actors
WHERE date_of_birth BETWEEN '1990-01-01' AND '1999-12-31'
ORDER BY date_of_birth;

-- Get all records whose revenues from 100 to 300
SELECT * FROM movies_revenues
WHERE revenues_domestic BETWEEN 100 AND 300
ORDER BY revenues_domestic;

--######################################################################

-- Using LIKE, ILIKE

-- Operators to query data using pattern matching
-- Returns True or False
-- Both let you search pattern using two special chars

-- % => matches any seq of zero or more chars
-- _ => matches any single chars

-- SYNTAX:
-- value LIKE
-- value ILIKE

-- Full char search
SELECT 'hello' LIKE 'hello'

-- Partial char search
SELECT 'hello' LIKE 'h%'
SELECT 'hello' LIKE 'h___o'
SELECT 'hello' LIKE '%e%'

-- Get all actors name starts with A
SELECT * FROM actors
WHERE first_name LIKE 'A%';

SELECT * FROM actors
WHERE first_name LIKE '%a';

SELECT * FROM actors
WHERE first_name LIKE '_____';

-- Is LIKE casensitive? YES, it's casesensitive.
-- Is ILIKE casesnsitive? NO, it's not casensitive.

--######################################################################

-- Using IS NULL, IS NOT NULL

-- Retrurns True or False

--SYNTAX:
-- SELECT col_list FROM table_name WHERE col_name IS NULL;
-- SELECT col_list FROM table_name WHERE col_name IS NOT NULL;

-- Find list of actors with missing birth date
SELECT
	*
FROM
	ACTORS
WHERE
	DATE_OF_BIRTH IS NULL;

-- Get list of records where both revenues is NULL
SELECT * FROM movies_revenues 
WHERE (revenues_domestic, revenues_international) IS NULL;

-- Get list of records where any revenues is NULL
SELECT * FROM movies_revenues 
WHERE 
	revenues_domestic IS NULL
	or revenues_international IS NULL;

--######################################################################

-- Concatenation techniques

-- For concat two or more strings we can use ||
-- CONCAT(col1, col2)
-- CONCAT_WS(seperator, col1, col2)


SELECT CONCAT_WS(' ', 'Hello', 'World', 'PlSQL');
SELECT CONCAT(first_name, ' ', last_name, ' ', gender) as Name FROM actors;

-- How NULL values are handled in concatenation?
-- || => reruens null if any values is null
-- CONCAT => returns if any value is not null
-- CONCAT_WS => ignores null values

