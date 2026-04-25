/*
TASK: SqlTheater
================================================================================
You are given two tables describing theater plays and reservations for these plays in specific theaters.

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

Write an SQL query that counts the total number of tickets reserved for each play. The table of results should contain three columns: id (id of play), title (title of play) and reserved_tickets (total number of reserved tickets for play). Rows should be ordered by decreasing reserved_tickets. In the case of a tie, rows should be sorted by increasing id of play.

Examples:

1. Given:

plays:
 id  | title                        | writer
-----+------------------------------+----------------
 109 | Queens and Kings of Madagascar | Paul Sat
 123 | Merlin                       | Lee Roy
 142 | Key of the tea               | Max Rogers
 144 | ROMEance Comedy              | Bohring Ashell
 145 | Nameless.                    | Note Nul

reservations:
 id | play_id | number_of_tickets | theater
----+---------+-------------------+-------------------
 13 | 109     | 12                | Mc Rayleigh Theater
 24 | 109     | 34                | Mc Rayleigh Theater
 37 | 145     | 84                | Mc Rayleigh Theater
 49 | 145     | 45                | Mc Rayleigh Theater
 51 | 145     | 41                | Mc Rayleigh Theater
 68 | 123     | 3                 | Mc Rayleigh Theater
 83 | 142     | 46                | Mc Rayleigh Theater

Your query should return:
 id  | title                        | reserved_tickets
-----+------------------------------+------------------
 145 | Nameless.                    | 170
 109 | Queens and Kings of Madagascar | 46
 142 | Key of the tea               | 46
 123 | Merlin                       | 3
 144 | ROMEance Comedy              | 0

2. Given:

plays:
 id | title                     | writer
----+---------------------------+--------------
 34 | The opera of the phantom  | Lero Gastonx
 35 | The legend of the cake    | Oscar Glad
 36 | Stone swords              | Arthur King

reservations:
 id | play_id | number_of_tickets | theater
----+---------+-------------------+---------------------------
 10 | 36      | 13                | Arthur King Theater
 30 | 35      | 20                | The Legend Theater
 31 | 36      | 21                | The Legend Theater
 32 | 35      | 23                | The Legend Theater
 33 | 36      | 19                | The Legend Theater
 40 | 34      | 29                | The Jupiter Assembly Theater
 41 | 34      | 19                | The Jupiter Assembly Theater
 42 | 34      | 6                 | The Jupiter Assembly Theater

Your query should return:
 id | title                     | reserved_tickets
----+---------------------------+------------------
 34 | The opera of the phantom  | 54
 36 | Stone swords              | 53
 35 | The legend of the cake    | 43
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