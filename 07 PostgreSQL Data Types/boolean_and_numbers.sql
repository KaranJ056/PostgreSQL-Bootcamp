/* PostgreSQL DATA TYPES */

-- 1. BOOLEAN DATA TYPE

-- Single Boolean Data Type:
-- 1. TRUE
-- 2. FALSE
-- 3. NULL

-- Create table table_boolean
CREATE TABLE IF NOT EXISTS table_boolean (
	product_id SERIAL PRIMARY KEY,
	is_available BOOLEAN NOT NULL
);

-- Insert data into a table
INSERT INTO table_boolean (is_available)
VALUES (TRUE);

INSERT INTO table_boolean (is_available)
VALUES (FALSE);

-- See the records
SELECT * FROM table_boolean;

-- we can use following for boolean values in PostgreSQL
-- TRUE    FALSE
-- TRUE    FALSE
-- 'true'	'false'
-- 't'	    'f'
-- 'y'     'n'
-- 'yes'   'no'
-- '1'     '0'

-- To set default value for booleans
ALTER TABLE table_boolean
ALTER COLUMN is_available
SET DEFAULT FALSE;

--##################################################################

-- 2. Charecter Data Type

-- Generally suitable for,
-- text, numbers, symbols

-- 3 main types of char data type
-- CHARECTER(n), CHAR(n) => fixed length, blank padded
-- CHARECTYR VARYING(n), VARCHAR (n) => variable length with length limit
-- TEXT, VARCHAR => variable unlimited length

-- n is value of chars variable holds, default is 1

-- CHARACTER(n), CHAR(n)
------------------------

SELECT CAST('Karan' AS CHAR(10)) as "Name"; 
SELECT 'Karan'::CHAR(10) as "Name"; 



-- CHARACTER VARYING(n), VARCHAR(n)
-----------------------------------

SELECT 'Karan'::VARCHAR(10) AS "Name";


-- TEXT, VARCHAR
----------------

-- Max size => 1GB

--##################################################################

-- 3. NUMERIC DATA TYPE

-- Used to hold numbers, but not nulls
-- Maths operations can be performed on this type of data
-- Main 2 data types:
-- 1. Integers => Mpost common
-- 2. Fixed-point, Floating-point numbers

-- Integers
-- smallint
-- int
-- bigint

-- Autoincrement : SERIAL
-- samllSERIAL
-- SERIAL
-- bigSERIAL

--#####################################################################

-- DECIMAL numbers

-- Represents whole number + fraction of whol;e number

-- Fixed point numbers
----------------------
--	NUMERIC(precision, scale)
--  DECIMAL(precision, scale)

-- Fixed point numbers
----------------------
--	real => precision 6 deciamal places
--  double => precision 15 decimal places

CREATE TABLE table_numbers (
	col_numeric numeric(18, 5),
	col_real real,
	col_double double precision
);

SELECT * FROM table_numbers;

INSERT INTO table_numbers (col_numeric, col_real, col_double)
VALUES
(.9, .9, .9),
(2.12412, 2.124123, 2.124123),
(8.518231832971823123, 8.518231832971823123, 8.518231832971823123);

-- Selecting numbers data type
-- 1. Use int whereever possible
-- 2. When Decimal data needs to be exact use numeric or decimal
-- 	  Float will save space but lacks exactness
-- 3. Choose big enough data type for our data