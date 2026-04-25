/*
TASK: SqlPriceChanges
================================================================================
You are given an SQL table containing changes in prices of articles in a shop of following structure:

price_updates:
 product  | varchar
 date     | date
 price    | int

Write an SQL query which lists all articles whose price increased with every update.

Examples:

1. Given the table:
 product          | date       | price
------------------+------------+-------
 banana [single]  | 2020-01-21 | 1
 banana [single]  | 2020-01-22 | 2
 cheese           | 2020-01-23 | 1
 potatoes [pack]  | 2020-01-21 | 3
 potatoes [pack]  | 2020-01-30 | 3

Your query should return:
 product
------------------
 banana [single]

Note that the price of "cheese" was entered only once, so there was not enough data to determine whether it was increasing.

2. Given the table:
 product    | date       | price
------------+------------+-------
 board game | 2021-03-31 | 10
 board game | 2021-04-05 | 15
 board game | 2021-04-10 | 12
 book       | 2021-03-31 | 10
 book       | 2021-04-05 | 15
 T-shirt    | 2021-03-31 | 10
 T-shirt    | 2021-04-05 | 15

Your query should return:
 product
---------
 T-shirt
 book

Assume that:
- key (product, date) is unique, that is each product can change in price at most once a day;
- column price contains only positive values.

*/

-- MY QUERY 2

WITH price_update_summary AS
(
  SELECT
  	product,
  	price,
  	LAG(price,1) OVER(PARTITION BY product ORDER BY date) AS prev_price,
  COUNT(*) OVER (PARTITION BY product) AS update_count
  FROM price_updates
)
SELECT 
	product
FROM price_update_summary
WHERE update_count > 1
GROUP BY product
HAVING BOOL_AND (prev_price < price OR prev_price IS NULL)
