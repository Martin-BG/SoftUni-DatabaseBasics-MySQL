-- https://judge.softuni.bg/Contests/Practice/Index/605#0

CREATE DATABASE `exercises`;
USE `exercises`;

-- 01. One-To-One Relationship
-- Create two tables as follows. Use appropriate data types.
/*
persons	   
	person_id	first_name	salary		passport_id	   
	1  			Roberto  	43300.00	102	   
	2			Tom			56100.00	103	   
	3			Yana		60200.00	101	
	   
passports	   
	passport_id	passport_number	   
	101			N34FG21B	   
	102			K65LO4R7	   
	103			ZE657QP2	
*/
-- Insert the data from the example above.
-- Alter table persons and make person_id a primary key. 
-- Create a foreign key between persons and passports by using passport_id column. 
-- Think about which passport field should be UNIQUE

CREATE TABLE `persons` (
	`person_id` INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `salary` DECIMAL(10, 2) NOT NULL DEFAULT 0,
    `passport_id` INT UNSIGNED NOT NULL UNIQUE
);

CREATE TABLE `passports` (
	`passport_id` INT UNSIGNED UNIQUE AUTO_INCREMENT PRIMARY KEY,
    `passport_number` VARCHAR(8) NOT NULL UNIQUE
) AUTO_INCREMENT=101;

INSERT 
	INTO `persons` (`first_name`, `salary`, `passport_id`) 
	VALUES 
		('Roberto', 43300, 102), 
		('Tom', 56100, 103), 
		('Yana', 60200, 101);

INSERT 
	INTO `passports` (`passport_number`) 
    VALUES ('N34FG21B'), ('K65LO4R7'), ('ZE657QP2');

ALTER TABLE `persons` 
	ADD CONSTRAINT `pk_persons` 
		PRIMARY KEY (`person_id`),
    ADD CONSTRAINT `fk_persons_passports` 
		FOREIGN KEY(`passport_id`) 
        REFERENCES `passports`(`passport_id`);


-- 02.	One-To-Many Relationship
-- Create two tables as follows. Use appropriate data types.
/* 
manufacturers	   
	manufacturer_id		name	established_on	   
	1  					BMW     01/03/1916	   
	2					Tesla	01/01/2003	   
	3					Lada	01/05/1966	   
    
models	   
	model_id	name		manufacturer_id	   
	101			X1			1	   
	102			i6			1	   
	103			Model S		2	   
	104			Model X		2	   
	105			Model 3		2	   
	106			Nova		3	 
*/
-- Insert the data from the example above. 
-- Add primary and foreign keys.

CREATE TABLE `manufacturers` (
	`manufacturer_id` INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(30) UNIQUE NOT NULL,
    `established_on` DATE NOT NULL
);

CREATE TABLE `models` (
	`model_id` INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    `manufacturer_id` INT UNSIGNED NOT NULL
) AUTO_INCREMENT=101;

-- Data should be inserted here, but if we do so the data test in 
-- Judge fails because entries are not order as expected there so
-- first we have to complete tables setup.

ALTER TABLE `manufacturers` 
	ADD CONSTRAINT `pk_manufacturers` 
		PRIMARY KEY (`manufacturer_id`);

ALTER TABLE `models` 
	ADD CONSTRAINT `pk_models` 
		PRIMARY KEY (`model_id`),
    ADD CONSTRAINT `fk_models_manufacturers` 
		FOREIGN KEY (`manufacturer_id`)
        REFERENCES `manufacturers` (`manufacturer_id`);

INSERT 
	INTO `manufacturers` (`name`, `established_on`)
	VALUES 
		('BMW', '1916-03-01'),
		('Tesla', '2003-01-01'),
		('Lada', '1966-05-01');

INSERT
	INTO `models` (`name`, `manufacturer_id`)
    VALUES
		('X1', 1),
		('i6', 1),
		('Model S', 2),
		('Model X', 2),
		('Model 3', 2),
		('Nova', 3);

-- Data test query used in Judge
SELECT 
    man.manufacturer_id,
    man.name,
    DATE(man.established_on),
    m.model_id,
    m.name
FROM
    manufacturers man
        INNER JOIN
    models m ON man.manufacturer_id = m.manufacturer_id
ORDER BY man.manufacturer_id;


-- 03. Many-To-Many Relationship
-- Create three tables as follows. Use appropriate data types.
/*
students	   
	student_id	name	   
	1  			Mila                                      	   
	2			Toni	   
	3			Ron	 
  
exams	   
	exam_id	name	   
	101		Spring MVC	   
	102		Neo4j	   
	103		Oracle 11g	 

students_exams	   
	student_id	exam_id	   
	1			101	   
	1			102	   
	2			101	   
	3			103	   
	2			102	   
	2			103	 
*/
-- Insert the data from the example above.
-- Add primary keys and foreign keys. 
-- Have in mind that table student_exams should have a composite primary key.

CREATE TABLE `students` (
	`student_id` INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
);

CREATE TABLE `exams` (
	`exam_id` INT UNSIGNED UNIQUE NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL
) AUTO_INCREMENT=101;

CREATE TABLE `students_exams` (
	`student_id` INT UNSIGNED NOT NULL,
    `exam_id` INT UNSIGNED NOT NULL
);

-- Data should be inserted here, but by doing so the solution doesn't compile 
-- in Judge: "Object reference not set to an instance of an object.", 
-- so first tables setup should be finished:

ALTER TABLE `students` 
	ADD CONSTRAINT `pk_students` 
		PRIMARY KEY (`student_id`);

