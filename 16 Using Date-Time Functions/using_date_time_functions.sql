-- DATE/TIME/TIMESTAMP DataTypes

-- 1. OverView

-- DATE - Stores Date Only - YYYY-MM-DD

-- TIME - Stores Time Only - HH:MM:SS
-- 		- With Time Zone
-- 		- With Out Time Zone

-- TIMESTAMP - Stores Date and Time Both - YYYY-MM-DD HH:MM:SS

--#####################################################################

-- 2. System Month-Date Settings

-- To see current setting for date style

SHOW DateStyle;

-- To change date style
-- SET DateStyle = 'type, format'

-- type => ISO, Postgres, SQL, German
-- format => MDY, DMY, YMD

--#####################################################################

-- 3. Time of day formats and inputs

-- TIme Format
-- HH:MM
-- 01:10 AM
-- 06:11 PM
-- 06:10:01
-- 06:10:01.786

-- Time Stamp Format
-- date time
-- date time timezone

-- Date/Time Input Formats
-- allballs time
-- now() date,time,timestamp
-- today date,timestamp
-- tomorrow
-- yesterday
-- epoch
-- infinity
-- -infinity

--#####################################################################

-- 4. Strings to Date conversion

-- TO_DATE(string, format)
-- Used to convert valid formated sring to a date

SELECT 
	TO_DATE('2024-06-26', 'YYYY-MM-DD'),
	TO_DATE('Jan 12, 2025', 'mon DD, YYYY');

SELECT TO_DATE('01-01-202', 'YYYY-MM-DD'); 

SELECT 
	TO_DATE('26th Jul, 2024', 'DDth Mon, YYYY'),
	TO_DATE('1st Jan, 2025', 'DDth Mon, YYYY');

-- TO_TIMESTAMP(string, format)
-- Used to convert valid formated string to a timestamp

SELECT
	TO_TIMESTAMP('2025-02-07 15:27:23', 'YYYY-MM-DD HH24:MI:SS'),
	TO_TIMESTAMP('2025-02-07 15:27:23.111', 'YYYY-MM-DD HH24:MI:SS.p');

--#####################################################################

-- 5. Formatting Dates

-- TO_CHAR(data_type_value, format)
-- Converts various datatype value to strings

SELECT CURRENT_TIMESTAMP;

SELECT
	CURRENT_TIMESTAMP,
	TO_CHAR('2025-06-11 10:00:00'::TIMESTAMP, 'YYYY Month DD'),
	TO_CHAR('2025-06-11 10:00:00+05:30'::TIMESTAMPTZ, 'YYYY Month, DD HH:MM:SS TZ');

SELECT
	movie_name,
	TO_CHAR(release_date, 'YYYY FMMonth, DDth')
FROM movies
ORDER BY release_date;

--#####################################################################

-- 6. Date Construction Functins

-- MAKE_DATE(YYYY,MM,DD)

SELECT MAKE_DATE(2025, 2, 7);

-- MAKE_TIME(HH,MM,SS)
-- WithOut Time ZOne
SELECT MAKE_TIME(16, 04, 29);

-- MAKE_TIMESTAMP(YYYY, MM, DD, HH, MI, SS)
SELECT MAKE_TIMESTAMP(2025, 02, 07, 16, 04, 29);

-- MAKE_INTERVAL(years, months, weeks, days, hours, minutes, seconds)

SELECT MAKE_INTERVAL(2024, 02, 01, 07, 16, 04, 29);

SELECT
	MAKE_INTERVAL(2024, 01, 01, 07, 16, 04, 29),
	MAKE_INTERVAL(2024, 01, 02, 07, 16, 04, 29),
	MAKE_INTERVAL(2024, 01, 03, 07, 16, 04, 29),
	MAKE_INTERVAL(2024, 01, 04, 07, 16, 04, 29),
	MAKE_INTERVAL(2024, 01, 05, 07, 16, 04, 29);

-- We can also use named notations
SELECT MAKE_INTERVAL(days => 5);

-- MAKE_TIMESTAMPTZ(YYYY,MM,DD,HH,MI,SS,TZ)

SELECT
	MAKE_TIMESTAMPTZ(2023,09,09,10,09,09.98,'America/New_York');

SELECT pg_typeof(MAKE_TIMESTAMPTZ(2023,09,09,10,09,09.98,'America/New_York'));

SELECT * FROM pg_timezone_names;
SELECT * FROM pg_timezone_abbrevs;

--#####################################################################

-- 7. Date Value Extractor Functions

-- EXTRACT(field form source)
-- DATE_PART(field, source)

SELECT EXTRACT('DAY' FROM CURRENT_TIMESTAMP);

-- EPOCH -> No. of seconds since 1970-01-01 00:00:00 UTC
SELECT 
	EXTRACT('DAY' FROM CURRENT_TIMESTAMP),
	EXTRACT('MONTH' FROM CURRENT_TIMESTAMP),
	EXTRACT('YEAR' FROM CURRENT_TIMESTAMP),
	EXTRACT('EPOCH' FROM CURRENT_TIMESTAMP);

SELECT
	EXTRACT('CENTURY' FROM INTERVAL '500 YEARS 2 MONTHS 11 DAYS');

-- DATE_PART(field, source);
	
SELECT 	
	DATE_PART('century', CURRENT_TIMESTAMP) AS century,
	DATE_PART('year', CURRENT_TIMESTAMP) as year,
	DATE_PART('day', CURRENT_TIMESTAMP) as day,
	DATE_PART('hour', CURRENT_TIMESTAMP) as hour,
	DATE_PART('week', CURRENT_TIMESTAMP) as week;

