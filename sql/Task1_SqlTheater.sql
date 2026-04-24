/*
TASK: SqlTheater
================================================================================
DESCRIPTION:
You are given two tables describing theater plays and reservations for these 
plays in specific theaters. Write a query that counts the total number of 
tickets reserved for each play.

TABLE STRUCTURE:
----------------
create table plays (
    id integer not null,
    title varchar(40) not null,
    writer varchar(40) not null,
    unique(id)
);

create table reservations (
    id integer not null,
    play_id integer not null,
    number_of_tickets integer not null,
    theater varchar(40) not null,
    unique(id)
);

REQUIREMENTS:
- The result should contain three columns: id, title, and reserved_tickets.
- Plays with no reservations should appear with 0 tickets.
- Rows should be ordered by decreasing reserved_tickets.
- In case of a tie, sort by increasing id of the play.
================================================================================
*/

/* EXACT TEST CASE 1: SqlTheater
-----------------------------
Scenario: Multiple reservations for some plays, zero for others.

INSERT INTO plays (id, title, writer) VALUES 
(109, 'Queens and Kings of Madagascar', 'Paul Sat'),
(123, 'Merlin', 'Lee Roy'),
(142, 'Key of the tea', 'Max Rogers'),
(144, 'ROMEance Comedy', 'Bohring Ashell'),
(145, 'Nameless.', 'Note Nul');

INSERT INTO reservations (id, play_id, number_of_tickets, theater) VALUES 
(13, 109, 12, 'Mc Rayleigh Theater'),
(24, 109, 34, 'Mc Rayleigh Theater'),
(37, 145, 84, 'Mc Rayleigh Theater'),
(49, 145, 45, 'Mc Rayleigh Theater'),
(51, 145, 41, 'Mc Rayleigh Theater'),
(68, 123, 3, 'Mc Rayleigh Theater'),
(83, 142, 46, 'Mc Rayleigh Theater');

Expected Output for Example 1:
id  | title                          | reserved_tickets
----|--------------------------------|-----------------
145 | Nameless.                      | 170
109 | Queens and Kings of Madagascar | 46
142 | Key of the tea                 | 46
123 | Merlin                         | 3
144 | ROMEance Comedy                | 0


EXACT TEST CASE 2: SqlTheater
-----------------------------
Scenario: All plays have some reservations.

TRUNCATE TABLE plays, reservations;

INSERT INTO plays (id, title, writer) VALUES 
(34, 'The opera of the phantom', 'Lero Gastonx'),
(35, 'The legend of the cake', 'Oscar Glad'),
(36, 'Stone swords', 'Arthur King');

INSERT INTO reservations (id, play_id, number_of_tickets, theater) VALUES 
(10, 36, 13, 'Arthur King Theater'),
(30, 35, 20, 'The Legend Theater'),
(31, 36, 21, 'The Legend Theater'),
(32, 35, 23, 'The Legend Theater'),
(33, 36, 19, 'The Legend Theater'),
(40, 34, 29, 'The Jupiter Assembly Theater'),
(41, 34, 19, 'The Jupiter Assembly Theater'),
(42, 34, 6, 'The Jupiter Assembly Theater');

Expected Output for Example 2:
34 | The opera of the phantom | 54
36 | Stone swords             | 53
35 | The legend of the cake   | 43

*/

-- MY QUERY

SELECT
	a.id,
    a.title,
    COALESCE(reserved_tickets,0) AS reserved_tickets
FROM plays a
LEFT JOIN
(
SELECT
	play_id,
    SUM(number_of_tickets) AS reserved_tickets
FROM reservations
GROUP BY play_id
) b
ON a.id = b.play_id
ORDER BY reserved_tickets DESC, a.id