-- USER DEFINED DATA TYPES

-- CREATE DOMAIN data type
/*
1. CREATE DOMAIN statement creates a user—defined data type with a range, optional DEFAULT ,
   NOT NULL and CHECK constraint
2. They have to be unique within a schema scope. Cannot be re—use outside Of scope where they are defined
3. Help to STANDERDIZE your database data types in one place.
4. A domain data type is a COMMON data type and can be RE-USE In multiple columns. Write once and share it all.
5. NULL is default
6. Composite Type : Only Single Value return
*/

-- CREATE DOMAIN name AS data_type CONSTRAINT 

CREATE DOMAIN addr AS VARCHAR(100);

CREATE TABLE loactions (
	address addr
);

INSERT INTO loactions (address)
VALUES ('123 London');

SELECT * FROM loactions;

------------------------------------

CREATE DOMAIN positive_numeric AS INT NOT NULL CHECK (VALUE > 0);

CREATE TABLE sample (
	id SERIAL PRIMARY KEY,
	num positive_numeric
);

INSERT INTO sample (num) VALUES (10), (2), (-1);
INSERT INTO sample (num) VALUES (10), (2), (1);

SELECT * FROM sample;

-- Create a domain 'indian_postal_code' for checking valid indain postal code

CREATE DOMAIN indian_postal_code AS TEXT NOT NULL 
CHECK (
	VAlUE ~'^\d{6}$'
	OR VALUE ~'^\d{3} \d{3}$'
);

CREATE TABLE posts (
	post_id SERIAL NOT NULL,
	postal_code indian_postal_code
);

INSERT INTO posts (postal_code)
VALUES 
('370 001'),
('222222'),
('2y348912738');

INSERT INTO posts (postal_code)
VALUES 
('370 001'),
('222 222');

SELECT * FROM posts;

-- cratae a domain 'proper_email' for valid email check
CREATE DOMAIN proper_eamil AS TEXT NOT NULL
CHECK (
	VALUE ~'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9._%-]+\.[a-zA-Z]{2,4}$'
);

CREATE TABLE customer_emails (
	customer_is SERIAL PRIMARY KEY,
	email proper_eamil
);

INSERT INTO customer_emails (email)
VALUES
('kjj123@gmail.com'),
('kjj123gmail.com'),
('kjj23109[]gmail.com');

INSERT INTO customer_emails (email)
VALUES ('kjj123@gmail.com');

SELECT * FROM customer_emails;

--@#############################################################################

-- create an enum type domain

CREATE DOMAIN valid_color AS VARCHAR(10)
CHECK (VALUE IN ('red', 'green', 'yellow'));

CREATE TABLE colors (
	color valid_color
);

INSERT INTO colors
VALUES ('Red'), ('Yellow'), ('Blue');

INSERT INTO colors
VALUES ('red'), ('yellow');

SELECT * FROM colors;

--@#############################################################################

-- Get all domain in your schema

SELECT typname
FROM pg_catalog.pg_type
JOIN pg_catalog.pg_namespace
ON pg_namespace.oid = pg_type.typnamespace
WHERE
typtype = 'd' and nspname = 'public';

--#####################################################################
-- How to drop a doamin data type

-- DROP DOMAIN name

DROP DOMAIN positive_numeric;
DROP DOMAIN positive_numeric CASCADE;

SELECT * FROM sample;

ALTER TABLE colors
ALTER COLUMN color TEXT;

DROP DOMAIN valid_color CASCADE;

SELECT * FROM colors;