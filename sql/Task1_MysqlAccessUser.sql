/*
TASK: MysqlAccessUser
================================================================================
DESCRIPTION:
You are part of a team creating an IAM (Identity & Access Management) solution. 
You have defined a table UserRole with the following structure:

CREATE TABLE UserRole(
    Id bigint NOT NULL AUTO_INCREMENT,
    Name varchar(100) NOT NULL,
    Description varchar(200) NULL,
    IsEnabled bit NOT NULL,
    Created date NOT NULL,
    CreatedBy varchar(200) NOT NULL,
    Updated date NULL,
    UpdatedBy varchar(200) NULL,
    CONSTRAINT PK_UserRole PRIMARY KEY ( Id ASC )
)

YOUR TASK:
Write a SQL query that will return roles that:
1. have a non-NULL description;
2. were created by John Smith;
3. were created later than 3rd January 2020;
4. were created before 7th January 2020;
5. have never been updated, i.e. the Updated column is not set.

OUTPUT SPECIFICATIONS:
- The results should contain the role name, description and status. 
- Rows should also be sorted by a role name in descending order. 
- A column with a role name should be called Name.
- A column with a description should be called Description.
- A column with a status should be called Status.
- The Status column should be set to DISABLED if the IsEnabled column 
  is set to 0, and ENABLED otherwise.

DATA CONSISTENCY NOTE:
Values in the CreatedBy column are not consistent:
- They can contain additional white spaces at the beginning or the end;
- They can be written in a mixture of small and capital letters; 
  e.g. JOHN SMITH, john smith.

HINTS:
- Your query will be executed against MySQL 8.0 database.
- Pay attention to the Query_Can_Be_Executed_Without_Any_Error test, 
  which only validates if your query can be executed. If this test fails, 
  it probably means that your query is not syntactically correct.
================================================================================
*/

/* TEST CASES

-- 2. Insert test cases
INSERT INTO UserRole (Name, Description, IsEnabled, Created, CreatedBy, Updated) VALUES 
-- SUCCESS CASES (Should appear in your results)
('System_Admin', 'Full system access', 1, '2020-01-04', 'John Smith', NULL),
('Support_Lead', 'Handle tickets', 0, '2020-01-05', '  john smith  ', NULL),
('Editor_User', 'Content editing', 1, '2020-01-06', 'JOHN SMITH', NULL),

-- EDGE CASES (Should be FILTERED OUT)
('Old_Role', 'Created too early', 1, '2020-01-03', 'John Smith', NULL),         -- Too early (not > Jan 3)
('New_Role', 'Created too late', 1, '2020-01-07', 'John Smith', NULL),          -- Too late (not < Jan 7)
('Updated_Role', 'Was modified', 1, '2020-01-05', 'John Smith', '2020-01-10'),  -- Has an Updated date
('Wrong_User', 'Not John', 1, '2020-01-05', 'Jane Doe', NULL),                  -- Wrong creator
('Missing_Desc', NULL, 1, '2020-01-05', 'John Smith', NULL),                    -- NULL description
('Similar_Name', 'Almost John', 1, '2020-01-05', 'Johnny Smith', NULL);

*/

-- MY QUERY

SELECT
	Name,
    Description,
    IF(IsEnabled = 0, 'DISABLED', 'ENABLED') AS Status
FROM UserRole
WHERE
	Description IS NOT NULL
    AND TRIM(UPPER(CreatedBy)) IN ('JOHN SMITH', 'JOHNSMITH')
    AND (Created BETWEEN '2020-01-03' AND '2020-01-07')
    AND Updated IS NULL 
ORDER BY Name DESC