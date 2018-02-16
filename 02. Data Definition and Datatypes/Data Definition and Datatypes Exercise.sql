-- https://judge.softuni.bg/Contests/Practice/Index/286#0

-- 01 - Create Database
-- You now know how to create database using the GUI of the HeidiSQL. 
-- Now it’s time to create it using SQL queries. In that task (and the several following it)
-- you will be required to create the database from the previous exercise using only SQL
-- queries. Firstly, just create new database named minions.

CREATE DATABASE `minions`;


-- 02 - Create Tables
-- In the newly created database Minions add table minions (id, name, age). Then add new table
-- towns (id, name). Set id columns of both tables to be primary key as constraint.

USE `minions`;

CREATE TABLE `minions` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(50) NOT NULL,
	`age` tinyint unsigned DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_unicode_ci;

CREATE TABLE `towns` (
	`id` int NOT NULL AUTO_INCREMENT,
	`name` varchar(50) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_unicode_ci;


-- 03. Alter Minions Table
-- Change the structure of the Minions table to have new column town_id
-- that would be of the same type as the id column of towns table.
-- Add new constraint that makes town_id foreign key and references to
-- id column of towns table.

ALTER TABLE `minions`
	ADD COLUMN `town_id` int DEFAULT NULL,
	ADD CONSTRAINT FK_minions_towns
	FOREIGN KEY (town_id)
	REFERENCES towns(id);


-- 04. Insert Records in Both Tables
-- Populate both tables with sample records given in the table below.
-- minions								towns
-- id	name		age		town_id		id	name
-- 1	Kevin		22		1			1	Sofia
-- 2	Bob			15		3			2	Plovdiv
-- 3	Steward		NULL 	2			3	Varna
-- Use only insert SQL queries.

INSERT INTO `towns`(`id`, `name`)
	VALUES (1, 'Sofia'),
			 (2, 'Plovdiv'),
			 (3, 'Varna');

INSERT INTO `minions`(`id`, `name`, `age`, `town_id`) 
	VALUES (1, 'Kevin', 22, 1), 
			 (2, 'Bob', 15, 3),
			 (3, 'Steward', NULL, 2);
			 

-- 05. Truncate Table Minions
-- Delete all the data from the minions table using SQL query. 

TRUNCATE `minions`;


-- 06. Drop All Tables
-- Delete all tables from the minions database using SQL query.

DROP TABLE `minions`;
DROP TABLE `towns`;


-- 07. Create Table People
-- Using SQL query create table “people” with columns:
-- id – unique number for every person there will be no more than 2^31-1 people. (Auto incremented)
-- name – full name of the person will be no more than 200 Unicode characters. (Not null)
-- picture – image with size up to 2 MB. (Allow nulls)
-- height –  In meters. Real number precise up to 2 digits after floating point. (Allow nulls)
-- weight –  In kilograms. Real number precise up to 2 digits after floating point. (Allow nulls)
-- gender – Possible states are m or f. (Not null)
-- birthdate – (Not null)
-- biography – detailed biography of the person it can contain max allowed Unicode characters. (Allow nulls)
-- 	Make id primary key. Populate the table with 5 records.

CREATE TABLE `people` (
	`id` int NOT NULL PRIMARY KEY UNIQUE AUTO_INCREMENT,
	`name` VARCHAR(200) NOT NULL,
	`picture` BLOB,
	`height` DOUBLE(3,2),
	`weight` DOUBLE(5,2),
	`gender` ENUM('m', 'f') NOT NULL,
	`birthdate` date NOT NULL,
	`biography` LONGTEXT
) ENGINE=InnoDB;

INSERT INTO `people`(`name`, `gender`, `birthdate`)
	VALUES 
		('Pesho', 'm', '1980-02-10'),
		('Gosho', 1, '1985-10-15'),
		('Maria', 'f', '1985-10-15'),
		('Pena', 2, '1986-10-15'),
		('Tosho', 1, '1976-10-15');


-- 08. Create Table Users
-- Using SQL query create table users with columns:
-- * id – unique number for every user. There will be no more than 2^63-1 users. (Auto incremented)
-- * username – unique identifier of the user will be no more than 30 characters (non Unicode). (Required)
-- * password – password will be no longer than 26 characters (non Unicode). (Required)
-- * profile_picture – image with size up to 900 KB. 
-- * last_login_time
-- * is_deleted – shows if the user deleted his/her profile. Possible states are true or false.
-- Make id primary key. 
-- Populate the table with 5 records. 
-- Submit your CREATE and INSERT statements

CREATE TABLE `users` (
	`id` BIGINT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`username` VARCHAR(30) UNIQUE NOT NULL,
	`password` VARCHAR(26) NOT NULL,
	`profile_picture` BLOB,
	`last_login_time` TIMESTAMP,
	`is_deleted` BOOLEAN
);

INSERT INTO `users`
	(`username`, `password`, `last_login_time`, `is_deleted`)
VALUES 
	('Gogo', 'spojpe', NOW(), TRUE),
	('Bobo', 'epgojro', NOW(), FALSE),
	('Ani', 'rpker', NOW(), TRUE),
	('Sasho', 'rgpjrpe', NOW(), TRUE),
	('Gery', 'pkptkh',NULL, FALSE);


-- 09. Change Primary Key
-- Using SQL queries modify table users from the previous task. 
-- First remove current primary key then create new primary key 
-- that would be combination of fields id and username. 
-- The initial primary key name on id is pk_users

ALTER TABLE `users` 
	DROP PRIMARY KEY,
	ADD CONSTRAINT `pk_users` PRIMARY KEY (`id`, `username`);


-- 10. Set Default Value of a Field
-- Using SQL queries modify table users. Make the default 
-- value of last_login_time field to be the current time.

ALTER TABLE `users` 
	MODIFY COLUMN `last_login_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP; -- now()

ALTER TABLE `users`
	CHANGE COLUMN `last_login_time` `last_login_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;


-- 11. Set Unique Field
-- Using SQL queries modify table users. Remove username field from
-- the primary key so only the field id would be primary key. 
-- Now add unique constraint to the username field. 
-- The initial primary key name on (id, username) is pk_users.

ALTER TABLE `users`
	DROP PRIMARY KEY,
	ADD CONSTRAINT PRIMARY KEY (`id`),
	ADD CONSTRAINT UNIQUE (`username`);


-- 12. Movies Database
-- Using SQL queries create Movies database with the following entities:
-- * directors (id, director_name, notes) 
-- * genres (id, genre_name, notes) 
-- * categories (id, category_name, notes)  
-- * movies (id, title, director_id, copyright_year, length, 
-- 		genre_id, category_id, rating, notes)
-- Set most appropriate data types for each column. 
-- Set primary key to each table. 
-- Populate each table with 5 records.
-- Make sure the columns that are present in 2 tables would be of the same data type.
-- Consider which fields are always required and which are optional.
-- Submit your CREATE TABLE and INSERT statements

CREATE DATABASE `movies`;
USE `movies`;

CREATE TABLE `directors` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`director_name` VARCHAR(30) NOT NULL,
	`notes` TEXT
);

