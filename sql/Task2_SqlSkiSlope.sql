/*
TASK: SqlSkiSlope
================================================================================
A ski resort company is planning to construct a new ski slope using a pre-existing network of mountain huts and trails between them. A new slope has to begin at one of the mountain huts, have a middle station at another hut connected with the first one by a direct trail, and end at the third mountain hut which is also connected by a direct trail to the second hut. The altitude of the three huts chosen for constructing the ski slope has to be strictly decreasing.

You are given two SQL tables, mountain_huts and trails, with the following structure:

create table mountain_huts (
    id integer not null,
    name varchar(40) not null,
    altitude integer not null,
    unique(name),
    unique(id)
);

create table trails (
    hut1 integer not null,
    hut2 integer not null
);

Each entry in the table trails represents a direct connection between huts with IDs hut1 and hut2. Note that all trails are bidirectional.

Create a query that finds all triplets (startpt, middlept, endpt) representing the mountain huts that may be used for construction of a ski slope. Output returned by the query can be ordered in any way.

Examples:

1. Given the tables:

mountain_huts:
 id | name    | altitude
----+---------+----------
  1 | Dakonat | 1900
  2 | Natisa  | 2100
  3 | Gajantut| 1600

[...trails data omitted for brevity...]

your query should return:
 startpt  | middlept | endpt
----------+----------+-------
 Dakonat  | Gajantut | Tupur
 Dakonat  | Tupur    | Rifat
 Gajantut | Tupur    | Rifat
 Natisa   | Gajantut | Tupur

2. Given the tables:

mountain_huts:
 id | name      | altitude
----+-----------+----------
  1 | Adam      | 2100
  2 | Emily     | 1800
  3 | Diana     | 1800
  4 | Bobs Inn  | 1400
  5 | Carls Inn | 1350
  6 | Hannah    | 2300

trails:
 hut1 | hut2
------+------
    2 | 1
    2 | 3
    2 | 4
    2 | 5
    3 | 1
    3 | 4
    3 | 5
    3 | 6

your query should return:
 startpt | middlept | endpt
---------+----------+-----------
 Adam    | Diana    | Bobs Inn
 Adam    | Diana    | Carls Inn
 Adam    | Emily    | Bobs Inn
 Adam    | Emily    | Carls Inn
 Hannah  | Diana    | Bobs Inn
 Hannah  | Diana    | Carls Inn

Assume that:
- there is no trail going from a hut back to itself;
- for every two huts there is at most one direct trail connecting them;
- each hut from table trails occurs in table mountain_huts.

*/

SELECT
	a.name AS startpt,
    b.name AS middlept,
    c.name AS endpt
FROM mountain_huts a
LEFT JOIN mountain_huts b
	ON a.altitude > b.altitude
LEFT JOIN mountain_huts c
	ON b.altitude > c.altitude
WHERE EXISTS 
	(SELECT 1
     FROM trails d
     WHERE 	(a.id = d.hut1 OR a.id = d.hut2)
     		AND (b.id = d.hut1 OR b.id = d.hut2)
     )
AND EXISTS 
	(SELECT 1
     FROM trails e
     WHERE (b.id = e.hut1 OR b.id = e.hut2)
     		AND (c.id = e.hut1 OR c.id = e.hut2)
     )