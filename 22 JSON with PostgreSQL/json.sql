-- JSON With PostgreSQL

--#####################################################################
-- What is json?

-- JSON stands for "JavaScript Object Noti fication" which is a type Of data format 
-- popularly used by web applications.
-- JSON was introduced as an alternative to the XML format. In the "good old days" 
-- the data used to get transmitted in XML format which is a heavy weight data type compared to JSON.
-- JSON is a lightweight format for storing and transporting data.
-- JSON is a syntax for storing and exchanging data.
-- JSON is "self-describing" and easy to understand. It is human readable.

-- JSON is Often used to serialize and transfer data over a network connection, for example between the web server and
-- a web application. In computer science, serialization a process to transforming data Structures and objects in a
-- format suitable to be Stored in a file or memory buffer or transmitted over a network connection. Later on, this data
-- can be retrieved. Because Of the very nature Of the JSON, •it is useful for storing or representing semi structured
-- data.

--#####################################################################
-- JSON Syntax:

-- Name/Value pairs
-- EX:
-- "name":"Karan"
-- "age":21

-- Whole JSON object:
-- {"name":"Karan", "age":21, "city":"Surat"}

-- JSON arrays:
-- "contacts": [
-- 	{"name":"Karan", "age":21, "city":"Surat"},
-- 	{"name":"DD", "age":20, "city":"Anand"},
-- 	{"name":"AS", "age":23, "city":"Patan"}
-- ]

-- Both arrays and json can be nested

--#####################################################################
-- JSON in POstgreSQL

-- POstgreSQL supports native json support since version 9.2

-- We can store json data in two ways in PostgreSQL:
-- a. JSON
-- b. JSONB

--#####################################################################
-- Exploring json objects:

-- Representataion of JSON objects in PostgreSQL:
SELECT '{"text": "The lord of the rings"}';

-- Casting to json / josnb
SELECT 
	'{"text": "The lord of the rings"}'::JSON,
	'{"text": "The lord of the rings"}'::JSONB;

--#####################################################################
-- JSONB objects in tables

CREATE TABLE books (
	book_id SERIAL PRIMARY KEY,
	book_info JSONB
);

SELECT * FROM books;

INSERT INTO books (book_info)
VALUES
('{
	"title": "title1",
	"author": "author1"
}');

INSERT INTO books (book_info)
VALUES
('{
	"title": "title2",
	"author": "author2"
}'),
('{
	"title": "Atomic Habits",
	"author": "James Clear"
}');

-- -> returns JSON object as a field in quotes
SELECT
	book_info -> 'title' "Book Title"
FROM books;

-- ->> returns JSON object field as TEXT
SELECT
	book_info ->> 'title' "Book Title"
FROM books;

-- Filter records
SELECT
	book_info -> 'title' "Book Title"
FROM books
WHERE 
	book_info ->> 'author' = 'James Clear';
	
SELECT
	book_info ->> 'title' "Book Title"
FROM books
WHERE 
	book_info -> 'author' = '"James Clear"';

--#####################################################################
-- Update and Delete JSON data

INSERT INTO books (book_info)
VALUES
('{
	"title": "Harry Potter",
	"author": "J. K. Rolling"
}');

SELECT * FROM books;

-- updating json objects/fields
-- Operator used: ||
-- It allows to
-- 		a. add field
-- 		b. replace existing field

-- Update author2 with Karan
UPDATE books
SET book_info = book_info || '{"author": "Karan"}'
WHERE book_info ->> 'author' = 'author2';

SELECT * FROM books;

-- Add a new field named best_seller
UPDATE books
SET book_info = book_info || '{"best_seller": true}'
WHERE book_info ->> 'author' = 'Karan'
RETURNING *;

SELECT * FROM books;

-- Add multiple key/value pair
UPDATE books
SET book_info = book_info || '
{
	"category": "mystrey, drama",
	"pages": "350"
}'
WHERE book_info ->> 'author' = 'Karan'
RETURNING *;

