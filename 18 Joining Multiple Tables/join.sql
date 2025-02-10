-- Joining Multiple Tables Via JOIN

-- SYNTAX:
/*
SELECT
	t1.col1,
	t2.col2,
	t3.col3
FROM t1
JOIN t2 ON t1.col1 = t2.col1
JOIN t3 ON t1.col2 = t3.col2
*/

-- Join movies, directors and movies_revenues tables
SELECT
	m.movie_name "Movie Name",
	
	d.first_name || ' ' || d.last_name "Director Name",
	
	COALESCE(r.revenues_domestic, 0) + COALESCE(r.revenues_international, 0) "Total Revenue"
FROM movies m
JOIN directors d USING (director_id)
JOIN movies_revenues r USING (movie_id)
ORDER BY 
	"Total Revenue" DESC;

-- Join actors, movies, movies_revenues, directors together

SELECT
	m.movie_name "Movie Name",

	d.first_name || ' ' || d.last_name "Director Name",

	COALESCE(r.revenues_domestic, 0) + COALESCE(r.revenues_international, 0) "Total Revenue",

	a.first_name || ' ' || a.last_name "Actor Name"

FROM actors a
JOIN movies_actors ma USING (actor_id)
JOIN movies m ON m.movie_id = ma.movie_id
JOIN directors d ON d.director_id = m.director_id
JOIN movies_revenues r ON m.movie_id = r.movie_id
ORDER BY
	"Movie Name";


-- Is JOIN same as INNER JOIN? YES