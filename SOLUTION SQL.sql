-- NETFLIX PROJECT
CREATE TABLE NetflixData
(
 show_id  VARCHAR(6),
 typeis	  VARCHAR(10),
 title	  VARCHAR(150),
 director VARCHAR(208),
 casts	  VARCHAR(1000),
 country  VARCHAR(150),
 date_added VARCHAR(50),
 release_year INT,
 rating VARCHAR(10),
 duration VARCHAR(15),
 listed_in VARCHAR(100),
 description VARCHAR(250)

);
SELECT * FROM netflixdata;

SELECT COUNT(*) as total 
FROM netflixdata;

SELECT DISTINCT typeis FROM netflixdata;



-- 15 BUSINESS PROBLEMS --

-- 1. count the number of movies vs tv shows

SELECT 
	typeis, 
	count(*) as total_content
FROM netflixdata
GROUP BY typeis;


-- 2. Find the most common rating for movies and TV shows

SELECT 
	typeis,
	rating
FROM
(SELECT 
	typeis,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY typeis ORDER BY COUNT (*) DESC) as ranking
FROM netflixdata
GROUP BY 1,2
) as t1
WHERE ranking = 1;


-- 3. List all the movies released in the year 2020

SELECT title
FROM netflixdata
WHERE typeis = 'Movie' AND release_year = 2020


-- 4. Find the top 5 Countries with most content on Netflix

SELECT 
	TRIM(UNNEST(STRING_TO_ARRAY(Country, ','))) as new_country,
	COUNT(show_id) 
FROM netflixdata
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- 5. IDENTIFY THE LONGEST MOVIE

select title,  substring(duration, 1,position ('m' in duration)-1)::int duration
from Netflixdata
where typeis = 'Movie' and duration is not null
order by 2 desc
limit 1


-- 6. Find content added in the last 5 years

SELECT *
FROM netflixdata
WHERE
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'


-- 7. Find all the movies and tv shows by director 'Binayak Das'

SELECT * FROM netflixdata
WHERE director ILIKE '%Rajiv Chilaka%'


-- 8. Find all the tv shows with more than 5 seasons

SELECT *
FROM netflixdata
WHERE 
	typeis = 'TV Show' AND
	SPLIT_PART(duration, ' ', 1)::Numeric > 5 


-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
	COUNT(show_id) AS totalshows
FROM netflixdata
GROUP BY 1


-- 10. Find each year and average numberr of contenr released by india on netflix. 
-- Return top 5 year with highest avg content released

SELECT 
	EXTRACT(YEAR FROM TO_DATE (date_added, 'Month DD, YYYY')) as date,
	COUNT(*)::numeric/(SELECT COUNT(*)FROM netflixdata WHERE country = 'India')* 100 :: numeric
FROM netflixdata
WHERE country = 'India'
GROUP BY 1


-- 11. List all the movies that are documentaries

SELECT * FROM netflixdata
WHERE listed_in ILIKE '%documentaries%'


-- 12. Find all content without a director

SELECT * FROM netflixdata 
WHERE director IS NULL


-- 13. find how many movies actor salman khan has appeared in the last 10 years

SELECT * FROM netflixdata
WHERE
	casts ILIKE '%Salman khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 14. find the top 10 actors who have appeared in the highest number of movies produced in INDIA

SELECT
	UNNEST(STRING_TO_ARRAY(casts,',')),
	COUNT(*) as total
FROM netflixdata
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


-- 15. Categorize the content based on the presence of the keywords 'kill' ans 'violence' in
-- the description field. Label content containing these keywords as 'Bad' and all other content as 'GOOD'
-- Count how many items fall into these categories.

With new_table AS 
(
SELECT 
*,
	CASE
	WHEN 
		description ILIKE '%Kill%' OR
		description ILIKE '%Violence' THEN 'BAD'
		ELSE 'Good'
	END category
FROM netflixdata
) 
SELECT 
	category,
	COUNT(*)as total_content 
FROM new_table
GROUP BY 1

