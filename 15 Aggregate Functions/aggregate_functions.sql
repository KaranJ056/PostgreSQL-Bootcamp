-- AGGREGATE FUNCTIONS

-- 1. COUNT

-- SELECT COUNT(*) FROM table_name
-- SELCET COUNT(col_name) FROM table_name

-- Ex: Count total no. of movies in movies table 
SELECT COUNT(*) FROM movies;

--Using count with distinct
SELECT
	COUNT(movie_lang),
	COUNT(DISTINCT movie_lang) 
FROM 
	movies;

-- COUNT(), COUNT(*) and COUNT(1)

CREATE TABLE table_test (
	name VARCHAR(10)
);

INSERT INTO table_test
VALUES ('Apple'), ('Banana'), (NULL), ('Orange');

SELECT 
	COUNT(*),
	COUNT(name),
	COUNT(1)
FROM 
	table_test;

-- 2. SUM 

-- SUM(sol_name)

SELECT 
	SUM(revenues_domestic) as "Domestic Revenue",
	SUM(revenues_international) as "International Revenue"
FROM 
	movies_revenues;

-- Find total movie len of english movies
SELECT SUM(movie_length)::TEXT || ' ' || 'mins' AS tatal
FROM movies
WHERE movie_lang = 'English';

-- IS sum only works on numeric data type? YES
SELECT SUM(movie_name) FROM movies;

-- 3. MIN and MAX functions

SELECT 
	MIN(movie_length) AS shortest_movie,
	MAX(movie_length) AS longest_movie
FROM 
	movies;

SELECT 
	MIN(movie_length) AS shortest_movie,
	MAX(movie_length) AS longest_movie
FROM 
	movies
WHERE 
	movie_lang = 'English';

-- Get the first movies released in Chinese
SELECT 
	MIN(release_date) as first_released
FROM 
	movies
WHERE 
	movie_lang = 'Chinese';

SELECT MIN(movie_name) FROM movies;

-- 4. GREATEST and LEAST functions

-- GREATEST(list)
-- LEAST(list)

-- Selects GREATEST and LEAST value from the list of nay number or expression

SELECT 	
	GREATEST('a', 'b', 'c'),
	LEAST('a', 'b', 'c');

-- 5. AVG function

-- AVG(col_name) => Returns avg value of a col_name

SELECT 
	AVG(movie_length) avg_len,
	AVG(DISTINCT movie_length) avg_len_d
FROM movies
WHERE movie_lang = 'English'; 

-- Can we use AVG with cols data type other than numeric? NO 
-- Special Case we'll see later 

-- Using AVG with SUM

SELECT 
	AVG(movie_length),
	SUM(movie_length)/COUNT(*) as avg_manual,
	SUM(movie_length)
FROM movies
WHERE movie_lang = 'English';

-- 6. combining cols using mathematical operators
-- +
-- -
-- *
-- /
-- %

SELECT 
	10+2 as add,
	10-2 as sub,
	10*2 as mul,
	10/2 as div,
	10%3 as mod;

SELECT 
	movie_id,
	revenues_domestic,
	revenues_domestic,
	(revenues_domestic + revenues_domestic) as total_revenue
FROM movies_revenues;