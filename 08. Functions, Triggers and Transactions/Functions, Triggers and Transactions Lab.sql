USE `soft_uni`;

-- 1. Count Employees by Town
-- Write a function ufn_count_employees_by_town(town_name) 
-- that accepts town_name as parameter and returns the count 
-- of employees who live in that town. 

CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(20))
RETURNS INT
RETURN (
		SELECT COUNT(e.employee_id) 
		FROM `employees` AS e
			JOIN `addresses` AS a ON a.address_id = e.address_id
			JOIN `towns` AS t ON t.town_id = a.town_id
        WHERE t.name = town_name
);

-- Demo
SELECT ufn_count_employees_by_town('Sofia') AS 'count';

-- Cleanup
DROP FUNCTION IF EXISTS ufn_count_employees_by_town;


-- 2. Employees Promotion
-- Write a stored procedure usp_raise_salaries(department_name) to 
-- raise the salary of all employees in given department as parameter by 5%.

DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
	UPDATE `employees` AS e
    JOIN `departments` AS d ON e.department_id = d.department_id
    SET e.salary = e.salary * 1.05
    WHERE d.name = department_name;
END $$
DELIMITER ;

-- Demo
DELIMITER $$
CREATE PROCEDURE usp_get_salary_by_department(department_name VARCHAR(50))
BEGIN
	SELECT 
		e.employee_id, e.salary
	FROM
		`employees` AS e
			JOIN
		`departments` AS d ON e.department_id = d.department_id
	WHERE
		d.name = department_name;
END $$
DELIMITER ;

CALL usp_get_salary_by_department('Sales');

SET SQL_SAFE_UPDATES=0;
CALL usp_raise_salaries('Sales');
SET SQL_SAFE_UPDATES=1;

CALL usp_get_salary_by_department('Sales');

DROP PROCEDURE IF EXISTS usp_raise_salaries;
DROP PROCEDURE IF EXISTS ufn_get_salary_by_department;


-- 3.	Employees Promotion By ID
-- Write a stored procedure usp_raise_salary_by_id(id) that raises
-- a given employee’s salary (by id as parameter) by 5%. Consider 
-- that you cannot promote an employee that doesn’t exist – if that 
-- happens, no changes to the database should be made. 

DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT(10))
BEGIN
	UPDATE `employees` AS e
    SET e.salary = e.salary * 1.05
    WHERE e.employee_id = id;
END $$
DELIMITER ;

-- With transaction
DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT(10))
BEGIN
	START TRANSACTION;
    IF((SELECT COUNT(e.employee_id) 
		FROM `employees` as e 
		WHERE e.employee_id LIKE id)<>1) 
		THEN ROLLBACK;
    ELSE
		UPDATE `employees` AS e
		SET e.salary = e.salary * 1.05
		WHERE e.employee_id = id;
	END IF;
END $$
DELIMITER ;

-- 4. Triggered
-- Create a table deleted_employees(employee_id PK, first_name,
-- last_name,middle_name,job_title,deparment_id,salary) that will hold 
-- information about fired(deleted) employees from the employees table. 
-- Add a trigger to employees table that inserts the corresponding 
-- information in deleted_employees.

CREATE TABLE deleted_employees(
	`employee_id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(20),
    `last_name` VARCHAR(20),
    `middle_name` VARCHAR(20),
    `job_title` VARCHAR(50),
    `department_id` INT,
    `salary` DOUBLE
);

DELIMITER $$
CREATE TRIGGER tr_deleted_employees
AFTER DELETE ON `employees`
FOR EACH ROW
BEGIN
	INSERT INTO `deleted_employees` 
		(`first_name`, `last_name`, `middle_name`, 
			`job_title`, `department_id`, `salary`)
    VALUES (OLD.first_name, OLD.last_name, OLD.middle_name, 
		OLD.job_title, OLD.department_id, OLD.salary);
END $$
DELIMITER ;


-- Examples from presentation slides

DELIMITER $$
CREATE PROCEDURE usp_select_employees_by_seniority()
BEGIN
	SELECT *
    FROM `employees` AS e
    WHERE ROUND(DATEDIFF(NOW(), e.hire_date) / 365.25) < 15;
END $$
DELIMITER ;

CALL usp_select_employees_by_seniority();

DROP PROCEDURE usp_select_employees_by_seniority;

--
DELIMITER $$
CREATE PROCEDURE usp_select_employees_by_seniority(min_years_at_work INT)
BEGIN
	SELECT 
		e.first_name, 
        e.last_name, 
        e.hire_date, 
        ROUND(DATEDIFF(NOW(), e.hire_date) / 365.25) AS 'years'
    FROM `employees` AS e
    WHERE ROUND(DATEDIFF(NOW(), e.hire_date) / 365.25) > min_years_at_work
    ORDER BY e.hire_date;
END $$
DELIMITER ;

CALL usp_select_employees_by_seniority(15);

DROP PROCEDURE usp_select_employees_by_seniority;

--
DELIMITER $$
CREATE PROCEDURE usp_add_numbers(
	first_number INT, second_number INT, OUT result INT)
BEGIN
	SET result := first_number + second_number;
END $$
DELIMITER ;

SET @result=0;
CALL usp_add_numbers(5, 6, @result);
SELECT @result as 'result';

DROP PROCEDURE usp_add_numbers;