-- Indexes and Performance Optimization:

--#####################################################################
-- What is index?

-- a. Index is a structured relation.
-- b. It helps to improve access of data in database.
-- c. An index is a data structure that allows faster access to the underlying table 
-- so that specific tuples can be found quickly. Here, "quickly" means faster than 
-- scanning the whole underlying table and analyzing every single tuple.
-- d. Maintaining an index is a fundamental for having good performance.
-- e. Performance tuning is a most complex task in role of DBA.
-- f. Adding indices may improve the speed of the data access but they add a COST 
-- to the data modification. Therefore it is important to understand if 
-- the index is used

--#####################################################################
-- Create an Index

-- NOTE: SQL is a declarative languagage. Therefore it does not define the
-- how to access the underlying data.

-- Key points:

-- a. You put them on table column or columns
-- b. Why not put an index on all columns?
-- Too many indexes will result in slow insert/update/delete operations! (High cost)
-- c. PostgreSQL supports indexes with up to 32 columns.
-- d. Two main basic index types:
/*
		1. INDEX: 			Create an index on values of column or columns.
		2. UNOIQUE INDEX: 	Create an index on UNIQUE values of column or columns.
*/

-- SYNTAX:
-- CREATE INDEX index_name
-- ON table_name (col1, col2, col3, .....)

-- CREATE UNIQUE INDEX index_name
-- ON table_name (col1, col2, col3, .....)

-- Full Syntax:
-- CREATE INDEX index_name ON table_name [USING method]
-- (
-- 	column_name [ASC | DESC] [NULLS {FIRST | LAST}],
-- 	...
-- );

-- Try to keep naming conventions uniwue and globally accessible
-- Ex:
INDEX				CREATE INDEX idx_table_name_column_name
UNIQUE INDEX 		CREATE UNIQUE INDEX idx_u_table_name_column_name

-- Create an index on oreder_date on northwind.orders table
EXPLAIN ANALYZE SELECT *
FROM orders
WHERE order_date > '1997-01-01';

-- Avg time: 0.5ms

CREATE INDEX idx_orders_order_date
ON orders (order_date);

EXPLAIN ANALYZE SELECT *
FROM orders
WHERE order_date > '1997-01-01';

-- Avg time: 0.8ms WHY?

-- Create an index on multiple fields:
CREATE INDEX idx_orders_customer_id_order_id
ON orders (customer_id, order_id);

/*
	It is important to note that, when creating multi—column •indexes, you should always place the most
	selective columns first. PostgreSQL consider a multi—column index from the first column onward, so
	if the first columns are the most selective, the index access method will be the cheapest.
*/

-- We can also use a pgAdmin tool for the creation of the index.

--#####################################################################
-- Create unique indexes

-- PRIMARY KEY and INDEXES
/*
	1. Normally the primary key of a table are kept with a UNIQUE INDEX
	2. If you define a UNIQUE index for two or more columns, the combined 
	   values in these columns cannot be duplicated in multiple rows.
*/

-- Create an unique index on product_id
CREATE UNIQUE INDEX idx_uq_products_product_id
ON products (product_id);

-- Create an unique index on amployee_id
CREATE UNIQUE INDEX idx_uq_employees_employee_id
ON employees (employee_id);

-- Create an unique index on customer_id, order_id
CREATE UNIQUE INDEX idx_uq_orders_customer_id_order_id
ON orders (customer_id, order_id);

-- Create an unique index on employee_id, hire_date
CREATE UNIQUE INDEX idx_uq_employees_employee_id_hire_date
ON employees (employee_id, hire_date);

SELECT * FROM employees;

INSERT INTO employees (employee_id, first_name, last_name, hire_date)
VALUES (2, 'Karan', 'Joshi', '2025-02-13');

--#####################################################################
-- List all indexes

-- PostgreSQL contains table called pg_indixes for list of indixes

-- all indixes
SELECT *
FROM pg_indexes;

-- indices of a table
SELECT *
FROM pg_indexes
WHERE tablename = 'employees';

SELECT *
FROM pg_indexes
WHERE tablename = 'orders';

--#####################################################################
-- Size of the table index

SELECT 
	pg_indexes_size('orders') orders,
	pg_size_pretty(pg_indexes_size('employees')) employees;

-- more indexes > more space

--#####################################################################
-- List count for all indexes

-- pg_stat_all_indexes

-- all stats
SELECT *
FROM pg_stat_all_indexes;

-- stats for a schema
SELECT	*
FROM pg_stat_all_indexes
WHERE schemaname = 'public'
ORDER BY relname, indexrelname;