CREATE TABLE `genres` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`genre_name` VARCHAR(30) NOT NULL,
	`notes` TEXT
);

CREATE TABLE `categories` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`category_name` VARCHAR(30) NOT NULL,
	`notes` TEXT
);

CREATE TABLE `movies` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`title` VARCHAR(30) NOT NULL,
	`director_id` INT UNSIGNED NOT NULL,
	`copyright_year` YEAR NOT NULL,
	`length` TIME NOT NULL,
	`genre_id` INT UNSIGNED NOT NULL,
	`category_id` INT UNSIGNED NOT NULL,
	`rating` DOUBLE NOT NULL DEFAULT 0,
	`notes` TEXT
);

INSERT INTO `movies`
	(`id`, `title`, `director_id`, `copyright_year`, `length`, `genre_id`, `category_id`)
VALUES
	(11,"kamen",2,'2016',23,1,2),
	(10,"kamen",2,'2016',23,1,2),
	(13,"kamen",2,'2016',23,1,2),
	(14,"kamen",2,'2016',23,1,2),
	(15,"kamen",1,'2016',23,1,2);

INSERT INTO `directors`
	(`id`, `director_name`, `notes`)
VALUES
	(1,'dasdasd','fasdfasdfasdfa'),
	(2,'dasdasd','fasdfasdfasdfa'),
	(3,'dasdasd','fasdfasdfasdfa'),
	(4,'dasdasd','fasdfasdfasdfa'),
	(5,'dasdasd','fasdfasdfasdfa');

