CREATE DATABASE `buhtig`;

USE `buhtig`;

-- Section 1: Data Definition Language (DDL) – 40 pts
-- 01. Table Design

CREATE TABLE `users` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) UNIQUE NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    `email` VARCHAR(50) NOT NULL
);

CREATE TABLE `repositories` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `repositories_contributors` (
    `repository_id` INT,
    `contributor_id` INT,
    CONSTRAINT `fk_repositories_contributors_repositories` FOREIGN KEY (`repository_id`)
        REFERENCES `repositories` (`id`),
    CONSTRAINT `fk_repositories_contributors_users` FOREIGN KEY (`contributor_id`)
        REFERENCES `users` (`id`)
);

CREATE TABLE `issues` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `issue_status` VARCHAR(6) NOT NULL,
    `repository_id` INT NOT NULL,
    `assignee_id` INT NOT NULL,
    CONSTRAINT `fk_issues_repositories` FOREIGN KEY (`repository_id`)
        REFERENCES `repositories` (`id`),
    CONSTRAINT `fk_issues_users` FOREIGN KEY (`assignee_id`)
        REFERENCES `users` (`id`)
);

CREATE TABLE `commits` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `message` VARCHAR(255) NOT NULL,
    `issue_id` INT,
    `repository_id` INT NOT NULL,
    `contributor_id` INT NOT NULL,
    CONSTRAINT `fk_commits_issues` FOREIGN KEY (`issue_id`)
        REFERENCES `issues` (`id`),
    CONSTRAINT `fk_commits_repositories` FOREIGN KEY (`repository_id`)
        REFERENCES `repositories` (`id`),
    CONSTRAINT `fk_commits_users` FOREIGN KEY (`contributor_id`)
        REFERENCES `users` (`id`)
);

CREATE TABLE `files` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `size` DECIMAL(10, 2) NOT NULL,
    `parent_id` INT,
    `commit_id` INT NOT NULL,
    CONSTRAINT `fk_files_files` FOREIGN KEY (`parent_id`)
        REFERENCES `files` (`id`),
    CONSTRAINT `fk_files_commits` FOREIGN KEY (`commit_id`)
        REFERENCES `commits` (`id`)
);


-- Section 2: Data Manipulation Language (DML) – 30 pts
-- 02. Insert
-- You will have to INSERT records of data into the issues table, based on the files table.
-- For files with id between 46 and 50 (inclusive), insert data in the issues table with
-- the following values:
--  title – set it to “Critical Problem With {fileName}!”. Where the fileName is the name
--   of the file.
--  issue_status – set it to “open”.
--  repository_id – MULTIPLY the id of the file by 2 and DIVIDE it by 3. ROUND the resulting
--   value UP.
--  assignee_id – the file’s commit’s contributor’s id.


INSERT INTO `issues` 
    (`title`, `issue_status`, `repository_id`, `assignee_id`) 
    SELECT
        CONCAT('Critical Problem With ', f.name, '!'),
        'open' AS 'issue_status',
        CEIL(f.id * 2 / 3) AS 'repository_id',
        c.contributor_id AS 'assignee_id'
    FROM
        `files` AS f
            JOIN
        `commits` AS c ON f.commit_id = c.id
    WHERE
        f.id BETWEEN 46 AND 50;


-- 03. Update
-- UPDATE all contributors to repositories which have the same id (value) as
-- the repository they contribute to. 
-- SET them as a contributor to the repository with the lowest id (by value)
-- which has no contributors. 
-- If there aren’t any repositories with no contributors do nothing.
    
UPDATE `repositories_contributors` AS rc
        JOIN
    (SELECT 
        r.id AS 'repo'
    FROM
        `repositories` AS r
    WHERE
        r.id NOT IN (SELECT 
                repository_id
            FROM
                `repositories_contributors`)
    ORDER BY r.id
    LIMIT 1) AS d 
SET 
    rc.repository_id = d.repo
WHERE
    rc.contributor_id = rc.repository_id;

-- 04. Delete
-- Buhtig is all about activity, and activity is expressed in issues. Issues
-- indicate the constant process of development. Naturally, inactive repositories
-- are being treated as abandoned. DELETE all repositories which do NOT have any issues.

DELETE r FROM `repositories` AS r
        LEFT JOIN
    `issues` AS i ON r.id = i.repository_id 
WHERE
    i.id IS NULL;


