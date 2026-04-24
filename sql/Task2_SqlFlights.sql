/*
TASK: SqlFlights
================================================================================
DESCRIPTION:
A passenger wants to travel from New York to Tokyo in the shortest possible time. 
The passenger can start at any airport in New York and must finish at any 
airport in Tokyo.

Rules for travel:
- The passenger can change planes at most once (0 or 1 plane changes).
- A plane change is possible if the first flight ends no later than the start 
  time of the second flight.
- If changing planes, the second flight must start from the same airport at 
  which the first flight ended.
- It is possible to change planes if the end_time of the first flight is 
  exactly equal to the start_time of the second flight.

TABLE STRUCTURE:
----------------
create table flights (
    start_time timestamp NOT NULL,
    end_time timestamp NOT NULL,
    start_port char(3) NOT NULL,
    end_port char(3) NOT NULL
);

create table airports (
    city_name varchar(17) NOT NULL,
    port_code char(3) NOT NULL
);

REQUIREMENTS:
- Find the shortest time (in minutes) in which this journey can occur.
- Return the difference between the departure time from New York and the 
  arrival time in Tokyo.
- If such a journey is impossible, return NULL.

EXAMPLES:
---------
Example 1:
- Flight 1: LGA -> LAX (Starts 13:00, Ends 16:00)
- Flight 2: LAX -> HND (Starts 17:00, Ends 06:33 next day)
- Total journey: 1053 minutes.

Example 2:
- Journey impossible with at most one plane change.
- Returns NULL.
================================================================================

TEST CASE 1: 

INSERT INTO airports (city_name, port_code) VALUES 
('New York', 'JFK'),
('New York', 'LGA'),
('Paris', 'CDG'),
('Tokyo', 'HND'),
('Los Angeles', 'LAX'),
('Tokyo', 'NRT'),
('Munich', 'MUC');

INSERT INTO flights (start_time, end_time, start_port, end_port) VALUES 
('2023-02-10 10:00', '2023-02-12 12:00', 'JFK', 'NRT'),
('2023-01-30 13:00', '2023-01-30 16:00', 'LGA', 'LAX'),
('2023-01-30 17:00', '2023-01-31 06:33', 'LAX', 'HND'),
('2023-01-30 15:55', '2023-01-31 04:20', 'LAX', 'HND'),
('2023-03-03 04:00', '2023-03-03 08:30', 'JFK', 'CDG'),
('2023-03-03 08:30', '2023-03-03 10:30', 'CDG', 'MUC'),
('2023-03-03 10:40', '2023-03-03 13:30', 'MUC', 'HND');

TEST CASE 2:

INSERT INTO airports (city_name, port_code) VALUES 
('New York', 'JFK'),
('Paris', 'CDG'),
('Tokyo', 'HND'),
('Munich', 'MUC');

INSERT INTO flights (start_time, end_time, start_port, end_port) VALUES 
('2023-03-03 06:00', '2023-03-03 10:30', 'JFK', 'CDG'),
('2023-03-03 10:30', '2023-03-03 12:30', 'CDG', 'MUC'),
('2023-03-03 12:40', '2023-03-03 15:30', 'MUC', 'HND');

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
