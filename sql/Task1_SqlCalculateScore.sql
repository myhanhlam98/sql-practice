/*
TASK: SqlCalculateScore
================================================================================
DESCRIPTION:
An automatic judging system checks a solution for the task on multiple test cases. 
The outcome of a test case is binary: either the solution succeeds or fails. 
Each test case is assigned to a group, and every test case in the group is worth 
the same number of points.

TABLE STRUCTURE:
----------------
CREATE TABLE test_groups (
    name varchar(40) not null,
    test_value integer not null,
    unique(name)
);

CREATE TABLE test_cases (
    id integer not null,
    group_name varchar(40) not null,
    status varchar(5) not null,
    unique(id)
);

REQUIREMENTS:
- Write a SQL query that summarizes each group of tests.
- Status contains either one of two possible words: 'OK' or 'ERROR'.
- Assume that every group_name in the table test_cases also appears as a name 
  in the table test_groups.

OUTPUT SPECIFICATIONS:
The table of results should contain four columns:
1. name: (name of the group)
2. all_test_cases: (number of tests in the group)
3. passed_test_cases: (number of test cases with the status 'OK')
4. total_value: (total value of passed tests in this group)

SORTING:
- Rows should be ordered by decreasing total_value.
- In the case of a tie, rows should be sorted lexicographically by name.

EXAMPLES:
---------
If 'numerical stability' has 4 test cases, all are 'OK', and each test is 
worth 20 points, the total_value is 80.
If 'performance' has 2 test cases, both are 'ERROR', the total_value is 0.
If a group has 0 test cases (like 'corner cases' in Example 1), the 
total_value is 0.
================================================================================
*/

/* TEST CASES

-- Example 1:
-- Insert Groups
INSERT INTO test_groups (name, test_value) VALUES 
('performance', 15),
('corner cases', 10),
('numerical stability', 20),
('memory usage', 10);

-- Insert Test Cases
INSERT INTO test_cases (id, group_name, status) VALUES 
(13, 'memory usage', 'OK'),
(14, 'numerical stability', 'OK'),
(15, 'memory usage', 'ERROR'),
(16, 'numerical stability', 'OK'),
(17, 'numerical stability', 'OK'),
(18, 'performance', 'ERROR'),
(19, 'performance', 'ERROR'),
(20, 'memory usage', 'OK'),
(21, 'numerical stability', 'OK');

-- Example 2: 
-- Clean up previous data
TRUNCATE TABLE test_cases, test_groups;

-- Insert Groups (including groups with no tests)
INSERT INTO test_groups (name, test_value) VALUES 
('performance', 15),
('corner cases', 10),
('numerical stability', 20),
('memory usage', 10),
('partial functionality', 20),
('full functionality', 40);

-- Insert Test Cases (only two cases, both are ERROR)
INSERT INTO test_cases (id, group_name, status) VALUES 
(1, 'performance', 'ERROR'),
(2, 'full functionality', 'ERROR');


*/
-- MY QUERY

SELECT DISTINCT
	a.name,
    COALESCE(all_test_cases,0) 					AS all_test_cases,
    COALESCE(passed_test_cases,0) 				AS passed_test_cases,
    COALESCE(passed_test_cases,0) * test_value 	AS total_value
FROM test_groups a
LEFT JOIN
(
  SELECT
    group_name,
    COUNT(status) AS all_test_cases,
    SUM(CASE WHEN status = 'OK' THEN 1 ELSE 0 END) AS passed_test_cases
    FROM test_cases
  GROUP BY group_name
) b
ON a.name = b.group_name	
ORDER BY total_value DESC, a.name ASC



