/*
TASK: SqlBuses
================================================================================
You are given two tables, buses and passengers, with the following structure:

create table buses (
    id integer primary key,
    origin varchar not null,
    destination varchar not null,
    time varchar not null,
    unique (origin, destination, time)
);

create table passengers (
    id integer primary key,
    origin varchar not null,
    destination varchar not null,
    time varchar not null
);

Each row of table buses contains information about a single bus's origin (origin), destination (destination) and time of departure (time). Each row of table passengers describes a single passenger and contains information about the station they're traveling from (origin), the station they're traveling to (destination) and the time they will arrive at the departure station (time). Passengers will board the earliest possible bus that travels directly to their desired destination. Passengers can still board a bus if it departs in the same minute that they arrive at the station. All passengers who are still at the station at 23:59 and don't board any of the 23:59 buses will leave the platform without boarding any bus.

You can assume that no two buses with the same origin and destination depart at the same time.

Write an SQL query that, for each bus, returns the number of passengers boarding it. For each bus you should provide its id (id) and the number of passengers on board (passengers_on_board). Rows should be ordered by the id column (in ascending order).

Time is represented as a string in the format HH:MM.

Examples:

1. Given tables:

buses:
 id | origin | destination | time
----+--------+-------------+-------
 10 | Warsaw | Berlin      | 10:55
 20 | Berlin | Paris       | 06:20
 21 | Berlin | Paris       | 14:00
 22 | Berlin | Paris       | 21:40
 30 | Paris  | Madrid      | 13:30

passengers:
 id | origin | destination | time
----+--------+-------------+-------
 1  | Paris  | Madrid      | 13:30
 2  | Paris  | Madrid      | 13:31
 10 | Warsaw | Paris       | 10:00
 11 | Warsaw | Berlin      | 22:31
 40 | Berlin | Paris       | 06:15
 41 | Berlin | Paris       | 06:50
 42 | Berlin | Paris       | 07:12
 43 | Berlin | Paris       | 12:03
 44 | Berlin | Paris       | 20:00

your query should return:
 id | passengers_on_board
----+---------------------
 10 | 0
 20 | 1
 21 | 3
 22 | 1
 30 | 1

2. Given tables:

buses:
 id  | origin | destination | time
-----+--------+-------------+-------
 100 | Munich | Rome        | 13:00
 200 | Munich | Rome        | 15:30
 300 | Munich | Rome        | 20:00

passengers:
 id | origin | destination | time
----+--------+-------------+-------
 1  | Munich | Rome        | 10:01
 2  | Munich | Rome        | 11:30
 3  | Munich | Rome        | 11:30
 4  | Munich | Rome        | 12:03
 5  | Munich | Rome        | 13:00

your query should return:
 id  | passengers_on_board
-----+---------------------
 100 | 5
 200 | 0
 300 | 0
*/

-- MY QUERY

WITH buses_add_last_depart_time AS
(
  SELECT
  	*,
  LAG(time) OVER(PARTITION BY origin, destination ORDER BY time) AS last_depart_time
  FROM buses
)
SELECT 
	a.id,
    COUNT(b.id) AS passengers_on_board
FROM buses_add_last_depart_time a
LEFT JOIN passengers b
	ON a.origin = b.origin
    AND a.destination = b.destination
    AND (b.time > COALESCE(a.last_depart_time,'00:00') AND b.time <= a.time)
GROUP BY a.id
ORDER BY a.id