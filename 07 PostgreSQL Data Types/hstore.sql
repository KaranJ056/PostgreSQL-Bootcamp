-- hstore Data Type

-- Stores data into key value-pairs
-- hstore module implements this data type
-- Key-Value pairs are only text strings only

CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE table_hstore (
	book_id SERIAL PRIMARY KEY,
	title VARCHAR(30) NOT NULL,
	book_info hstore
);

INSERT INTO table_hstore (title, book_info)
VALUES
(
	'TITLE1',
	'
		"publisher" => "ABC",
		"paper-cost" => "10.00",
		"e-cost" => "5.85"
	'
),
(
	'TITLE2',
	'
		"publisher" => "XYZ",
		"paper-cost" => "12.00",
		"e-cost" => "3.85"
	'
);

SELECT * FROM table_hstore;

SELECT 
	title,
	book_info ['e-cost'],
	book_info ['publisher']
FROM table_hstore;

SELECT 
	title,
	book_info -> 'e-cost',
	book_info -> 'Publisher'
FROM table_hstore;

