-- All About Views

--#####################################################################
-- Intro. to Views

/*
	One of the advantages of using a programing language is that it allows us to automate repetitive, 
	boring tasks. For example, if you have to run the same query every day or month to update the 
	same table, sooner or later you'll search for a shortcut to accomplish the task. 
	The good news is that shortcuts exist in PostgreSQL! and it's called a 'View

	- We can store queries to a view.
	- View is a db object that is of 'stored queery'.
	- They are like Don't Repeat Yourself.
	- Similar to table,
		- query a view
		- join a view to regular table or othyer views
		- use the view to update or insert data into the table it's based on, albeit with some caveats.
	- Please note that a regular views do not store any data except the 'materialized views'.
*/

--#####################################################################
-- Creating a view

-- SYNTAX:
-- CREATE OR REPLACE VIEW view_name AS query

-- Ceate a view to include all movies with directors name

-- Normal Approach:
SELECT
	m.movie_name "Movie",

	CONCAT(d.first_name, ' ', d.last_name) "Director Name"
FROM movies m
JOIN directors d USING (director_id)
ORDER BY 1;

-- View based approach:
CREATE OR REPLACE VIEW v_movies_directors_quick AS
SELECT
	m.movie_name "Movie",

	CONCAT(d.first_name, ' ', d.last_name) "Director Name"
FROM movies m
JOIN directors d USING (director_id)
ORDER BY 1;

-- Use a view
SELECT * FROM v_movies_directors_quick;

--#####################################################################
-- Rename a view

-- SYNTAX:
-- ALTER VIEW view_name RENAME TO new_view_name;

ALTER v_movies_directors_quick RENAME TO v_movies_directors_quick1;
-- We can also use pgAdmin tool for the same.

-- Delete a view

-- SYNTAX:
DROP VIEW view_name;

--#####################################################################
-- Using condition/filters with views

-- Create a view to list all movies released after 1997

CREATE OR REPLACE VIEW v_movies_after_1997 AS
SELECT
	movie_id "Movie Id",
	movie_name "Movie Name",
	movie_length "Duration (mins)",
	age_certificate "Age Cert.",
	release_date "Released On"
FROM movies
WHERE release_date > '1997-12-31'
ORDER BY "Released On" DESC NULLS LAST;

SELECT * FROM v_movies_after_1997;

-- create a view for movies with directors form Japanese and American nationality.
CREATE OR REPLACE VIEW v_movies_of_american_japnese_directors AS
SELECT 
	m.movie_id "Movies Id",
	m.movie_name "Movie Name",

	CONCAT(d.first_name, ' ', d.last_name) "Director Name",
	d.nationality "Director's Nationality"
FROM 
	movies m
JOIN directors d USING (director_id)
WHERE 
	d.nationality IN ('American', 'Japanese')
ORDER BY 4;

SELECT * FROM v_movies_of_american_japnese_directors;

--#####################################################################
--View using SELECT and UNION with multiple tables

CREATE VIEW v_all_directors_actors AS
SELECT
	first_name,
	last_name,
	'actors' AS people_type
FROM actors
UNION ALL
SELECT
	first_name,
	last_name,
	'direcotrs' AS people_type
FROM directors;

SELECT * 
FROM v_all_directors_actors
ORDER BY people_type, first_name;

--#####################################################################
-- Connecting multiple tables with a single row

-- Connect movies, directros, moivies_revennues tables in a single row
CREATE VIEW v_movies_directors_movies_revenues AS
SELECT 
	*
FROM movies mv
JOIN directors d USING (director_id)
JOIN movies_revenues USING (movie_id);

--#####################################################################
-- Changing views

-- Can we re-arrange a column in a existing view? YES
CREATE OR REPLACE VIEW v_directors AS
SELECT
	first_name,
	last_name
FROM directors;

CREATE OR REPLACE VIEW v_directors AS
SELECT
	last_name,
	first_name
FROM directors;

