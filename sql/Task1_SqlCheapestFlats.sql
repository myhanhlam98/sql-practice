/*
TASK: SqlFlats
================================================================================
DESCRIPTION:
You are given a table 'flats' where each row represents a flat located in a 
city available for sale for a given price.

TABLE STRUCTURE:
----------------
create table flats (
    id integer primary key,
    city varchar(40) not null,
    price integer not null
);

YOUR TASK:
Write an SQL query that, for each city, finds the three cheapest flats 
located in that city. 

REQUIREMENTS:
- In case of a tie, the query may return any three flats with the cheapest prices.
- If a city has less than three flats for sale, the result table should 
  contain all of them.
- Please use an OVER clause to simplify your solution.

OUTPUT SPECIFICATIONS:
- The result table should contain three columns: id, city, and price.
- The results should be sorted by the id column.

CONSTRAINTS / ASSUMPTIONS:
- The flats table has at most 100 rows.
- The price column contains integers from 1,000 to 10,000,000 inclusive.

EXAMPLE:
--------
Input: 
(25, 'London', 200000), (5, 'Cairo', 90000), (7, 'London', 200000), 
(18, 'Warsaw', 150000), (2, 'London', 178000), (3, 'Cairo', 300000), 
(21, 'London', 500000), (9, 'London', 200000)

Possible Output:
(2, 'London', 178000), (3, 'Cairo', 300000), (5, 'Cairo', 90000), 
(7, 'London', 200000), (9, 'London', 200000), (18, 'Warsaw', 150000)
================================================================================
*/
/* TEST CASES
INSERT INTO flats (id, city, price) VALUES 
(25, 'London', 200000),
(5, 'Cairo', 90000),
(7, 'London', 200000),
(18, 'Warsaw', 150000),
(2, 'London', 178000),
(3, 'Cairo', 300000),
(21, 'London', 500000),
(9, 'London', 200000);

*/
-- MY QUERY

SELECT
	id,
    city,
    price
FROM
(
  SELECT 
    id,
    city,
    price,
    ROW_NUMBER() OVER (PARTITION BY city ORDER BY price) AS price_rank
  FROM flats
)  a
WHERE price_rank <= 3
ORDER BY id