ALTER TABLE `exams` 
	ADD CONSTRAINT `pk_exams` 
		PRIMARY KEY (`exam_id`);

ALTER TABLE `students_exams` 
	ADD CONSTRAINT `pk_students_exams` 
		PRIMARY KEY (`student_id`, `exam_id`),
    ADD CONSTRAINT `fk_students_exams_students` 
		FOREIGN KEY (`student_id`)
        REFERENCES `students` (`student_id`),
    ADD CONSTRAINT `fk_students_exams_exams` 
		FOREIGN KEY (`exam_id`)
        REFERENCES `exams` (`exam_id`);

INSERT 
	INTO `students` 
		(`name`)
	VALUES 
		('Mila'), 
        ('Toni'), 
        ('Ron');

INSERT 
	INTO `exams` 
		(`name`)
	VALUES 
		('Spring MVC'), 
        ('Neo4j'), 
        ('Oracle 11g');

INSERT 
	INTO `students_exams`
    VALUES  
		(1, 101),
		(1, 102),
		(2, 101),
		(3, 103),
		(2, 102),
		(2, 103);


-- 04. Self-Referencing
-- Create a single table as follows. Use appropriate data types.
 /*
teachers	   
	teacher_id	name	manager_id	   
	101			John		   
	102			Maya	106	   
	103			Silvia	106	   
	104			Ted		105	   
	105			Mark	101	   
	106			Greta	101	
*/ 
-- Insert the data from the example above.
-- Add primary keys and foreign keys. 
-- The foreign key should be between manager_id and teacher_id.

CREATE TABLE `teachers` (
	`teacher_id` INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    `manager_id` INT UNSIGNED DEFAULT NULL
) AUTO_INCREMENT=101;

INSERT 
	INTO `teachers`
		(`name`, `manager_id`)
    VALUES
		('John', NULL),
        ('Maya', 106),
        ('Silvia', 106),
        ('Ted', 105),
        ('Mark', 101),
        ('Greta', 101);

ALTER TABLE `teachers`
	ADD CONSTRAINT `pk_teachers` 
		PRIMARY KEY (`teacher_id`),
	ADD CONSTRAINT `fk_teacher_manager_id`
		FOREIGN KEY (`manager_id`)
        REFERENCES `teachers`(`teacher_id`);


-- 05. Online Store Database
CREATE DATABASE `online_store`;
USE `online_store`;

CREATE TABLE `item_types` (
	`item_type_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `items` (
	`item_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `item_type_id` INT NOT NULL,
    CONSTRAINT `fk_items_item_types` 
		FOREIGN KEY (`item_type_id`) 
        REFERENCES `item_types` (`item_type_id`)
);

CREATE TABLE `cities` (
	`city_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `customers` (
	`customer_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `birthday` DATE,
    `city_id` INT NOT NULL,
    CONSTRAINT `fk_customers_cities` 
		FOREIGN KEY (`city_id`) 
        REFERENCES `cities` (`city_id`)
);

CREATE TABLE `orders` (
	`order_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `customer_id` INT NOT NULL,
    CONSTRAINT `fk_orders_customers` 
		FOREIGN KEY (`customer_id`) 
        REFERENCES `customers` (`customer_id`)
);

CREATE TABLE `order_items` (
    `order_id` INT NOT NULL,
    `item_id` INT NOT NULL,
    CONSTRAINT `pk_order_items` 
		PRIMARY KEY (`order_id` , `item_id`),
    CONSTRAINT `fk_order_items_orders` 
		FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`order_id`),
    CONSTRAINT `fk_order_items_items` 
		FOREIGN KEY (`item_id`)
        REFERENCES `items` (`item_id`)
);


-- 06.	University Database
CREATE DATABASE `university`;
USE `university`;

CREATE TABLE `subjects` (
	`subject_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `subject_name` VARCHAR(50) NOT NULL
);

CREATE TABLE `majors` (
	`major_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `students` (
	`student_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `student_number` VARCHAR(12) NOT NULL,
    `student_name` VARCHAR(50) NOT NULL,
    `major_id` INT NOT NULL,
	CONSTRAINT `fk_students_majors` 
		FOREIGN KEY (`major_id`)
        REFERENCES `majors` (`major_id`)
);

CREATE TABLE `payments` (
	`payment_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `payment_date` DATE NOT NULL,
    `payment_amount` DECIMAL(8, 2) NOT NULL,
    `student_id` INT NOT NULL,
	CONSTRAINT `fk_payments_students` 
		FOREIGN KEY (`student_id`)
        REFERENCES `students` (`student_id`)
);

CREATE TABLE `agenda` (
    `student_id` INT NOT NULL,
    `subject_id` INT NOT NULL,
    CONSTRAINT `pk_agenda` PRIMARY KEY (`student_id` , `subject_id`),
    CONSTRAINT `fk_agendar_students` FOREIGN KEY (`student_id`)
        REFERENCES `students` (`student_id`),
    CONSTRAINT `fk_agenda_subjects` FOREIGN KEY (`subject_id`)
        REFERENCES `subjects` (`subject_id`)
);


-- 09.	Peaks in Rila
-- Display all peaks for "Rila" mountain_range. 
-- Include:
--  mountain_range
--  peak_name
--  peak_elevation
-- Peaks should be sorted by peak_elevation descending.
 
USE `geography`;
 
SELECT 
    m.mountain_range,
    p.peak_name,
    p.elevation AS 'peak_elevation'
FROM
    `mountains` AS m
        JOIN
    `peaks` AS p ON m.id = p.mountain_id
WHERE
    m.mountain_range = 'Rila'
ORDER BY p.elevation DESC;
 