-- delete best_seller key_value pair
UPDATE books
SET book_info = book_info - 'best_seller'
WHERE book_info ->> 'author' = 'Karan'
RETURNING *;

SELECT * FROM books;

-- Add a json array in json data
UPDATE books
SET book_info = book_info || '
{
	"available_locations": [
		"New York",
		"New Jersey"
	] 
}'
WHERE book_info ->> 'author' = 'Karan'
RETURNING *;

-- Delete values from arrays via path '#-'
UPDATE books
SET book_info = book_info #- '{available_locations, 1}'
WHERE book_info ->> 'author' = 'Karan'
RETURNING *;

--#####################################################################
-- Create json objects from a table:

SELECT 
	ROW_TO_JSON(directors) 
FROM directors;

-- Get only first_name, last_name and nationality from directors in json
SELECT ROW_TO_JSON(t) FROM
(
	SELECT
		director_id,
		first_name,
		last_name,
		nationality
	FROM directors
) t;

--#####################################################################
-- Aggregate data using json_agg()

-- List movies for each director
SELECT
	*
FROM directors d
JOIN movies m USING(director_id)
ORDER BY director_id;

-- Do following
SELECT
	director_id "Director Id",
	first_name || ' ' || last_name "Full Name",
	date_of_birth "DoB",
	nationality "Nationality",
	(
		SELECT json_agg(x) AS "All Movies" FROM
		(
			SELECT
				movie_name
			FROM movies
			WHERE director_id = directors.director_id
		) AS x
	)
FROM directors;

--#####################################################################
-- Build json array using json_bild_array(values)

SELECT
	JSON_BUILD_ARRAY(1,2,3,4,5),
	JSON_BUILD_ARRAY(1,2,3,4,5,'Hi','sssj');

-- json_build_object(values in key/value)
SELECT
	JSON_BUILD_OBJECT(1,2,3,4,5,6,7,'Hi');

-- json_object({keys}, {values})
SELECT
	JSON_OBJECT('{name, email, city, age}', '{Karan, kj123@gmail.com, Surat, 21}');

--#####################################################################
-- Create documents from data

CREATE TABLE directors_docs (
	doc_id SERIAL PRIMARY KEY,
	body JSONB
);

SELECT * FROM directors_docs;

-- Get all movies by each directors in JSON array and convert all data to json
-- and insert into a directors_docs table

INSERT INTO directors_docs (body)
SELECT ROW_TO_JSON(a)::JSONB FROM
(
	SELECT
		director_id "Director Id",
		first_name || ' ' || last_name "Director Name",
		date_of_birth "DoB",
		nationality "Nationality",
		(
			SELECT
				JSON_AGG(x) "All Movies"
			FROM
			(
				SELECT 
					movie_name
				FROM movies
				WHERE 
					director_id = directors.director_id
			) AS x
		)
	FROM directors
)AS a;

SELECT * FROM directors_docs;

--#####################################################################
-- NULL values in JSON doocument

DELETE FROM directors_docs;

INSERT INTO directors_docs (body)
SELECT ROW_TO_JSON(a)::JSONB FROM
(
	SELECT
		director_id "Director Id",
		first_name || ' ' || last_name "Director Name",
		date_of_birth "DoB",
		nationality "Nationality",
		(
			SELECT
				CASE COUNT(x) WHEN 0 THEN '[]' ELSE JSON_AGG(x) END "All Movies"
			FROM
			(
				SELECT 
					movie_name
				FROM movies
				WHERE 
					director_id = directors.director_id
			) AS x
		)
	FROM directors
)AS a;

SELECT * FROM directors_docs;

SELECT
	JSONB_ARRAY_ELEMENTS(BODY -> 'All Movies') FROM DIRECTORS_DOCS;

--#####################################################################
-- JSON nulls vs SQL nulls

--#####################################################################
-- Getting information from JSON documents

