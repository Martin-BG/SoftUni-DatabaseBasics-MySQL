CREATE DATABASE IF NOT EXISTS `gamebar`;
USE `gamebar`;

CREATE TABLE `employees` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`first_name` VARCHAR(50) NOT NULL,
	`last_name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `categories` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `products` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL,
	`category_id` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`id`),
	KEY `FK_products_categories` (`category_id`),
	CONSTRAINT `FK_products_categories` FOREIGN KEY (category_id)
	REFERENCES `categories` (`id`)
)
COLLATE='utf8_general_ci'employees
ENGINE=InnoDB
;

INSERT INTO `gamebar`.`employees` (`first_name`, `last_name`) 
VALUES ("Pesho", "Petrov"), ("Ivan", "Ivanov"), ("Georgy", "Georgiev");

ALTER TABLE `gamebar`.`employees` ADD COLUMN `middle_name` VARCHAR(50) NOT NULL DEFAULT "";

ALTER TABLE `gamebar`.`employees` MODIFY COLUMN `middle_name` VARCHAR(100) NOT NULL;

DROP DATABASE `gamebar`;