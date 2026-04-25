/*
TASK: SqlFlights
================================================================================
You are given two tables, flights and airports, with the following structure:

create table flights (
    start_port char(3) NOT NULL,
    end_port char(3) NOT NULL
);

and

create table airports (
    city_name varchar(17) NOT NULL,
    port_code char(3) NOT NULL
);

Each row in the table flights contains information about a flight: code of departure port (start_port) and code of destination port (end_port).

Each row in the table airports contains information about an airport: the city name (city_name) and the port code (port_code). Each port_code is assigned to at most one airport.

Write an SQL query that finds all cities through which a flight from New York to Tokyo may pass if the passenger wants to make exactly one change of flights.

Example:

For given tables flights:

start_port | end_port
-----------+---------
JFK        | NRT
LGA        | LAX
LAX        | HND
LAX        | HND
JFK        | CDG
CDG        | MUC
JFK        | HND
JFK        | MUC
MUC        | NRT

and airports:

city_name   | port_code
------------+----------
New York    | JFK
New York    | LGA
Paris       | CDG
Tokyo       | HND
Los Angeles | LAX
Tokyo       | NRT
Munich      | MUC

your query should return:

cities
-----------
Los Angeles
Munich

Assume that:

- there are no flights with the same start_port and end_port.

*/

-- MY QUERY

SELECT DISTINCT
    c.city_name
FROM flights a
INNER JOIN flights b
  ON a.end_port = b.start_port 
  AND a.start_port IN ('JFK','LGA') 
  AND b.end_port IN ('HND','NRT') 
LEFT JOIN airports c
	ON b.start_port = c.port_code
