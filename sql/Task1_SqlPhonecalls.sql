/*
TASK: SqlPhonecalls
================================================================================
DESCRIPTION:
A telecommunications company wants to identify clients who talked for at least 
10 minutes in total (as either a caller or a callee) to offer them a new contract. 


TABLE STRUCTURE:
----------------
CREATE TABLE phones (
    name varchar(20) NOT NULL UNIQUE,
    phone_number integer NOT NULL UNIQUE
);

CREATE TABLE calls (
    id integer NOT NULL,
    caller integer NOT NULL,
    callee integer NOT NULL,
    duration integer NOT NULL,
    UNIQUE(id)
);


YOUR TASK:
Write an SQL query that finds all clients who talked for at least 10 minutes 
in total.

REQUIREMENTS:
- The total duration for a client is the sum of the durations of all calls 
  where they were either the 'caller' or the 'callee'.
- The result table should contain one column: the name of the client (name).
- Rows should be sorted alphabetically.

EXAMPLE:
--------
If Jack (1234) called Anna (7582) for 8 minutes, and later Jack called 
Lena (3333) for 2 minutes, Jack's total is 10 minutes. Both Jack and Anna 
receive credit for the 8-minute call.

ASSUMPTIONS:
- Each client has only one phone number.
- Every phone number in the 'calls' table exists in the 'phones' table.
- A call is always between two different clients.
================================================================================
*/


/* TEST CASES
-- Example 1:
-- Table: phones
INSERT INTO phones (name, phone_number) VALUES 
('Jack', 1234),
('Lena', 3333),
('Mark', 9999),
('Anna', 7582);

-- Table: calls
INSERT INTO calls (id, caller, callee, duration) VALUES 
(25, 1234, 7582, 8),
(7, 9999, 7582, 1),
(18, 9999, 3333, 4),
(2, 7582, 3333, 3),
(3, 3333, 1234, 1),
(21, 3333, 1234, 1);

-- Example 2: 

-- Table: phones
INSERT INTO phones (name, phone_number) VALUES 
('John', 6356),
('Addison', 4315),
('Kate', 8003),
('Ginny', 9831);

-- Table: calls
INSERT INTO calls (id, caller, callee, duration) VALUES 
(65, 8003, 9831, 7),
(100, 9831, 8003, 3),
(145, 4315, 9831, 18);

*/

-- MY QUERY

SELECT
	a.name
FROM phones a
INNER JOIN 
(
  SELECT
    caller AS phone_number,
    duration
  FROM calls

  UNION ALL
  SELECT
    callee,
    duration
  FROM calls
) b
	ON a.phone_number = b.phone_number
GROUP BY a.name, a.phone_number
HAVING SUM(duration) >= 10
ORDER BY a.name