/*
TASK: SqlFlights
================================================================================
DESCRIPTION:
Find all intermediate cities through which a passenger can travel from 
New York to Tokyo with exactly one change of flights.

TABLE STRUCTURE:
----------------
CREATE TABLE flights (
    start_port char(3) NOT NULL,
    end_port char(3) NOT NULL
);

CREATE TABLE airports (
    city_name varchar(17) NOT NULL,
    port_code char(3) NOT NULL
);

REQUIREMENTS:
- Identify cities where a passenger can fly: 
  (New York Airport) -> (City X Airport) -> (Tokyo Airport).
- Each port_code is assigned to at most one airport.
- There are no flights with the same start_port and end_port.

OUTPUT SPECIFICATIONS:
- The result table should contain one column: cities.
- The list should include the names of the intermediate cities.

EXAMPLE:
--------
If a flight goes JFK (New York) -> LAX (Los Angeles) and another flight 
goes LAX -> HND (Tokyo), then 'Los Angeles' should be in the output.
================================================================================
*/

/* TEST CASES

-- Insert Airports
INSERT INTO airports (city_name, port_code) VALUES 
('New York', 'JFK'),
('New York', 'LGA'),
('Paris', 'CDG'),
('Tokyo', 'HND'),
('Los Angeles', 'LAX'),
('Tokyo', 'NRT'),
('Munich', 'MUC');

-- Insert Flights
INSERT INTO flights (start_port, end_port) VALUES 
('JFK', 'NRT'), -- Direct (Should be ignored)
('LGA', 'LAX'), -- Leg 1
('LAX', 'HND'), -- Leg 2 (Connection: Los Angeles)
('JFK', 'CDG'), -- Leg 1
('CDG', 'MUC'), -- Leg 2 (Not Tokyo)
('JFK', 'HND'), -- Direct
('JFK', 'MUC'), -- Leg 1
('MUC', 'NRT'); -- Leg 2 (Connection: Munich)

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