INSERT INTO `categories`
	(`id`, `category_name`)
VALUES
	(1,'wi-fi'),
	(2,'wi-fi'),
	(3,'wi-fi'),
	(4,'wi-fi'),
	(5,'wi-fi');

INSERT INTO `genres`
	( `id`, `genre_name`, `notes`)
VALUES
	(2,'dasdad','kaman'),
	(1,'dasdad','kaman'),
	(3,'dasdad','kaman'),
	(4,'dasdad','kaman'),
	(5,'dasdad','kaman');


-- 13. Car Rental Database
-- Using SQL queries create car_rental database with the following entities:
-- * categories (id, category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
-- * cars (id, plate_number, make, model, car_year, category_id, 
-- 		doors, picture, car_condition, available)
-- * employees (id, first_name, last_name, title, notes)
-- * customers (id, driver_licence_number, full_name, address, city, zip_code, notes)
-- * rental_orders (id, employee_id, customer_id, car_id, car_condition, tank_level, 
-- 		kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, 
-- 		total_days, rate_applied, tax_rate, order_status, notes)
-- Set most appropriate data types for each column. 
-- Set primary key to each table. 
-- Populate each table with 3 records.
-- Make sure the columns that are present in 2 tables would be of the same data type.
-- Consider which fields are always required and which are optional. 
-- Submit your CREATE TABLE and INSERT statements 

CREATE DATABASE `car_rental`;
USE `car_rental`;

CREATE TABLE `categories` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`category` VARCHAR(30) NOT NULL,
	`daily_rate` DOUBLE NOT NULL,
	`weekly_rate` DOUBLE NOT NULL,
	`monthly_rate` DOUBLE NOT NULL,
	`weekend_rate` DOUBLE NOT NULL
);

INSERT INTO `categories`
		(`category`, `daily_rate`, `weekly_rate`, `monthly_rate`, `weekend_rate`)
	VALUES 
		('Category 1', 1.1, 2.1, 3.1, 4.1),
		('Category 2', 1.2, 2.2, 3.2, 4.2),
		('Category 3', 1.3, 2.3, 3.3, 4.3);

CREATE TABLE `cars` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`plate_number` VARCHAR(20) NOT NULL UNIQUE,
	`make` VARCHAR(20) NOT NULL,
	`model` VARCHAR(20) NOT NULL,
	`car_year` YEAR NOT NULL,
	`category_id` INT UNSIGNED NOT NULL,
	`doors` TINYINT UNSIGNED NOT NULL,
	`picture` BLOB,
	`car_condition` VARCHAR(20),
	`available` BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO `cars`
		(`plate_number`, `make`, `model`, `car_year`, `category_id`, `doors`, `car_condition`)
	VALUES 
		('Plate Num 1', 'Maker 1', 'Model 1', '1970', 1, 2, ''),
		('Plate Num 2', 'Maker 2', 'Model 2', '1980', 2, 4, 'Scrap'),
		('Plate Num 3', 'Maker 3', 'Model 3', '1990', 3, 5, 'Good');

CREATE TABLE `employees` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`first_name` VARCHAR(30) NOT NULL,
	`last_name` VARCHAR(30) NOT NULL,
	`title` VARCHAR(30) NOT NULL,
	`notes` VARCHAR(128)
);

INSERT INTO `employees`
		(`first_name`, `last_name`, `title`, `notes`)
	VALUES 
		('Gosho', 'Goshev', 'Boss', ''),
		('Pesho', 'Peshev', 'Supervisor', ''),
		('Bai', 'Ivan', 'Worker', 'Can do any work');

CREATE TABLE `customers` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`driver_licence_number` VARCHAR(30) NOT NULL,
	`full_name` VARCHAR(60) NOT NULL,
	`address` VARCHAR(50) NOT NULL,
	`city` VARCHAR(20) NOT NULL,
	`zip_code` INT(4) NOT NULL,
	`notes` VARCHAR(128)
);

