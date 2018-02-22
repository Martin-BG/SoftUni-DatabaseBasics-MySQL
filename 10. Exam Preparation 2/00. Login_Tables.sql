CREATE TABLE logged_in_users (
	id INT,
    username VARCHAR(30) NOT NULL UNIQUE,
    password VARCHAR(30) NOT NULL,
    email VARCHAR(50),
    CONSTRAINT pk_logged_in_users PRIMARY KEY (id)
);

CREATE TABLE evaluated_submissions (
	id INT AUTO_INCREMENT,
    problem VARCHAR(100) NOT NULL,
    user VARCHAR(30) NOT NULL,
    result INT NOT NULL,
    CONSTRAINT pk_evaluated_submissions PRIMARY KEY (id)
);