--#####################################################################

-- 8. Using math operations with dates

SELECT DATE '20200101' + 10;
SELECT TIME '23:59:59' + INTERVAL '1 SECOND';

SELECT 
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP + '01:01:01';

SELECT 
	DATE '20200101' +  TIME '01:01:01';

SELECT
	'10:10:01' + TIME '01:01:11';

SELECT INTERVAL '02:00' / 2 AS "1 hour";

--#####################################################################

-- 9. OVERLAPS operator

SELECT
	(DATE '2020-01-01', DATE '2020-12-31') 
	OVERLAPS 
	(DATE '2020-10-12', DATE '2020-12-01');

--#####################################################################

-- 10. Date/Time Functions

SELECT 
	CURRENT_DATE;

SELECT 
	CURRENT_DATE,
	CURRENT_TIME;

SELECT
	CURRENT_DATE,
	CURRENT_TIME,
	CURRENT_TIMESTAMP;
	
SELECT 
	NOW(),
	LOCALTIME,
	LOCALTIMESTAMP;


--#####################################################################

-- 11. PostgresSQL DATE/TIME Functions

SELECT
	NOW(),
	TRANSACTION_TIMESTAMP(),
	STATEMENT_TIMESTAMP(), -- TIMESTAMP of statement execution
	CLOCK_TIMESTAMP(); -- SHOW current date and time (changes during statement execution)

SELECT TIMEOFDAY(); -- Returns same thing as CLOCK_TIMESTAMP but as a string

--#####################################################################

-- 12.AGE Function

-- AGE(date1 - date2)
-- returns number of years, months and days b/w two days

SELECT AGE(DATE '2015-03-31', DATE '2012-12-12');

SELECT AGE(DATE '2012-12-12');

--#####################################################################

-- 13. CURRENT_TIME and CURRENT_DATE

--#####################################################################

-- 14. Date accuracy with EPOC

-- Arithmatic with dates are sometimes complex, Consider foloowing for accuracy,
-- 1. Timezones
-- 2. Daylight saving times

-- AGE can be used for above but it's not accurarte, we can use EPOCH for that

SELECT
	AGE(TIMESTAMP '2025-02-10', TIMESTAMP '2025-01-06'),
	EXTRACT('EPOCH' FROM TIMESTAMPTZ '2025-02-10') -
	EXTRACT('EPOCH' FROM TIMESTAMPTZ '2025-01-06')
	AS "Difference in Seconds";

SELECT
	(EXTRACT('EPOCH' FROM TIMESTAMPTZ '2025-02-10') -
	EXTRACT('EPOCH' FROM TIMESTAMPTZ '2025-01-06'))
	/60/60/24
	AS "Difference in days";
	
SELECT
	(EXTRACT('EPOCH' FROM TIMESTAMPTZ '2025-02-10') -
	EXTRACT('EPOCH' FROM TIMESTAMPTZ '2025-01-06'))
	/60/60/24
	AS "EPOCH",

	AGE(TIMESTAMP '2025-02-10', TIMESTAMP '2025-01-06') AS "AGE",

	TIMESTAMP '2025-02-10' - TIMESTAMP '2025-01-06' AS "TIMESTAMPTZ";

--#####################################################################

-- 15. Using time, date and timestamp in table

DROP TABLE IF EXISTS table_times;
CREATE TABLE table_times (
	time_id SERIAL PRIMARY KEY,
	start_time TIME,
	start_date DATE,
	start_timestamp TIMESTAMP
);

SELECT * FROM table_times;

INSERT INTO table_times(start_date, start_time, start_timestamp)
VALUES 
('epoch', 'allballs', 'infinity');

--#####################################################################

-- 16. View and Set timezones

SELECT * FROM pg_timezone_names;
SELECT * FROM pg_timezone_abbrevs;

SHOW TIME ZONE;

SET TIME ZONE 'US/Alaska';

SELECT CURRENT_TIMESTAMP;

SET TIME ZONE 'Asia/Calcutta';

--#####################################################################

-- 17. Handle timezones

-- Always use date and time when using timestamp
-- Try avoiding numeric offsetst with timezones

ALTER TABLE table_times
ADD COLUMN end_timestamp TIMESTAMP WITH TIME ZONE;

ALTER TABLE table_times
ADD COLUMN end_time TIME WITH TIME ZONE;

SELECT * FROM table_times;

INSERT INTO table_times (end_timestamp, end_time)
VALUES
('2020-01-20 11:20:00 US/Pacific', '11:20:00+6');

-- NOTE: In table o/p is always according to a timezone of server
-- So consider timestamp with timezone always for better and easy execution and less cpmplexity

--#####################################################################

-- 18. date_trunc() Function

-- To truncate a timestamo or interval to a specified level of precision

-- SYNTAX:
-- date_trunc('datepart', field)

SELECT
	DATE_TRUNC('year', CURRENT_TIMESTAMP) "Year",
	DATE_TRUNC('hour', CURRENT_TIMESTAMP) "Hour",
	DATE_TRUNC('second', CURRENT_TIMESTAMP) "Seconds";

-- Count the number of movies by release month

SELECT
	DATE_TRUNC('month', release_date) "release_month",
	COUNT(movie_id)
FROM movies
GROUP BY "release_month"
ORDER BY 2 DESC;
