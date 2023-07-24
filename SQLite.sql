CREATE TABLE appstore_description_combined AS
SELECT * from appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
union ALL
select * from appleStore_description3
UNION ALL
select * FROM appleStore_description4


-- CHECK FOR UNIQUE APPS

Select count(DISTINCT id) as UniqueAppIDs
FROM AppleStore

SELECT count(distinct id) as UniqueAppIds
from appstore_description_combined


-- CHECK FOR MISSING VALUES

Select count(*) as MissingValues
from AppleStore
where track_name is NULL or user_rating is NULL OR prime_genre is NULL

Select count(*) as MissingValues
from appstore_description_combined
where app_desc is NULL


-- FIND NUMBER OF APPS PER GENRE 

select prime_genre, count(*) as NumApps
from AppleStore
GROUP BY prime_genre
order by NumApps DESC


-- OVERVIEW OF APPS RATING 
SELECT min(user_rating) as MinRating
	   max(user_rating) as MaxRating
       avg(user_rating) as AvgRating
from AppleStore


-- GET DISTRIBUTION OF APP PRICES 

SELECT
	(price/2) *2 as PriceBinStart,
    ((price/2) *2)+2 as PriceBinEnd,
    count(*) as NumApps
from AppleStore
group by PriceBinStart
Order By PriceBinStart

--  DETERMINE WHETHER PAID APPS HAVE HIGHER RATINGS THAN FREE APPS

SELECT CASE
			WHEN price > 0 then 'paid'
            else 'Free'
	   end as AppType,
       avg(user_rating) as AvgRating
from AppleStore
group by AppType


-- CHECK WHETHER APPS WITH MORE LANGUAGES HAVE HIGHER RATINGS 

SELECT CASE
			when lang_num < 10 then 'Less Than 10 Languages'
            when lang_num between 10 and 30 then '10 To 30 Languages'
            else 'More Than 30 Languages'
       END as LanguageBucket,
       avg(user_rating) as Avg_Rating
from AppleStore
GROUP by LanguageBucket
ORDER by Avg_Rating DESC


-- CHECK GENRES WITH LOW RATING 

select prime_genre, avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC
limit 10

-- CHECK IF THERE IS ANY RELATION BETWEEN LENGTH OF THE APP DESCRIPTION AND THE USER RATING

SELECT case
			when length(b.app_desc) < 500 then 'Short'
            when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
            else 'Long'
       end as description_length_bucket,
       avg(a.user_rating) as Avg_Rating
from 
	AppleStore as a 
JOIN
	appstore_description_combined as b 
ON
	a.id = b.id
GROUP by description_length_bucket
order by Avg_Rating DESC


-- CHECK TOP RATED APPS FOR EACH GENRE
		-- used window function 
        
SELECT
		prime_genre,
        track_name,
        user_rating
FROM (
  		select
  		prime_genre,
        track_name,
        user_rating,
        RANK() OVER(PARTITION BY prime_genre order by user_rating DESC, rating_count_tot DESC) as Rank
  		from 
  		AppleStore 
   ) as a
   WHERE 
   		a.Rank = 1