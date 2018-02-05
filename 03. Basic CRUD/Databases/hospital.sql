CREATE DATABASE IF NOT EXISTS `hospital`; 
USE `hospital`;

CREATE TABLE departments (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(50)
);

INSERT INTO departments(name) VALUES('Therapy'), ('Support'), ('Management'), ('Other');

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	job_title VARCHAR(50) NOT NULL,
	department_id INT NOT NULL,
	salary DOUBLE NOT NULL,
	CONSTRAINT `fk_department_id` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
);

INSERT INTO `employees` (`first_name`,`last_name`, `job_title`,`department_id`,`salary`) VALUES
	('John', 'Smith', 'Therapist',1, 900.00),
	('John', 'Johnson', 'Acupuncturist',1, 880.00),
	('Smith', 'Johnson', 'Technician',2, 1100.00),
	('Peter', 'Petrov', 'Supervisor',3, 1100.00),
	('Peter', 'Ivanov', 'Dentist',4, 1500.23),
	('Ivan' ,'Petrov', 'Therapist',1, 990.00),
	('Jack', 'Jackson', 'Epidemiologist',4, 1800.00),
	('Pedro', 'Petrov', 'Medical Director',3, 2100.00),
	('Nikolay', 'Ivanov', 'Nutrition Technician',4, 1600.00);
	

	
CREATE TABLE rooms (
	id INT PRIMARY KEY AUTO_INCREMENT,
	occupation VARCHAR(30)
);

INSERT INTO rooms(`occupation`) VALUES('free'), ('occupied'),('free'),('free'),('occupied');

CREATE TABLE patients (
	id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	room_id INT NOT NULL
);

INSERT INTO patients(`first_name`,`last_name`,`room_id`) VALUES('Pesho','Petrov',1),('Gosho','Georgiev',3),('Mariya','Marieva', 2), ('Katya','Katerinova', 2), ('Nikolay','Nikolaev',3);