--#####################################################################
-- DROP a INDEX

DROP INDEX [CONCURRENTLY]
[IF EXISTS] index_name
[CASCADE | RESTRICT];

/*
CASCADE
If the index has dependent objects, you use the CASCADE option to automatically drop 
these objects and all objects that depends on those objects.

RESTRICT
The RESTRICT option •instructs PostgreSQL to refuse to drop the index if any objects 
depend on it. The DROP INDEX uses RESTRICT by default.

CONCURRENTLY
When you execute the DROP INDEX Statement, PostgreSQL acquires an lock on the table 
and block other accesses until the index removal completes.
*/

DROP INDEX idx_orders_order_date;

--#####################################################################
-- High level overview of SQL statement execution process

/*
	1. SQL is a declarative language.
	2. You trust your database to run the best way to fetch the data.
	3. As a DBA, its your job to provide as much information to database engine to 
	   take best route to get your result set.
*/

-- fastest path vs time spent in  reasoning about this path

--#####################################################################
-- SQL statemeent execution stages

-- 4 Stages:
-- 		a. parser
-- 		b. rewriter
-- 		c. optimizer
-- 		d. executor

--#####################################################################
-- Query optimizer

/*

	a. WHAT TO USE TP ACCESS DATA
	b. AS QUICKLY AS POSSIBLE
	
		1. The COST is everything!
		2. Thread
			Possible after PostgreSQL 9.6
		3. Nodes
		4. Nodes Types
*/

--#####################################################################
-- Optimizer node types:

/*
	1. Nodes are available for:
		- every operations
		- every access methods

	2. Nodes are stackable

	3. Types of Node
		— Sequential Scan
		— Index Scan, Index Only Scan, and Bitmap Index Scan
		— Nested Loop, Hash Join, and Merge Join
		— The Gather and Merge parallel nodes

		SELECT * FROM pg_am;
*/

--#####################################################################
-- Sequential Nodes -> Sequential Scan

/*
	Seq Scan

	1. Default when no other alternative valuable is specified/available.
	2. Read form the begining of the dataset
*/

EXPLAIN SELECT * FROM orders;
EXPLAIN SELECT * FROM orders WHERE order_id IS NOT NULL;
EXPLAIN SELECT * FROM orders WHERE order_date > '1998-01-01';

--#####################################################################
-- Index Nodes

/*
	1. An index is used to access the dataset.
	2. Data files and index files are separated but they are nearby.
	3. Index Nodes Scan Types:
		a. Index Scan
		b. Index Only Scan
		c. Bitmap Index Scan
*/

EXPLAIN SELECT * FROM orders WHERE order_id = 1; -- Index Scan
EXPLAIN SELECT order_id FROM orders WHERE order_id = 1; -- Index Only Scan
EXPLAIN SELECT order_id, customer_id FROM orders WHERE order_id = 78; -- Index Scan
EXPLAIN SELECT order_id, customer_id FROM orders WHERE order_id > 78; -- Seq Scan

--#####################################################################
-- JOIN Nodes

/*
	1. Used when joining tables.
	2. Types:
		a. Hash
			Inner Table
			Outer Table
		b. Merge
		c. Nested Lop
*/

SHOW work_mem; -- Default: 4MB
-- Can be set by 
-- SET work_mem = val;
-- Used in: ORDER BY, DISTINCT, MERGE JOIN

-- HASH tables usage: 
	-- hash joins, 
	-- hash-based aggregation and 
	-- hash-based aggregation in subqueries

--#####################################################################
-- Index Types in PostgreSQL:

-- 1. B-Tree Index
/*
	a. Default Index
	b. Self-balancing Tree
	   SELECT, INSERT and DELETE, seq. access in logarithmic time
	c. Can be used for most operators and column type
 	d. Supports UNIQUE condition
	e. Normally used to make/build primary key indexes

	f. One drawback: It copies whole column(s) values in the tree structure
*/

-- 2. Hash Index
/*
	a. For equalities / equality  operators only
	b. Larger than btree indexes
	c. Not for range nor disequality operator.
*/

-- Ex:
CREATE INDEX idx_orders_order_id_on 
ON orders
USING HASH (order_date);

EXPLAIN SELECT order_date 
FROM orders
WHERE order_date = '1996-01-01';

-- 3. BRIN Index
/*
	1. Block range indexes
	2. Smaller Index
	3. Data block -> MIN MAX value
	4. Less costly to maintain than btree index
	5. Used linear sort order
*/

