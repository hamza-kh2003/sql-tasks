-- 1
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- 2
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(30),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT NOT NULL,
  name VARCHAR(120) NOT NULL,
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE (category_id, name),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('pending','paid','shipped','cancelled') NOT NULL DEFAULT 'pending',
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL UNIQUE,
  method ENUM('cash','card','paypal') NOT NULL,
  amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
  paid_at DATETIME,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 4
INSERT INTO users (full_name, email, phone)
VALUES ('Ahmad Saleh', 'ahmad@example.com', '0790000001');

INSERT INTO users (full_name, email, phone)
VALUES ('sara noor', 'sara@example.com', '0780000001');

INSERT INTO users (full_name, email, phone)
VALUES ('hamza alkhader', 'hamza@example.com', '0770000001');

INSERT INTO categories (name) VALUES
('Electronics'), ('Books');

INSERT INTO products (category_id, name, price, stock) VALUES
(1, 'Wireless Mouse', 12.50, 50),
(1, 'Keyboard', 25.00, 30),
(2, 'SQL Basics Book', 15.00, 20);

INSERT INTO orders (user_id, status) VALUES
(1, 'pending');

INSERT INTO orders (user_id, status) VALUES
(5, 'pending');

INSERT INTO orders (user_id, status) VALUES
(6, 'pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(3, 1, 2, 12.50),
(3, 2, 1, 25.00);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(4, 1, 2, 12.50),
(5, 2, 1, 25.00);



INSERT INTO payments (order_id, method, amount, paid_at) VALUES
(3, 'card', 15.00, NOW());

UPDATE products
SET stock = stock - 2
WHERE product_id = 1;

DELETE FROM order_items WHERE order_id = 3;


-- 5

select * from products;

select * from users ;

SELECT o.order_id, o.order_date, o.status, u.full_name, u.email
FROM orders o
INNER JOIN users u ON u.user_id = o.user_id;

SELECT name, price
FROM products
WHERE price >= 20;

SELECT name, price
FROM products
ORDER BY price DESC;

SELECT name, price
FROM products
ORDER BY price DESC
LIMIT 2;

-- 6
SELECT COUNT(*) AS total_orders
FROM orders;

SELECT AVG(price) AS avg_product_price
FROM products;

SELECT SUM(quantity * unit_price) AS total_sales
FROM order_items;

-- 7
SELECT o.order_id, u.full_name
FROM orders o
INNER JOIN users u ON u.user_id = o.user_id;

SELECT o.order_id, o.status, p.method, p.amount
FROM orders o
LEFT JOIN payments p ON p.order_id = o.order_id;
