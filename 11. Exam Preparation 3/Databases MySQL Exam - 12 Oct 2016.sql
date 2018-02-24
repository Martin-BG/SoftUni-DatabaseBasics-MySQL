-- https://judge.softuni.bg/Contests/Practice/Index/319#0

-- Import all from 'Bank Skeleton.sql'

USE `bank`;

-- Section 1. DDL
CREATE TABLE `deposit_types` (
    `deposit_type_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(20)
);

CREATE TABLE `deposits` (
    `deposit_id` INT PRIMARY KEY AUTO_INCREMENT,
    `amount` DECIMAL(10 , 2 ),
    `start_date` DATE,
    `end_date` DATE,
    `deposit_type_id` INT,
    `customer_id` INT,
    CONSTRAINT `fk_deposits_customers` FOREIGN KEY (`customer_id`)
        REFERENCES `customers` (`customer_id`),
    CONSTRAINT `fk_deposits_deposit_types` FOREIGN KEY (`deposit_type_id`)
        REFERENCES `deposit_types` (`deposit_type_id`)
);

CREATE TABLE `employees_deposits` (
    `employee_id` INT,
    `deposit_id` INT,
    CONSTRAINT `pk_employees_deposits` PRIMARY KEY (`employee_id` , `deposit_id`),
    CONSTRAINT `fk_employees_deposits_employees` FOREIGN KEY (`employee_id`)
        REFERENCES `employees` (`employee_id`),
    CONSTRAINT `fk_employees_deposits_deposits` FOREIGN KEY (`deposit_id`)
        REFERENCES `deposits` (`deposit_id`)
);

CREATE TABLE `credit_history` (
    `credit_history_id` INT PRIMARY KEY AUTO_INCREMENT,
    `mark` CHARACTER(1),
    `start_date` DATE,
    `end_date` DATE,
    `customer_id` INT,
    CONSTRAINT `fk_credit_history_customers` FOREIGN KEY (`customer_id`)
        REFERENCES `customers` (`customer_id`)
);

CREATE TABLE `payments` (
    `payement_id` INT PRIMARY KEY AUTO_INCREMENT,
    `date` DATE,
    `amount` DECIMAL(10 , 2 ),
    `loan_id` INT,
    CONSTRAINT `fk_payments_loans` FOREIGN KEY (`loan_id`)
        REFERENCES `loans` (`loan_id`)
);

CREATE TABLE `users` (
    `user_id` INT PRIMARY KEY AUTO_INCREMENT,
    `user_name` VARCHAR(20),
    `password` VARCHAR(20),
    `customer_id` INT UNIQUE,
    CONSTRAINT `fk_users_customers` FOREIGN KEY (`customer_id`)
        REFERENCES `customers` (`customer_id`)
);

ALTER TABLE `employees` 
    ADD COLUMN `manager_id` INT, 
    ADD CONSTRAINT `fk_employees_employees` FOREIGN KEY (`manager_id`)
    REFERENCES `employees` (`employee_id`);


-- Section 2: DML - P01. Inserts
-- Add all customers with ID lower than 20 to table Deposits.
--  The id should be auto generated from table deposits
--  The deposit amount is based on the following logic
--  If you are born after 01-01-1980 then it is 1000 BGN else, it is 1500 BGN
--  If you are Male add 100 BGN else add 200 BGN 
--  The start date should be the current date
--  The end should be empty
--  The deposit type id should 1 if the customer id is odd and 2 if the customer id is even.
--   If the customer id is larger than 15 then the deposit type should be 3.
--  The customer id should come from table Customers

INSERT INTO `deposit_types` VALUES
    (1, 'Time Deposit'),
    (2, 'Call Deposit'),
    (3, 'Free Deposit');

INSERT INTO `deposits`
    (`amount`, `start_date`, `deposit_type_id`, `customer_id`)
    SELECT 
        (IF(c.date_of_birth > '1980-01-01',
            1000,
            1500) + IF(c.gender = 'M', 100, 200)) AS 'amount',
        DATE(NOW()) AS 'start_date',
        IF(c.customer_id > 15,
            3,
            IF(c.customer_id % 2 = 1, 1, 2)) AS 'deposit_type_id',
        c.customer_id
    FROM
        `customers` AS c
    WHERE
        c.customer_id < 20;
    
INSERT INTO `employees_deposits` 
VALUES
    (15, 4),
    (20, 15),
    (8, 7),
    (4, 8),
    (3, 13),
    (3, 8),
    (4, 10),
    (10, 1),
    (13, 4),
    (14, 9);


-- Section 2: DML - P02. Update
-- Update table Employees. The manager id should have the following values:
--  If EmployeeID is in the range [2;10] then the value is 1
--  If EmployeeID is in the range [12;20] then the value is 11
--  If EmployeeID is in the range [22;30] then the value is 21
--  If EmployeeID is in 11 or 21 then 1

UPDATE `employees` AS e 
SET 
    e.manager_id = CASE
        WHEN e.employee_id BETWEEN 2 AND 11 THEN 1
        WHEN e.employee_id BETWEEN 12 AND 20 THEN 11
        WHEN e.employee_id = 21 THEN 1
        WHEN e.employee_id BETWEEN 22 AND 30 THEN 21
    END;


-- Section 2: DML - P03. Delete
-- Delete all records from EmployeeDeposits if the DepositID is 9 or the EmployeeID is 3

DELETE e FROM `employees_deposits` AS e 
WHERE
    e.deposit_id = 9 OR e.employee_id = 3;


-- Section 3: Querying - P01. Employees’ Salary
-- Write a query that returns: employee_id, hire_date, salary, branch_id
-- from table Employees. Filter employees which salaries are higher than
-- 2000 and their hire date is after 15/06/2009.

SELECT 
    e.employee_id, e.hire_date, e.salary, e.branch_id
FROM
    `employees` AS e
WHERE
    e.salary > 2000
        AND e.hire_date > '2009-06-15';


-- Section 3: Querying - P02. Customer Age
-- Write a query that returns: first_name, date_of_birth, age
-- of all customers who are between 40 and 50 years old. The range is inclusive.
-- Consider that today is 01-10-2016. Assume that each year has 360 days.

SELECT 
    *
FROM
    (SELECT 
        c.first_name,
            c.date_of_birth,
            FLOOR(DATEDIFF('2016-10-01', c.date_of_birth) / 360) AS 'age'
    FROM
        `customers` AS c) AS a
WHERE
    a.age BETWEEN 40 AND 50;
    

-- Section 3: Querying - P03. Customer City
-- Write a query that returns: customer_id, first_name, last_name, gender, city_name
-- for all customers whose last name starts with ‘Bu’ or first name ends with ‘a’.
-- Moreover, for those customers the length of the city name should at least 8 letters.
-- Sort by CustomerID in ascending order.

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.gender,
    ct.city_name
FROM
    `customers` AS c
        JOIN
    `cities` AS ct ON c.city_id = ct.city_id
WHERE
    (c.first_name LIKE '%a'
        OR c.last_name LIKE 'Bu%')
        AND CHAR_LENGTH(ct.city_name) >= 8
ORDER BY c.customer_id;


-- Section 3: Querying - P04. Employee Accounts
-- Write a query that returns top 5: employee_id, first_name, account_number
-- of all employees who are responsible for maintaining accounts which has
-- started after the year of 2012. Sort the results by the first name of the
-- employees in descending order.

SELECT 
    e.employee_id,
    e.first_name,
    a.account_number
FROM
    `employees` AS e
        JOIN
    `employees_accounts` AS ea ON e.employee_id = ea.employee_id
        JOIN
    `accounts` AS a ON ea.account_id = a.account_id
WHERE
    YEAR(a.start_date) > 2012
ORDER BY e.first_name DESC
LIMIT 5;


-- Section 3: Querying - P05. Count Cities
-- Write a query that returns: city_name, name (of the branch), employees_count
-- The count of all employees grouped by city name and branch name.
-- Exclude cities with id 4 and 5. Don’t show groups with less than 3 employees.

SELECT 
    c.city_name,
    b.name,
    COUNT(e.employee_id) AS 'employees_count'
FROM
    `employees` AS e
        JOIN
    `branches` AS b ON e.branch_id = b.branch_id
        JOIN
    `cities` AS c ON b.city_id = c.city_id
WHERE
    c.city_id NOT IN (4 , 5)
GROUP BY c.city_name , b.name
HAVING `employees_count` > 2;


-- Section 3: Querying - P06. Loan Statistics
-- Write a query that returns:
--  The total amount of loans
--  Max interest of loans
--  Min salary of employees
-- Of all employees that are responsible for maintaining the loans.

SELECT 
    SUM(l.amount) AS 'total_loan_amount',
    MAX(l.interest) AS 'max_interest',
    MIN(e.salary) AS 'min_employee_salary'
FROM
    `employees` AS e
        JOIN
    `employees_loans` AS el ON e.employee_id = el.employee_id
        JOIN
    `loans` AS l ON el.loan_id = l.loan_id;


-- Section 3: Querying - P07. Unite People
-- Write a query that returns top 3 employees’ first names and the city name
-- of their branch followed by top 3 customer’s first names and the name of
-- the city they live in.

(SELECT 
    e.first_name, c.city_name
FROM
    `employees` AS e
        JOIN
    `branches` AS b ON e.branch_id = b.branch_id
        JOIN
    `cities` AS c ON b.city_id = c.city_id
LIMIT 3) UNION (SELECT 
    c.first_name, ct.city_name
FROM
    `customers` AS c
        JOIN
    `cities` AS ct ON c.city_id = ct.city_id
LIMIT 3);


-- Section 3: Querying - P08. Customers w/o Accounts
-- Write a query that returns: customer_id, height
-- of all customers who doesn’t have accounts.
-- Filter only those who are tall between 1.74 and 2.04.

SELECT 
    c.customer_id, c.height
FROM
    `customers` AS c
        LEFT JOIN
    `accounts` AS a ON c.customer_id = a.customer_id
WHERE
    a.account_id IS NULL
        AND c.height BETWEEN 1.74 AND 2.04;


-- Section 3: Querying - P09. Average Loans
-- Write a query that returns top 5 rows: customer_id, amount
-- of all customers who have loans higher than the average loan amount of the
-- male customers. Sort the data by customer last name in ascending order

SELECT 
    c.customer_id, l.amount
FROM
    `loans` AS l
        JOIN
    `customers` AS c ON l.customer_id = c.customer_id
WHERE
    l.amount > (SELECT 
            AVG(l.amount)
        FROM
            `loans` AS l
                JOIN
            `customers` AS c ON l.customer_id = c.customer_id
        WHERE
            c.gender = 'M')
ORDER BY c.last_name
LIMIT 5;


-- Section 3: Querying - P10. Oldest Account
-- Write a query that returns: customer_id, first_name, start_date
-- for the customer with the oldest account.

SELECT 
    c.customer_id, c.first_name, a.start_date
FROM
    `customers` AS c
        JOIN
    `accounts` AS a ON c.customer_id = a.customer_id
ORDER BY a.start_date
LIMIT 1;


-- Section 4: Programmability - P01. String Joiner
-- Write a function with name udf_concat_string that reverses two strings,
-- joins them and returns the concatenation. The function should have two
-- input parameters of type VARCHAR.

CREATE FUNCTION udf_concat_string(str1 VARCHAR(50), str2 VARCHAR(50))
RETURNS VARCHAR(100)
    RETURN CONCAT(REVERSE(str1), REVERSE(str2));

SELECT udf_concat_string('123', '789');


-- Section 4: Programmability - P02. Inexpired Loans
-- Write a procedure that returns a customer if it has unexpired loan.
-- The following result set should be returned: customer_id, first_name, loan_id
-- The function should have one parameter for customer_id of type integer.
-- Name the function usp_customers_with_unexpired_loans.
-- If the id of the customer doesn’t have unexpired loans return an empty result set.

DELIMITER $$
CREATE PROCEDURE usp_customers_with_unexpired_loans(customer_id INT)
BEGIN
    SELECT
        c.customer_id, c.first_name, l.loan_id
    FROM `customers` AS c 
        JOIN 
    `loans` AS l ON c.customer_id = l.customer_id
    WHERE 
        c.customer_id = customer_id
            AND l.expiration_date IS NULL;
END $$
DELIMITER ;

CALL usp_customers_with_unexpired_loans(9);


-- Section 4: Programmability - P03. Take Loan
-- Write usp_take_loan procedure that adds a loan to an existing customer.
-- The procedure should have the following input parameters:
--  customer_id, loan_amount, interest, start_date
-- If the loan amount is not between 0.01 AND 100000 raise an error
-- ‘Invalid Loan Amount.’ And rollback the transaction.
-- If no error is raised insert the loan into table Loans.
-- The column loan_id has an auto_increment property so there is no
-- need to specify a value for it. 

DELIMITER $$
CREATE PROCEDURE usp_take_loan
    (customer_id INT, loan_ammount DECIMAL(18,2), interest DECIMAL(4,2), start_date DATE)
BEGIN
    IF (loan_ammount NOT BETWEEN 0.01 AND 100000) THEN
            SIGNAL SQLSTATE '45000'
            SET Message_Text = 'Invalid Loan Amount.';
    ELSE
        INSERT INTO `loans` (`start_date`, `amount`, `interest`, `customer_id`)
            VALUES (start_date, loan_ammount, interest, customer_id);
    END IF;
END $$
DELIMITER ;

CALL usp_take_loan (1, 500, 1,'20160915')


-- Section 4: Programmability - P04. Hire Employee
-- Write a trigger on table Employees. After an insert of a new employee
-- the new employee takes the loan maintenance of the previous employee.
-- Hint: Your trigger should update table employees_loans


DELIMITER $$
CREATE TRIGGER tr_employees_insert
AFTER INSERT ON `employees`
FOR EACH ROW
BEGIN
    UPDATE `employees_loans` AS el
    SET el.employee_id = new.employee_id
    WHERE el.employee_id + 1= new.employee_id;
END $$
DELIMITER ;


-- Section 5: Bonus - P01. Delete Trigger
-- Create a table with the same structure as table accounts and name it account_logs.
-- Then create a trigger that logs the deleted records from table accounts into table
-- account_logs. Post in judge only the create trigger statement

CREATE TABLE `account_logs` LIKE `accounts`;  

DELIMITER $$
CREATE TRIGGER tr_accounts_delete
AFTER DELETE ON `accounts`
FOR EACH ROW
BEGIN
    INSERT INTO `account_logs` 
    VALUES (OLD.account_id, OLD.account_number, OLD.start_date, OLD.customer_id);
END $$
DELIMITER ;

-- Test
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM accounts
WHERE customer_id = 4;
SET FOREIGN_KEY_CHECKS=1;

-- Better solution
DROP TRIGGER IF EXISTS tr_accounts_delete;

DELIMITER $$
CREATE TRIGGER tr_accounts_delete
BEFORE DELETE ON `accounts`
FOR EACH ROW
BEGIN
    DELETE FROM `employees_accounts`
    WHERE account_id = OLD.account_id;
    
    INSERT INTO `account_logs` 
    VALUES (OLD.account_id, OLD.account_number, OLD.start_date, OLD.customer_id);
END $$
DELIMITER ;