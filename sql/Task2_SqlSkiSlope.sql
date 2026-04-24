/*
TASK: SqlSkiSlope
================================================================================
DESCRIPTION:
A ski resort company is planning to construct a new ski slope using a pre-existing 
network of mountain huts and trails between them. 

A new slope must:
1. Begin at one mountain hut (startpt).
2. Have a middle station at another hut (middlept) connected to the first by a direct trail.
3. End at a third mountain hut (endpt) connected by a direct trail to the second hut.
4. The altitude of the three huts chosen must be STRICTLY DECREASING 
   (altitude(startpt) > altitude(middlept) > altitude(endpt)).

TABLE STRUCTURE:
----------------
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

REQUIREMENTS:
- Each entry in the 'trails' table represents a direct connection between huts.
- Trails are BIDIRECTIONAL (if a trail exists between hut 1 and 2, it can be 
  traveled in either direction).
- Find all triplets (startpt, middlept, endpt) representing names of the huts.
- Output can be ordered in any way.

ASSUMPTIONS:
- No trail goes from a hut back to itself.
- At most one direct trail connects any two huts.
- Each hut in 'trails' exists in 'mountain_huts'.
================================================================================

TEST CASE

INSERT INTO mountain_huts (id, name, altitude) VALUES 
(1, 'Adam', 2100), 
(2, 'Emily', 1800), 
(3, 'Diana', 1800), 
(4, 'Bobs Inn', 1400), 
(5, 'Carls Inn', 1350), 
(6, 'Hannah', 2300);

INSERT INTO trails (hut1, hut2) VALUES 
(2, 1), -- Emily <-> Adam
(2, 3), -- Emily <-> Diana
(2, 4), -- Emily <-> Bobs Inn
(2, 5), -- Emily <-> Carls Inn
(3, 1), -- Diana <-> Adam
(3, 4), -- Diana <-> Bobs Inn
(3, 5), -- Diana <-> Carls Inn
(3, 6); -- Diana <-> Hannah

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