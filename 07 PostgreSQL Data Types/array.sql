-- Array Data Type 

CREATE TABLE table_array (
	id SERIAL,
	name VARCHAR(20),
	phones text []
);

INSERT INTO table_array (name, phones)
VALUES
('Karan', ARRAY ['+91 83409 37489', '+91 32498 23489']),
('SK', ARRAY ['+91 83409 37423', '+91 33498 23489']);

SELECT * FROM table_array;

SELECT
	name,
	phones [1]	
FROM table_array;