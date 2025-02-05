-- Select data from a table

-- SYNTAX : SELECT * FROM table_name;

-- 1. Get all rocoeds from a movies table
SELECT * FROM movies;

-- 2. Get all records from a actors table
SELECT * FROM actors;

-- 3. 
-- All SQL keywords are case insensitive
-- It's good practice to write keywords in Caps

-- 4. NOTE:
-- Postgres SQL evaluates the FROM clause before SELECT clause

-- ###########################################################

-- Selecting specific columns/fields from a table

-- SYNTAX: SELECT col_1, col_2, .... FROM table_name;

-- 1. Get forst name from actors table
SELECT first_name FROM actors;

-- 2. Get first_name, last_name from actors table
SELECT first_name, last_name FROM actors;

-- 3. Using explicit colummns is a good practice and produce
--    Less load on the server

-- ###########################################################

-- Adding alias to a column name

-- 1. Get all records from actors and review it from a non-tech 
--    reader's point of view 
SELECT * FROM actors;

-- 2. Make an alias for first_name as firstName of actors table
SELECT first_name AS firstName FROM actors;
SELECT first_name AS "firstName" FROM actors;
SELECT first_name AS "First Name" FROM actors;

-- 3. Make alias for movie_name as Movie Name and movie_lang as Language
-- 	  From a cols of movies table

SELECT 
	movie_name AS "Movie Name", 
	movie_lang AS "LANGUAGE" 
FROM movies;

-- 4. AS keyword is optional
SELECT 
	movie_name "Movie Name", 
	movie_lang "LANGUAGE" 
FROM movies;

-- 5. We can't use '' for an alias

-- Usually AS iis used for derived columns

-- ###########################################################

-- Assinging Col alias to an expression

-- 1. Combine first_name, last_name together to make full name
--    We can do it using '||' expression
SELECT first_name || last_name FROM actors;
SELECT first_name || ' ' || last_name FROM actors;
SELECT 
	first_name || ' ' || last_name AS "Full Name" 
FROM actors;

-- 2. Use expression to get output w/oi using a table col
SELECT 2*10;
