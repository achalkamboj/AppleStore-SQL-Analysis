# AppleStore-SQL-Analysis

## Analysis of the Apple Store dataset to derive powerful insights.

### Language Used
SQL

## About The Dataset
There are two datasets:
1. **Applestore dataset** contains:
   - id: Shows the unique id of the app.
   - track_name: Name of the app.
   - size_bytes: Size of the app in bytes.
   - currency: Currency of the app's price.
   - price: Price of the app.
   - rating_count_tot: Total rating count.
   - user_rating: Rating of the app.
   - ver: Version of the app.
   - prime_genre: Prime genre of the app.
   - sup_devices_num: Number of supported devices.
   - lang_num: Number of supported languages.
   - etc.

2. **Apple store description** contains:
   - id: Id of the app.
   - track_name: Name of the app.
   - size_bytes: Size of the app.
   - app_desc: Description of the app.
   - etc.

## Identify the stakeholders
Stakeholders in this analysis are the aspiring app developers who need data-driven insights to decide what type of app to build. We will answer questions like:
1. What app categories are more popular?
2. What price should I set?
3. How can I maximize user ratings?

## Exploratory Data Analysis
Exploratory data analysis helped me to analyze characteristics and structure of the data, and it also often revealed issues in the dataset that needed to be addressed before further analysis. Issues might include missing or inconsistent data, errors, and outliers. Identifying these issues saved me a lot of time and effort in the later stages of analysis.
 

1)HECK FOR UNIQUE APPS:-
To check if we are dealing with the same apps in both the datasets. A discrepancy could mean missing data in either of the two tables.

The code:- 
```

Select count(DISTINCT id) as UniqueAppIDs
FROM AppleStore

```

Output:- 
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/3ed7711e-a4c9-476c-a548-5f685d5e28c7)


```

SELECT count(distinct id) as UniqueAppIds
from appstore_description_combined

```

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/e0b161d5-08dc-4962-ac21-413bfca2cbd1)

There are 7197 apps in both the tables.

2)CHECK FOR MISSING VALUES:-

```

Select count(*) as MissingValues
from AppleStore
where track_name is NULL or user_rating is NULL OR prime_genre is NULL

```

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/dd42b3d3-725b-4173-9b83-0946cbf0b680)

```

Select count(*) as MissingValues
from appstore_description_combined
where app_desc is NULL

```

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/0e7d883b-099e-43b2-8a1d-df632ecb9786)

There are no missing values in any of the dataset.

3)FIND NUMBER OF APPS PER GENRE:-

```

select prime_genre, count(*) as NumApps
from AppleStore
GROUP BY prime_genre
order by NumApps DESC

```

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/3ced97d6-4dca-41a1-8a95-8a6ab8710a65)
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/a41c3eb7-fc90-4ece-bc47-2588efe13f71)

We can see that gams and Entertainment are the dominant app categorie.

4)OVERVIEW OF APPS RATING 

```

SELECT min(user_rating) as MinRating,
	     max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore


```

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/42aaf9a5-67a6-4bae-8ead-4ddfff31526c)


5) GET DISTRIBUTION OF APP PRICES :-

      ````

      SELECT
	(price/2) *2 as PriceBinStart,
    ((price/2) *2)+2 as PriceBinEnd,
    count(*) as NumApps
from AppleStore
group by PriceBinStart
Order By PriceBinStart

```

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/c3b3a563-aa17-4dc8-86a6-6c5abf94d0b9)


# Finding the insights:-

1) DETERMINE WHETHER PAID APPS HAVE HIGHER RATINGS THAN FREE APPS

```

SELECT CASE
			WHEN price > 0 then 'paid'
            else 'Free'
	   end as AppType,
       avg(user_rating) as AvgRating
from AppleStore
group by AppType

```

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/06ade68b-1539-4340-a723-ce8fe7622de9)

We can see that on an average, the rating of paid apps os slightly higher than free apps.

2)CHECK WHETHER APPS WITH MORE LANGUAGES HAVE HIGHER RATINGS 

```

SELECT CASE
			when lang_num < 10 then 'Less Than 10 Languages'
            when lang_num between 10 and 30 then '10 To 30 Languages'
            else 'More Than 30 Languages'
       END as LanguageBucket,
       avg(user_rating) as Avg_Rating
from AppleStore
GROUP by LanguageBucket
ORDER by Avg_Rating DESC

````

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/6ffb39c6-6d5e-41be-a5af-55e27db552fb)

We can see that the apps with 10-30 languages have higher average user rating.

3)CHECK GENRES WITH LOW RATING

```


select prime_genre, avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC
limit 10

```

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/5ca83ab9-2ea5-47d0-ab70-7a5398e5f38a)

The top 3 categories with poor ratings are Catalogue, Finance and Books.
This means that app developers have good opportunity to build an app in this space.

4)CHECK IF THERE IS ANY RELATION BETWEEN LENGTH OF THE APP DESCRIPTION AND THE USER RATING

```

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

```

Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/096f4f7f-1e4e-4d01-9a02-dff4fa092793)

We can see that the longer the description, the better is the user rating.

5)CHECK TOP RATED APPS FOR EACH GENRE:-

```

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

```
Output:-
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/7c9308b9-504a-462b-8293-d836cf398282)
![image](https://github.com/achalkamboj/AppleStore-SQL-Analysis/assets/82465596/119ddf41-6338-4551-ba42-3eca55cca1ef)

Shows all the apps with highest rating in every genre. App developers can build apps like these to achieve more engagement.


# Final Recommendations for the client:-

1)Users who pay for an app have higher chances of perceiving it of value, leading it to better ratings. Our client should charge a certain amount for the app.
2)Apps supporting between 10 and 30 languages have better ratings. Our Client should choose the right languages for the app.
3)User needs are not being met in the categories like finance and books because exixting apps have poor ratings. This can mean a market opportunity to create better app for market oenetration.
4)Apps with longer description have better ratings. Users appreciate having a clear underdtanding of the app's features before they download it. A carefully crafted description can increase customer satisfaction and result in better app ratings.
5)Avg rating is 3.5 and client should aim for a rating above it.
5)Games and entertainment have a very high volume of apps suggesting that the market may be saturated. Entering these spaces might be challenging due to high competition however these apps might also have high user demand.





