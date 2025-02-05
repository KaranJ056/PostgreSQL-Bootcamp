-- Conversion Functions
-- 1. to_char()
-- 2. to_number()
-- 3. to_date
-- 4. to_timestamp()

--#####################################################################

-- #1. to_char()
/*
	# PostgreSQL TO_CHAR() function converts
	- a timestamp,
	- an interval,
	- an integer,
	- a double precision, or
	- a numeric value
	
	to a string.
	
	# TO_CHAR (expression, format)

	# return will be a TEXT data type
*/

SELECT 
	TO_CHAR(18321, '9,999999'),
	TO_CHAR(1.8321, '9.999999'),
	TO_CHAR(18321, '9,999999'),
	TO_CHAR(18321, '9.99');

SELECT 
	release_date,
	TO_CHAR(release_date, 'DD-MM-YYYY'),
	TO_CHAR(release_date, 'Dy-MM-YYYY')
FROM movies;

SELECT 
	TO_CHAR(TIMESTAMP '2024-06-26 18:30:00', 'HH24:MI:SS');

SELECT 
	movie_id,
	revenues_domestic,
	To_CHAR(revenues_domestic, '$99999D99')
FROM movies_revenues;


--#####################################################################

-- #2. to_number()
/*
	1.PostgreSQL TO_NUMBER() function converts a character string to a numeric 
	  value.

	2. TO_NUMBER(string, fromat)
*/

SELECT TO_NUMBER('12412.234', '99999.');

SELECT TO_NUMBER('$1,420.24', 'L9G999D99');

--#####################################################################

-- #3. to_date()
/*
	1. PostgreSQL TO_DATE() function that helps you convert a string to a date.
	2. TO_DATE(text , format)
*/

SELECT TO_DATE('2025/02/05', 'YYYY/MM/DD');

SELECT TO_DATE('June 26, 2024', 'Month DD, YYYY');

--#####################################################################

-- #4. to_timestamp()
/*
	1.PostgreSQL TO_TIMESTAMP() function to convert a string to a timestamp based on a specified format
	2. TO_TIMESTAMP(timestamp, FORMAT)
*/

SELECT TO_TIMESTAMP('2025-06-26 09:30:00', 'YYYY-MM-DD HH:MI:SS');