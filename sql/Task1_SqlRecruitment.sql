/*
TASK: SqlRecruitment
================================================================================
DESCRIPTION:
Recruitment is underway in many companies. For each candidate, calculate the 
number of distinct companies they have applied to.

TABLE STRUCTURE:
----------------
create table candidates (
    id integer primary key,
    name varchar(20) not null unique,
    age integer not null
);

create table reports (
    id integer primary key,
    company varchar(20) not null,
    candidate_id integer not null,
    score integer not null
);

YOUR TASK:
Write an SQL query that, for each candidate, calculates the number of distinct 
companies that he/she applied to. 

REQUIREMENTS:
- The result table should contain three columns: id (of the candidate), 
  name (of the candidate), and companies (number of distinct companies).
- Candidates who have not applied to any companies should still appear 
  in the result with 0 companies.
- The rows should be ordered by increasing id of the candidates.

CONSTRAINTS:
- candidate_id in 'reports' always exists in the 'candidates' table.
================================================================================
*/

/* TEST CASES
-- EXAMPLE 1: Multi-test entries for one candidate
-- Lara applied to Codility twice (scores 20 and 30) and ITCompany once.
-- Paul applied to Soft once. Taylor applied to zero.
INSERT INTO candidates (id, name, age) VALUES 
(25, 'Taylor', 30),
(113, 'Paul', 21),
(10, 'Lara', 19);

INSERT INTO reports (id, company, candidate_id, score) VALUES 
(1, 'Codility', 10, 20),
(36, 'Soft', 113, 60),
(137, 'Codility', 10, 30),
(2, 'ITCompany', 10, 99);

/* Expected Output Example 1:
id  | name   | companies
------------------------
10  | Lara   | 2
25  | Taylor | 0
113 | Paul   | 1
*/

-- EXAMPLE 2: No reports at all
-- This tests your LEFT JOIN logic.
TRUNCATE TABLE reports, candidates;

INSERT INTO candidates (id, name, age) VALUES 
(30, 'Tom', 42),
(25, 'Kate', 23);

/* Expected Output Example 2:
id | name | companies
---------------------
25 | Kate | 0
30 | Tom  | 0
*/

-- EXAMPLE 3: Multiple reports for the same company
-- Jack has 3 reports, but 2 are for 'Codility'. Distinct count should be 2.
TRUNCATE TABLE reports, candidates;

INSERT INTO candidates (id, name, age) VALUES 
(25, 'Jack', 32);

INSERT INTO reports (id, company, candidate_id, score) VALUES 
(10, 'Codility', 25, 100),
(82, 'ITCompany', 25, 90),
(50, 'Codility', 25, 50);

/* Expected Output Example 3:
id | name | companies
---------------------
25 | Jack | 2
*/

*/

-- MY QUERY

SELECT
	a.id,
    a.name,
    COALESCE(b.companies,0) AS companies
FROM candidates a
LEFT JOIN
(
  SELECT
      candidate_id,
      COUNT(DISTINCT company) AS companies
  FROM reports
  GROUP BY candidate_id
) b
ON a.id = b.candidate_id
ORDER BY a.id

