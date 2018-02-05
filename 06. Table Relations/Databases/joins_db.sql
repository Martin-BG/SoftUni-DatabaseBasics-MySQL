CREATE DATABASE joins_db;
USE joins_db;

CREATE TABLE courses(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL
);

CREATE TABLE students(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20) NOT NULL,
	course_id INT,
	CONSTRAINT fk_course_id
	FOREIGN KEY (course_id)
	REFERENCES courses(id)
);

INSERT INTO courses(id, name) VALUES (1, 'HTML5'),(2,'CSS3'),
(3,'JavaScript'),(4,'PHP'),(5,'MySQL');

INSERT INTO students(id, name, course_id) 
VALUES (1,'Alice',1),(2,'Michael',1),(3,'Caroline',2),(4,'David',5),(5,'Emma',NULL);