-- https://judge.softuni.bg/Contests/Compete/Index/298#0

-- Part I – Queries for SoftUni Database
USE `soft_uni`;

-- 01. Employees with Salary Above 35000
-- Create stored procedure usp_get_employees_salary_above_35000 that returns
-- all employees’ first and last names for whose salary is above 35000. 
-- The result should be sorted by first_name then by last_name alphabetically, and id ascending.

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
    SELECT e.first_name, e.last_name
    FROM `employees` AS e
    WHERE e.salary > 35000
    ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

CALL usp_get_employees_salary_above_35000();

DROP PROCEDURE IF EXISTS usp_get_employees_salary_above_35000;

-- 02. Employees with Salary Above Number
-- Create stored procedure usp_get_employees_salary_above that accept a number
-- as parameter and return all employees’ first and last names whose salary is
-- above or equal to the given number. The result should be sorted by first_name
-- then by last_name alphabetically and id ascending.

DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(salary_limit DOUBLE(19,4))
BEGIN
    SELECT e.first_name, e.last_name
    FROM `employees` AS e
    WHERE e.salary >= salary_limit
    ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

CALL usp_get_employees_salary_above(48100);

DROP PROCEDURE IF EXISTS usp_get_employees_salary_above;


-- 03. Town Names Starting With
-- Write a stored procedure usp_get_towns_starting_with that accept string as
-- parameter and returns all town names starting with that string. The result
-- should be sorted by town_name alphabetically.

DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(name_start TEXT)
BEGIN
    SELECT t.name AS 'town_name'
    FROM `towns` AS t
    WHERE t.name LIKE concat(name_start,'%')
    ORDER BY t.name;
END $$
DELIMITER ;

CALL usp_get_towns_starting_with('b');
CALL usp_get_towns_starting_with('be');
CALL usp_get_towns_starting_with('berlin');

DROP PROCEDURE IF EXISTS usp_get_towns_starting_with;


-- 04. Employees from Town
-- Write a stored procedure usp_get_employees_from_town that accepts town_name
-- as parameter and return the employees’ first and last name that live in the
-- given town. The result should be sorted by first_name then by last_name
-- alphabetically and id ascending.

DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town_name TEXT)
BEGIN
    SELECT e.first_name, e.last_name
    FROM `employees` AS e
    JOIN `addresses` AS a ON e.address_id = a.address_id
    JOIN  `towns` AS t ON a.town_id = t.town_id 
    WHERE t.name = town_name
    ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

CALL usp_get_employees_from_town('Sofia');

DROP PROCEDURE IF EXISTS usp_get_employees_from_town;


-- 05. Salary Level Function
-- Write a function ufn_get_salary_level that receives salary
-- of an employee and returns the level of the salary.
-- If salary is < 30000 return “Low”
-- If salary is between 30000 and 50000 (inclusive) return “Average”
-- If salary is > 50000 return “High”

CREATE FUNCTION ufn_get_salary_level(salary DOUBLE(19,4))
RETURNS VARCHAR(7)
RETURN (
    CASE 
        WHEN salary < 30000 THEN 'Low'
        WHEN salary <= 50000 THEN 'Average'
        ELSE 'High'
    END
);

SELECT ufn_get_salary_level(13500);
SELECT ufn_get_salary_level(43300);
SELECT ufn_get_salary_level(125500);

DROP FUNCTION IF EXISTS ufn_get_salary_level;

-- Using return parameter and IF-ELSE construction
DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(salary DOUBLE(19,4))
RETURNS VARCHAR(7)
BEGIN
    DECLARE level VARCHAR(7);
    IF 
        salary < 30000 THEN SET level := 'Low';
    ELSEIF 
        salary <= 50000 THEN SET level := 'Average';
    ELSE 
        SET level := 'High';
    END IF;
    RETURN level;
END $$
DELIMITER ;


-- 06.	Employees by Salary Level
-- Write a stored procedure usp_get_employees_by_salary_level that
-- receive as parameter level of salary (low, average or high) and
-- print the names of all employees that have given level of salary.
-- The result should be sorted by first_name then by last_name both in descending order.

DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(7))
BEGIN
    SELECT e.first_name, e.last_name
    FROM `employees` AS e
    WHERE e.salary < 30000 AND salary_level = 'low'
        OR e.salary >= 30000 AND e.salary <= 50000 AND salary_level = 'average'
        OR e.salary > 50000 AND salary_level = 'high'
    ORDER BY e.first_name DESC, e.last_name DESC;
END $$
DELIMITER ;

-- Solution with call to ufn_get_salary_level
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(7))
BEGIN
    SELECT e.first_name, e.last_name
    FROM `employees` AS e
    WHERE ufn_get_salary_level(e.salary) = salary_level
    ORDER BY e.first_name DESC, e.last_name DESC;
END $$
DELIMITER ;

CALL usp_get_employees_by_salary_level('low');
CALL usp_get_employees_by_salary_level('average');
CALL usp_get_employees_by_salary_level('high');

DROP PROCEDURE IF EXISTS usp_get_employees_by_salary_level;

-- 07. Define Function
-- Define a function ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50)) 
-- that returns true or false depending on that if the word is a comprised of the given
-- set of letters.

CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
RETURN word REGEXP (concat('^[', set_of_letters, ']+$'));

SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');
SELECT ufn_is_word_comprised('oistmiahf', 'halves');
SELECT ufn_is_word_comprised('bobr', 'Rob');
SELECT ufn_is_word_comprised('pppp', 'Guy');

DROP FUNCTION IF EXISTS ufn_is_word_comprised;


-- 08.	* Delete Employees and Departments
-- Write a SQL query to delete all employees from the Production and
-- Production Control departments. Also delete these departments from
-- the departments table.
-- After that exercise restore your database to revert those changes.

ALTER TABLE `departments` DROP FOREIGN KEY `fk_departments_employees`;
ALTER TABLE `departments` DROP INDEX `fk_departments_employees` ;
ALTER TABLE `employees_projects` DROP FOREIGN KEY `fk_employees_projects_employees`;
ALTER TABLE `employees` DROP FOREIGN KEY `fk_employees_employees`;

DELETE FROM `employees` 
WHERE
    `department_id` IN (SELECT 
        d.department_id
    FROM
        `departments` AS d
    WHERE
        d.name IN ('Production' , 'Production Control'));
        
DELETE FROM `departments` 
WHERE
    `name` IN ('Production' , 'Production Control');


-- PART II – Queries for Bank Database
USE `bank`;


-- 09. Find Full Name
-- You are given a database schema with tables:
--  account_holders(id (PK), first_name, last_name, ssn) 
--  accounts(id (PK), account_holder_id (FK), balance).
-- Write a stored procedure usp_get_holders_full_name that selects the
-- full names of all people. The result should be sorted by full_name 
-- alphabetically and id ascending.

DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
    SELECT 
        CONCAT_WS(' ', h.first_name, h.last_name) AS 'full_name'
    FROM
        `account_holders` AS h
            JOIN
        (SELECT DISTINCT
            a.account_holder_id
        FROM
            `accounts` AS a) as a ON h.id = a.account_holder_id
    ORDER BY `full_name`;
END $$
DELIMITER ;

CALL usp_get_holders_full_name();

DROP PROCEDURE IF EXISTS usp_get_holders_full_name;


-- 10. People with Balance Higher Than
-- Your task is to create a stored procedure usp_get_holders_with_balance_higher_than
-- that accepts a number as a parameter and returns all people who have more money in
-- total of all their accounts than the supplied number. 
-- The result should be sorted by first_name then by last_name alphabetically and 
-- account id ascending.

DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(balance DECIMAL(19, 4))
BEGIN
    SELECT 
         h.first_name, h.last_name
    FROM
        `account_holders` AS h
            JOIN
        (SELECT 
            a.id, a.account_holder_id, SUM(a.balance) AS 'total_balance'
        FROM
            `accounts` AS a
        GROUP BY (a.account_holder_id)
        HAVING `total_balance` > balance) as a ON h.id = a.account_holder_id
    ORDER BY a.id;
END $$
DELIMITER ;

CALL usp_get_holders_with_balance_higher_than(7000);

DROP PROCEDURE IF EXISTS usp_get_holders_with_balance_higher_than;


