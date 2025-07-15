
-- find the number of movie and tv shows
 SELECT
 type,
 COUNT(*) total_content
 FROM
 net
 GROUP BY type


 -- most common rating for movie and tv show
 SELECT
 type,
 rating
 FROM(
	 SELECT
	 type,
	 rating,
	 COUNT(rating) AS rating_count,
	 RANK() OVER (PARTITION BY type ORDER BY  COUNT(rating) DESC) AS ranks
	 FROM 
	 net
	WHERE rating IS NOT NULL
	 GROUP BY type,rating)t
WHERE ranks=1

--select all movie realsed on 2020
SELECT
*
FROM
net
WHERE type='movie' AND release_year=2020

--find the top 5 countrie with the most content on netflix

SELECT TOP 5
country,
COUNT(show_id) AS total_country_content
FROM
net
WHERE country IS NOT NULL 
GROUP BY country
ORDER BY COUNT(show_id) DESC

-- indetify the longest movie
SELECT
*
FROM net
WHERE type= 'movie'
AND duration= (SELECT MAX(duration) FROM net)


-- find content added in the last 5 years
SELECT*,
CONVERT(DATE, date_added, 107) AS converted_date
FROM net
WHERE CONVERT(DATE, date_added, 107) >=DATEADD(YEAR, -5, GETDATE())

-- find all movies/tv shows by director 'Rajiv Chilaka'
SELECT
*
FROM net
WHERE director  LIKE'%Rajiv Chilaka%'

-- All tv show with more than 5 seasons

SELECT *,
    duration,
    CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) AS season
FROM net
WHERE type='TV Show' AND LEFT(duration, CHARINDEX(' ', duration) - 1)>5 ;

-- find each yaer the average number of content released by india in netflix 
-- return top 5 years withe the highest averagecontent release
SELECT TOP 5
converted_date,
CAST(total_released AS FLOAT)/(SELECT COUNT(*) FROM net) AS avg_release_per_year
FROM(
SELECT 
COUNT(show_id) as total_released,
YEAR(CONVERT(DATE, date_added, 107)) AS converted_date
FROM net
WHERE country= 'India'
GROUP BY YEAR(CONVERT(DATE, date_added, 107))) AS t

-- list all movies that are documentaries
SELECT
*
FROM net
WHERE listed_in LIKE '%Documentaries%'

--find all content with no director
SELECT *
FROM net
WHERE director IS NULL


/*categorize the content based on the presence of the keywords 'kill' and 'violence'
in the description field.label the content containing the keywords as 'bad' and all other 
content as good.count how many items fall on each categories*/
SELECT
film_category,
COUNT(film_category) AS total_count
FROM
(SELECT *,
	CASE 
	WHEN description LIKE '%kill%' OR 
	description LiKE '%violence%' 
	THEN 'bad_film'
	ELSE 'good_film'
END film_category
FROM 
net) t
GROUP BY film_category
