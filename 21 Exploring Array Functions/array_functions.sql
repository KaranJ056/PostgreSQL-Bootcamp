-- Using Array Functions

/*
Quick into of an array:

	- An array is an ordered collection of values
	- The 'Cardinality' of an array is the number of elements in the array. 
	  This values can be zero or more.
	- You can access individual elements in an array by enclosing their 'subscripts' 
	  or position in square brackets.
		If you have Ia array named customers, then
		customers[2] will refer to the second element of the customers array
*/

-- Construct arrays & ranges:
/*
	range_type(lower_bound, upper_bound)
		range_type: INT4RANGE, INT8RANGE. NUMRANGE, TSRANGE, TSTZRANGE, DATERANGE

	range_type(lower_bound, upper_bound, opeen_close)
	 open_close: [], [), (]. ()
	 				
*/

SELECT 
	INT4RANGE(1, 6),
	NUMRANGE(1.4213, 6.2986, '[]'),
	DATERANGE('20100101', '20201231', '()'),
	TSRANGE(LOCALTIMESTAMP, LOCALTIMESTAMP + INTERVAL '6 days', '(]');

-- Constructing arrays
/*
	Array [val1, val2, val3, val4]
*/

SELECT
	ARRAY[1,2,3] "INT array",
	ARRAY[4.23132::FLOAT],
	ARRAY[CURRENT_DATE, CURRENT_DATE+5];

-- Using operators with array

SELECT
	ARRAY[1,2,3,4] = ARRAY[1,2,3,4] "=",
	ARRAY[1,2,3,4] = ARRAY[2,3,4] "=",
	ARRAY[1,2,3,4] <> ARRAY[2,3,4,5] "<>",
	ARRAY[1,2,3,4] < ARRAY[2,3,4,5] "<",
	ARRAY[1,2,3,4] > ARRAY[2,3,4,5] ">",
	ARRAY[1,2,3,4] <= ARRAY[2,3,4,5] "<=";

-- for ranges
SELECT
	INT4RANGE(1,4) @> INT4RANGE(2,3) "Contains",
	DATERANGE(CURRENT_DATE, CURRENT_DATE+39) @> CURRENT_DATE + 15 "Contains value",
	NUMRANGE(1.5, 5.2) && NUMRANGE(2, 4) "Overlaps";

-- Inclusion Operators
-- @>, <@, &&

SELECT 
	ARRAY[1,2,3,4] @> ARRAY[2,3,4,5] "Contains",
	ARRAY['a','b'] <@ ARRAY['a','b'] "Contains BY",
	ARRAY[1,2,3,4] && ARRAY[2,3,4] "Is Overlap";

-- Constructing Array:
-- With ||

SELECT
	ARRAY[1,2,3] || ARRAY[4,5,6] "Using ||",
	ARRAY_CAT(ARRAY[1,2,3], ARRAY[4,5,6]) "Using ARRAY_CAT";

-- Add an item into an array
SELECT 
	ARRAY[1,2,3] || 4 "Adding using ||",
	ARRAY_PREPEND(4, ARRAY[1,2,3]) "Using ARRAY_PREPEND",
	ARRAY_APPEND(ARRAY[1,2,3], 4) "Using ARRAY_APPEND";

-- Array Metadata Functions

-- ARRAY_NDIM(any_array) -- returns dimensions in an array

SELECT
	ARRAY_NDIMS(ARRAY[1,2,3]),
	ARRAY_NDIMS(ARRAY[[1], [2]]),
	ARRAY_NDIMS(ARRAY[[[1]], [[2]]]);

-- ARRAY_DIM(any_array) -- returns a text representation of array's dimensions

SELECT
	ARRAY_DIMS(ARRAY[1,2,3]),
	ARRAY_DIMS(ARRAY[[1], [2]]),
	ARRAY_DIMS(ARRAY[[[1]], [[2]]]);

-- ARRAY_LENGTH(any_array, int) -- returns length of the requested array dimensions
-- ARRAY_LOWER(any_array, int) -- returns lower bound of the requested array dimensions
-- ARRAY_UPPER(any_array, int) -- returns upper bound of the requested array dimensions
-- CARDINALITY(array) -- returns cardinality of an array or total no. of arrays in an array

SELECT
	ARRAY_LENGTH(ARRAY[1,2,3,4,5], 1),
	ARRAY_LOWER(ARRAY[-1,2,3,4,12], 1),
	ARRAY_UPPER(ARRAY[-1,2,3,4,52], 1),
	CARDINALITY(ARRAY[1,2,3,4,5,6]);

-- Array Search Functions

-- ARRAY_POSITION(array, any_elem)
-- ARRAY_POSITION(array, any_elem, start_location)
-- Returns the subscript of the first occurence of the second arg. in an array
-- Array must be one-dimensional

SELECT 
	ARRAY_POSITION(ARRAY[1,2,3,4,5], 3),
	ARRAY_POSITION(ARRAY['Jan', 'Feb', 'Mar', 'Apr', 'Jun'], 'Jun'),
	ARRAY_POSITION(ARRAY['Jan', 'Feb', 'Mar', 'Apr', 'Jun'], 'Dec');
	
