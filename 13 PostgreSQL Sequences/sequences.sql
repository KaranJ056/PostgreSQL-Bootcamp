-- SEQUENES => ORDERED LIST OF INTEGERS

-- 1. CREATE A SEQUENCE
CREATE SEQUENCE IF NOT EXISTS test_seq;
CREATE SEQUENCE test_seq;

-- 2. ADVANCE SEQUENCE AND RETURN VALUE
SELECT nextval('test_seq');

-- 3. RETURN MOST CURRENT VAALUE OF THE SEQ
SELECT currval('test_seq');

-- 4. SET A SEQ
SELECT setval('test_seq', 10);

-- 5. SET A SEQ AND DON'T SEP OVER
SELECT setval('test_seq', 200, false);

-- 6. CONTROL THE START VAL OF A SEQUENCE
-- CREATE SEQUENCE IF NOT EXISTS name START WITH value
-- CREATE SEQUENCE name START WITH value

-- 7. USE MULTIPLE SEQ PARAS TO CREATE A NEW SEQ
-- CREATE SEQUENCE name
-- START WITH value
-- INCREMENT BY step
-- MINVALUE value
-- MAXVALUE value
-- CYCLE | NO CYCLE

-- 8. ALTER A SEQUENCE
-- ALTER SEQUENCE seq_name RESTART WITH val
-- ALTER SEQUENCE seq_name RENAME TO new_seq_name

-- 9. DROP/DELETE A SEQ
--  DROP SEQUENCE seq_name;

-- 10. CREATE SEQ WITH A SPECIFIC DATA TYPE
-- CREATE SEQUENCE IF NOT EXISTS seq_name AS DATA_TYPE_NAME
-- CREATE SEQWUENCE seq_name AS DATA_TYPE_NAME

-- 11. CREATINH A DESCENDING SEQ WITH CYCLE|NO CYCLE
CREATE SEQUENCE test_seq2 
INCREMENT BY -1
MINVALUE 1
MAXVALUE 4
START WITH 4
CYCLE;

SELECT nextval('tesT_seq2');

-- 12. ATTACH A SEQ TO A TABLE
-- ATTACH TO AN EXISTING TABLE

CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50)
);

INSERT INTO users (username) VALUES ('Karan'), ('kaskla');

SELECT * FROM users;

ALTER SEQUENCE users_user_id_seq RESTART WITH 100;

-- STEP1: CREATE A SEQ AND ATTACH TO A TABLE
-- CREATE SEQUENCE se1_name
-- START WITH value OWNED BY table_name.col_name

-- STEP2: ALTER TABLE COLUMN AND SET SEQ
-- ALTER TABLE table_name
-- ALTER COLUMN col_name SET DEFAULT nextval(seq_name)

CREATE TABLE table_users (
	user_id INT PRIMARY KEY,
	username VARCHAR(100)
);

CREATE SEQUENCE table_users_user_id_seq
START WITH 100
OWNED BY table_users.user_id;

ALTER TABLE table_users
ALTER COLUMN user_id SET DEFAULT nextval('table_users_user_id_seq');

INSERT INTO table_users (username)
VALUES ('Karan'), ('sdhajks');

SELECT * FROM table_users;

-- 13. List all SEQ OF A DATABASE
SELECT
	RELNAME SEQUENCQ_NAME
FROM
	PG_CLASS
WHERE
	RELKIND = 'S';

-- 14. SHARE SINGLE SEQ B/W MULTIPLE TABLE
CREATE SEQUENCE common_fruit_seq START WITH 100;

CREATE TABLE apples (
	fruit_id INT DEFAULT nextval('common_fruit_seq') NOT NULL,
	fruit_name VARCHAR(20)
);

CREATE TABLE mangoes (
	fruit_id INT DEFAULT nextval('common_fruit_seq') NOT NULL,
	fruit_name VARCHAR(20)
);

INSERT INTO apples (fruit_name) VALUES ('Kashmiri Apples'), ('Bengali Apples');

INSERT INTO mangoes (fruit_name) VALUES ('Kesar Mangoes'), ('Hafus Mangoes');

SELECT * FROM apples;
SELECT * FROM mangoes;


--##########################################################################

-- CREATE AN ALPHANUMERIC SEQUENCES

-- BY DEFAULT SEQ ARE CONSISTS OF NUMBERS

CREATE SEQUENCE table_seq;

CREATE TABLE contacts (
	contact_id TEXT NOT NULL DEFAULT ('ID' || nextval('table_seq')),
	contact_name VARCHAR(20),
	contact_number NUMERIC
);

ALTER SEQUENCE table_seq OWNED BY contacts.contact_id;

INSERT INTO contacts (contact_name, contact_number)
VALUES
('jsaja', 34189237),
('sjsja', 34283953);

SELECT * FROM contacts;