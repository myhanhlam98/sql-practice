/*
TASK: MysqlAccessUser

You are part of a team creating an IAM (Identity & Access Management) solution. You have defined a table UserRole with the following structure:

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

Your task is to write a SQL query that will return roles that:

- have a non-NULL description;
- were created by John Smith;
- were created later than 3rd January 2020;
- were created before 7th January 2020;
- have never been updated, i.e. the Updated column is not set.

The results should contain the role name, description and status. Rows should also be sorted by a role name in descending order. A column with a role name should be called Name, with a description Description and a status Status. The Status column should be set to DISABLED if the IsEnabled column is set to 0, and ENABLED otherwise.

You should also take into account that values in the CreatedBy column are not consistent:

- They can contain additional white spaces at the beginning or the end;
- They can be written in a mixture of small and capital letters; e.g. JOHN SMITH, john smith.

Hints:

- Your query will be executed against MySQL 8.0 database.
- Pay attention to the Query_Can_Be_Executed_Without_Any_Error test, which only validates if your query can be executed. If this test fails, it probably means that your query is not syntactically correct.
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