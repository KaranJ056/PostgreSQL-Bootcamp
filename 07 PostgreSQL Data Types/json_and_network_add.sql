-- JSON Data Type

-- PpostgreSQL has complete built-in support for the json and complete
-- indexing options
-- JOSNB is a binary impplementation of JSON 

CREATE TABLE table_json (
	id SERIAL PRIMARY KEY,
	info json
);

INSERT INTO table_json (info) 
VALUES 
('[1,2,3,4,5,6]'),
('[2,3,4,5,6,7]'),
('{"key":"value"}');

SELECT * FROM table_json;

SELECT info FROM table_json;

ALTER TABLE table_json
ALTER COLUMN info TYPE jsonb;

SELECT * FROM table_json
WHERE info @> '2';

--#####################################################################

-- Network Address Data Types'

-- PostgreSQL offers to store IPv4, IPv6, and MAC addresses

-- cidr = 7/19 bytes = IPv4 and IPv6 networks
-- inet = 7/19 bytes = IPv4 and IPv6 hosts and networks
-- macaddr = 6 bytes = Mac Add
-- macaddr8 = 8 bytes = Mac Add [EUI-64 format]

-- better to use this instead of simple text types
-- it provides better storage and error checking
-- speacial sorting mechenism

CREATE TABLE table_netaddr (
	id SERIAL PRIMARY KEY,
	ip INET
);

INSERT INTO table_netaddr (ip)
VALUES
('4.35.221.243'),
('4.152.207.126'),
('4.152.207.238'),
('4.249.111.121'),
('12.1.223.132'),
('12.8.192.60');

SELECT * FROM table_netaddr;

SELECT 
	ip, 
	set_masklen(ip, 24) as ipnet_24
FROM table_netaddr;

SELECT 
	ip, 
	set_masklen(ip, 24) as ipnet_24,
	set_masklen(ip::cidr, 24) as cider_24
FROM table_netaddr;

SELECT 
	ip, 
	set_masklen(ip, 24) as ipnet_24,
	set_masklen(ip::cidr, 24) as cider_24,
	set_masklen(ip::cidr, 27) as cider_27,
	set_masklen(ip::cidr, 28) as cider_28
FROM table_netaddr;