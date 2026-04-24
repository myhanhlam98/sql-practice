/*
TASK: SqlWarehouse
================================================================================
DESCRIPTION:
You are given two tables, 'warehouse' and 'orders'. 

- Table 'warehouse' contains exactly one row describing the total number of 
  available shirts in sizes: Small (S), Medium (M), and Large (L).
- Table 'orders' contains individual orders with a unique 'order_time' and the 
  number of shirts requested for each size (S, M, L).

BUSINESS RULES:
1. Orders must be completed in CHRONOLOGICAL order (by order_time).
2. An order can only be completed if there are enough products of EACH size 
   remaining in the warehouse to fulfill that specific order.
3. Once an order cannot be completed due to insufficient stock, all subsequent 
   orders are also considered incomplete (processing stops).

GOAL:
Write an SQL query that finds the 'order_time' of the FIRST order that CANNOT 
be completed. If all orders can be completed, the query should return NULL.

TABLE STRUCTURE:
----------------
CREATE TABLE warehouse (
    S integer NOT NULL,
    M integer NOT NULL,
    L integer NOT NULL
);

CREATE TABLE orders (
    order_time timestamp NOT NULL UNIQUE,
    S integer NOT NULL,
    M integer NOT NULL,
    L integer NOT NULL
);

EXAMPLE 1:
----------
Warehouse: S: 10, M: 15, L: 12
Orders:
- 10:00: (1,1,1)  -> OK
- 11:00: (2,3,4)  -> OK
- 12:00: (5,2,1)  -> OK
- 10:00 (Next Day): (1,1,4) -> OK
- 10:00 (Day after): (1,2,3) -> FAIL (Not enough Large shirts left)

Result: 2023-05-13 10:00:00
================================================================================
*/
WITH orders_running_totals AS
(
  SELECT
      *,
      SUM(S) OVER(ORDER BY order_time) AS running_sum_S,
      SUM(M) OVER(ORDER BY order_time) AS running_sum_M,
      SUM(L) OVER(ORDER BY order_time) AS running_sum_L
  FROM orders
),
orders_flag_unable_to_complete AS
(
  SELECT 
  *,
  CASE 
      WHEN running_sum_S > (SELECT S FROM warehouse) THEN 'X'
      WHEN running_sum_M > (SELECT M FROM warehouse) THEN 'X'
      WHEN running_sum_L > (SELECT L FROM warehouse) THEN 'X'
  ELSE '' END AS flag_unable_to_complete
  FROM orders_running_totals
)
SELECT
MIN(order_time) AS order_time
FROM orders_flag_unable_to_complete
WHERE flag_unable_to_complete = 'X'
ORDER BY order_time
LIMIT 1

