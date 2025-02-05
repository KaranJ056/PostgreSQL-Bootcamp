CREATE TABLE IF NOT EXISTS customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(40),
	age INT
);

-- Insert data into a table 

INSERT INTO customers (first_name, last_name, email, age)
VALUES ('Karan', 'Joshi', 'kj123@gmail.com', 21);

-- Insert multiple data into a table

INSERT INTO customers (first_name, last_name, email, age)
VALUES 
('Deep', 'Dabhi', 'dd123@gmail.com', 20),
('P', 'T', 'pt123@gmail.com', 22),
('A', 'S', 'as123@gmail.com', 23);

-- Insert data with quotes into a table

INSERT INTO customers (first_name, last_name, email, age)
VALUES ('Bill''o', 'Sullivan', 'bs123@gmail.com', 34);


-- Insert data with RETURNING into a table

INSERT INTO customers (first_name)
VALUES ('Abhi') RETURNING *;

INSERT INTO customers (first_name)
VALUES ('Harsh') RETURNING customer_id;

-- Update data of a table

UPDATE customers 
SET email = 'ads@123gmail.com'
WHERE first_name = 'A';

UPDATE customers 
SET 
email = 'sad@123gmail.com',
age = 24
WHERE first_name = 'A'
RETURNING *;

-- Update all records of a table

UPDATE customers
SET is_enable = 'Y';

-- UPSERT 

-- 1. Idea is that if we inseert a data into a table using a UPSERT
--    It updates row if alredy exists
--    Otherwise it inserts data into a table

-- SYNTAX
-- INSERT INTO table_name (col_list)
-- VALUES (values_list)
-- ON CONFLICT target action; 

-- ON CONFLICT

-- 1. DO NOTHING
-- 2. DO UPDATE SET col_1 = val_1
--    WHERE condition

CREATE TABLE IF NOT EXISTS t_tags (
	id SERIAL PRIMARY KEY,
	tag TEXT UNIQUE,
	update_date TIMESTAMP DEFAULT NOW()
);

INSERT INTO t_tags (tag)
VALUES
('pen'),
('pencil');

SELECT * FROM t_tags;

-- Insert into a table on conflict do nothing

INSERT INTO t_tags (tag)
VALUES
('pen')
ON CONFLICT (tag) 
DO 
	NOTHING;

-- Insert into a table on conflict set new values

INSERT INTO t_tags (tag)
VALUES
('pen')
ON CONFLICT (tag)
DO 
	UPDATE SET 
		tag = EXCLUDED.tag,
		update_date = NOW();

SELECT * FROM t_tags;