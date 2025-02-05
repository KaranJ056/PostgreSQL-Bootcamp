-- DATE / TIME Data type

-- 1. Assigned to variable that needs to store inly time value
/*
					Stores						Low Value
	TIME			time only					   ||
	TIMESTAMP		date and time				   ||
	TIMESTAMPTZ		date, time and timestamp	   ||

	INTERVAL		store values
*/

-- DATE data type

-- stores date value in 4 bytes
-- default format YYYY-MM-DD
-- CURRENT_DATE gives/stores current date

CREATE TABLE table_dates (
	id SERIAL PRIMARY KEY,
	emp_name VARCHAR(50),
	hire_date DATE,
	add_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO table_dates (emp_name, hire_date)
VALUES
('Karan', '2025-01-06'),
('SK', '2025-02-04'),
('HS', '2024-12-16');

SELECT * FROM table_dates;

-- Select current date
SELECT CURRENT_DATE;

-- Select current date and time
SELECT NOW();

--#################################################################

-- TIME Data Type

-- stores time of day in 8 bytes of memory
-- col_name TIME(precision)
-- precision => no. of fractional digits placed in the second field, upto 6 digits
-- Common formats
-- HH:MM
-- HH:MM:SS
-- HHMMSS
-- HH:SS.pppppp
-- HH:MM:SS.pppppp
-- HHMMSS.pppppp

CREATE TABLE table_times (
	id SERIAL PRIMARY KEY,
	cls_name VARCHAR(20) NOT NULL,
	start_time TIME NOT NULL,
	end_time TIME NOT NULL,
	add_time TIME DEFAULT NOW()
);

INSERT INTO table_times (cls_name, start_time, end_time)
VALUES
('Math', '08:01:00', '09:00:00'),
('Chem', '09:01:00', '10:00:00'),
('Phy', '10:01:00', '11:00:00');

SELECT * FROM table_times;

-- Select current time
SELECT CURRENT_TIME;

-- Select local time
SELECT LOCALTIME;

-- Arithmetic Operations
SELECT time '12:00' - time '04:00' as RESULT;

-- INTERVAL
SELECT
CURRENT_TIME,
CURRENT_TIME + INTERVAL '4 hours';

SELECT
CURRENT_TIME,
CURRENT_TIME + INTERVAL '-4 hours';

--#####################################################################

-- TIMESTAMP AND TIMESTAMPTZ Data Types
-- Allows to store date and tine together
-- TIMESTAMP date and time w/o timestamp
-- TIMESTAMPTZ date and time with timestamp

-- Internally values are stored in UTC always


CREATE TABLE IF NOT EXISTS table_time_tz (
	ts TIMESTAMP,
	tstz TIMESTAMPTZ
);

INSERT INTO table_time_tz (ts, tstz)
VALUES
('2024-06-25 10:10:10-07', '2024-06-25 10:10:10-07');

SELECT * FROM table_time_tz;

SHOW TIMEZONE;

SELECT CURRENT_TIMESTAMP;

SELECT TIMEOFDAY();

SELECT timezone('America/New_York', '2024-06-26 10:00:00');