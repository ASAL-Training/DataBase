

DROP DATABASE IF EXISTS store_db;
CREATE DATABASE store_db;

\c store_db

CREATE TABLE users (
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE products (
    id    SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE orders (
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE order_items (
    order_id   INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity   INTEGER NOT NULL CHECK (quantity > 0),
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);


INSERT INTO users (name, email) VALUES
    ('Ahmad Khalil', 'ahmad.khalil@example.com'),
    ('Lina Saleh',   'lina.saleh@example.com'),
    ('Omar Nasser',  'omar.nasser@example.com');

INSERT INTO products (title, price) VALUES
    ('Wireless Mouse',      25.99),
    ('Mechanical Keyboard', 79.50),
    ('USB-C Hub',           34.00),
    ('Laptop Stand',        45.00);


INSERT INTO orders (user_id, order_date) VALUES
    (1, '2026-10-01'),
    (1, '2026-10-05'),
    (2, '2026-10-07');


INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 1, 2),
    (1, 2, 1),
    (2, 3, 1),
    (3, 1, 1),
    (3, 4, 1);



-- 1. INNER JOIN (2 tables): every order with its date and customer name
SELECT o.id AS order_id,
       o.order_date,
       u.name
FROM orders o
INNER JOIN users u ON u.id = o.user_id
ORDER BY o.id;

-- 2. MANY-TO-MANY JOIN (4 tables): every item ordered
SELECT u.name     AS user_name,
       p.title    AS product_title,
       oi.quantity,
       p.price
FROM order_items oi
INNER JOIN orders   o ON o.id = oi.order_id
INNER JOIN users    u ON u.id = o.user_id
INNER JOIN products p ON p.id = oi.product_id
ORDER BY oi.order_id, p.title;

-- 3. LEFT JOIN: all users and their order ids, including users with no orders
SELECT u.name,
       o.id AS order_id
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
ORDER BY u.id, o.id;

-- 4. AGGREGATE JOIN: total spent per order
SELECT oi.order_id,
       SUM(oi.quantity * p.price) AS total_spent
FROM order_items oi
INNER JOIN products p ON p.id = oi.product_id
GROUP BY oi.order_id
ORDER BY oi.order_id;