-- WE CAN NOT DO IT DIRECTLY
-- FIRST WE HAVE TO DELETE VIEW AND CREATE A NEW VIEW WITH ARRANGED VIEW

--#####################################################################
-- Delete a column in a view

-- PostgreSQL does not support removing an existing column in the view.
-- The query must generate the same columns that were generated when the view was created.
-- The new columns must have the same names, same data types, and in the same order as they were created.

-- So can we add a column to a view?

-- YES AS FOLLOWING:
CREATE OR REPLACE VIEW v_directors AS
SELECT
	first_name,
	last_name,
	nationality
FROM directors;

-- A regular view
	-- Doesn't store data physically
	-- always return the updated data

--#####################################################################
-- What is an updatable view?

-- An updatable view allows us to update the data on the underlying data,
-- However, There are some rules to follow.
/*
	1. query must have one FROM entry which can be either a table or another updatable view.
	2. query can not have following at the top level:
		DISTINCT, GROUP BY, WITH

		LIMIT,  OFFSET

		UNION, INTERSECT, EXCEPT

		HAVING

	3, You cannot use the following in the selection list;
		Any Window function,
		Any set-returning function,
		Any aggregate function such as
			SUM,
			COIJNF ,
			AVG ,
			MIN,
			MAX

	4. You can use the following operations to update the data
		INSERT, UPDATE, DELETE along with a WHERE clause

	5. 	When you perform an update operations,l user must have corresponding privillege on the view, 
		but you don't need to have privilege on the underlying table!
		This will help a tot on securing the database!
*/

--#####################################################################
-- Updatable view with a CRUD operation

-- Create an updatable view for the directors table
CREATE OR REPLACE VIEW vu_directors AS
SELECT
	first_name,
	last_name
FROM directors;

-- Insert and Delete a data through a view not an underlying table
INSERT INTO vu_directors (first_name, last_name)
VALUES ('dir1', 'dirl1'), ('dir2', 'dirl2');

SELECT * FROM directors;

DELETE FROM vu_directors
WHERE first_name IN ('dir1', 'dir2');

SELECT * FROM directors;

-- Updatable views using WITH CHECK OPTION

-- WITH CHECK OPTION clause ensure that the changes to the base tables 
-- through the view satisfy the view-defining condition.
-- Its provides a good added benefits as a security measures.

CREATE TABLE countries (
	country_id SERIAL PRIMARY KEY,
	country_code VARCHAR(4),
	city_name VARCHAR(20)
);

INSERT INTO countries (country_code, city_name)
VALUES
('US', 'New York'),
('US', 'New Jersey'),
('IN', 'Mumbai'),
('IN', 'Ahmedabad'),
('UK', 'London');

SELECT * FROM countries;

-- Create a simple view called v_cities_us to list US based cities
CREATE OR REPLACE VIEW v_cities_us AS
SELECT
	country_id,
	country_code,
	city_name
FROM countries
WHERE country_code = 'US';

SELECT * FROM v_cities_us;

INSERT INTO v_cities_us (country_code, city_name)
VALUES ('US', 'California');

SELECT * FROM v_cities_us;

INSERT INTO v_cities_us (country_code, city_name)
VALUES ('UK', 'Greater Manchaster');

SELECT * FROM v_cities_us;
SELECT * FROM countries;

CREATE OR REPLACE VIEW v_cities_us AS
SELECT
	country_id,
	country_code,
	city_name
FROM countries
WHERE country_code = 'US'
WITH CHECK OPTION;

-- Doesn't run following;
INSERT INTO v_cities_us (country_code, city_name)
VALUES ('UK', 'Greater Manchaster');

-- Updatabel views using WITH LOCAL and CASCADED CHECK OPTION

-- WITH LOACL
CREATE OR REPLACE VIEW view_cities_c AS
SELECT country_id, country_code, city_name
FROM countries
WHERE city_name LIKE 'C%';

SELECT * FROM view_cities_c;