-- Section 3: Querying – 100 pts
-- 05. Users
-- Extract from the database, all of the users. 
-- ORDER the results ascending by user id.
-- Required Columns: id (users), username

SELECT 
    u.id, u.username
FROM
    `users` AS u
ORDER BY u.id;


-- 06. Lucky Numbers
-- When a contributor has the same id as the repository he contributes to, it’s a lucky number. 
-- Extract from the database, all of the repositories, which have the same id as
-- their contributor. 
-- ORDER the results ascending by repository id.
-- Required Columns: repository_id, contributor_id

SELECT 
    *
FROM
    `repositories_contributors` AS rc
WHERE
    rc.contributor_id = rc.repository_id
ORDER BY rc.repository_id;


-- 07. Heavy HTML
-- There are some pretty big HTML files in the Buhtig database… Unnaturally big.
-- Extract from the database all of the files, which have size, GREATER than 1000,
-- and their name contains “html”.
-- ORDER the results descending by size.
-- Required Columns: id (files), name, size

SELECT 
    f.id, f.name, f.size
FROM
    `files` AS f
WHERE
    f.size > 1000 AND f.name LIKE '%html%'
ORDER BY f.size DESC;


-- 08. IssuesAndUsers
-- Extract from the database, all of the issues, and the users that are assigned to them,
-- so that they end up in the following format: {username} : {issueTitle}
-- ORDER the results descending by issue id.
-- Required Columns: id (issues), issue_assignee

SELECT 
    i.id,
    CONCAT_WS(' : ', u.username, i.title) AS 'issue_assignee'
FROM
    `issues` AS i
        JOIN
    `users` AS u ON i.assignee_id = u.id
ORDER BY i.id DESC;


-- 09. NonDirectoryFiles
-- Some of the files are Directories, because they are a parent to some file.
-- Try to find those, which aren’t.
-- Extract from the database all of the files, which are NOT a parent to any other file.
-- Extract the size of the file and add “KB” to the end of it.
-- ORDER the results ascending by file id.
-- Required Columns: id (files), name, size

SELECT 
    f.id, f.name, CONCAT(f.size, 'KB') AS 'size'
FROM
    `files` AS f
        LEFT JOIN
    `files` AS p ON f.id = p.parent_id
WHERE
    p.id IS NULL;


-- 10. ActiveRepositories
-- Extract from the database, the top 5 repositories, in terms of count of issues on them.
-- ORDER the results descending by issues (count of issues), and ascending by repository id.
-- Required Columns: id (repositories), name (repositories), issues (count of issues)

SELECT 
    r.id, r.name, COUNT(i.id) AS 'issues'
FROM
    `repositories` AS r
        JOIN
    `issues` AS i ON r.id = i.repository_id
GROUP BY r.id
ORDER BY `issues` DESC , r.id
LIMIT 5;


-- 11. MostContributedRepository
-- Extract from the database, the top 1 repository in terms of count of contributors.
-- If there are 2 repositories have the same count of contributors, order them ascending, by id.
-- Required Columns: id (repositories), name (repositories), commits (count of commits),
--  contributors (count of contributors)

SELECT 
    cn.id, r.name, COUNT(c.id) AS 'commits', cn.contributors
FROM
    (SELECT 
        rc.repository_id AS 'id',
            COUNT(rc.contributor_id) AS 'contributors'
    FROM
        `repositories_contributors` AS rc
    GROUP BY rc.repository_id) AS cn
        JOIN
    `repositories` AS r ON cn.id = r.id
        LEFT JOIN
    `commits` AS c ON cn.id = c.repository_id
GROUP BY cn.id
ORDER BY `contributors` DESC , r.id
LIMIT 1;


-- 12. FixingMyOwnProblems
-- Extract from the database, for every user – the count of commits he has on issues that
-- were assigned to him.
-- ORDER the results descending by commits (count of commits), and ascending by user id.
-- Required Columns: id (users), username, commits (count of commits)

SELECT 
    u.id,
    u.username,
    SUM(IF(c.contributor_id = u.id, 1, 0)) AS 'commits'
FROM
    `users` AS u
        LEFT JOIN
    `issues` AS i ON u.id = i.assignee_id
        LEFT JOIN
    `commits` AS c ON i.id = c.issue_id
GROUP BY u.id
ORDER BY `commits` DESC , u.id;

