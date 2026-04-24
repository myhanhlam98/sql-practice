/*
TASK: SqlTournamentWinners
================================================================================
DESCRIPTION:
Compute the winner in each group. The winner is the player who scored the maximum 
total number of points within the group.

TIE-BREAKING RULES:
-------------------
If there is more than one such player (a tie in score), the winner is the one 
with the LOWEST player_id.

TABLE STRUCTURE:
----------------
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

REQUIREMENTS:
- Return a table containing 'group_id' and 'winner_id'.
- Every group must have a winner (even if a player played 0 matches).
- Order results by group_id ascending.
================================================================================


TEST CASE: Multiple groups with ties and inactivity
TRUNCATE TABLE players, matches;

INSERT INTO players (player_id, group_id) VALUES 
(20, 2), (30, 1), (40, 3), (45, 1), (50, 2), (65, 1);

INSERT INTO matches (match_id, first_player, second_player, first_score, second_score) VALUES 
(1, 30, 45, 10, 12),
(2, 20, 50, 5, 5),   -- Tie in score: player 20 should win (lower ID)
(13, 65, 45, 10, 10),
(5, 30, 65, 3, 15),
(42, 45, 65, 8, 4);

-- Expected Result:
-- Group 1: Player 45 (30 pts)
-- Group 2: Player 20 (5 pts, tie-break by ID)
-- Group 3: Player 40 (0 pts, only player in group)

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