CREATE OR REPLACE VIEW view_cities_us_c AS
SELECT country_id, country_code, city_name
FROM view_cities_c
WHERE country_code = 'US'
WITH LOCAL CHECK OPTION;

INSERT INTO view_cities_us_c (country_code, city_name)
VALUES
('US','Connecticut');

SELECT * FROM view_cities_us_c;

INSERT INTO view_cities_us_c (country_code, city_name)
VALUES
('US','Los Angeles');

SELECT * FROM view_cities_us_c;

SELECT * FROM countries;


-- WITH CASCADED CHECK OPTION
CREATE OR REPLACE VIEW view_cities_us_c AS
SELECT country_id, country_code, city_name
FROM view_cities_c
WHERE country_code = 'US'
WITH CASCADED CHECK OPTION;

INSERT INTO view_cities_us_c (country_code, city_name)
VALUES
('US','Boston');

INSERT INTO view_cities_us_c (country_code, city_name)
VALUES
('US','Clear Water');

SELECT * FROM view_cities_us_c;

--#####################################################################
-- Materialized View

/*
	1. A materialized view allow you to;
			store result of a query physically and
			update the data periodically

	2. A materialized view caches the result of a complex expensive 
	   query and then allow you to refresh this result periodically.

	3. A Materialized view executes the query once and then holds onto those 
	   results for your viewing pleasure until you refresh the materialized view again.

	SYNTAX:
	CREATE MATERIALIZED VIEW IF NOT EXISTS view_name AS query
	WITH [NO] DATA;

	4. A MatView can be used like a regular table.

	5. Quick tip: You can mess up your source table, your end—user won't 
	notice it before the refresh, as they access the materialized view and not the actual table.
*/

-- Create a materialized view
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors AS
SELECT first_name, last_name
FROM directors
WITH DATA;

SELECT * FROM mv_directors;

CREATE MATERIALIZED VIEW IF NOT EXISTS mv_directors_nodata AS
SELECT first_name, last_name
FROM directors
WITH NO DATA;

SELECT * FROM mv_directors_nodata;

-- WITH NO DATA, the view is flagged as unreadable. It means that you cannot query 
-- data from the view until you load data into it.

REFRESH MATERIALIZED VIEW mv_directors_nodata;

SELECT * FROM mv_directors_nodata;

-- Drop a materialized view
-- DROP MATERIALIZED VIEW view_name;

-- Changing materialzed view data
SELECT * FROM mv_directors;

INSERT INTO mv_directors (first_name, last_name)
VALUES
('Christopher','Nolan');


INSERT INTO directors (first_name, last_name)
VALUES
('Christopher','Nolan');

SELECT * FROM mv_directors;


REFRESH MATERIALIZED VIEW mv_directors;

SELECT * FROM mv_directors;


DELETE FROM mv_directors
WHERE first_name = 'Christopher';


UPDATE mv_directors
SET first_name = 'Chris'
WHERE first_name = 'Christopher';

-- Check if a materialzed view is populated or not:

-- SYNTAX:
-- SELECT relispopulated FROM pg_class
-- WHERE relname = mat_view_name;

DROP MATERIALIZED VIEW mv_directors_nodata;
CREATE MATERIALIZED VIEW mv_directors_nodata AS
SELECT first_name, last_name
FROM directors
WITH NO DATA;

SELECT * FROM mv_directors_nodata;

SELECT relispopulated FROM pg_class
WHERE relname = 'mv_directors_nodata';

-- Refresh data in a materialized view:

-- REFRESH MATERIALIZED VIEW mt_view_name;

-- Please note when you refresh data for a materialized view, 
-- PosgreSQL LOCKS THE ENTIRE TABLE therefore you cannot query data against it.

-- How to use materialized view while refreshing it?
-- SYNTAX:
-- REFRESH MATERIALIZED VIEW CONCURRENTLY mat_view_name;
/*
	1. CONCURRENTLY allows for the update of the materialized view without locking it.
	2. With CONCURRENTLY option, PostgreSQL creates a temporary updated version of 
	the materialized view, compares two versions, and performs INSERT and UPDATE only the differences.
	3. You can query against the materialized view while it is being updated.
	## 4. One requirement for using CONCURRENTLY option is that the materialized view must have a UNIQUE index.
*/

