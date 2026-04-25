/*
TASK: SqlBitcoinSpikes
You are given a table prices with the following structure:

create table prices (
    day integer NOT NULL UNIQUE,
    price integer NOT NULL
);

It represents average bitcoin price per day for a period of time. All days from the range [1..number of rows] occur at some point in the day column. The data isn't necessarily ordered by any column.

Your task is to find anomalies in bitcoin prices during this period of time. More specifically, you are asked to find days when the price spiked (days on which the price was strictly larger than on the day before and the day after). The first day and last day can never be spikes.

Write an SQL query that returns the days when the bitcoin price spiked. Rows should be ordered in increasing order by "day".

Examples:

1. Given:

+-------+-----------+
|  day  |   price   |
+-------+-----------+
|   1   |     1     |
|   2   |     2     |
|   3   |     2     |
|   4   |     2     |
|   5   |     1     |
|   6   |     2     |
|   7   |     1     |
+-------+-----------+

your query should return:

+-------+
|  day  |
+-------+
|   6   |
+-------+

This is the only day when the price went up after the day before and dropped the day after.

2. Given:

+-------+-----------+
|  day  |   price   |
+-------+-----------+
|   1   |     1     |
|   2   |     3     |
|   3   |     5     |
|   4   |    10     |
|   5   |    20     |
+-------+-----------+

your query should return an empty table. The prices are continually increasing, so there are no spikes.

3. Given:

+-------+-----------+
|  day  |   price   |
+-------+-----------+
|   4   |     2     |
|   5   |     1     |
|   3   |     1     |
|   1   |     1     |
|   2   |     5     |
+-------+-----------+

your query should return:

+-------+
|  day  |
+-------+
|   2   |
|   4   |
+-------+

Notice that days in the returned table are sorted in increasing order.

*/
-- MY QUERY
WITH price_comparison AS (
  SELECT 
    day,
    price,
    LAG (price,1) OVER (ORDER BY day) AS prev_price,
    LEAD (price,1) OVER (ORDER BY day) AS next_price
  FROM prices
) 
SELECT
	day
FROM price_comparison
WHERE price > prev_price AND price > next_price
ORDER BY day