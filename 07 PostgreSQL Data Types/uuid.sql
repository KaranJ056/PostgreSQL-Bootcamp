-- UUID Data Type

-- Universal Unique Identifier
-- 128 bit qauntity generated by an algo. that make it unique in the known
-- universe using same algo
-- 32 digits, hex digits, seperated by -

-- UUID are much better than SERIAL as it generates unique id across syatems
-- To use/generate UUID we need to integrate third partt algo in PostgreSQL

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SELECT uuid_generate_v1();

SELECT uuid_generate_v4();

CREATE TABLE table_uuid (
	product_id UUID DEFAULT uuid_generate_v1(),
	product_name varchar(20) NOT NULL
);

INSERT INTO table_uuid (product_name)
VALUES
('Keyboard'),
('Mouse');

SELECT * FROM table_uuid;