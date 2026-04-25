/*
TASK: SqlRecruitment
================================================================================
Recruitment is underway in many companies. For each candidate we want to calculate the number of companies they have applied to.

We are given two tables, candidates and reports, representing data about an ongoing recruitment process. They have the following structure:

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

Every row of the table candidates contains information about a single candidate: unique id (id), unique name (name) and age (age). Every row of the table reports contains information about a single test session: unique id (id), name of the company that conducted the test (company), id of a candidate that was tested (candidate_id) and a final score (score).

Write an SQL query that, for each candidate, calculates the number of distinct companies that he/she applied to. The table of results should contain three columns: id (id of the candidate), name (name of the candidate) and companies (number of distinct companies the candidate applied to). The rows should be ordered by increasing id of the candidates.

Examples:

1. Given tables:

candidates:
+-----+--------+-----+
| id  | name   | age |
+-----+--------+-----+
| 25  | Taylor | 30  |
| 113 | Paul   | 21  |
| 10  | Lara   | 19  |
+-----+--------+-----+

reports:
+-----+-----------+--------------+-------+
| id  | company   | candidate_id | score |
+-----+-----------+--------------+-------+
| 1   | Codility  | 10           | 20    |
| 36  | Soft      | 113          | 60    |
| 137 | Codility  | 10           | 30    |
| 2   | ITCompany | 10           | 99    |
+-----+-----------+--------------+-------+

The query should return:
+-----+--------+-----------+
| id  | name   | companies |
+-----+--------+-----------+
| 10  | Lara   | 2         |
| 25  | Taylor | 0         |
| 113 | Paul   | 1         |
+-----+--------+-----------+

2. Given tables:

candidates:
+-----+------+-----+
| id  | name | age |
+-----+------+-----+
| 30  | Tom  | 42  |
| 25  | Kate | 23  |
+-----+------+-----+

reports:
+----+---------+--------------+-------+
| id | company | candidate_id | score |
+----+---------+--------------+-------+

The query should return:
+-----+------+-----------+
| id  | name | companies |
+-----+------+-----------+
| 25  | Kate | 0         |
| 30  | Tom  | 0         |
+-----+------+-----------+

3. Given tables:

candidates:
+----+------+-----+
| id | name | age |
+----+------+-----+
| 25 | Jack | 32  |
+----+------+-----+

reports:
+----+-----------+--------------+-------+
| id | company   | candidate_id | score |
+----+-----------+--------------+-------+
| 10 | Codility  | 25           | 100   |
| 82 | ITCompany | 25           | 90    |
| 50 | Codility  | 25           | 50    |
+----+-----------+--------------+-------+

The query should return:
+----+------+-----------+
| id | name | companies |
+----+------+-----------+
| 25 | Jack | 2         |
+----+------+-----------+

Assume that:
- values of id column in both candidates and reports are integers within the range [1..1,000,000];
- values of the name column in candidates and the company column in reports are strings consisting of lower- and uppercase letters;
- values of the age column are integers within the range [18..100];
- values of the score column are integers within the range [0..100];
- every value in the candidate_id column occurs as a value in the id column in the candidates table.

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