-- Why not to use regular table instead of materialized view?

-- Using materialized views for a website page clicks analytics
CREATE TABLE page_clicks (
	rec_id SERIAL PRIMARY KEY,
	page VARCHAR(200),
	click_time TIMESTAMP,
	user_id BIGINT
);

INSERT INTO page_clicks (page, click_time, user_id)
SELECT
(
	CASE (RANDOM() * 2)::INT
		WHEN 0 THEN 'klickanalytics.com'
		WHEN 1 THEN 'clickapis.com'
		WHEN 2 THEN 'google.com'
	END
) AS page,
NOW() AS click_time,
(FLOOR(RANDOM() * (111111111 - 1000000 - 1) + 1000000))::INT AS user_id
FROM GENERATE_SERIES(1, 10000) AS "Sequence";

SELECT * FROM page_clicks;


CREATE MATERIALIZED VIEW mv_page_clicks AS
SELECT DATE_TRUNC('DAY',click_time) AS "Day",
page,
COUNT(*) AS total_clicks
FROM page_clicks
GROUP BY "Day", page;

REFRESH MATERIALIZED VIEW mv_page_clicks;

SELECT * FROM mv_page_clicks;


CREATE MATERIALIZED VIEW mv_page_clicks_daily AS
SELECT click_time AS "Day",
page,
COUNT(*) AS "Count"
FROM page_clicks
WHERE click_time >= DATE_TRUNC('DAY', NOW())
AND click_time < TIMESTAMP 'TOMORROW'
GROUP BY "Day", page;

CREATE UNIQUE INDEX idx_u_mv_page_clicks_daily_day_page ON mv_page_clicks_daily ("Day", page);

REFRESH MATERIALIZED VIEW CONCURRENTLY mv_page_clicks_daily;

SELECT * FROM mv_page_clicks_daily;

-- LIST MATERIALIZED VIEWS
SELECT oid::regclass::TEXT FROM pg_class
WHERE relkind = 'm';

-- LIST MATERIALIZED VIEWS WITH NO UNIQUE INDEX
WITH matviews_with_no_unique_keys AS (
	 SELECT c.oid, c.relname, c2.relname AS idx_name
	 FROM pg_catalog.pg_class AS c, pg_catalog.pg_class AS c2, pg_catalog.pg_index AS i
	 LEFT JOIN pg_catalog.pg_constraint AS con
	 ON (
		conrelid = i.indrelid AND conrelid = i.indexrelid AND contype IN ('p','u')
	 )
	 WHERE
	 c.relkind = 'm'
	 AND c.oid = i.indrelid
	 AND i.indexrelid = c2.oid
	 AND indisunique
)
SELECT c.relname AS materiliazed_view_name
FROM pg_class AS c
WHERE c.relkind = 'm'
EXCEPT
SELECT mwk.relname
FROM matviews_with_no_unique_keys AS mwk;


-- QUICK QUERIES FOR MATERIALIZED VIEWS

-- WHETHER MATERIALIZED VIEW EXISTS
-- SELECT
-- 	COUNT(*) > 0
-- FROM
-- 	PG_CATALOG.PG_CLASS AS C
-- 	JOIN PG_NAMESPACE AS N ON N.OID = C.RELNAMESPACE
-- WHERE
-- 	C.RELKIND = 'm'
-- 	AND N.NSPNAME = 'some_schema'
-- 	AND C.RELNAME = 'some_mat_view';


SELECT view_definition FROM information_schema.views
WHERE table_schema = 'information_schema'
AND table_name = 'views';

-- 	LIST MATERIALIZED VIEWS
SELECT * FROM pg_matviews;


SELECT * FROM pg_matviews 
WHERE matviewname = 'view_name';