-- CONSTRAINTS IN PL/PGSQL

-- 1. They are like 'Gate Keepers'
-- 2. Controls the the what kind of data goes into the table
-- 3. They ensures reliability and accuracy of data in the database
-- 4. They can be added on
-- 		a. Table level => Applies to whole table
-- 		b. Column Level => Applies to one column only
-- 5. Types of constraints
/*
		NOT NULL
		UNIQUE
		CHECK
		PRIMARY KEY
		FOREIGN KEY
		DEFAULT
*/

--##########################################################################

-- 1. NOT NULL Constraint

-- NULL represents empty strings or info. missing
-- It's not same as the empty string or number 0
-- To chcek IS NULL/ IS NOT NULL is used
-- SYNTAX:
-- CREATE TABLE table_name (
-- 		col_name data_type NOT NULL,
--		...
-- );

CREATE TABLE table_nn (
	id SERIAL PRIMARY KEY,
	tag TEXT NOT NULL
);

SELECT * FROM table_nn;

INSERT INTO table_nn (tag) VALUES ('ABC');

INSERT INTO table_nn (tag) VALUES (NULL);

SELECT * FROM table_nn;

CREATE TABLE table_nn2 (
	id SERIAL PRIMARY KEY,
	tag2 TEXT
);

SELECT * FROM table_nn;

ALTER TABLE table_nn2
ALTER COLUMN tag2 SET NOT NULL;

DROP TABLE table_nn;
DROP TABLE table_nn2;

--##########################################################################

-- 2. UNIQUE Constraint

-- This makes sure that value in column or group of columns is unique
-- SYNTAX:
-- CREATE TABLE TABLE_NAME (
-- 	COLUMN_NAME DATATYPE UNIQUE
-- 	.....
-- );

CREATE TABLE table_emails (
	id SERIAL PRIMARY KEY,
	emails TEXT UNIQUE
);

INSERT INTO table_emails (emails)
VALUES 
('a@b.com'),
('a@b.com');

INSERT INTO table_emails (emails)
VALUES ('askdj21@gamail.com');

SELECT * FROM table_emails;

-- Add UNIQUE constraint to multple COLUMNS

CREATE TABLE table_products (
	id SERIAL PRIMARY KEY,
	product_code VARCHAR(10),
	product_name TEXT
	-- UNIQUE (col1, col2, ....)
);

-- ALTER TABLE table_products
-- ADD CONSTRAINT constraint_name UNIQUE (col1, col2, col3, .....)

ALTER TABLE table_products
ADD CONSTRAINT unique_product_code UNIQUE (product_code, product_name);

--##########################################################################

-- 3. DEFAULT Constraint

-- Set a deafault value of a column in a new table

CREATE TABLE table_employees (
	emp_id SERIAL PRIMARY KEY,
	emp_name VARCHAR(50),
	is_available VARCHAR(2) DEFAULT 'Y' 
);

SELECT * FROM table_employees;

INSERT INTO table_employees (emp_name) VALUES ('Karan');

-- SET DEFAULT VALUE FOR AN EXISTING TABLE AND COLUMN

ALTER TABLE table_employees
ALTER COLUMN is_available SET DEFAULT 'N';

-- DROP A DEFAULT VALUE

ALTER TABLE table_employees
ALTER COLUMN is_available DROP DEFAULT;


--##########################################################################

-- 4. PRIMARY KEY Constraint

-- Used to uniquely identify each record in a database/table
-- There are more unique key but only one primary key in table
-- Theay are same as UNIQUE NOT NULL

CREATE TABLE table_items (
	item_id INTEGER PRIMARY KEY,
	item_name VARCHAR(100) NOT NULL
);

SELECT * FROM table_items;

INSERT INTO table_items (item_id, item_name)
VALUES 
(1, 'Pen'),
(2, 'Keyboard'),
(3, 'Mouse');

-- DROP A CONSTRAINT
ALTER TABLE table_items
DROP CONSTRAINT table_items_pkey;

-- HOW TO ADD A PRIMARY KEY CONSTRAINT IN AN EXISTING TABLE?
ALTER TABLE table_items 
ADD PRIMARY KEY (item_id);


-- PRIMARY KEY ON MULTIPLE COLUMNS | COMPOSITE PRRIMARY KEY

CREATE TABLE table_grades (
	course_id INT NOT NULL,
	student_id INT NOT NULL,
	grade NUMERIC NOT NULL
);

SELECT * FROM table_grades;

INSERT INTO table_grades (course_id, student_id, grade) 
VALUES
(1, 1, 87),
(2, 1, 90),
(1, 2, 87),
(2, 2, 90);

 ALTER TABLE table_grades
 ADD PRIMARY KEY (course_id, student_id);

 DROP TABLE table_grades;

 CREATE TABLE table_grades (
	course_id INT NOT NULL,
	student_id INT NOT NULL,
	grade NUMERIC NOT NULL,
	PRIMARY KEY (course_id, student_id) -- Order is also very important
);

ALTER TABLE table_grades
DROP CONSTRAINT table_grades_pkey;

DROP TABLE table_grades;

--##########################################################################

-- 5. FOREIGN KEY Constraint

-- FOREIGN KEY IS A COLUMN OR A GROUP OF COLUMN THAT IS REFERED TO A PRIMARY
-- KEY OF OTHER TABLE

