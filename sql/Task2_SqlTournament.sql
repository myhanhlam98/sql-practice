/*
TASK: SqlTournamentWinners
================================================================================
You are given two tables, players and matches, with the following structure:

create table players (
    player_id integer not null unique,
    group_id integer not null
);

create table matches (
    match_id integer not null unique,
    first_player integer not null,
    second_player integer not null,
    first_score integer not null,
    second_score integer not null
);

Each record in the table players represents a single player in the tournament. The column player_id contains the ID of each player. The column group_id contains the ID of the group that each player belongs to.

Each record in the table matches represents a single match in the group stage. The column first_player (second_player) contains the ID of the first player (second player) in each match. The column first_score (second_score) contains the number of points scored by the first player (second player) in each match. You may assume that, in each match, players belong to the same group.

You would like to compute the winner in each group. The winner in each group is the player who scored the maximum total number of points within the group. If there is more than one such player, the winner is the one with the lowest ID.

Write an SQL query that returns a table containing the winner of each group. Each record should contain the ID of the group and the ID of the winner in this group. Records should be ordered by increasing ID number of the group.

For example, given:

players:
 player_id | group_id
-----------+----------
 20        | 2
 30        | 1
 40        | 3
 45        | 1
 50        | 2
 65        | 1

matches:
 match_id | first_player | second_player | first_score | second_score
----------+--------------+---------------+-------------+--------------
 1        | 30           | 45            | 10          | 12
 2        | 20           | 50            | 5           | 5
 13       | 65           | 45            | 10          | 10
 5        | 30           | 65            | 3           | 15
 42       | 45           | 65            | 8           | 4

your query should return:
 group_id | winner_id
----------+-----------
 1        | 45
 2        | 20
 3        | 40

In group 1 the winner is player 45 with the total score of 30 points. In group 2 both players scored 5 points, but player 20 has lower ID and is a winner. In group 3 there is only one player, and although she didn't play any matches, she is a winner.

Assume that:
- groups are numbered with consecutive integers beginning from 1;
- every player from table matches occurs in table players;
- in each match players belong to the same group;
- score is a value between 0 and 1000000;
- there is at most 100 players;
- there is at most 100 matches.
*/
WITH player_scores AS
(
  SELECT 
      first_player AS player_id,
      first_score AS score
  FROM matches
  UNION ALL
  SELECT
      second_player,
      second_score
  FROM matches
),
player_score_summary AS
(
  SELECT
      b.group_id,
      a.player_id,
      SUM(score) AS total_score
  FROM player_scores a
  LEFT JOIN players b
  	ON a.player_id = b.player_id
  GROUP BY b.group_id, a.player_id
),
player_score_summary_ranking AS
(
  SELECT 
      c.group_id,
  	  c.player_id,
      RANK() OVER(PARTITION BY c.group_id ORDER BY COALESCE(total_score,0) DESC, c.player_id) AS score_rank
  FROM players c
  LEFT JOIN player_score_summary d
      ON c.player_id = d.player_id
)
SELECT 
	group_id,
    player_id AS winner_id
FROM player_score_summary_ranking
WHERE score_rank = 1
ORDER BY group_id
