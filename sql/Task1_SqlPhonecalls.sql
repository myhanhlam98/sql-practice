/*
TASK: SqlPhonecalls
================================================================================
A telecommunications company decided to find which of their clients talked for at least 10 minutes on the phone in total and offer them a new contract.

You are given two tables, phones and calls, with the following structure:

create table phones (
    name varchar(20) not null unique,
    phone_number integer not null unique
);

create table calls (
    id integer not null,
    caller integer not null,
    callee integer not null,
    duration integer not null,
    unique(id)
);

Each row of the table phones contains information about a client: name (name) and phone number (phone_number). Each client has only one phone number. Each row of the table calls contains information about a single call: id (id), phone number of the caller (caller), phone number of the callee (callee) and duration of the call in minutes (duration).

Write an SQL query that finds all clients who talked for at least 10 minutes in total. The table of results should contain one column: the name of the client (name). Rows should be sorted alphabetically.

Examples:

1. Given:

phones:
+--------+--------------+
| name   | phone_number |
+--------+--------------+
| Jack   | 1234         |
| Lena   | 3333         |
| Mark   | 9999         |
| Anna   | 7582         |
+--------+--------------+

calls:
+----+--------+--------+----------+
| id | caller | callee | duration |
+----+--------+--------+----------+
| 25 | 1234   | 7582   | 8        |
| 7  | 9999   | 7582   | 1        |
| 18 | 9999   | 3333   | 4        |
| 2  | 7582   | 3333   | 3        |
| 3  | 3333   | 1234   | 1        |
| 21 | 3333   | 1234   | 1        |
+----+--------+--------+----------+

your query should return:

+------+
| name |
+------+
| Anna |
| Jack |
+------+

Jack talked three times and the total duration of his calls is 8 + 1 + 1 = 10. Lena talked four times and the total duration of her calls is 4 + 3 + 1 + 1 = 9. Mark talked twice and the total duration of his calls is 1 + 4 = 5. Anna talked three times and the total duration of her calls is 8 + 1 + 3 = 12. Anna and Jack both talked for at least 10 minutes.

2. Given:

phones:
+---------+--------------+
| name    | phone_number |
+---------+--------------+
| John    | 6356         |
| Addison | 4315         |
| Kate    | 8003         |
| Ginny   | 9831         |
+---------+--------------+

calls:
+-----+--------+--------+----------+
| id  | caller | callee | duration |
+-----+--------+--------+----------+
| 65  | 8003   | 9831   | 7        |
| 100 | 9831   | 8003   | 3        |
| 145 | 4315   | 9831   | 18       |
+-----+--------+--------+----------+

your query should return:

+---------+
| name    |
+---------+
| Addison |
| Ginny   |
| Kate    |
+---------+

Assume that:
- values of the name column are strings consisting of lower- and uppercase letters;
- values of the phone_number column are integers within the range [1,000..9,999];
- values of id column in calls are integers within the range [1..1,000,000];
- each value in the caller or callee column occurs in the phone_number column in phones table;
- in each row of calls table, values of caller and callee are different (the call is between two different clients);
- values of the duration column are integers within the range [1..100].

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