-- 3. GIN Index
/*
	1. Generalized inverted indexes
	2. Point to multiple tuple
	3. Used with array type data
	4. Used in full-text search
	5. Useful when we have multiple values stored in a single column
*/

--#####################################################################
-- EXPLAIN statement

-- It shows query execution plan
-- Shows the lowest cost among the evaluated plans
-- Will not execute you gave, jus show query only
-- Show you the execution nodes that the executor will use to provide you with the dataset.

EXPLAIN SELECT order_date FROM orders WHERE order_id = 2;

--#####################################################################
-- Exlain output options:

-- ( FORMAT option )
-- Option:
-- TEXT< XML, JSON, YAML

-- EX:
EXPLAIN (FORMAT JSON) SELECT order_id, order_date FROM orders WHERE order_date = '1996-01-01' ORDER BY order_id; 

-- O/P:
"[
  {
    ""Plan"": {
      ""Node Type"": ""Sort"",
      ""Parallel Aware"": false,
      ""Async Capable"": false,
      ""Startup Cost"": 8.03,
      ""Total Cost"": 8.03,
      ""Plan Rows"": 1,
      ""Plan Width"": 6,
      ""Sort Key"": [""order_id""],
      ""Plans"": [
        {
          ""Node Type"": ""Index Scan"",
          ""Parent Relationship"": ""Outer"",
          ""Parallel Aware"": false,
          ""Async Capable"": false,
          ""Scan Direction"": ""Forward"",
          ""Index Name"": ""idx_orders_order_id_on"",
          ""Relation Name"": ""orders"",
          ""Alias"": ""orders"",
          ""Startup Cost"": 0.00,
          ""Total Cost"": 8.02,
          ""Plan Rows"": 1,
          ""Plan Width"": 6,
          ""Index Cond"": ""(order_date = '1996-01-01'::date)""
        }
      ]
    }
  }
]"

--#####################################################################
-- Using EXPLAIN ANALYZE

/*
	a. It prints out the best plan to execute the query
	b. It runs the query.
	c. Also report back some statistical information.
*/

-- Explain O/P:
EXPLAIN SELECT order_id, order_date FROM orders WHERE order_date = '1996-01-01' ORDER BY order_id; 

"Sort  (cost=8.03..8.03 rows=1 width=6)"
"  Sort Key: order_id"
"  ->  Index Scan using idx_orders_order_id_on on orders  (cost=0.00..8.02 rows=1 width=6)"
"        Index Cond: (order_date = '1996-01-01'::date)"

-- EXPLAIN ANALYZE O/P:
EXPLAIN ANALYZE SELECT order_id, order_date FROM orders WHERE order_date = '1996-01-01' ORDER BY order_id; 

"Sort  (cost=8.03..8.03 rows=1 width=6) (actual time=0.041..0.042 rows=0 loops=1)"
"  Sort Key: order_id"
"  Sort Method: quicksort  Memory: 25kB"
"  ->  Index Scan using idx_orders_order_id_on on orders  (cost=0.00..8.02 rows=1 width=6) (actual time=0.031..0.032 rows=0 loops=1)"
"        Index Cond: (order_date = '1996-01-01'::date)"
"Planning Time: 0.159 ms"
"Execution Time: 0.065 ms"

--#####################################################################
-- Understanding query cost model

CREATE TABLE t_big (
	id SERIAL,
	name TEXT	
);

INSERT INTO t_big (name)
SELECT 'Adam' FROM generate_series(1, 2000000);

INSERT INTO t_big (name)
SELECT 'Karan' FROM generate_series(1, 2000000);

EXPLAIN SELECT * FROM t_big WHERE id =12345;
-- o/p:
"Seq Scan on t_big  (cost=0.00..71622.00 rows=1 width=9)"
"  Filter: (id = 12345)"

SHOW max_parallel_workers_per_gather;

SET max_parallel_workers_per_gather TO 0;

SELECT pg_relation_size('t_big') / 8192.0; -- returns size of table in size.
-- 21622

SHOW seq_page_cost;
-- 1

SHOW cpu_tuple_cost;
-- 0.01

SHOW cpu_operator_cost;
-- 0.0025

-- Cost Formula:
pg_relation_size * seq_page_cost + total_no_of_table_records * cpu_tuple_cost 
+ total_no_of_tablee_records * cpu_operator_cost

SELECT
	pg_relation_size('t_big') / 8192.0 *1 + 4000000*0.01 + 4000000*0.0025;