INSERT INTO `customers`
		(`driver_licence_number`, `full_name`, `address`, `city`, `zip_code`, `notes`)
	VALUES 
		('1234ABCD', 'Gosho Goshev', 'A casstle', 'Sofia', 1000, ''),
		('2234ABCD', 'Pesho Peshev', 'A boat', 'Varna', 2000, ''),
		('3234ABCD', 'Bai Ivan', 'Under the bridge', 'Sofia', 1000, '');

CREATE TABLE `rental_orders` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`employee_id` INT UNSIGNED NOT NULL,
	`customer_id` INT UNSIGNED NOT NULL,
	`car_id` INT UNSIGNED NOT NULL,
	`car_condition` VARCHAR(20),
	`tank_level` DOUBLE,
	`kilometrage_start` DOUBLE,
	`kilometrage_end` DOUBLE,
	`total_kilometrage` DOUBLE,
	`start_date` DATE,
	`end_date` DATE,
	`total_days` INT UNSIGNED,
	`rate_applied` DOUBLE,
	`tax_rate` DOUBLE,
	`order_status` VARCHAR(30),
	`notes` VARCHAR(128)
);

INSERT INTO `rental_orders`
		(`employee_id`, `customer_id`, `car_id`, `car_condition`, `start_date`)
	VALUES 
		(1, 3, 2, 'Good', NOW()),
		(2, 1, 3, 'Bad', NOW()),
		(3, 2, 1, 'OK', NOW());


-- 14. Hotel Database
-- Using SQL queries create Hotel database with the following entities:
-- * employees (id, first_name, last_name, title, notes)
-- * customers (account_number, first_name, last_name, 
-- 		phone_number, emergency_name, emergency_number, notes)
-- * room_status (room_status, notes)
-- * room_types (room_type, notes)
-- * bed_types (bed_type, notes)
-- * rooms (room_number, room_type, bed_type, rate, room_status, notes)
-- * payments (id, employee_id, payment_date, account_number, 
-- 		first_date_occupied, last_date_occupied, total_days, 
-- 		amount_charged, tax_rate, tax_amount, payment_total, notes)
-- * occupancies (id, employee_id, date_occupied, account_number,
-- 		room_number, rate_applied, phone_charge, notes)
-- Set most appropriate data types for each column. 
-- Set primary key to each table. 
-- Populate each table with 3 records.
-- Make sure the columns that are present in 2 tables would be of the same data type. 
-- Consider which fields are always required and which are optional.
-- Submit your CREATE TABLE and INSERT statements

CREATE DATABASE `hotel`;
USE `hotel`;

CREATE TABLE `employees` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`first_name` VARCHAR(30) NOT NULL,
	`last_name` VARCHAR(30) NOT NULL,
	`title` VARCHAR(30) NOT NULL,
	`notes` VARCHAR(128)
);

INSERT INTO `employees`
		(`first_name`, `last_name`, `title`, `notes`)
	VALUES 
		('Gosho', 'Goshev', 'Boss', ''),
		('Pesho', 'Peshev', 'Supervisor', ''),
		('Bai', 'Ivan', 'Worker', 'Can do any work');

CREATE TABLE `customers` (
	`account_number` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`first_name` VARCHAR(30) NOT NULL,
	`last_name` VARCHAR(30) NOT NULL,
	`phone_number` VARCHAR(20) NOT NULL,
	`emergency_name` VARCHAR(50),
	`emergency_number` VARCHAR(20),
	`notes` VARCHAR(128)
);

INSERT INTO `customers`
		(`first_name`, `last_name`, `phone_number`)
	VALUES 
		('Gosho', 'Goshev', '123'),
		('Pesho', 'Peshev', '44-2432'),
		('Bai', 'Ivan', '007');

CREATE TABLE `room_status` (
	`room_status` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`notes` VARCHAR(128)
);

INSERT INTO `room_status` 
		(`notes`)
	VALUES 
		('Free'),
		('For clean'),
		('Occupied');

CREATE TABLE `room_types` (
	`room_type` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`notes` VARCHAR(128)
);

