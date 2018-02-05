CREATE DATABASE orders;

USE orders;

CREATE TABLE orders
(
id INT NOT NULL,
product_name VARCHAR(50) NOT NULL,
order_date DATETIME NOT NULL,
CONSTRAINT pk_orders PRIMARY KEY (id)
);

INSERT INTO orders (id, product_name, order_date) VALUES (1, 'Butter', '20160919');
INSERT INTO orders (id, product_name, order_date) VALUES (2, 'Milk', '20160930');
INSERT INTO orders (id, product_name, order_date) VALUES (3, 'Cheese', '20160904');
INSERT INTO orders (id, product_name, order_date) VALUES (4, 'Bread', '20151220');
INSERT INTO orders (id, product_name, order_date) VALUES (5, 'Tomatoes', '20150101');
INSERT INTO orders (id, product_name, order_date) VALUES (6, 'Tomatoe2', '20150201');
INSERT INTO orders (id, product_name, order_date) VALUES (7, 'Tomatoess', '20150401');
INSERT INTO orders (id, product_name, order_date) VALUES (8, 'Tomatoe3', '20150128');
INSERT INTO orders (id, product_name, order_date) VALUES (9, 'Tomatoe4', '20150628');
INSERT INTO orders (id, product_name, order_date) VALUES (10, 'Tomatoe44s', '20150630');
INSERT INTO orders (id, product_name, order_date) VALUES (11, 'Tomatoefggs', '20150228');
INSERT INTO orders (id, product_name, order_date) VALUES (12, 'Tomatoesytu', '20160228');
INSERT INTO orders (id, product_name, order_date) VALUES (13, 'Toyymatddoehys', '20151231');
INSERT INTO orders (id, product_name, order_date) VALUES (14, 'Tom443atoes', '20151215');
INSERT INTO orders (id, product_name, order_date) VALUES (15, 'Tomat65434foe23gfhgsPep', '20151004');