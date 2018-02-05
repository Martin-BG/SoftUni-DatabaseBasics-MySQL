USE `hospital`;

-- Problem 1: Select Employee Information
-- Write a query to select all employees and retrieve information about 
-- their id, first_name, last_name and job_title ordered by id.
SELECT 
    `id`, `first_name`, `last_name`, `job_title`
FROM
    `employees`
ORDER BY `id` ASC;
    
-- Problem 2: Select Employees with Filter
-- Write a query to select all employees (id, first_name, last_name, job_title, salary) 
-- whose salaries are higher than 1000.00, ordered by id. Concatenate fields first_name 
-- and last_name into ‘full_name’.

SELECT 
    `id`,
    CONCAT(`first_name`, ' ', `last_name`) AS 'full_name',
    `job_title`,
    `salary`
FROM
    `employees`
WHERE
    `salary` > 1000.00
ORDER BY `id` ASC;
    
-- Problem 3: Update Employees Salary
-- Update all employees salaries whose job_title is “Therapist” by 10%. 
-- Retrieve information about all salaries ordered ascending.

UPDATE `employees`
	SET `salary` = `salary` * 1.1
    WHERE `job_title` = 'Therapist';
    
SELECT `salary`
	FROM `employees`
	ORDER BY `salary` ASC;
    
-- Problem 4: Top Paid Employee
-- Write a query to create a view that selects all information about the 
-- top paid employee from the “employees” table in the hospital database.

SELECT * FROM `employees`
	ORDER BY `salary` DESC
    LIMIT 1;
    
-- Problem 5: Select Employees by Multiple Filters
-- Write a query to retrieve information about employees, who are in department 
-- 4 and have salary higher or equal to 1600. Order the information by id.

SELECT * FROM `employees`
	WHERE (`department_id` = 4 AND `salary` >= 1600.0)
    ORDER BY `id`;
    
-- Problem 6: Delete from Table
-- Write a query to delete all employees from the “employees” table who are 
-- in department 2 or 1. Order the information by id.

DELETE FROM `employees`
	WHERE `department_id` IN (2, 1);

SELECT *
	FROM `employees`
	ORDER BY `id` ASC;
    