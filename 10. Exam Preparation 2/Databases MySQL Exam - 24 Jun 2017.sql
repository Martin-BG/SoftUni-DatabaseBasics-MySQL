-- https://judge.softuni.bg/Contests/Practice/Index/671#0

CREATE DATABASE `closed_judge_system`;

USE `closed_judge_system`;


-- Section 1: Data Definition Language (DDL) – 40 pts

CREATE TABLE `users` (
    `id` INT PRIMARY KEY,
    `username` VARCHAR(30) UNIQUE NOT NULL,
    `password` VARCHAR(30) NOT NULL,
    `email` VARCHAR(50)
);

CREATE TABLE `categories` (
    `id` INT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    `parent_id` INT,
    CONSTRAINT `fk_categories_parent_id` FOREIGN KEY (`parent_id`)
        REFERENCES `categories` (`id`)
);

CREATE TABLE `contests` (
    `id` INT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    `category_id` INT,
    CONSTRAINT `fk_contests_categories` FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`)
);

CREATE TABLE `problems` (
    `id` INT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `points` INT NOT NULL,
    `tests` INT DEFAULT 0,
    `contest_id` INT,
    CONSTRAINT `fk_problems_contests` FOREIGN KEY (`contest_id`)
        REFERENCES `contests` (`id`)
);

CREATE TABLE `submissions` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `passed_tests` INT NOT NULL,
    `problem_id` INT,
    `user_id` INT,
    CONSTRAINT `fk_submissions_problems` FOREIGN KEY (`problem_id`)
        REFERENCES `problems` (`id`),
    CONSTRAINT `fk_submissions_users` FOREIGN KEY (`user_id`)
        REFERENCES `users` (`id`)
);

CREATE TABLE `users_contests` (
    `user_id` INT NOT NULL,
    `contest_id` INT NOT NULL,
    CONSTRAINT `pk_users_contests` PRIMARY KEY (`user_id` , `contest_id`),
    CONSTRAINT `fk_users_contests_users` FOREIGN KEY (`user_id`)
        REFERENCES `users` (`id`),
    CONSTRAINT `fk_users_contests_contests` FOREIGN KEY (`contest_id`)
        REFERENCES `contests` (`id`)
);


-- Section 2: Data Manipulation Language (DML) – 30 pts

-- Allow unsafe operations
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- 02. Data Insertion
-- You will have to INSERT records of data into the submissions table, based
-- on the problems table. For problem with id between 1 and 10, insert data in
-- the submissions table with the following values:
-- * passed_tests – POWER the length of the name of the problem by 3 and take the
--   SQUARE ROOT of it. SUBTRACT from the resulting value the LENGTH of the problem’s name.
--   ROUND the resulting value UP.
-- * problem_id – the problem’s id.
-- * user_id – MULTIPLY the id of the problem by 3 and DIVIDE it by 2.
--   ROUND the resulting value UP.

INSERT INTO `submissions` 
        (`passed_tests`, `problem_id`, `user_id`)
    SELECT
        CEIL(SQRT(POW(LENGTH(p.name), 3)) - LENGTH(p.name)),
        p.id,
        CEIL(p.id * 3 / 2)
    FROM `problems` AS p
    WHERE p.id BETWEEN 1 AND 10;


-- 03. Data Update
-- UPDATE all problems which have tests equal to 0.
-- DIVIDE the problem’s id by 3 and take the REMAINDER:
-- If the remainder is 0 set the column tests to the LENGTH
--  of the problem’s contest’s category’s name.
-- If the remainder is 1 set the column tests to the SUM
--  of the ids of the problem’s submissions.
-- If the remainder is 2 set the column tests to the LENGTH
--  of the problem’s contest’s name.

UPDATE `problems` AS p
        JOIN
    `contests` AS c ON c.id = p.contest_id
        JOIN
    `categories` AS cat ON cat.id = c.category_id 
SET 
    p.tests = CASE (p.id % 3)
        WHEN 0 THEN LENGTH(cat.name)
        WHEN 1 THEN (SELECT SUM(s.id) FROM `submissions` AS s WHERE s.problem_id = p.id)
        WHEN 2 THEN CHAR_LENGTH(c.name)
    END
WHERE p.tests = 0;


-- 04. Data Deletion
-- DELETE all users which do NOT participate in any contest.

DELETE u FROM `users` AS u
        LEFT JOIN
    `users_contests` AS uc ON uc.user_id = u.id 
WHERE
    uc.user_id IS NULL;


-- Disallow unsafe operations
SET SQL_SAFE_UPDATES = 1;
SET FOREIGN_KEY_CHECKS = 1;

-- Section 3: Querying – 100 pts

-- 05. Users
-- Extract from the database, all of the users. 
-- ORDER the results ascending by user id.
-- Required Columns: id (users), username, email

SELECT 
    u.id, u.username, u.email
FROM
    `users` AS u
ORDER BY u.id;


-- 06. Root Categories
-- Extract from the database, all root categories.
-- A root category is a category which has NO parent.
-- ORDER the results ascending by category id.
-- Required Columns: id (categories), name (categories)

SELECT 
    c.id, c.name
FROM
    `categories` AS c
WHERE
    ISNULL(c.parent_id)
ORDER BY c.id;


-- 07. Well Tested Problems
-- Extract from the database, all problems, which have MORE tests
-- THAN points, and their name consists of two words.
-- The two words will always be separated by a single space.
-- ORDER the results descending by problem id. 
-- Required Columns: id (problems), name (problems), tests

SELECT 
    p.id, p.name, p.tests
FROM
    `problems` AS p
WHERE
    p.tests > p.points
        AND (LENGTH(p.name) - LENGTH(REPLACE(p.name, ' ', ''))) = 1
    --  AND p.name LIKE '% %'
    --  AND p.name REGEXP '^.+ .+$'
ORDER BY p.id DESC;


-- 08. Full Path Problems
-- Extract from the database, all problems and the full path to them.
-- The full path is the concatenation of the category’s name,
-- contest’s name and problem’s name in the following format:
-- {category.name} – {contest.name} – {problem.name}
-- You will have to take the contest in which the problem is and
-- the category in which the contest is.
-- ORDER the results ascending by problem id. 
-- Required Columns: id (problems), full_path

SELECT 
    p.id, CONCAT_WS(' - ', cat.name, c.name, p.name)
FROM
    `problems` AS p
        JOIN
    `contests` AS c ON c.id = p.contest_id
        JOIN
    `categories` AS cat ON cat.id = c.category_id
ORDER BY p.id;


-- 09. Leaf Categories
-- Extract from the database, all leaf categories.
-- A leaf category is a category which has NO children.
-- In other words, there is no category which has the corresponding category as its parent.
-- ORDER the results in alphabetically by category name, and ascending by category id. 
-- Required Columns: id (categories), name (categories)

SELECT 
    c.id, c.name
FROM
    `categories` AS c
        LEFT JOIN
    `categories` AS c2 ON c.id = c2.parent_id
WHERE
    c2.id IS NULL
ORDER BY c.name, c.id;


-- 10. Mainstream Passwords
-- Extract from the database, all users, which have exactly the SAME password as another user.
-- ORDER the results alphabetically by username, and ascending by user id.
-- Required Columns: id (users), username, password

SELECT DISTINCT
    (u.id), u.username, u.password
FROM
    `users` AS u
        JOIN
    `users` AS u2 ON u.password = u2.password
WHERE
    u.id != u2.id
ORDER BY u.username , u.id;

-- Solution with nested SELECT
SELECT DISTINCT
    (u.id), u.username, u.password
FROM
    `users` AS u
WHERE
    u.password IN (SELECT 
            u1.password
        FROM
            `users` AS u1
        WHERE
            u.id <> u1.id)
ORDER BY u.username , u.id;

-- 11. Most Participated Contests
-- Extract from the database, the top 5 contests in terms of count of their contestants.
-- ORDER the result ascending by count of contestants, and ascending by contest id.
-- Required Columns: id (contests), name (contests), contestants

SELECT 
    *
FROM
    (SELECT 
        c.id, c.name, COUNT(uc.contest_id) AS 'contestants'
    FROM
        `contests` AS c
    LEFT JOIN `users_contests` AS uc ON uc.contest_id = c.id
    GROUP BY uc.contest_id
    ORDER BY `contestants` DESC , c.id DESC
    LIMIT 5) AS l
ORDER BY l.contestants , l.id;


-- 12. Most Valuable Person
-- Extract from the database, all submissions of the user that
-- participates in the most contests. 
-- For each submission (if there are any) extract the problem’s name. 
-- Concatenate passed_tests from the submission and tests from the
-- problem in the following format: passed_tests / tests as result.
-- ORDER the results descending by submission id.
-- Required Columns: id (submissions), username (users), name (problems), result

SELECT 
    s.id,
    u.username,
    p.name,
    CONCAT_WS(' / ', s.passed_tests, p.tests)
FROM
    `submissions` AS s
        JOIN
    `problems` AS p ON s.problem_id = p.id
        JOIN
    `users` AS u ON u.id = s.user_id
WHERE
    u.id = (SELECT 
            uc.user_id
        FROM
            `users_contests` AS uc
        GROUP BY uc.user_id
        ORDER BY COUNT(uc.contest_id) DESC
        LIMIT 1)
ORDER BY s.id DESC;

-- Optimised solution
SELECT 
    s.id,
    u.username,
    p.name,
    CONCAT_WS(' / ', s.passed_tests, p.tests)
FROM
    (SELECT 
        uc.user_id
    FROM
        `users_contests` AS uc
    GROUP BY uc.user_id
    ORDER BY COUNT(uc.contest_id) DESC
    LIMIT 1) AS m
        JOIN
    `submissions` AS s ON s.user_id = m.user_id
        JOIN
    `problems` AS p ON s.problem_id = p.id
        JOIN
    `users` AS u ON u.id = s.user_id
ORDER BY s.id DESC;

-- 13. Contests Maximum Points
-- Extract from the database, all contests. For each contest, extract the
-- maximum possible points (sum of all points of its problems IF THERE ARE ANY).
-- ORDER the results descending by maximum possible points, and ascending by contest id.
-- Required Columns: id (contests), name (contests), maximum_points

