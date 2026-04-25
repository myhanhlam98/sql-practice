/*
TASK: SqlFlights
================================================================================
You are given two tables, flights and airports, with the following structure:

  flights
  start_time timestamp NOT NULL
  end_time   timestamp NOT NULL
  start_port char(3) NOT NULL
  end_port   char(3) NOT NULL

and

  airports
  city_name varchar(17) NOT NULL
  port_code char(3) NOT NULL

Each row in the table flights contains information about a flight: the time of departure (start_time), time of landing (end_time), the code of its port of departure (start_port) and the code of its destination port (end_port).

Each row in the table airports contains information about an airport: the city name (city_name) and the port code (port_code). Each port_code is assigned to at most one airport.

A passenger wants to travel from New York to Tokyo in the shortest possible time. The passenger can start at any airport in New York and must finish their journey at any airport in Tokyo. They can change planes at most once. A plane change is possible if the first flight ends no later than the start time of the second flight. Note that it is possible to change planes if the end_time of the first flight is equal to the start_time of the second flight. The second flight must start from the airport at which the first flight ended.

Write an SQL query that finds the shortest time in which this journey can occur. Return the difference between the time of departure from New York and the time of arrival in Tokyo in minutes. If such a journey is impossible, return NULL.

Examples:

1. For the given tables flights:
+---------------------+---------------------+------------+----------+
| start_time          | end_time            | start_port | end_port |
+---------------------+---------------------+------------+----------+
| 2023-02-10 10:00    | 2023-02-12 12:00    | JFK        | NRT      |
| 2023-01-30 13:00    | 2023-01-30 16:00    | LGA        | LAX      |
| 2023-01-30 17:00    | 2023-01-31 06:33    | LAX        | HND      |
| 2023-01-30 15:55    | 2023-01-31 04:20    | LAX        | HND      |
| 2023-03-03 04:00    | 2023-03-03 08:30    | JFK        | CDG      |
| 2023-03-03 08:30    | 2023-03-03 10:30    | CDG        | MUC      |
| 2023-03-03 10:40    | 2023-03-03 13:30    | MUC        | HND      |
+---------------------+---------------------+------------+----------+

and airports:
+-----------+-----------+
| city_name | port_code |
+-----------+-----------+
| New York  | JFK       |
| New York  | LGA       |
| Paris     | CDG       |
| Tokyo     | HND       |
| Los Angeles| LAX      |
| Tokyo     | NRT       |
| Munich    | MUC       |
+-----------+-----------+

your query should return:
+------------+
| flight_time|
+------------+
| 1053       |
+------------+

The shortest flight is LGA -> LAX -> HND. It starts at 2023-01-30 13:00 and finishes at 2023-01-31 06:33, so the journey takes 1053 minutes in total. The flight JFK -> CDG -> MUC -> HND could take less time but it requires too many plane changes.

2. For the given tables flights:
+---------------------+---------------------+------------+----------+
| start_time          | end_time            | start_port | end_port |
+---------------------+---------------------+------------+----------+
| 2023-03-03 06:00    | 2023-03-03 10:30    | JFK        | CDG      |
| 2023-03-03 10:30    | 2023-03-03 12:30    | CDG        | MUC      |
| 2023-03-03 12:40    | 2023-03-03 15:30    | MUC        | HND      |
+---------------------+---------------------+------------+----------+

and airports:
+-----------+-----------+
| city_name | port_code |
+-----------+-----------+
| New York  | JFK       |
| Paris     | CDG       |
| Tokyo     | HND       |
| Munich    | MUC       |
+-----------+-----------+

your query should return:
+------------+
| flight_time|
+------------+
| NULL       |
+------------+

It is impossible to fly from New York to Tokyo with at most one plane change.

Assume that:
- there are no flights with the same start_port and end_port.

*/

-- MY QUERY
WITH flight_time_list AS
(
SELECT 
    60 * EXTRACT
    (HOUR FROM 
    	(
       		(a.end_time-a.start_time)+(b.start_time-a.end_time)+(b.end_time-b.start_time)
     	)
    )
    +
    EXTRACT
    (MINUTE FROM 
    	(
       		(a.end_time-a.start_time)+(b.start_time-a.end_time)+(b.end_time-b.start_time)
     	)
    )
     AS flight_time
FROM flights a
LEFT JOIN flights b
	ON a.end_port = b.start_port
    AND a.end_time <= b.start_time
WHERE a.start_port IN ('JFK','LGA') AND b.end_port IN ('HND', 'NRT')
) 
SELECT 
MIN (flight_time) AS flight_time 
FROM flight_time_list
