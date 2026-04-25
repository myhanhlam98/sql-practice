/*
TASK: SqlRecommendations
================================================================================
You are given a table of people's opinions about places in a city:

create table opinions (
    id int not null primary key,
    place varchar(255) not null,
    opinion varchar(255) not null
);

Each row contains a place's name and an opinion about it, which is either recommended or not recommended. Your task is to generate a list of the recommended places. It should be a table with one column (named place), containing the names of the places which have strictly more recommended than not recommended opinions. The names in the returned table should appear in alphabetical order. Assume that in alphabetical order, the space character is lower than any letter, as it is by default in SQL.

Examples:

1. Given table opinions:

id | place         | opinion
---+---------------+----------------
 1 | mount nawo oz | recommended
 2 | mount nawo oz | not recommended
 3 | codility      | recommended
 4 | codility      | recommended
 5 | codility      | recommended
 6 | qr week       | recommended
 7 | qr week       | not recommended
 8 | cafe worst    | not recommended
 9 | mount nawo oz | recommended

your query should return:

place
-------------
codility
mount nawo oz

2. Given table opinions:

id | place      | opinion
---+------------+----------------
 1 | cafe best  | recommended
 2 | cafe bad   | recommended
 3 | cafe worst | not recommended
 4 | cafe bad   | not recommended
 5 | cafe bad   | not recommended

your query should return:

place
---------
cafe best

Assume that:
- column opinion contains only values recommended and/or not recommended;
- values in column place consist only of small english letters and spaces.

*/

-- MY QUERY

WITH place_recommendation_summary AS
(
  	SELECT
  		place,
  		SUM(CASE WHEN opinion = 'recommended' THEN 1 ELSE 0 END) AS recommended_count,
  		SUM(CASE WHEN opinion = 'not recommended' THEN 1 ELSE 0 END) AS not_recommended_count
  	FROM opinions
  GROUP BY place
 )
SELECT DISTINCT place
FROM place_recommendation_summary
WHERE recommended_count > not_recommended_count