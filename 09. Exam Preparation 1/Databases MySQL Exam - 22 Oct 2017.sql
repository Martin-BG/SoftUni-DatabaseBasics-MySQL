CREATE DATABASE `report_service`;

USE `report_service`;

-- Section 1. DDL (30 pts)
-- 01. DDL - Table Design

CREATE TABLE `users` (
    `id` INT(11) UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(30) UNIQUE,
    `password` VARCHAR(50) NOT NULL,
    `name` VARCHAR(50),
    `gender` VARCHAR(1),
    `birthdate` DATETIME,
    `age` INT(11) UNSIGNED,
    `email` VARCHAR(50) NOT NULL
);

CREATE TABLE `departments` (
    `id` INT(11) UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `employees` (
    `id` INT(11) UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(25),
    `last_name` VARCHAR(25),
    `gender` VARCHAR(1),
    `birthdate` DATETIME,
    `age` INT(11) UNSIGNED,
    `department_id` INT(11) UNSIGNED,
    CONSTRAINT `fk_users_departments` FOREIGN KEY (`department_id`)
        REFERENCES `departments` (`id`)
);

CREATE TABLE `categories` (
    `id` INT(11) UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    `department_id` INT(11) UNSIGNED,
    CONSTRAINT `fk_categories_departments` FOREIGN KEY (`department_id`)
        REFERENCES `departments` (`id`)
);

CREATE TABLE `status` (
	`id` INT(11) UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `label` VARCHAR(30) NOT NULL
);

CREATE TABLE `reports` (
    `id` INT(11) UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `category_id` INT(11) UNSIGNED,
    `status_id` INT(11) UNSIGNED,
    `open_date` DATETIME,
    `close_date` DATETIME,
    `description` VARCHAR(200),
    `user_id` INT(11) UNSIGNED,
    `employee_id` INT(11) UNSIGNED,
    CONSTRAINT `fk_reports_categories` FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`),
    CONSTRAINT `fk_reports_status` FOREIGN KEY (`status_id`)
        REFERENCES `status` (`id`),
    CONSTRAINT `fk_reports_users` FOREIGN KEY (`user_id`)
        REFERENCES `users` (`id`),
    CONSTRAINT `fk_reports_employees` FOREIGN KEY (`employee_id`)
        REFERENCES `employees` (`id`)
);


-- Section 2. DML (10 pts)
-- 2. Insert

INSERT INTO `employees`
    (`first_name`, `last_name`, `gender`, `birthdate`, `department_id`)
VALUES
    ('Marlo', 'O''Malley', 'M', '1958-09-21', 1), 
    ('Niki', 'Stanaghan', 'F', '1969-11-26', 4), 
    ('Ayrton', 'Senna', 'M', '1960-03-21', 9), 
    ('Ronnie', 'Peterson', 'M', '1944-02-14', 9), 
    ('Giovanna', 'Amati', 'F', '1959-07-20', 5);

INSERT INTO `reports`
    (`category_id`, `status_id`, `open_date`, `close_date`, 
        `description`, `user_id`, `employee_id`)
VALUES
    (1, 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2),
    (6, 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5),
    (14, 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2),
    (4, 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1);


-- 3. Update
-- Switch all report’s status to 2 where it is currently 1 for the 4 category.

UPDATE `reports`
SET 
    `status_id` = 2
WHERE
    `status_id` = 1 AND `category_id` = 4;


-- 4. Delete
-- Delete all reports who have a status 4.

DELETE FROM `reports` 
WHERE
    `status_id` = 4;


-- Section 3. Querying (40 pts)
-- You need to start with a fresh dataset, so recreate your DB and
-- import the sample data again (Data_ReportService.sql).

-- 5. Users by Age
-- Select all usernames and age ordered by age (ascending) then by username (descending). 

SELECT 
    u.username, u.age
FROM
    `users` AS u
ORDER BY u.age , u.username DESC; 

-- 6. Unassigned Reports
-- Find all reports that don’t have an assigned employee.
-- Order the results by open_date in ascending order, then by description.

SELECT 
    r.description, r.open_date
FROM
    `reports` AS r
WHERE
    r.employee_id IS NULL
ORDER BY r.open_date, r.description;


-- 7. Employees and Reports
-- Select only employees who have an assigned report and show all reports of
-- each found employee. Show the open date column in the format “yyyy-MM-dd”.
-- Order them by employee_id (ascending) then by open_date (again ascending)
-- and by report_id ascending.

SELECT 
    e.first_name,
    e.last_name,
    r.description,
    DATE_FORMAT(r.open_date, '%Y-%m-%d') AS 'open_date'
FROM
    `reports` AS r
        JOIN
    `employees` AS e ON r.employee_id = e.id
ORDER BY r.employee_id , r.open_date , r.id;


-- 8. Most Reported Category
-- Select ALL categories and order them by the number of reports per
-- category in ascending order and then alphabetically by name.

SELECT 
    c.`name` AS 'category_name', COUNT(*) AS 'reports_number'
FROM
    `categories` AS c
        JOIN
    `reports` AS r ON c.id = r.category_id
GROUP BY r.category_id
ORDER BY `reports_number` , c.`name`;


-- 9. One Category Employees
-- Select ALL categories and the number of employees in each
-- category and order them alphabetically by category name.

SELECT 
    c.`name`, COUNT(e.id) AS 'employees_number'
FROM
    `categories` AS c
        JOIN
    `employees` AS e ON c.department_id = e.department_id
GROUP BY c.`name`
ORDER BY c.`name`;


-- 10. Birthday Report
-- Select all categories in which users have submitted a report
-- on their birthday. Order them by name alphabetically.
-- Duplicates are not needed.

SELECT DISTINCT
    (c.`name`) AS 'category_name'
FROM
    `reports` AS r
        JOIN
    `users` AS u ON r.user_id = u.id
        JOIN
    `categories` AS c ON r.category_id = c.id
WHERE
    DAY(r.open_date) = DAY(u.birthdate)
        AND MONTH(r.open_date) = MONTH(u.birthdate)
ORDER BY `category_name`;


-- 11. Users per Employee
-- Select all employees and show how many unique users each of them have served to.
--  Required columns:
--  Employee’s name - Full name consisting of first_name and last_name and a space between them 
--  User’s count
-- Order by users_number descending and then by name ascending.

SELECT 
    CONCAT_WS(' ', e.first_name, e.last_name) AS 'name',
    COUNT(DISTINCT (r.user_id)) AS 'users_count'
FROM
    `employees` AS e
        LEFT OUTER JOIN
    `reports` AS r ON e.id = r.employee_id
GROUP BY e.id
ORDER BY `users_count` DESC , `name`;


-- 12. Emergency Patrol
-- Select all reports which satisfy all the following criteria:
--  are not closed yet (they don’t have a close_date)
--  the description is longer than 20 symbols and the word “str” is mentioned anywhere
--  are assigned to one of the following departments: “Infrastructure”, “Emergency”, “Roads Maintenance”
-- Order the results by open_date and then by Reporter’s Email and report_id ascending.

SELECT 
    r.open_date, r.description, u.email AS 'reporter_email'
FROM
    `reports` AS r
        JOIN
    `users` AS u ON r.user_id = u.id
        JOIN
    `categories` AS c ON r.category_id = c.id
        JOIN
    `departments` AS d ON c.department_id = d.id
WHERE
    r.close_date IS NULL
        AND LENGTH(r.description) > 20
        AND r.description LIKE '%str%'
        AND d.`name` IN ('Infrastructure' , 'Emergency', 'Roads Maintenance')
ORDER BY r.open_date , u.email , r.id;


-- 13. Numbers Coincidence
-- Select all usernames which:
--  starts with a digit and have reported in a category with id equal to the digit
-- OR
--  ends with a digit and have reported in a category with id equal to the digit
-- Order them alphabetically.

SELECT 
    DISTINCT(u.`username`)
FROM
    `reports` AS r
        JOIN
    `users` AS u ON r.user_id = u.id
        JOIN
    `categories` AS c ON r.category_id = c.id
WHERE
    (LEFT(u.`username`, 1) REGEXP '^[0-9]')
        AND CAST(LEFT(u.`username`, 1) AS UNSIGNED) = c.id
        OR (RIGHT(u.`username`, 1) REGEXP '^[0-9]')
        AND CAST(RIGHT(u.`username`, 1) AS UNSIGNED) = c.id
ORDER BY u.`username`;

-- Another WHERE clause:
SELECT DISTINCT
    (u.`username`)
FROM
    `reports` AS r
        JOIN
    `users` AS u ON r.user_id = u.id
        JOIN
    `categories` AS c ON r.category_id = c.id
WHERE
    (CAST(c.id AS CHAR (50)) = LEFT(u.username, 1))
        OR (CAST(c.id AS CHAR (50)) = RIGHT(u.username, 1))
ORDER BY u.`username`;

-- Simplified WHERE clause:
SELECT DISTINCT
    (u.`username`)
FROM
    `reports` AS r
        JOIN
    `users` AS u ON r.user_id = u.id
        JOIN
    `categories` AS c ON r.category_id = c.id
WHERE
    c.id = LEFT(u.username, 1)
        OR c.id = RIGHT(u.username, 1)
ORDER BY u.`username`;

-- 14. Open/Closed Statistics
-- Select all employees who have at least one assigned closed (have a closed_date value)
-- / open report through year 2016 and their number. Reports that have been opened before
-- 2016 but were closed in 2016 are counted as closed only!
-- Order the results by name alphabetically.

SELECT 
    g.`name`,
    CONCAT_WS('/', g.`close`, g.`open`) AS 'closed_open_reports'
FROM
    (SELECT 
        CONCAT_WS(' ', e.first_name, e.last_name) AS 'name',
            COUNT(CASE
                WHEN YEAR(r.close_date) = 2016 THEN 'close'
            END) AS 'close',
            COUNT(CASE
                WHEN YEAR(r.open_date) = 2016 THEN 'open'
            END) AS 'open'
    FROM
        `reports` AS r
    JOIN `employees` AS e ON r.employee_id = e.id
    WHERE
        YEAR(r.close_date) = 2016
            OR YEAR(r.open_date) = 2016
    GROUP BY `name`) AS g
ORDER BY `name`;


-- 15. Average Closing Time
-- Select all departments that have been reported in and the average time(in days)
-- for closing a report for each department. If there is no information (e.g. none
-- closed reports) about any department fill in the Average Duration column “no info”.
-- Round the average duration to the nearest smaller integer value.
-- Order them by department name.

