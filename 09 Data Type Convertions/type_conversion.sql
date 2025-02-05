-- Data Type Conversions

-- Conversion of data from its original data type to another data type
-- 2 Types
-- 1. Implicit
-- 2. Explicit

-- integer = integer
SELECT * FROM movies
WHERE movie_id < 6;

-- integer = stirng
SELECT * FROM movies
WHERE movie_id < '6'; -- Implicit conversion

-- Explicit conversion
SELECT * FROM movies
WHERE movie_id < '6'::integer;

SELECT * FROM movies
WHERE movie_id < integer '6';

--###############################################################

-- Using CAST function for data type
-- SYNTAX:
-- CAST(exprssion AS target_data_type)

-- 1. String to Int conversion
SELECT 
	CAST('10' AS INT);

SELECT 
	CAST('10n' AS INT);

-- 2. String to date conversion
SELECT 
	CAST('2025-01-14' AS DATE),
	CAST('26-JUNE-2024' AS DATE);

-- 3. String to BOOLEAN
SELECT
	CAST('true' AS BOOLEAN),
	CAST('f' AS BOOLEAN),
	CAST('no' AS BOOLEAN),
	CAST('y' AS BOOLEAN);

-- 4. String to double
SELECT
	CAST('12.12341' AS double precision),
	CAST('1.1231231' AS double precision);

-- We can also use following
-- expression::type

-- 5. String to interval
SELECT
	'10 minutes'::INTERVAL,
	'4 days'::INTERVAL;

--#####################################################################

-- Iplicit to explicit conversion

-- cast with round
SELECT ROUND(10, 4) AS "Result";
SELECT ROUND(CAST(10 AS NUMERIC), 4) AS "Result";

-- cast with text
SELECT SUBSTR('123456', 2) AS "result";
SELECT
	SUBSTR('123456', 4) AS "Implicit",
	SUBSTR(CAST('123456' AS TEXT), 4) AS "explicit";

--#####################################################################

-- TABLE DATA CONVERSION

CREATE TABLE ratings (
	rating_id SERIAL PRIMARY KEY,
	rating VARCHAR(1) NOT NULL
);

SELECT * FROM ratings;

INSERT INTO ratings (rating)
VALUES
('A'), ('B'), ('C');

INSERT INTO ratings (rating)
VALUES
(1), (2), (3);

-- Convert A, B and C ratings into an integer
SELECT 
	rating_id,
	CASE
		WHEN rating~E'^\\d+$' THEN
			CAST(rating as INTEGER)
		ELSE 
			0
	END AS rating
FROM ratings;