SELECT * FROM directors_docs;

-- Count total movies for each director
SELECT	
	body->'Director Name',
	JSONB_ARRAY_LENGTH(body -> 'All Movies') AS "Total Movies" 
FROM directors_docs
ORDER BY 2 DESC;

-- List all the keys within each json row
SELECT
	jsonb_object_keys(body)
FROM directors_docs;

SELECT 
	jsonb_each(body)
FROM directors_docs;

SELECT
	j.key,
	j.value
FROM directors_docs, jsonb_each(directors_docs.body) j;

-- Turning json document to a table
-- jsonb_to_record
SELECT * FROM directors_docs;

SELECT
	j.*
FROM directors_docs, jsonb_to_record(directors_docs.body) j (
	"Director Id" INT,
	"Director Name" VARCHAR(255),
	"DoB" DATE,
	"Nationality" VARCHAR(255)
);

--#####################################################################
-- Existance operator '?'.

-- Find all first name equal to 'John'
SELECT
	*
FROM 
	directors_docs
WHERE
	body -> 'Director Name' ? 'Terry Jones';

-- find all records within director id = 1 
SELECT
	*
FROM 
	directors_docs
WHERE
	body -> 'Director Id' ? '1';
-- returns empty table data
-- because ? expect both side values as text
-- Solution : containment operator

--#####################################################################
-- The Containment Operator '@>'

SELECT
	*
FROM directors_docs
WHERE body @> '{"Director Name":"Terry Jones"}';

SELECT
	*
FROM directors_docs
WHERE body @> '{"Director Id":1}';

-- Find record for the movie name 'Toy Story'
SELECT
	*
FROM directors_docs
WHERE body @> '{"All Movies":[{"movie_name":"Toy Story"}]}';

SELECT
	*
FROM directors_docs
WHERE body -> 'All Movies' @> '[{"movie_name":"Toy Story"}]';

--#####################################################################
-- Mix and Match JOSN Search

-- We can use PostgreSQL functions with JSON document

-- Find the all records where name starts with 'J'
SELECT
	*
FROM 
	directors_docs
WHERE
	body ->> 'Director Name' LIKE 'J%';

-- Find records where director_id > 2
SELECT
	*
FROM 
	directors_docs
WHERE
	(body ->> 'Director Id')::INT > 2;

--#####################################################################
-- Indexing on JSONB data type:

SELECT * FROM contacts_docs;

-- Get all records where first name is 'John'
SELECT 
	*
FROM 
	contacts_docs
WHERE body @> '{"first_name":"John"}';

EXPLAIN ANALYZE SELECT 
	*
FROM 
	contacts_docs
WHERE body @> '{"first_name":"John"}';

-- Query execution time? Avg 10ms

-- How data was searched? Is there any index?

-- Can we reduce this time?
-- Yes, Via GIN index

-- GIN -> Generalized Inverted Index
-- Core functionality is to speed up full text searches

-- Create a GIN index
CREATE INDEX idx_gin_contacts_docs_body ON contacts_docs USING GIN(body);

EXPLAIN ANALYZE SELECT 
	*
FROM 
	contacts_docs
WHERE body @> '{"first_name":"John"}';

-- Query execution time? Avg 0.5ms

-- Check size of index:
SELECT
	pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body'::regclass)) as index_name;

-- Challenges wity GIN index:
-- Depending on the complexity Of the data, maintaining GIN Indexes can be expensive.
-- Creation Of GIN Index consumes time and resources as the Index has to search through the whole document
-- to find the Keys and their row IDS.
-- It can be even more challenging if the GIN index is bloated.
-- Also, the size Of the GIN index can be very big based on the data size and complexity.

-- Is there better index?

CREATE INDEX idx_gin_contacts_docs_body_cool ON contacts_docs USING GIN(body jsonb_path_ops);

SELECT
	pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body_cool'::regclass)) as index_name;

-- can we create a index on specific josn key? YES