/*
TASK: SqlPriceChanges
================================================================================
DESCRIPTION:
You are given a table containing price updates for various products. Write a 
query that lists all articles whose price increased with every update.

TABLE STRUCTURE:
----------------
create table price_updates (
    product varchar not null,
    date date not null,
    price int not null,
    unique(product, date)
);

REQUIREMENTS:
- A product is included only if it has MORE than one price update.
- Every update (ordered by date) must show a price strictly greater than 
  the previous update.
- The result should be a table with one column: 'product'.
- Sort the results alphabetically.

EXAMPLES:
---------
- 'banana' (1, 2) -> Included (strictly increased).
- 'cheese' (1) -> NOT included (only one entry, no "change" to determine).
- 'potatoes' (3, 3) -> NOT included (price stayed the same).
- 'board game' (10, 15, 12) -> NOT included (decreased at the end).
================================================================================

-- EXACT TEST CASE 1: Mixed outcomes
TRUNCATE TABLE price_updates;
INSERT INTO price_updates (product, date, price) VALUES 
('banana [single]', '2020-01-21', 1),
('banana [single]', '2020-01-22', 2),
('cheese', '2020-01-23', 1),
('potatoes [pack]', '2020-01-21', 3),
('potatoes [pack]', '2020-01-30', 3);
-- Expected Result: banana [single]

-- EXACT TEST CASE 2: Multi-step increases vs. dips
TRUNCATE TABLE price_updates;
INSERT INTO price_updates (product, date, price) VALUES 
('board game', '2021-03-31', 10),
('board game', '2021-04-05', 15),
('board game', '2021-04-10', 12),
('book', '2021-03-31', 10),
('book', '2021-04-05', 15),
('T-shirt', '2021-03-31', 10),
('T-shirt', '2021-04-05', 15);
-- Expected Result: book, T-shirt
*/

/*
-- MY QUERY 1
WITH price_update_summary AS
(
  SELECT
      product,
      date,
      price,
      LEAD(price,1) OVER (PARTITION BY product ORDER BY date) AS next_price,
      CASE 
          WHEN price <  LEAD(price,1) OVER (PARTITION BY product ORDER BY date) THEN 'increased'
          WHEN price = LEAD(price,1) OVER (PARTITION BY product ORDER BY date) THEN 'unchanged'
          WHEN price > LEAD(price,1) OVER (PARTITION BY product ORDER BY date) THEN 'decreased'
      ELSE 'no next update' END AS price_update_category
  FROM price_updates
)
SELECT
	product,
    STRING_AGG(price_update_category, ', ' ORDER BY date)
FROM price_update_summary
GROUP BY product
HAVING 
  STRING_AGG(price_update_category, ', ' ORDER BY date) NOT LIKE '%unchanged%'
  AND STRING_AGG(price_update_category, ', ' ORDER BY date) NOT LIKE '%decreased%'
  AND STRING_AGG(price_update_category, ', ' ORDER BY date) <> 'no next update'
  AND STRING_AGG(price_update_category, ', ' ORDER BY date) LIKE '%increased%'
  
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
