/*
TASK: SqlBitcoinSpikes
================================================================================
DESCRIPTION:
Given a record of bitcoin prices, find days when the price was higher than 
the day before and the day after.

TABLE STRUCTURE:
----------------
create table prices (
    day integer NOT NULL UNIQUE,
    price integer NOT NULL
);

Your task is to find anomalies in bitcoin prices during this period of time. 
More specifically, you are asked to find days when the price spiked (days on 
which the price was strictly larger than on the day before and the day after). 

CONSTRAINTS:
------------
- The first day and last day can never be spikes.
- All days from the range [1..number of rows] occur at some point in the day column.
- The data isn't necessarily ordered by any column.

OUTPUT SPECIFICATIONS:
----------------------
- Return the days when the bitcoin price spiked.
- Rows should be ordered in increasing order by "day".

EXAMPLE 1:
----------
Input:
 day | price 
-----+-------
  1  |   1
  2  |   2
  3  |   2
  4  |   2
  5  |   1
  6  |   2
  7  |   1

Output:
 day 
-----
  6
(Note: Day 6 is the only day where the price went up after the day before 
and dropped the day after. Day 2 is not a spike because it is not strictly 
larger than day 3.)

EXAMPLE 2:
----------
Input: (Prices 1, 3, 5, 10, 20)
Output: Empty table (Prices are continually increasing).

EXAMPLE 3:
----------
Input: (Day 4:2, Day 5:1, Day 3:1, Day 1:1, Day 2:5)
Output: 2, 4 (Sorted in increasing order).
================================================================================
*/

/* TEST CASES
-- Expected Output: day 6
INSERT INTO prices (day, price) VALUES 
(1, 1),
(2, 2),
(3, 2),
(4, 2),
(5, 1),
(6, 2),
(7, 1);

-- Expected Output: Empty Table
INSERT INTO prices (day, price) VALUES 
(1, 1),
(2, 3),
(3, 5),
(4, 10),
(5, 20);

-- Expected Output: days 2 and 4 (sorted by day)
INSERT INTO prices (day, price) VALUES 
(4, 2),
(5, 1),
(3, 1),
(1, 1),
(2, 5);

-- Expected Output: Empty Table
INSERT INTO prices (day, price) VALUES 
(1, 10),
(2, 10),
(3, 5),
(4, 10),
(5, 10);

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