SET max_parallel_workers_per_gather TO 2;

--#####################################################################
-- Index are not free.

SELECT
	pg_size_pretty(pg_indexes_size('t_big'));

SELECT
	pg_size_pretty(pg_total_relation_size('t_big'));

EXPLAIN ANALYZE SELECT * FROM t_big WHERE id = 123456;
"Gather  (cost=1000.00..43455.43 rows=1 width=9) (actual time=28.476..553.537 rows=1 loops=1)"
"  Workers Planned: 2"
"  Workers Launched: 2"
"  ->  Parallel Seq Scan on t_big  (cost=0.00..42455.33 rows=1 width=9) (actual time=267.199..434.234 rows=0 loops=3)"
"        Filter: (id = 123456)"
"        Rows Removed by Filter: 1333333"
"Planning Time: 0.091 ms"
"Execution Time: 553.562 ms"

SELECT * FROM t_big;

CREATE INDEX idx_t_big_id
ON t_big (id);

EXPLAIN ANALYZE SELECT * FROM t_big WHERE id = 123456;
"Index Scan using idx_t_big_id on t_big  (cost=0.43..8.45 rows=1 width=9) (actual time=0.025..0.026 rows=1 loops=1)"
"  Index Cond: (id = 123456)"
"Planning Time: 0.102 ms"
"Execution Time: 0.047 ms"

--#####################################################################
-- Indexes for sorted output:

EXPLAIN SELECT * FROM t_big 
ORDER BY id
LIMIT 20;
"Limit  (cost=0.43..1.06 rows=20 width=9)"
"  ->  Index Scan using idx_t_big_id on t_big  (cost=0.43..125505.43 rows=4000000 width=9)"

EXPLAIN SELECT * FROM t_big 
ORDER BY name
LIMIT 20;
"Limit  (cost=83638.10..83640.43 rows=20 width=9)"
"  ->  Gather Merge  (cost=83638.10..472554.22 rows=3333334 width=9)"
"        Workers Planned: 2"
"        ->  Sort  (cost=82638.08..86804.74 rows=1666667 width=9)"
"              Sort Key: name"
"              ->  Parallel Seq Scan on t_big  (cost=0.00..38288.67 rows=1666667 width=9)"

EXPLAIN SELECT
MIN(id),
MAX(id)
FROM t_big;

--#####################################################################
-- Using multiple index on a single query:

EXPLAIN SELECT * FROM t_big
WHERE 
	id = 20 OR id = 30;
"Bitmap Heap Scan on t_big  (cost=8.88..16.85 rows=2 width=9)"
"  Recheck Cond: ((id = 20) OR (id = 30))"
"  ->  BitmapOr  (cost=8.88..8.88 rows=2 width=0)"
"        ->  Bitmap Index Scan on idx_t_big_id  (cost=0.00..4.44 rows=1 width=0)"
"              Index Cond: (id = 20)"
"        ->  Bitmap Index Scan on idx_t_big_id  (cost=0.00..4.44 rows=1 width=0)"
"              Index Cond: (id = 30)"

--#####################################################################
-- Execution plan depends on input values

CREATE INDEX idx_t_big_name 
ON t_big (name);

EXPLAIN SELECT * FROM t_big
WHERE name = 'Adam'
LIMIT 10;
"Limit  (cost=0.00..0.36 rows=10 width=9)"
"  ->  Seq Scan on t_big  (cost=0.00..71622.00 rows=1997067 width=9)"
"        Filter: (name = 'Adam'::text)"

EXPLAIN SELECT * FROM t_big
WHERE name = 'Adam';
"Index Scan using idx_t_big_name on t_big  (cost=0.43..52512.10 rows=1997067 width=9)"
"  Index Cond: (name = 'Adam'::text)"

EXPLAIN SELECT id FROM t_big
WHERE name = 'Adam';
"Index Scan using idx_t_big_name on t_big  (cost=0.43..52512.10 rows=1997067 width=4)"
"  Index Cond: (name = 'Adam'::text)"

EXPLAIN SELECT name FROM t_big
WHERE id < 10;
"Index Scan using idx_t_big_id on t_big  (cost=0.43..8.59 rows=9 width=5)"
"  Index Cond: (id < 10)"

EXPLAIN SELECT name FROM t_big
WHERE 
	name = 'Adam1' OR name = 'Karan';
