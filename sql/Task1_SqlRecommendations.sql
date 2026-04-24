/*
TASK: SqlRecommendations
================================================================================
DESCRIPTION:
You are given a table of people's opinions about places in a city. Your task is 
to generate a list of the recommended places. 

A place is recommended if it has STRICTLY MORE 'recommended' opinions than 
'not recommended' opinions.

TABLE STRUCTURE:
----------------
create table opinions (
    id int not null primary key,
    place varchar(255) not null,
    opinion varchar(255) not null
);

REQUIREMENTS:
- The result should be a table with one column named 'place'.
- The names in the returned table should appear in alphabetical order.
- Assume that in alphabetical order, the space character is lower than any letter.

EXAMPLES:
---------
If 'mount nawo oz' has 2 'recommended' and 1 'not recommended', it is included.
If 'qr week' has 1 'recommended' and 1 'not recommended', it is NOT included 
(because it is not strictly more).
================================================================================
*/

/* TEST CASES

CREATE TABLE opinions (
    id int NOT NULL PRIMARY KEY,
    place varchar(255) NOT NULL,
    opinion varchar(255) NOT NULL

Example 1:

TRUNCATE TABLE opinions;

INSERT INTO opinions (id, place, opinion) VALUES 
(1, 'mount nawo oz', 'recommended'),
(2, 'mount nawo oz', 'not recommended'),
(3, 'codility', 'recommended'),
(4, 'codility', 'recommended'),
(5, 'codility', 'recommended'),
(6, 'qr week', 'recommended'),
(7, 'qr week', 'not recommended'),
(8, 'cafe worst', 'not recommended'),
(9, 'mount nawo oz', 'recommended');

-- Expected Result:
-- codility
-- mount nawo oz

Example 2:
TRUNCATE TABLE opinions;

INSERT INTO opinions (id, place, opinion) VALUES 
(1, 'cafe best', 'recommended'),
(2, 'cafe bad', 'recommended'),
(3, 'cafe worst', 'not recommended'),
(4, 'cafe bad', 'not recommended'),
(5, 'cafe bad', 'not recommended');

-- Expected Result:
-- cafe best
);

*/

-- MY QUERY

WITH place_recommendation_summary AS
(
  	SELECT
  		place,
  		SUM(CASE WHEN opinion = 'recommended' THEN 1 ELSE 0 END) AS recommended_count,
  		SUM(CASE WHEN opinion = 'not recommended' THEN 1 ELSE 0 END) AS not_recommended_count
  	FROM opinions
  GROUP BY place
 )
SELECT DISTINCT place
FROM place_recommendation_summary
WHERE recommended_count > not_recommended_count