INSERT INTO `room_types` 
		(`notes`)
	VALUES 
		('Small'),
		('Medium'),
		('Appartment');


CREATE TABLE `bed_types` (
	`bed_type` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`notes` VARCHAR(128)
);

INSERT INTO `bed_types` 
		(`notes`)
	VALUES 
		('Single'),
		('Double'),
		('Water-filled');

CREATE TABLE `rooms` (
	`room_number` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`room_type` INT UNSIGNED NOT NULL,
	`bed_type` INT UNSIGNED NOT NULL,
	`rate` DOUBLE DEFAULT 0,
	`room_status` INT UNSIGNED NOT NULL,
	`notes` VARCHAR(128)
);

INSERT INTO `rooms` 
		(`room_type`, `bed_type`, `room_status`)
	VALUES 
		(1, 1, 1),
		(2, 2, 2),
		(3, 3, 3);

CREATE TABLE `payments` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`employee_id` INT UNSIGNED NOT NULL,
	`payment_date` DATE NOT NULL,
	`account_number` INT UNSIGNED NOT NULL,
	`first_date_occupied` DATE,
	`last_date_occupied` DATE,
	`total_days` INT UNSIGNED,
	`amount_charged` DOUBLE,
	`tax_rate` DOUBLE,
	`tax_amount` DOUBLE,
	`payment_total` DOUBLE,
	`notes` VARCHAR(128)
);

INSERT INTO `payments` 
		(`employee_id`, `payment_date`, `account_number`)
	VALUES 
		(1, DATE(NOW()), 1),
		(2, DATE(NOW()), 2),
		(3, DATE(NOW()), 3);


CREATE TABLE `occupancies` (
	`id` INT UNSIGNED PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	`employee_id` INT UNSIGNED NOT NULL,
	`date_occupied` DATE NOT NULL,
	`account_number` INT UNSIGNED NOT NULL,
	`room_number` INT UNSIGNED NOT NULL,
	`rate_applied` DOUBLE,
	`phone_charge` DOUBLE,
	`notes` VARCHAR(128)
);

INSERT INTO `occupancies` 
		(`employee_id`, `date_occupied`, `account_number`, `room_number`)
	VALUES 
		(1, DATE(NOW()), 1, 1),
		(2, DATE(NOW()), 2, 2),
		(3, DATE(NOW()), 3, 3);


-- 15. Create SoftUni Database
-- Now create bigger database called soft_uni. You will use database in the future tasks. It should hold information about
-- * towns (id, name)
-- * addresses (id, address_text, town_id)
-- * departments (id, name)
-- * employees (id, first_name, middle_name, last_name, job_title, department_id, hire_date, salary, address_id)
-- Id columns are auto incremented starting from 1 and increased by 1 (1, 2, 3, 4…). 
-- Make sure you use appropriate data types for each column. 
-- Add primary and foreign keys as constraints for each table. 
-- Use only SQL queries. 
-- Consider which fields are always required and which are optional. 
-- Submit your CREATE TABLE  statements

CREATE DATABASE `soft_uni`;
USE `soft_uni`;

CREATE TABLE `towns` (
	`id` INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL,
	CONSTRAINT `pk_towns` PRIMARY KEY (`id`)
);

CREATE TABLE `addresses` (
	`id` INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
	`address_text` VARCHAR(30) NOT NULL,
	`town_id` INT UNSIGNED,
	CONSTRAINT `pk_addresses` PRIMARY KEY (`id`),
	CONSTRAINT `fk_addresses_towns` FOREIGN KEY (`town_id`)
		REFERENCES `towns` (`id`)
);

CREATE TABLE `departments` (
	`id` INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL,
	CONSTRAINT `pk_departments` PRIMARY KEY (`id`)
);

CREATE TABLE `employees` (
	`id` INT UNSIGNED NOT NULL UNIQUE AUTO_INCREMENT,
	`first_name` VARCHAR(30) NOT NULL,
	`middle_name` VARCHAR(30),
	`last_name` VARCHAR(30) NOT NULL,
	`job_title` VARCHAR(30) NOT NULL,
	`department_id` INT UNSIGNED,
	`hire_date` DATE,
	`salary` DECIMAL(10 , 2 ),
	`address_id` INT UNSIGNED,
	CONSTRAINT `pk_employees` PRIMARY KEY (`id`),
	CONSTRAINT `fk_employees_departments` FOREIGN KEY (`department_id`)
		REFERENCES `departments` (`id`),
	CONSTRAINT `fk_employees_addresses` FOREIGN KEY (`address_id`)
		REFERENCES `addresses` (`id`)
);


