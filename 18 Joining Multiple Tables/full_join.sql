-- FULL JOINs in PostgreSQL

-- Returns all the data from table1 and table2

-- SYNTAX:
/*
SELECT
	t1.col1
	t2.col2
FROM t1
FULL JOIN t2 ON t1.col1 = t2.col2
*/

SELECT 
	*
FROM table_left_products
FULL JOIN table_right_products USING (prod_id);