-- 11. Future Value Function
-- Your task is to create a function ufn_calculate_future_value that accepts 
-- as parameters – sum, yearly interest rate and number of years. It should 
-- calculate and return the future value of the initial sum. Using the following formula:
-- FV=I*((1+R)^T)
--  I – Initial sum
--  R – Yearly interest rate
--  T – Number of years

DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(
    initial_sum DECIMAL(19, 4), interest_rate DECIMAL(19, 4), years INT)
RETURNS DECIMAL(19, 4)
-- RETURNS DOUBLE(19, 2) -- Judge
BEGIN
    RETURN initial_sum * POW((1 + interest_rate), years);
END $$
DELIMITER ;

SELECT ufn_calculate_future_value(1000, 0.1, 5); -- Expected result: 1610.51

DROP FUNCTION IF EXISTS ufn_calculate_future_value;


-- 12. Calculating Interest
-- Your task is to create a stored procedure usp_calculate_future_value_for_account
-- that uses the function from the previous problem to give an interest to a person's
-- account for 5 years, along with information about his/her account id, first name,
-- last name and current balance as it is shown in the example below. It should take
-- the account_id and the interest_rate as parameters. Interest rate should have
-- precision up to 0.0001, same as the calculated balance after 5 years. Be extremely
-- careful to achieve the desired precision!
/*
Here is the result for account_id = 1 and interest_rate = 0.1.
account_id  fist_name   last_name   current_balance balance_in_5_years
1           Susan       Cane        123.1200        198.2860
*/

DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(
    account_id INT, interest_rate DECIMAL(19, 4))
BEGIN
    SELECT 
         a.id AS 'account_id', h.first_name, h.last_name, a.balance AS 'current_balance',
         ufn_calculate_future_value(a.balance, interest_rate, 5) AS 'balance_in_5_years'
    FROM
        `account_holders` AS h
            JOIN
        `accounts` AS a ON h.id=a.account_holder_id
    WHERE a.id = account_id;
END $$
DELIMITER ;

CALL usp_calculate_future_value_for_account(1, 0.1);

DROP PROCEDURE IF EXISTS usp_calculate_future_value_for_account;


-- 13. Deposit Money
-- Add stored procedure usp_deposit_money(account_id, money_amount) that operate in
-- transactions. Make sure to guarantee valid positive money_amount with precision
-- up to fourth sign after decimal point. The procedure should produce exact results
-- working with the specified precision.
/*
Here is the result for account_id = 1 and money_amount = 10.
account_id  account_holder_id   balance
1           1                   133.1200
*/

