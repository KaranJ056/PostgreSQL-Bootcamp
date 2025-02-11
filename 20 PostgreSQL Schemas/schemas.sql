-- PostgreSQL Schemas:

-- WHAT IS SCHEMA?
-- A schema is a namespace that contains named database objects such as;
--      - tables,
--      - views,
--      - indexes,
--      - data types,
--      - functions,
--      - stored procedures and
--      - operators.
-- Each schema should be unique and different from each other.

-- Benifits of schema:
-- 1. It allow you to organize database objects.
-- 2. It enables multiple users to use one w/o interfering with each other.
-- 3. For every new db public schema is created.
-- 4. 2 scheams can have different objects that share the same name.

--#####################################################################

-- Schemas Operations (Add/Alter/Delete schemas)

-- 1. Create a schema
CREATE SCHEMA sales;
CREATE SCHEMA hr;

-- 2. Rename a schema
ALTER SCHEMA sales
RENAME TO sales_schema;

-- 3. Drop a schema
DROP SCHEMA hr;
DROP SCHEMA sales_schema;

-- 4. Use pgAdmin for schema operations

--#####################################################################

-- Schema Hierarchy

/*
	Physical => host > cluster > database > schema > object name
	
	Object access => database.schema.object_name
					  e.g. hr.public.employees
*/

-- 1. create a database called "test"

-- 2. select a table from public schema
SELECT * FROM hr.public.employees;

--#####################################################################

-- Move a table to a different schema

-- SYNTAX:
-- ALTER TABLE table_name 
-- SET SCHEMA schema_name;

SELECT * FROM hr.hrresources.orders;

ALTER TABLE hr.hrresources.orders
SET SCHEMA public;

SELECT * FROM orders;

--#####################################################################

-- Schema search path

-- Schema search path is just a list of schemas that is used to look for a object.

-- current schema
SELECT CURRENT_SCHEMA();

-- current search path 
SHOW SEARCH_PATH;

-- add a new schema to search path
-- SET search_path TO schema_name, public;
SET search_path TO hrresources, public;

SHOW search_path;

SELECT * FROM employees;
SELECT * FROM public.employees;

SET search_path TO '$user',public;

--#####################################################################

-- Alter a ownership of a schema

-- SYNTAX:
-- ALTER SCHEMA schema_name OWNER TO new_owner;

ALTER SCHEMA hrresources
OWNER TO "Karan";

-- We can also use pgAdmin tool for the same

--#####################################################################

-- Duplicate a schema along with data

-- create a db "test_schema"
CREATE DATABASE test_schema;

-- create a table called songs
CREATE TABLE test_schema.public.songs (
	song_id SERIAL PRIMARY KEY,
	song_title VARCHAR(50)
);

INSERT INTO test_schema.public.songs (song_title)
VALUES
('Counting Start'),
('Rolluing in the deep'),
('Until I found you');

SELECT * FROM test_schema.public.songs;

-- Now duplicate the schema "public" with all data

-- STEP-1:  Make a postgreSQL database "public" schema using pg_dump
-- SYNTAX:
-- pg_dump -d database_name -h localhost -U postgres -n public > dump.sql

pg_dump -d test_schema -h loacalhost -U postgres -n public > dump.sql

-- STEP-2: Rename "public" schema to old schema

-- STEP-3: Import back dumped file
-- SYNTAX:
-- psql -h localhost -U postgres -d database_name -f dump.sql

psql -h localhost -U postgres -d test_schema -f dump.sql

--#####################################################################

-- System catalog schema

-- In addition to public and user-created schemas, each database contains 
-- a 'pg_catalog' schema

--#####################################################################

-- Compare cols and schemas in two schema

-- The PostgreSQL query below compares columns names in tables between 
-- two PostgreSQL schemas.
-- It shows missing columns in either of two schemas.

SELECT 
	COALESCE(c1.table_name, c2.table_name) as table_name,
	COALESCE(c1.column_name, c2.column_name) as table_column,
	c1.column_name as schema1,
	c2.column_name as schema2
FROM
(
	SELECT table_name, column_name
	FROM information_schema.columns c 
	WHERE c.table_schema ='public'
) c1
FULL JOIN
(
	SELECT table_name, column_name
	FROM information_schema.columns c 
	WHERE c.table_schema ='hrresources'
) c2
ON c1.table_name = c2.table_name AND c1.column_name = c2.column_name
WHERE c1.column_name IS NULL OR c2.column_name IS NULL
ORDER BY table_name, table_column;

--#####################################################################

-- Schemas and Privileges

-- Users can only access objects that they own
-- Two schema level access rights:
-- 		a. USAGE : To access schema
-- 		b. CREATE : To create objects like tables, etc ... in a schema

-- a. USAGE:
-- To allow users to access the objects in the schema that trhey don't own,
-- we must provide/grant the schema privilege to them.

-- SYNTAX:
-- GRANT USAGE ON SCHEMA schema_name TO role_name;

-- - 1. Lets create a schema called "private" on 'hr' database and give rights to postgres user
-- - 2. Lets try to access the schema via user 'adam'
GRANT USAGE ON SCHEMA private TO "KaranJJoshi";

-- - 3. Give access rights to 'KaranJJoshi'
GRANT SELECT ON ALL TABLES IN SCHEMA private TO "KaranJJoshi";

-- - 4. Can he create a n objesct as a table in private schema?
GRANT CREATE ON SCHEMA private TO "KaranJJoshi";

-- 5. Note that, by default, every user has the CREATE and USAGE 
-- on the 'public' schema.
-- So from the security point of view, plan accordingly user access rights.