-- PAERNT TABLE
-- 		CHILD/FOREIGN TABLE

-- SYNTAX:
-- CREATE TABLE TABLE_NAME (
-- 	COLUMN_NAME1 DATATYPE PRIMARY_KEY,
-- 	COLUMN_NAME2 DATATYPE CONSTRAINT,
-- 	...,
-- 	FOREIGN KEY (col_name) REFERENCES CHILD_TABLE_NAME (col_name);
-- );

-- FIRST LOOK AT WHAT HAPPENS WHEN TABLES USING WITH NO FOREIGN KEY CONCEPTS

CREATE TABLE t_products (
	product_id INT PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	supplier_id INT NOT NULL
);

CREATE TABLE t_suppliers (
	supplier_id INT PRIMARY KEY,
	supplier_name VARCHAR(20)
);

INSERT INTO t_suppliers (supplier_id, supplier_name)
VALUES 
(1, 'SUPPLIER 1'),
(2, 'SUPPLIER 2');

INSERT INTO t_products (product_id, product_name, supplier_id)
VALUES
(1, 'Pen', 1),
(2, 'Keyboard', 2),
(3, 'Mouse', 2),
(4, 'Paper', 1);

SELECT * FROM t_products;
SELECT * FROM t_suppliers;

--  NOW IF WE ADD NEW PRODUCT THAT IS SUPPLIED BY SUPPLIER10
--  SYSTEM WILL ALLOW IT EVEN IF WE DONT'T HAVE ANY SUPPLIER WITH NAME SUPPLIER10

-- TACKLE DOWN THIS SITUATION WE WANT FOREIGN KEY RELATIONSHIP IN DATABASE OR TABLE



-- CREATING FOREIGN KEY CONSTRAINS

CREATE TABLE t_products (
	product_id INT PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	supplier_id INT NOT NULL,
	FOREIGN KEY (supplier_id) REFERENCES t_suppliers (supplier_id)
);

CREATE TABLE t_suppliers (
	supplier_id INT PRIMARY KEY,
	supplier_name VARCHAR(20)
);

INSERT INTO t_suppliers (supplier_id, supplier_name)
VALUES 
(1, 'SUPPLIER 1'),
(2, 'SUPPLIER 2');

INSERT INTO t_products (product_id, product_name, supplier_id)
VALUES
(1, 'Pen', 1),
(2, 'Keyboard', 2),
(3, 'Mouse', 2),
(4, 'Paper', 1);

SELECT * FROM t_suppliers;
SELECT * FROM t_products;

INSERT INTO t_products (product_id, product_name, supplier_id)
VALUES (5, 'MEDICINES', 10); -- THROWS AN ERROR

INSERT INTO t_suppliers (supplier_id, supplier_name)
VALUES 
(10, 'SUPPLIER 10');

INSERT INTO t_products (product_id, product_name, supplier_id)
VALUES (5, 'MEDICINES', 10);

DELETE FROM t_suppliers 
WHERE supplierr_id = 10 -- THROWS AN EROOR


-- HOW TO DROP A CONSTRAINT?

-- ALTER TABLE TABLE_NAME
-- DROP CONSTRAINT CONSTRAINT_NAME;

ALTER TABLE t_products
DROP CONSTRAINT t_products_supplier_id_fkey;


DROP TABLE t_products;
DROP TABLE t_suppliers;

-- UPDATE A FOREIGN KEY ON AN EXISTING TABLE

-- SYNTAX:
-- ALTER TABLE table_name
-- ADD CONSTRAINT constraint_name
-- 		FOREIGN KEY (col_name) REFERENCES CHILD_TABLE_NAME (col_name);



--##########################################################################

-- 6. CHECK Constraint

-- Used to specisy a special or some speciific crieteia for a column value
-- It uses boolean expression before executing INSERT OR UPDATE statements

-- ADD A CHECK CONSTRAINT ON NEW AND EXISTING TABLE

-- ON A NEW TABLE

CREATE TABLE staff (
	staff_id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	birth_date DATE CHECK (birth_date > '1900-01-01'),
	joined_date DATE CHECK (joined_date  > birth_date),
	salary numeric CHECK (salary > 0)
);

INSERT INTO staff (name, birth_date, joined_date, salary)
VALUES
('XYZ', '1890-03-21', '2025-01-02', 9000),
('ABC', '1978-11-19', '2025-01-06', 12000);

INSERT INTO staff (name, birth_date, joined_date, salary)
VALUES ('ABC', '1978-11-19', '2025-01-06', 12000);

SELECT * FROM staff;

-- ON AN EXISTING TABLE

CREATE TABLE prices (
	price_id SERIAL PRIMARY KEY,
	product_id INT NOT NULL,
	price INT NOT NULL,
	discount NUMERIC NOT NULL,
	valid_from DATE NOT NULL 
);

SELECT * FROM prices;

ALTER TABLE prices
ADD CONSTRAINT price_check 
CHECK (
	price > 0
	AND discount >= 0
	AND price > discount
);

INSERT INTO prices (product_id, price, discount, valid_from)
VALUES (11, 200, 0.3, '2025-04-23');

INSERT INTO prices (product_id, price, discount, valid_from)
VALUES (12, 100, 900, '2025-04-23');

SELECT * FROM prices;

--RENAME A CONSTRAINT 
ALTER TABLE PRICES
RENAME CONSTRAINT price_check TO price_and_discount_check;