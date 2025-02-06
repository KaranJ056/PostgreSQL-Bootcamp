-- Composite Data Types

-- List of field names with corresponding data types
-- Used in table as a column
-- Used in functions or procedures
-- Can return a multiple values

-- SYNTAX:
-- CREATE TYPE name AS (fields column_properties)

-- Ex:1 Create a address composite data type
CREATE TYPE address AS (
	city VARCHAR(50),
	counrty VARCHAR(30)
);

CREATE TABLE companies (
	id SERIAL PRIMARY KEY,
	addr address
);

INSERT INTO companies (addr)
VALUES
(ROW('LONDON', 'UK')),
(ROW('LA', 'USA'));

--SELECT (composite_column).field_name FROM companies;
--SELECT (table_name.composite_column).field_name FROM companies;
SELECT (addr).city FROM companies;
SELECT (companies.addr).city FROM companies;


-- Ex:2 Composie data type for an inventory_item
CREATE TYPE inventory_item AS (
	prod_name TEXT,
	supplier_id INT,
	price NUMERIC
);

CREATE TABLE inventory (
	id SERIAL PRIMARY KEY,
	items inventory_item
);

INSERT INTO inventory (items)
VALUES 
(ROW('pen', 20, 4.99)),
(ROW('keyboard', 10, 24)),
(ROW('mouse', 12, 40));

SELECT items FROM inventory;

SELECT 
	(items).prod_name AS "Item Name",
	(items).supplier_id AS "Item Supplier ID",
	(items).price AS "Item Price"
FROM inventory
WHERE 
	(items).price > 15;


CREATE TYPE currency AS ENUM ('USD', 'INR', 'EUR');

SELECT 'INR'::currency;

ALTER TYPE currency ADD VALUE 'CHF' AFTER 'INR';

CREATE TABLE stocks (
	stock_id SERIAL PRIMARY KEY,
	stock_curr currency
);

INSERT INTO stocks (stock_curr)
VALUES
('INR'),
('USD'),
('INR'),
('EUR');

INSERT INTO stocks (stock_curr)
VALUES ('USD2');

INSERT INTO stocks (stock_curr)
VALUES ('CHF');

SELECT * FROM stocks;

SELECT stock_id FROM stocks
WHERE stock_curr = 'INR';

--  HOW TO DROP A DATA TYPE?
CREATE TYPE sample_type AS ENUM ('asfa', 'sd');

DROP TYPE sample_type;

--########################################################################

-- Alter a data type

CREATE TYPE myaddress AS (
	city VARCHAR(50),
	country VARCHAR(20)
);

--Rename type
ALTER TYPE myaddress RENAME TO my_address;

--Set different owner
ALTER TYPE my_address OWNER TO "postgres"

--Set different schema
ALTER TYPE my_address SET SCHEMA test;

--Add attribute to type
ALTER TYPE test.my_address ADD ATTRIBUTE street_add VARCHAR(30);

--##################################################################

-- Alter an ENUM datat type

CREATE TYPE mycolors as ENUM ('Red', 'green', 'blue');

-- Update a value
ALTER TYPE mycolors RENAME VALUE 'Red' TO 'red';

-- List all enum eles
SELECT enum_range(NULL::mycolors);

-- Add a new value
ALTER TYPE mycolors ADD VALUE 'orange' AFTER 'green';

--##################################################################

-- Alter an enum data type in production server

CREATE TYPE status AS ENUM ('running', 'queued', 'waiting', 'done');

CREATE TABLE jobs (
	job_id SERIAL PRIMARY KEY,
	job_status status
);

INSERT INTO jobs (job_status)
VALUES ('waiting'), ('done'), ('queued'), ('running');

SELECT * FROM jobs;

UPDATE jobs SET job_status = 'running' WHERE job_status = 'waiting';

ALTER TYPE status RENAME TO status_old;

CREATE TYPE status AS ENUM ('running', 'queued', 'done');

ALTER TABLE jobs ALTER COLUMN job_status TYPE status USING job_status::text::status;

SELECT * FROM jobs;

DROP TYPE status_old;


--##################################################################

-- Enum with a default value in the table

CREATE TYPE status AS ENUM ('pending', 'approved', 'declined');

CREATE TABLE cron_jobs (
	cron_jobs_id INT PRIMARY KEY,
	staus status DEFAULT 'pending'
);

INSERT INTO cron_jobs (cron_jobs_id)
VALUES
(1),
(2);

SELECT * FROM cron_jobs;

