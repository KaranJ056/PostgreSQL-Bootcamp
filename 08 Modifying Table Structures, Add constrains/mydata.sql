-- Database: mydata

-- DROP DATABASE IF EXISTS mydata;

CREATE DATABASE mydata
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE TABLE IF NOT EXISTS persons (
	person_id SERIAL PRIMARY KEY,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL
);

ALTER TABLE persons
ADD COLUMN age INT NOT NULL;

SELECT * FROM persons;

ALTER TABLE persons
ADD COLUMN nationality VARCHAR(20) NOT NULL,
ADD COLUMN eamil VARCHAR(50) UNIQUE;

SELECT * FROM persons;

--###################################################################

-- Modify table structure, Add/Modify columns

-- Rename a table
ALTER TABLE users
RENAME TO persons;

-- Rename a column
ALTER TABLE persons
RENAME COLUMN age TO person_age;

-- Drop a column
ALTER TABLE persons
DROP COLUMN person_age;

ALTER TABLE persons
ADD COLUMN age VARCHAR(10) NOT NULL;

-- Chanege the data type of a col
ALTER TABLE persons
ALTER COLUMN age TYPE INT
USING age::integer;

-- Set default value of a column
ALTER TABLE persons
ADD COLUMN is_enable VARCHAR(1) DEFAULT 'Y'; 

SELECT * FROM persons;

--####################################################################

-- Add Constrains to table column

-- Add a unique constrains to table
CREATE TABLE web_links (
	link_id SERIAL PRIMARY KEY,
	link_url VARCHAR(255) NOT NULL,
	link_target VARCHAR(20)
);

INSERT INTO web_links (link_url, link_target)
VALUES 
('https://www.geeksforgeeks.com', '_blank'),
('https://www.example.com', '_parent');

ALTER TABLE web_links
ADD CONSTRAINT unique_web_url UNIQUE (link_url);	 

SELECT * FROM web_links;

-- To set columns to allow some specific defined/acceotable values

ALTER TABLE web_links
ADD COLUMN is_available VARCHAR(2);

INSERT INTO web_links (link_url, link_target, is_available)
VALUES ('https://www.netflix.com', '_blank', 'Y');

ALTER TABLE web_links
ADD CHECK (is_available IN ('Y', 'N'));

INSERT INTO web_links (link_url, link_target, is_available)
VALUES ('https://www.netflix.com', '_blank', 'X');

SELECT * FROM web_links;