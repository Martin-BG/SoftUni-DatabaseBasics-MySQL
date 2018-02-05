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
-- id	name		age	town_id		id	name
-- 1	Kevin		22		1				1	Sofia
-- 2	Bob		15		3				2	Plovdiv
-- 3	Steward	NULL 	2				3	Varna
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
		
		