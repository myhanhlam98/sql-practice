/*
TASK: SqlWarehouse
================================================================================
You are given two tables, warehouse and orders, with the following structures:

  warehouse
  S integer NOT NULL
  M integer NOT NULL
  L integer NOT NULL

and

  orders
  order_time timestamp NOT NULL UNIQUE
  S          integer NOT NULL
  M          integer NOT NULL
  L          integer NOT NULL

Table warehouse contains exactly one row describing the number of available shirts in the corresponding sizes: small (S), medium (M) and large (L).

Each row of the table orders contains information about individual orders: the unique time the order was created (order_time) and the number of ordered shirts in the corresponding sizes: small (S), medium (M) and large (L). No two rows have the same order_time.

Orders will be completed in chronological order of their appearance as long as there are enough products of each size in the warehouse.

Write an SQL query that finds the time of the first order that cannot be completed. If all orders can be completed, return NULL.

Examples:

1. For the given tables warehouse:
+----+----+----+
| S  | M  | L  |
+----+----+----+
| 10 | 15 | 12 |
+----+----+----+

and orders:
+---------------------+---+---+---+
| order_time          | S | M | L |
+---------------------+---+---+---+
| 2023-05-10 10:00:00 | 1 | 1 | 1 |
| 2023-05-10 11:00:00 | 2 | 3 | 4 |
| 2023-05-10 12:00:00 | 5 | 2 | 1 |
| 2023-05-12 10:00:00 | 1 | 1 | 4 |
| 2023-05-13 10:00:00 | 1 | 2 | 3 |
| 2023-05-14 10:00:00 | 1 | 1 | 1 |
| 2023-05-14 11:00:00 | 1 | 1 | 1 |
+---------------------+---+---+---+

the query should return the following table:
+---------------------+
|                     |
+---------------------+
| 2023-05-13 10:00:00 |
+---------------------+

After the first four orders there is one small shirt, eight medium shirts and two large shirts left in the warehouse. In the fifth order, three large shirts are required. As there are only two remaining, this order cannot be completed.

2. For the given tables warehouse:
+---+---+---+
| S | M | L |
+---+---+---+
| 3 | 4 | 5 |
+---+---+---+

and orders:
+---------------------+---+---+---+
| order_time          | S | M | L |
+---------------------+---+---+---+
| 2023-04-10 12:50:00 | 2 | 1 | 4 |
| 2023-04-10 11:00:00 | 1 | 3 | 1 |
+---------------------+---+---+---+

the query should return the following table:
+------+
|      |
+------+
| NULL |
+------+

There are enough shirts of each size to complete all orders.
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
MIN(order_time)
FROM orders_flag_unable_to_complete
WHERE flag_unable_to_complete = 'X'


