-- Natural Join

-- A natural join is a join that creates an implicit join based on the same column 
-- in the joined tables.
-- A natural join can be an inner join, left join, or right join.
-- If you do not specify a join explicitly, then PostgreSQL wilt use the INNER JOIN by default.

-- SELECT
-- 	col_list,
-- 	...
-- FROM t1
-- NATURAL [INNER< LEFT, RIGHT] JOIN ON t2;

SELECT
	*
FROM table_left_products t1
NATURAL JOIN table_right_products t2;