-- 13. RecursiveCommits
-- Extract from the database all files which are a parent to their parent.
-- In other words, file “a” is a parent to file “b” and file “b” is a parent to file “a”.
-- Extract the file name (but only the name, without the extension).
-- If its “index.html” you have to extract “index”, as “file”.
-- Extract the count of commits which hold the full file name (with extension)
-- in their messages as “recursive_count”.
-- ORDER the results ascending by file (file name).
-- Required Columns: file (fileName), recursive_count

SELECT 
    SUBSTRING_INDEX(f.name, '.', 1) AS 'file',
    COUNT(nullif(LOCATE(f.name, c.message), 0)) AS 'recursive_count'
FROM
    `files` AS f
        JOIN
    `files` AS p ON f.parent_id = p.id
        JOIN
    `commits` AS c
WHERE
    f.id <> p.id
    AND f.parent_id = p.id
    AND p.parent_id = f.id
GROUP BY f.name
ORDER BY f.name;


-- 14. RepositoriesAndCommits
-- Extract from the database, for every repository – the count of users
-- that have committed to it.
-- NOTE: 1 user may have more than 1 commit on the repository.
-- ORDER the results descending by users (count of users), and ascending by repository id.
-- Required Columns: id (repositories), name, users (count of users)

SELECT 
    r.id, r.name, COUNT(DISTINCT (c.contributor_id)) AS 'users'
FROM
    `repositories` AS r
        LEFT JOIN
    `commits` AS c ON r.id = c.repository_id
GROUP BY r.id
ORDER BY `users` DESC , r.id;


-- Section 4: Programmability – 30 pts
-- 15. Commit
-- Create a stored procedure udp_commit which accepts the following parameters:
-- username, password, message, issue_id
-- And checks the following things:
-- If the username does NOT exist in the users table:
--  Throw an exception with error code ‘45000’ and message ‘No such user!’.
-- If the password does NOT match the username in the users table:
--  Throw an exception with error code ‘45000’ and message ‘Password is incorrect!’.
-- If there is no issue with the given id in the issues table:
--  Throw an exception with error code ‘45000’ and message ‘The issue does not exist!’.
-- If all checks pass, extract the id of the corresponding user,
-- from the users table, then the repository_id of the issue, from the issues table,
-- and INSERT a new commit into the commits table with the extracted data.
-- The procedure should also update the issue’s status to ‘closed’.

DROP PROCEDURE IF EXISTS udp_commit;

DELIMITER $$
CREATE PROCEDURE udp_commit
    (username VARCHAR(30), password VARCHAR(30), message VARCHAR(255), issue_id INT)
BEGIN
    START TRANSACTION;
    
    IF ((SELECT COUNT(u.id) FROM `users` AS u WHERE u.username = username) = 0) THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'No such user!';
        ROLLBACK;
    ELSEIF ((SELECT u.password FROM `users` AS u WHERE u.username = username) <> password) THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Password is incorrect!';
        ROLLBACK;
    ELSEIF ((SELECT COUNT(i.id) FROM `issues` AS i WHERE i.id = issue_id) = 0) THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'The issue does not exist!';
        ROLLBACK;
    ELSE
        INSERT INTO `commits` 
            (`message`, `issue_id`, `repository_id`, `contributor_id`)
        VALUES
            (message,
            issue_id,
            (SELECT i.repository_id FROM `issues` AS i WHERE i.id = issue_id),
            (SELECT u.id FROM `users` AS u WHERE u.username = username));
        UPDATE `issues` AS i 
        SET 
            i.issue_status = 'closed'
        WHERE
            i.id = issue_id;
        COMMIT;
    END IF;
END $$
DELIMITER ;

CALL udp_commit('WhoDenoteBel', 'ajmISQi*', 'Fixed issue: blah', 2);


-- 16. Filter Extensions
-- Create a stored procedure udp_findbyextension which accepts the following parameters:
-- extension
-- And extracts all files that have the given extension. (like index.html for example)
-- The procedure should extract the file’s id, name and size.
-- The file’s size should have “KB” attached to it as a suffix.
-- The files should be ordered ascending by file id.

DROP PROCEDURE IF EXISTS udp_findbyextension;

DELIMITER $$
CREATE PROCEDURE udp_findbyextension(extension VARCHAR(100))
BEGIN
    SELECT 
        f.id, 
        f.name AS 'caption', 
        CONCAT(f.size, 'KB') AS 'user'
    FROM 
        `files` AS f 
    WHERE 
        f.name LIKE (CONCAT('%', extension))
    ORDER BY f.id;
END $$
DELIMITER ;

CALL udp_findbyextension('html');

