-- Grouping Data Using GROUP BY

-- 1. GROUP BY

-- It divides the rows returned form SELECT statement into groups
-- For each group we can apply an aggregation function

-- SYNTAX:
/*
	SELECT 
		col_1
		AGGREGATE_FUNCTION(col_2)
	FORM 
		table_name
	GROUP BY
		col_1;
*/

-- GROUP BY eleminates the duplicatre values from the result just like the DISTINCT

-- Get movie count by movie language 
SELECT
	movie_lang,
	COUNT(movie_id)
FROM
	movies
GROUP BY
	movie_lang
ORDER BY
	2 DESC;

-- get avg movie length byt movie language
SELECT 
	movie_lang,
	AVG(movie_length)
FROM 
	movies
GROUP BY
	movie_lang
ORDER BY 
	2 DESC;

-- Get the sum total movie length by age certificate
SELECT 
	age_certificate,
	SUM(movie_length)
FROM
	movies
GROUP BY
	age_certificate
ORDER BY
	2 DESC;

SELECT 
	movie_lang,
	MIN(movie_length),
	MAX(movie_length)
FROM
	movies
GROUP BY
	movie_lang
ORDER BY
	1;

-- Can we use group by without aggregate function? YES

-- Can we col1, agregate function w/o group by caluse? NO
SELECT 
	movie_lang,
	AVG(movie_length)
FROM 
	movies
ORDER BY 
	movie_lang;

-- 2. Using more than one columns in SELECT, Group BY

-- Get avg movie length group by movie language and age certificate
SELECT 
	movie_lang,
	age_certificate,
	AVG(movie_length) AS "Average movie len"
FROM
	movies
GROUP BY
	movie_lang, age_certificate
ORDER BY
	1, 3 DESC;

-- Can we not use GROUP BY for all cols?
-- Yes, we have to use GROUP BY for all cols in select

-- Get avg movie length by movie lang and age certificate where movie_len > 100
SELECT 
	movie_lang,
	age_certificate,
	AVG(movie_length) AS "Average movie len"
FROM
	movies
WHERE 
	movie_length > 100
GROUP BY
	movie_lang, age_certificate
ORDER BY
	1, 3 DESC;

-- Can we use WHERE clause after GROUP BY? NO

-- How many directors are there for each nationality?
SELECT
	nationality,
	COUNT(*)
FROM
	directors
GROUP BY
	nationality
ORDER BY 
	2 DESC NULLS LAST;

-- NOTE: Agregate functions are not allowed in GROUP BY cols_list
-- GROUP BY col_1, col_2, SUM(col2); -- NOT ALLOWED

-- 3. Order of execution in GROUP BY

-- PostgreSQL evaluates the GROUP BY cluase after FROM and WHERE
-- and before the HAVING SELECT, DISTINCT, ORDER BY, and LIMIT

FROM
WHERE
GROUP BY
HAVING
SELECT
DISTINCT
ORDER BY
LIMIT

-- 4. Using HAVING 

-- HAVING clause is used to specify a search conditon for a groupn or an aggregate
-- We can't use column aliases in HAVING as it evaluates before SELECT

-- SYNTAX:
/*
SELECT 
	col_1,
	...
FROM
	table_name
GROUP BY
	col_list
HAVING 
	condition
*/

-- List movie languages where sum total length > 200
SELECT 
	movie_lang,
	SUM(movie_length)
FROM
	movies
GROUP BY
	movie_lang
HAVING
	SUM(movie_length) > 200
ORDER BY
	2 DESC;

-- List directors where their sum total movie > 200
SELECT 
	director_id,
	SUM(movie_length)
FROM
	movies
GROUP BY
	director_id
HAVING 
	SUM(movie_length) > 200
ORDER BY
	2 DESC;

-- 5. HAVING and WHERE Differences

-- HAVING works on result group
-- WHERE works on SELECT cols and not on result group

-- List movie languages where sum total length > 200

-- 1. Using HAVING
SELECT 
	movie_lang,
	SUM(movie_length)
FROM
	movies
GROUP BY
	movie_lang
HAVING
	SUM(movie_length) > 200
ORDER BY
	2 DESC;

-- 2. Using WHERE
-- Throws an error that we can;t use aggregate funcitons in where
SELECT 
	movie_lang,
	SUM(movie_length)
FROM
	movies
WHERE
	SUM(movie_length) > 200
GROUP BY
	movie_lang
ORDER BY
	2 DESC;

-- 5. Handling NULL values in GROUP BY and HAVING

CREATE TABLE table_emp_test (
	emp_id SERIAL PRIMARY KEY,
	emp_name VARCHAR(50),
	department VARCHAR(20),
	salary INT
);

SELECT * FROM table_emp_test;

INSERT INTO table_emp_test (emp_name, department, salary)
VALUES 
('John', 'Finance', 100),
('Mary', NULL, 300),
('Adam', NULL, 400),
('Alex', 'Finance', 200),
('Linda', 'IT', 500),
('Mary', 'IT', 800);

SELECT 
	department, 
	SUM(salary)
FROM
	table_emp_test
GROUP BY
	department
ORDER BY
	1;

-- Using COALESCE(source, '')
SELECT 
	COALESCE(department, 'NO DEPARTMENT'), 
	SUM(salary)
FROM
	table_emp_test
GROUP BY
	department
ORDER BY
	1;

