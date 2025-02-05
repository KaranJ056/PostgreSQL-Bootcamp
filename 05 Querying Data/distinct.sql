-- Selecting distinct values from table 

-- SYNTAX: 
-- SELECT DISTINCT col_name FORM table_name;

SELECT
	movie_lang "Language"
FROM movies;

SELECT
	DISTINCT movie_lang "Language"
FROM movies
ORDER BY
	"Language";