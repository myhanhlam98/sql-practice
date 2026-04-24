/*
TASK: SqlBuses
================================================================================
DESCRIPTION:
For each bus, return the number of passengers boarding it. 
- Passengers board the earliest possible bus for their origin/destination.
- Passengers can board if the bus departs in the same minute they arrive.
- Time is 'HH:MM' string format.

TABLE STRUCTURE:
----------------
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

REQUIREMENTS:
- Output: id, passengers_on_board.
- Rows ordered by id ascending.
================================================================================


-- EXACT TEST CASE 1: Multiple buses on same route
TRUNCATE TABLE buses, passengers;

INSERT INTO buses (id, origin, destination, time) VALUES 
(10, 'Warsaw', 'Berlin', '10:55'),
(20, 'Berlin', 'Paris', '06:20'),
(21, 'Berlin', 'Paris', '14:00'),
(22, 'Berlin', 'Paris', '21:40'),
(30, 'Paris', 'Madrid', '13:30');

INSERT INTO passengers (id, origin, destination, time) VALUES 
(1, 'Paris', 'Madrid', '13:30'), (2, 'Paris', 'Madrid', '13:31'),
(10, 'Warsaw', 'Paris', '10:00'), (11, 'Warsaw', 'Berlin', '22:31'),
(40, 'Berlin', 'Paris', '06:15'), (41, 'Berlin', 'Paris', '06:50'),
(42, 'Berlin', 'Paris', '07:12'), (43, 'Berlin', 'Paris', '12:03'),
(44, 'Berlin', 'Paris', '20:00');

-- Expected Result: 10(0), 20(1), 21(3), 22(1), 30(1)


/* TEST CASE 2: BOUNDARY & MISSING ROUTES
-----------------------------------------
- Munich -> Rome at 13:00 (5 passengers arrive before or at 13:00)
- Munich -> Rome at 15:30 (Empty - all earlier passengers took the 13:00)
- Munich -> Rome at 20:00 (Empty)
*/

TRUNCATE TABLE buses, passengers;

INSERT INTO buses (id, origin, destination, time) VALUES 
(100, 'Munich', 'Rome', '13:00'),
(200, 'Munich', 'Rome', '15:30'),
(300, 'Munich', 'Rome', '20:00');

INSERT INTO passengers (id, origin, destination, time) VALUES 
(1, 'Munich', 'Rome', '10:01'),
(2, 'Munich', 'Rome', '11:30'),
(3, 'Munich', 'Rome', '11:30'),
(4, 'Munich', 'Rome', '12:03'),
(5, 'Munich', 'Rome', '13:00'), -- Should board the 13:00 bus
(6, 'Berlin', 'Tokyo', '10:00'); -- No such bus route exists

-- Expected Output:
-- 100 | 5
-- 200 | 0
-- 300 | 0
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