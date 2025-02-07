-- STRING FUNCTIONS

-- 1. UPPER, LOWER and INITCAP functions

-- UPPER(string) => Converts a string into a uppercase letters
-- LOWER(string) => Converts a string into a lowercase letters
-- INITCAP(string) => Converts a string into a title case letters

SELECT UPPER('Some Random Text');
SELECT LOWER('SoME RANDOm TeXT');
SELECT INITCAP('SOME RANDOM TEXT');

-- EX:
SELECT
	INITCAP(
		CONCAT(first_name, ' ', last_name)
	) AS "Full Name"
FROM 
	directors
ORDER BY
	first_name;

-- 2. LEFT and RIGHT functions

-- LEFT(string, n) => Returns first n chars from a string 
-- LEFT(string, -n) => Returns every chars except last n chars 
-- RIGHT(string, n) => Returns last n chars from a string
-- LEFT(string, -n) => Returns every chars except first n chars 

SELECT LEFT('This is some random text for test', 8);
SELECT LEFT('This is some random text for test', -3);

SELECT RIGHT('This is some random text for test', 8);
SELECT RIGHT('This is some random text for test', -3);

SELECT 
	LEFT(first_name, 1) AS "Initials"
FROM directors;

SELECT LEFT(NULL, 1);

-- 3. REVERSE function

-- REVERSE(string) => Retrurns reverse of a string

SELECT REVERSE('NARAK');

-- 4. SPLIT_PART function

-- SPLIT_PART(strinig, delimeter, position)
-- Splits string on a specified delimeter and returns the nth substr

SELECT SPLIT_PART('1,2,3,4,5', ',', 3);
SELECT SPLIT_PART('1,2,3,4,5', ',', -1);
SELECT SPLIT_PART('1,2,3,4,5', ',', -2);
SELECT SPLIT_PART('1,2,3,4,5', ',', 7);

-- EX: Get release year for all movies
-- Form till learning 2 ways
-- 1. LEFT|RIGHT functions
-- 2. SPLIT_PART fucntion

SELECT 
	movie_name,
	SPLIT_PART(release_date::TEXT, '-', 1) AS release_year
FROM movies
ORDER BY release_date;

SELECT 
	movie_name,
	LEFT(release_date::TEXT, 4) AS release_year
FROM movies
ORDER BY release_date;

-- 5. TRIM, LTRIM, BTRIM and RTRIM functions

-- TRIM => Removes the longest string of a specific char from a string
-- LTRIM => Removes all chars, default spapces, from begining of a string
-- RTRIM => Removes all chars, default spapces, from ending of a string
-- BTRIM => Combination of LTRIM and RTRIM

TRIM([LEADING | TRAILING | BOTH] [chars] FROM string)

LTRIM(string, [char]);
RTRIM(string, [char]);
BTRIM(string, [char]);

SELECT TRIM(BOTH FROM '    Some Random   Text     '); --"Some Random   Text"
SELECT LTRIM('    Some Random   Text     '); --"Some Random   Text     "
SELECT RTRIM('    Some Random   Text     '); --"    Some Random   Text"
SELECT BTRIM('    Some Random   Text     '); --"Some Random   Text"

SELECT 
	TRIM(LEADING '0' FROM 000123450000::TEXT), --"123450000"
	TRIM(TRAILING '0' FROM 000123450000::TEXT), --"12345"
	TRIM(BOTH '0' FROM 000123450000::TEXT); --"12345"
	
SELECT 
	LTRIM(000123450000::TEXT, '0'), --"123450000"
	RTRIM(000123450000::TEXT, '0'), --""12345""
	BTRIM(000123450000::TEXT, '0'); --"12345"

-- 6. LAPD and RAPD functions

-- LPAD => Pads a string on the left to a specified length with a seq of chars
-- RPAD => Pads a string on the right to a specified length with a seq of chars

LPAD(string, length[, fill])
RPAD(string, length[, fill])

SELECT 
	LPAD('EXAMPLE', 15, '*'),
	RPAD('EXAMPLE', 15, '*');

SELECT 
	LPAD('EXAMPLE', 15), --"        EXAMPLE"
	RPAD('EXAMPLE', 15); --"EXAMPLE        "

-- 7. LENGTH function

-- LENGTH(string) => Returns a length of a string char or a bytes of memory occupied by a string

SELECT LENGTH('Some Random TEXT');

SELECT
	LENGTH(' '),
	LENGTH(''),
	LENGTH(NULL);

SELECT
	CHAR_LENGTH(' '),
	CHAR_LENGTH(''),
	CHAR_LENGTH(NULL);

-- 8. POSITION function

-- POSITION(substr in string) 
-- Returns a position of substr in a string
-- Searches for a substr case-sensitively and returns first instsance of an occurence 

SELECT POSITION('ARA' IN 'KARAN');
SELECT POSITION('ara' IN 'KARAN');

-- 9. STRPOS function

-- STRPOS(<str>, <substr>) 
-- function is used to find the position, from where the substring is being matched within the string.

SELECT strpos('World Bank', 'Bank');

SELECT
	first_name,
	last_name
FROM 
	directors
WHERE
	STRPOS(last_name, 'on') > 0;

-- NOTE: SRPOS and POSITION are differ only in SYNTAX

-- 10. SUBSTRING function

-- SUBSTRING(stirng from start_postion for length);
-- SUBSTRING(stirng, start_postion, length);
-- Extracts substring from a string

SELECT
	SUBSTRING('WORLD BANK' from 3 for 5),
	SUBSTRING('WORLD BANK' for 8);

SELECT SUBSTRING('WORLD BANK' from -1 for 7);

SELECT
	SUBSTRING('WORLD BANK',3, 5),
	SUBSTRING('WORLD BANK', 8),
	SUBSTRING('WORLD BANK', -1, 7);
	
-- 11. REPEAT function

-- REPEAT(string, number)

SELECT REPEAT('ABC', 3);

-- 12. REPLACE function 

-- REPLACE(str, from_substr, to_substr)

SELECT REPLACE('ABC XYZ', 'XY', 'sdha');
SELECT REPLACE('It''s a wondorful scene', 'a wonderful', 'an amazing');

SELECT REPLACE('ABC', 'abc', 'sdaj');