"Bitmap Heap Scan on t_big  (cost=22812.33..74478.33 rows=2002933 width=5)"
"  Recheck Cond: ((name = 'Adam1'::text) OR (name = 'Karan'::text))"
"  ->  BitmapOr  (cost=22812.33..22812.33 rows=2002933 width=0)"
"        ->  Bitmap Index Scan on idx_t_big_name  (cost=0.00..4.44 rows=1 width=0)"
"              Index Cond: (name = 'Adam1'::text)"
"        ->  Bitmap Index Scan on idx_t_big_name  (cost=0.00..21806.43 rows=2002933 width=0)"
"              Index Cond: (name = 'Karan'::text)"

--#####################################################################
-- Using organized vs random data

SELECT * FROM t_big LIMIT 10;

EXPLAIN (ANALYZE true, BUFFERS true, TIMING true)
SELECT * FROM t_big WHERE id < 10000;
"Index Scan using idx_t_big_id on t_big  (cost=0.43..347.25 rows=10104 width=9) (actual time=0.043..5.052 rows=9999 loops=1)"
"  Index Cond: (id < 10000)"
"  Buffers: shared hit=6 read=79"
"Planning:"
"  Buffers: shared hit=4"
"Planning Time: 0.327 ms"
"Execution Time: 5.921 ms"

CREATE TABLE t_big_random AS SELECT * FROM t_big ORDER BY random();

SELECT * FROM t_big_random;

CREATE INDEX idx_t_big_random_id
ON t_big_random (id);

EXPLAIN (ANALYZE true, BUFFERS true, TIMING true)
SELECT * FROM t_big_random WHERE id < 10000;
"Bitmap Heap Scan on t_big_random  (cost=202.66..18375.43 rows=10610 width=9) (actual time=4.241..141.373 rows=9999 loops=1)"
"  Recheck Cond: (id < 10000)"
"  Heap Blocks: exact=8038"
"  Buffers: shared hit=901 read=7167"
"  ->  Bitmap Index Scan on idx_t_big_random_id  (cost=0.00..200.00 rows=10610 width=0) (actual time=2.777..2.778 rows=9999 loops=1)"
"        Index Cond: (id < 10000)"
"        Buffers: shared hit=3 read=27"
"Planning:"
"  Buffers: shared hit=22 read=4"
"Planning Time: 2.508 ms"
"Execution Time: 142.980 ms"

VACUUM ANALYZE t_big_random;

EXPLAIN (ANALYZE true, BUFFERS true, TIMING true)
SELECT * FROM t_big_random WHERE id < 10000;
"Bitmap Heap Scan on t_big_random  (cost=189.46..17818.17 rows=9939 width=9) (actual time=6.049..17.561 rows=9999 loops=1)"
"  Recheck Cond: (id < 10000)"
"  Heap Blocks: exact=8038"
"  Buffers: shared hit=8068"
"  ->  Bitmap Index Scan on idx_t_big_random_id  (cost=0.00..186.97 rows=9939 width=0) (actual time=3.404..3.404 rows=9999 loops=1)"
"        Index Cond: (id < 10000)"
"        Buffers: shared hit=30"
"Planning:"
"  Buffers: shared hit=12"
"Planning Time: 0.296 ms"
"Execution Time: 18.585 ms"

SELECT
	tablename,
	attname,
	correlation
FROM pg_stats
WHERE
	tablename IN ('t_big', 't_big_random')
ORDER BY 1, 2;

--#####################################################################
-- Try using index only scan

EXPLAIN ANALYZE SELECT * FROM t_big WHERE id = 123456;
-- 0.128ms + 0.047ms

EXPLAIN ANALYZE SELECT id FROM t_big WHERE id = 123456;
-- 0.122ms + 0.046ms

--#####################################################################
-- Partial Index:

-- Improves the performance of the query while reduce the index size.

-- SYNTAX:
-- CREATE INDEX index_name ON table_name
-- WHERE conditions;

-- Ex:
SELECT
	pg_size_pretty(pg_indexes_size('t_big'));
-- 112MB

CREATE INDEX idx_p_t_big_name
ON t_big(name)
WHERE name NOT IN ('Adam', 'Karan');

EXPLAIN ANALYZE SELECT * FROM t_big
WHERE
	name = 'Adam1' OR name = 'Karan1';
"Index Scan using idx_p_t_big_name on t_big  (cost=0.12..8.14 rows=1 width=9) (actual time=0.007..0.007 rows=0 loops=1)"
"  Filter: ((name = 'Adam1'::text) OR (name = 'Karan1'::text))"
"Planning Time: 2.194 ms"
"Execution Time: 0.028 ms"	

-- Ex:
SELECT * FROM customers;

