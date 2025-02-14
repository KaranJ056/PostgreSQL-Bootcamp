-- Using Stock Markets Data

-- Select first or last 10 records from a table:
SELECT
	*
FROM 
	stocks_prices
LIMIT 10;

-- Using offset:
SELECT
	*
FROM 
	stocks_prices
FETCH FIRST 10 ROWS ONLY;

SELECT
	*
FROM 
	stocks_prices
ORDER BY price_id DESC
FETCH FIRST 10 ROWS ONLY;

-- Get first and last record for each group
SELECT
	symbol_id,
	MIN(price_date),
	MAX(price_date)
FROM 
	stocks_prices
GROUP BY 
	symbol_id
ORDER BY 1;

-- How to calculate cube root in PostgreSQL?
SELECT 
	CBRT(27);

SELECT 
	close_price,
	CBRT(close_price)
FROM 
	stocks_prices
ORDER BY 1 DESC;

