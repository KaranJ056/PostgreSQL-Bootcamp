-- Joining Multiple Tables USING JOINS

-- PostgreSQL JOINs are used to combine/attach cols from one or more tables based 
-- on commin cols b/w tables
-- These common cols are generally
-- PK cols of first table and FK cols of second table

-- SYNTAX:
/*
	SELECT * 
	FROM table_1
	JOIN table_2
	ON table_1.key_col = table_2.f_key_col

	SELECT 
		table_1.col_1,
		tqable_2.col_1
	FROM table_1
	INNER JOIN table_2 ON table_1.col_1 = table_2.col_2
*/

-- Combine movies and directors table
SELECT * 
FROM movies
JOIN directors
ON movies.director_id = directors.director_id;

SELECT 
		movies.movie_name,
		movies.director_id,
		
		directors.first_name || ' ' || directors.last_name AS "Full Name"
FROM movies
INNER JOIN directors ON movies.director_id = directors.director_id;	

-- We can also use tables as aliases in the SQL in joins
SELECT 
		m.movie_name,
		m.director_id,
		
		d.first_name || ' ' || d.last_name AS "Full Name"
FROM movies m
INNER JOIN directors d ON m.director_id = d.director_id
ORDER BY director_id;	

-- Filter records
SELECT 
		m.movie_name,
		m.director_id,
		
		d.first_name || ' ' || d.last_name AS "Full Name"
FROM movies m
INNER JOIN directors d 
ON m.director_id = d.director_id
WHERE 
	m.movie_lang = 'English'
	AND d.nationality = 'American'
ORDER BY director_id;	

--#####################################################################

-- 2. Inner Join with USING

-- We use USING only when joining tables have the same column names, rather than ON!

-- SYNTAX:
/*
SELECT 
	t1.col1,
	t2.col2
FROM t1
INNER JOIN t1
USING (common_col);
*/

-- EXAMPLE:
SELECT
	d.director_id,
	SUM(m.movie_length) as tml
FROM 
	movies m
INNER JOIN 
	directors d
USING (director_id)
WHERE m.movie_lang = 'English'
GROUP BY
	d.director_id
ORDER BY
	director_id;

-- Can we connect more than two tables?
-- Can we join movies, movies_revenues and directors table?

-- Get directors name of English movies whose total revenue is > 500
SELECT	
	m.movie_name as "Movie Name",

	d.first_name || ' ' || d.last_name AS "Director Name",

	r.revenues_domestic + r.revenues_international AS "Total Revenue"
FROM
	movies m
INNER JOIN directors d USING (director_id)
INNER JOIN movies_revenues r USING (movie_id)
WHERE 
	m.movie_lang = 'English'
	AND r.revenues_domestic + r.revenues_international > 500
ORDER BY
	"Total Revenue";

-- Select movie name, director name, domestic revenue for all Japanese movies
SELECT	
	m.movie_name as "Movie Name",

	d.first_name || ' ' || d.last_name AS "Director Name",

	r.revenues_domestic AS "Domestic Revenue"
FROM
	movies m
INNER JOIN directors d USING (director_id)
INNER JOIN movies_revenues r USING (movie_id)
WHERE 
	m.movie_lang = 'Japanese'
ORDER BY
	"Domestic Revenue";

-- Select movie name, director name for all english, japanese and chinsese movie
-- where domestic revenue > 100
SELECT 
	m.movie_name,

	d.first_name,

	r.revenues_domestic
FROM movies m
INNER JOIN directors d USING (director_id)
INNER JOIN movies_revenues r USING (movie_id)
WHERE
	m.movie_lang IN ('English', 'Japanese', 'Chinese')
	AND r.revenues_domestic > 100
ORDER BY 
	3 DESC NULLS LAST;

-- Select movie name, director name, movie language, total revenues for all top 5 movies
SELECT 
	m.movie_name "Movie Name",
	m.movie_lang "Movie Language",

	CONCAT(d.first_name, ' ', d.last_name) "Director Name",

	COALESCE(r.revenues_domestic, 0) + COALESCE(r.revenues_international, 0) AS "Total Revenue"
FROM movies m
INNER JOIN directors d USING (director_id)
INNER JOIN movies_revenues r USING (movie_id)
ORDER BY
	"Total Revenue" DESC NULLS LAST
LIMIT 5;

-- Which are the top 10 most profitable movies b/w year 2005 and 2008.\
-- Print the movie name, director name, movie lang and the total revenues
SELECT 
	m.movie_name "Movie Name",
	m.movie_lang "Movie Language",

	CONCAT(d.first_name, ' ', d.last_name) "Director Name",

	COALESCE(r.revenues_domestic, 0) + COALESCE(r.revenues_international, 0) AS "Total Revenue"
FROM movies m
INNER JOIN directors d USING (director_id)
INNER JOIN movies_revenues r USING (movie_id)
WHERE
	m.release_date BETWEEN '2005-01-01' AND '2008-12-31'
ORDER BY
	"Total Revenue" DESC NULLS LAST
LIMIT 10;


-- How to INNER JOIN tables of different cols data type
CREATE TABLE t1 (test INT);

CREATE TABLE t2 (test VARCHAR(20));

-- Can we join t1 and t2? NO

SELECT *
FROM t1
INNER JOIN t2 USING (test);

-- What to do if we have to do it?
-- We use CAST
SELECT *
FROM t1
INNER JOIN t2
ON CAST(t1.test AS VARCHAR(20)) = t2.test;