UPDATE customers
SET is_active = 'N'
WHERE
	customer_id IN ('ALFKI', 'ANATR');

EXPLAIN ANALYZE
SELECT customer_id, is_active
FROM customers
WHERE is_active = 'N';

-- Before creating partial index:
"Seq Scan on customers  (cost=0.00..3.14 rows=1 width=134) (actual time=0.069..0.070 rows=2 loops=1)"
"  Filter: ((is_active)::text = 'N'::text)"
"  Rows Removed by Filter: 89"
"Planning Time: 0.132 ms"
"Execution Time: 0.089 ms"

DROP INDEX IF EXISTS idx_p_customers_is_active;
CREATE INDEX  idx_p_customers_is_active 
ON customers (is_active)
WHERE is_active = 'N';

-- After creating partial index:
"Seq Scan on customers  (cost=0.00..3.14 rows=1 width=134) (actual time=0.072..0.073 rows=2 loops=1)"
"  Filter: ((is_active)::text = 'N'::text)"
"  Rows Removed by Filter: 89"
"Planning Time: 2.097 ms"
"Execution Time: 0.094 ms"

--#####################################################################
-- Expression Index:

-- Index created based on an expression
-- They are vey expensive indexes

-- SYNTAX:
-- CREATE INDEX index_name
-- ON table_name (expression);

CREATE TABLE t_dates AS
SELECT d, REPEAT(md5(d::TEXT), 10) AS padding
FROM
	generate_series(timestamp '1800-01-01',
					timestamp '2100-01-01',
					interval '2 day') AS s(d);

VACUUM t_dates;

SELECT * FROM t_dates;

EXPLAIN ANALYZE SELECT * FROM t_dates WHERE d BETWEEN '2001-01-01' AND '2001-01-31';

CREATE INDEX idx_t_dates_d
ON t_dates (d);

EXPLAIN ANALYZE SELECT * FROM t_dates
WHERE EXTRACT(day FROM d) = 1;

CREATE INDEX idx_expr_t_dates_d
ON t_dates (EXTRACT(day FROM d));

ANALYZE t_Dates;

EXPLAIN ANALYZE SELECT * FROM t_dates
WHERE EXTRACT(day FROM d) = 1;

--#####################################################################
-- Adding Data While Indexing:

-- SYNTAX:
-- CREATE INDEX CONCURRENTLY

CREATE INDEX CONCURRENTLY idx_t_big_name2 ON t_big (name);

SELECT
	OID,
	RELNAME,
	RELPAGES,
	RELTUPLES,
	I.INDISUNIQUE,
	I.INDISCLUSTERED,
	I.INDISVALID,
	PG_CATALOG.PG_GET_INDEXDEF (I.INDEXRELID, 0, TRUE)
FROM
	PG_CLASS AS C
	JOIN PG_INDEX AS I ON C.OID = I.INDRELID
WHERE
	C.RELNAME = 't_big';

--#####################################################################
-- Invalidating an index:

-- List view all indexes for a table
SELECT
	OID,
	RELNAME,
	RELPAGES,
	RELTUPLES,
	I.INDISUNIQUE,
	I.INDISCLUSTERED,
	I.INDISVALID,
	PG_CATALOG.PG_GET_INDEXDEF (I.INDEXRELID, 0, TRUE)
FROM
	PG_CLASS AS C
	JOIN PG_INDEX AS I ON C.OID = I.INDRELID
WHERE
	C.RELNAME = 'orders';

EXPLAIN SELECT * FROM orders WHERE ship_country = 'USA';

CREATE INDEX idx_orders_ship_country ON orders (ship_country);

UPDATE pg_index
SET indisvalid = FALSE
WHERE indexrelid = (
	SELECT oid	FROM pg_class
	WHERE relkind = 'i'
	AND relname = 'idx_orders_ship_country'
);

--#####################################################################
-- Rebulding a index:

-- SYNTAX:
-- REINDEX [ (VERBOSE) ] {INDEX | TABLE | SCHEMA | DATABASE | SYSTEM} [CONCURRENTLY] name;

REINDEX INDEX idx_orders_customer_id_order_id;


REINDEX (VERBOSE) INDEX idx_orders_customer_id_order_id;


REINDEX (VERBOSE) TABLE orders;


REINDEX (VERBOSE) SCHEMA public;


REINDEX (VERBOSE) DATABASE northwind;


BEGIN
	REINDEX INDEX
	REINDEX TABLE
END


REINDEX (VERBOSE) TABLE CONCURRENTLY orders;