-- ARRAY_POSITIONS(array, element) -- Returns every occurance of an element
SELECT
	ARRAY_POSITIONS(ARRAY[1,2,3,4,5], 3),
	ARRAY_POSITIONS(ARRAY['Jan', 'Feb', 'Mar', 'Apr', 'Jun'], 'Jun'),
	ARRAY_POSITIONS(ARRAY[1,2,2,3,4,5,6,6], 2),
	ARRAY_POSITIONS(ARRAY[1,2,2,3,4,5,6,6], 6);

-- Array modification functions

-- ARRAY_CAT(array1, array2)
-- ARRAY_PREPEND(ele, array)
-- ARRAY_APPNED(array, ele)

-- ARRAY_REMOVE(array, ele) -- Removes all occurences of an ele in an array
SELECT
	ARRAY_REMOVE(ARRAY[1,2,3,4,5,1,2,3,2,2,2,4,5], 2);

-- ARRAY_REPLACE(array, from_ele, to_ele) -- replace all occurences of an ele in an array
SELECT
	ARRAY_REPLACE(ARRAY[1,2,3,4,5,1,2,3,2,2,2,4,5], 2, 55);

-- Array comparison with IN, ALL, ANY and SOME

SELECT
	20 IN (1,2,20,40) "IN",
	25 IN (1,2,20,40) "IN",
	
	20 NOT IN (1,2,20,40) "NOT IN",
	25 NOT IN (1,2,20,40) "NOT IN",
	
	25 = ALL(ARRAY[1,2,20,40]) "ALL",
	25 != ALL(ARRAY[1,2,20,40]) "ALL",
	
	25 = ANY(ARRAY[1,2,20,40]) "ANY",
	25 != ANY(ARRAY[1,2,20,40]) "ANY",
	
	25 = SOME(ARRAY[1,2,20,40]) "SOME",
	25 != SOME(ARRAY[1,2,20,40]) "SOME";

-- Formatting and converting arrays

-- STRING_TO_ARRAY(str, delimiter)
-- array_to_stirng(array, delimeter)

SELECT
	STRING_TO_ARRAY('1,2,3,4,5', ','),
	STRING_TO_ARRAY('1,2,3,4,5,ABC', ',', 'ABC'),
	STRING_TO_ARRAY('1,2,3,4,5,,6', ',', ''),
	
	ARRAY_TO_STRING(ARRAY[11,2,3,4,5,6], ','),
	ARRAY_TO_STRING(ARRAY['Jan', 'Feb', 'Mar'], '|');

-- Using arrays into a table

CREATE TABLE table_teachers (
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	phones TEXT[]
);

INSERT INTO table_teachers (name, phones)
VALUES
('Mahi', ARRAY['8312212832', '3214231230']),
('AG', ARRAY['4172383232', '1234123534']);

SELECT * FROM table_teachers;

-- To insert array we can do any of the following:
-- {val1,  val2}
-- ARRAY[val1, val2]
-- '{"val1", "val2"}'

SELECT 
	name, phones[1]
FROM table_teachers;

-- Modify Array Data:


UPDATE table_teachers
SET phones[1] = '9999999999'
WHERE teacher_id = 1;

SELECT * FROM table_teachers;

-- IGNORED ARRAY DIMENSIONS
-- PostgreSQL by default ignores dimensions
CREATE TABLE teachers2 (
	teacher_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	phones TEXT ARRAY[1]
);

INSERT INTO teachers2 (name, phones)
VALUES
('Adam', ARRAY['(111)-222-3333','(555)-666-7777']);

SELECT * FROM teachers2;


-- DISPLAY ARRAY ELEMENTS
-- unnest(array) -- Used to display all array elems individually
SELECT teacher_id, name, unnest(phones)
FROM teachers;

SELECT teacher_id, name, unnest(phones)
FROM teachers
ORDER BY 3;


-- MULTI DIMENSIONAL ARRAYS
-- Using Multidimensional arrays in tables
CREATE TABLE students (
	student_id SERIAL PRIMARY KEY,
	student_name VARCHAR(100),
	student_grade INTEGER[][]
);

INSERT INTO students (student_name, student_grade)
VALUES
('S1','{90, 2020}');

SELECT * FROM students;

INSERT INTO students (student_name, student_grade)
VALUES
('S2','{80, 2020}'),
('S3','{70, 2019}'),
('S2','{60, 2019}');

SELECT * FROM students;


SELECT student_grade[1] FROM students;

SELECT student_grade[2] FROM students;


SELECT * FROM students
WHERE student_grade[2] = '2020';

SELECT * FROM students
WHERE student_grade @> '{2020}';

SELECT * FROM students
WHERE 2020 = ANY(student_grade);

SELECT * FROM students
WHERE student_grade[1] > '80';

-- Array vs JSONB 