-- 16. Backup Database
-- By using mysqldump command from MySql command line make a backup of the database soft_uni, 
-- from the previous tasks, into a file named “softuni-backup.sql”. Drop your database from 
-- Heidi or MySQL Workbench. Then restore the database from the created backup file by using 
-- mysql command line.

-- Execute in command line:
-- mysqldump -u <user> -p<password> soft_uni > softuni-backup.sql

DROP DATABASE `soft_uni`;

-- Add following lines on top of softuni-backup.sql:
-- DROP DATABASE IF EXISTS `soft_uni`;
-- CREATE DATABASE `soft_uni`;
-- USE `soft_uni`;

-- Execute in command line:
-- mysql -u <user> -p<password> < softuni-backup.sql


-- 17. Basic Insert
-- Use the SoftUni database and insert some data using SQL queries.
-- towns: Sofia, Plovdiv, Varna, Burgas
-- departments: Engineering, Sales, Marketing, Software Development, Quality Assurance
-- employees:
-- 	name					job_title		department				hire_date	salary
-- 	Ivan Ivanov Ivanov		.NET Developer	Software Development	01/02/2013	3500.00
-- 	Petar Petrov Petrov		Senior Engineer	Engineering				02/03/2004	4000.00
-- 	Maria Petrova Ivanova	Intern			Quality Assurance		28/08/2016	525.25
-- 	Georgi Terziev Ivanov	CEO				Sales					09/12/2007	3000.00
-- 	Peter Pan Pan			Intern			Marketing				28/08/2016	599.88

INSERT INTO `towns` 
		(`name`) 
	VALUES
		('Sofia'),
		('Plovdiv'),
		('Varna'),
		('Burgas');

INSERT INTO `departments` 
		(`name`) 
	VALUES
		('Engineering'),
		('Sales'),
		('Marketing'),
		('Software Development'),
		('Quality Assurance');

INSERT INTO `employees`
		(`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`)
	VALUES
		('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
		('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
		('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
		('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
		('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);


-- 18. Basic Select All Fields
-- Use the soft_uni database and first select all records from the towns, 
-- then from departments and finally from employees table. 
-- Use SQL queries and submit them to Judge at once.

USE `soft_uni`;

SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;


-- 19. Basic Select All Fields and Order Them
-- Modify queries from previous problem by sorting:
-- towns - alphabetically by name
-- departments - alphabetically by name
-- employees - descending by salary

SELECT * FROM `towns` ORDER BY `name`;
SELECT * FROM `departments` ORDER BY `name`;
SELECT * FROM `employees` ORDER BY `salary` DESC;


-- 20. Basic Select Some Fields
-- Modify queries from previous problem to show only some of the columns. For table:
-- towns – name
-- departments – name
-- employees – first_name, last_name, job_title, salary
-- Keep the ordering from the previous problem.

SELECT `name` FROM `towns` ORDER BY `name`;
SELECT `name` FROM `departments` ORDER BY `name`;
SELECT 
	`first_name`, `last_name`, `job_title`, `salary`
FROM
	`employees`
ORDER BY `salary` DESC;


-- 21. Increase Employees Salary
-- Use soft_uni database and increase the salary of all employees by 10%. 
-- Select only salary column from the employees table. 

UPDATE `employees` 
SET 
	`salary` = `salary` * 1.1;

SELECT `salary` FROM `employees`;


-- 22. Decrease Tax Rate
-- Use hotel database and decrease tax rate by 3% to all payments. 
-- Select only tax_rate column from the payments table.

UPDATE `payments` 
SET 
	`tax_rate` = `tax_rate` * 0.97;

SELECT `tax_rate` FROM `payments`;


-- 23. Delete All Records
-- Use Hotel database and delete all records from the occupancies table. Use SQL query.

DELETE FROM `occupancies`;