DELIMITER $$
CREATE PROCEDURE usp_deposit_money(
    account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 THEN
        START TRANSACTION;
        
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance + money_amount
        WHERE
            a.id = account_id;
        
        IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END $$
DELIMITER ;

CALL usp_deposit_money(1, 10);

SELECT 
    a.id AS 'account_id', a.account_holder_id, a.balance
FROM
    `accounts` AS a
WHERE
    a.id = 1;
            
DROP PROCEDURE IF EXISTS usp_deposit_money;


-- 14. Withdraw Money
-- Add stored procedures usp_withdraw_money(account_id, money_amount)
-- that operate in transactions. 
-- Make sure to guarantee withdraw is done only when balance is enough
-- and money_amount is valid positive number. Work with precision up
-- to fourth sign after decimal point. The procedure should produce exact
-- results working with the specified precision.
/*
Here is the result for account_id = 1 and money_amount = 10.
account_id  account_holder_id   balance
1           1                   113.1200
*/

DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(
    account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 THEN
        START TRANSACTION;
        
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance - money_amount
        WHERE
            a.id = account_id;
        
        IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END $$
DELIMITER ;

CALL usp_withdraw_money(1, 10);

SELECT 
    a.id AS 'account_id', a.account_holder_id, a.balance
FROM
    `accounts` AS a
WHERE
    a.id = 1;

DROP PROCEDURE IF EXISTS usp_withdraw_money;


-- 15. Money Transfer
-- Write stored procedure usp_transfer_money(from_account_id, to_account_id, amount)
-- that transfers money from one account to another. Consider cases when one of the
-- account_ids is not valid, the amount of money is negative number, outgoing balance
-- is enough or transferring from/to one and the same account. Make sure that the whole
-- procedure passes without errors and if error occurs make no change in the database. 
-- Make sure to guarantee exact results working with precision up to fourth sign after
-- decimal point.
/*
Here is the result for from_account_id = 1, to_account_id = 2 and money_amount = 10.
account_id  account_holder_id   balance
1           1                   113.1200
2           3                   4364.2300
*/

DELIMITER $$
CREATE PROCEDURE usp_transfer_money(
    from_account_id INT, to_account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 
        AND from_account_id <> to_account_id 
        AND (SELECT a.id 
            FROM `accounts` AS a 
            WHERE a.id = to_account_id) IS NOT NULL
        AND (SELECT a.id 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) IS NOT NULL
        AND (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) >= money_amount
    THEN
        START TRANSACTION;
        
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance + money_amount
        WHERE
            a.id = to_account_id;
            
        UPDATE `accounts` AS a 
        SET 
            a.balance = a.balance - money_amount
        WHERE
            a.id = from_account_id;
        
        IF (SELECT a.balance 
            FROM `accounts` AS a 
            WHERE a.id = from_account_id) < 0
            THEN ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END $$
DELIMITER ;

CALL usp_transfer_money(1, 2, 10);
CALL usp_transfer_money(2, 1, 10);

SELECT 
    a.id AS 'account_id', a.account_holder_id, a.balance
FROM
    `accounts` AS a
WHERE
    a.id IN (1 , 2);
            
DROP PROCEDURE IF EXISTS usp_transfer_money;


-- 16. Log Accounts Trigger
-- Create another table – logs(log_id, account_id, old_sum, new_sum). 
-- Add a trigger to the accounts table that enters a new entry into the logs
-- table every time the sum on an account changes.
/*
The following data in logs table is inserted after updating balance of
account with account_id = 1 with 10.
 
log_id  account_id  old_sum new_sum
1       1           123.12  113.12
2       1           145.43  155.43
*/

CREATE TABLE `logs` (
    log_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    account_id INT(11) NOT NULL,
    old_sum DECIMAL(19, 4) NOT NULL,
    new_sum DECIMAL(19, 4) NOT NULL
);

DELIMITER $$
CREATE TRIGGER `tr_balance_updated`
AFTER UPDATE ON `accounts`
FOR EACH ROW
BEGIN
    IF OLD.balance <> NEW.balance THEN
        INSERT INTO `logs` 
            (`account_id`, `old_sum`, `new_sum`)
        VALUES (OLD.id, OLD.balance, NEW.balance);
    END IF;
END $$
DELIMITER ;

CALL usp_transfer_money(1, 2, 10);
CALL usp_transfer_money(2, 1, 10);

SELECT * FROM `logs`;

DROP TRIGGER IF EXISTS `bank`.tr_balance_updated;
DROP TABLE IF EXISTS `logs`;


-- 17.	Emails Trigger
-- Create another table – notification_emails(id, recipient, subject, body).
-- Add a trigger to logs table to create new email whenever new record is inserted
-- in logs table. The following data is required to be filled for each email:
-- * recipient – account_id
-- * subject – “Balance change for account: {account_id}”
-- * body - “On {date (current date)} your balance was changed from {old} to {new}.”
/*	
id  recipient   subject                         body
1   1           Balance change for account: 1   On Sep 15 2016 at 11:44:06 AM your balance was changed from 133 to 143.
…   …           …                               …
*/ 

CREATE TABLE `notification_emails` (
    `id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `recipient` INT(11) NOT NULL,
    `subject` VARCHAR(50) NOT NULL,
    `body` VARCHAR(255) NOT NULL
);

DELIMITER $$
CREATE TRIGGER `tr_notification_emails`
AFTER INSERT ON `logs`
FOR EACH ROW
BEGIN
    INSERT INTO `notification_emails` 
        (`recipient`, `subject`, `body`)
    VALUES (
        NEW.account_id, 
        CONCAT('Balance change for account: ', NEW.account_id), 
        CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), ' your balance was changed from ', ROUND(NEW.old_sum, 2), ' to ', ROUND(NEW.new_sum, 2), '.'));
END $$
DELIMITER ;

SELECT * FROM `notification_emails`;

DROP TRIGGER IF EXISTS `bank`.tr_notification_emails;
DROP TABLE IF EXISTS `notification_emails`;
