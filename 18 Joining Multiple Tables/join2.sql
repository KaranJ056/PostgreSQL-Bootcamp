-- CROSS JOIN

-- In a CROSS JOIN query, the result also known as a Cartesian product tines up each row in the left table
-- with each row in the right table to present all possible combinations of rows.

-- CROSS JOIN doen't have a join predicate.
-- Means no need to define ON clause

-- Ex:
SELECT
	*
FROM table_left_products
CROSS JOIN table_right_products;

-- Equivalent to above is following:
SELECT
	*
FROM table_left_products, table_right_products;

SELECT
	*
FROM table_left_products,
INNER JOIN table_right_products ON True;

-- APPEND tables with different cols

CREATE TABLE table_1 (
	add_date DATE DEFAULT CURRENT_DATE,
	col1 INT,
	col2 INT,
	col3 INT
);

CREATE TABLE table_2 (
	add_date DATE DEFAULT CURRENT_DATE,
	col1 INT,
	col2 INT,
	col3 INT,
	col4 INT,
	col5 INT
);

INSERT INTO table_1 (col1, col2, col3)
VALUES
(1,2,3),
(4,67,32);

INSERT INTO table_2 (col1, col2, col3, col4, col5)
VALUES
(234,45,123,53,124),
(123,346,123,454,123);

SELECT 
	COALESCE(t1.add_date, t2.add_date),
	COALESCE(t1.col1, t2.col1),
	COALESCE(t1.col2, t2.col2),
	COALESCE(t1.col3, t2.col3),
	t2.col4,
	t2.col5
FROM table_1 t1
FULL OUTER JOIN table_2 t2 USING (add_date);