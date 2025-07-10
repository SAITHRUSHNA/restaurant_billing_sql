-- Create Table: Menu
CREATE TABLE menu_list (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(100),
    price DECIMAL(10, 2),
    category VARCHAR(50)
);
-- Create Table: Customers
CREATE TABLE customers_list (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100)
);

-- Create Table: Orders
CREATE TABLE orders_list (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE DEFAULT CURRENT_DATE,
    payment_status VARCHAR(20) CHECK (payment_status IN ('Pending', 'Paid'))
);

-- Create Table: Order Items
CREATE TABLE order_items_list (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    item_id INT REFERENCES menu(item_id),
    quantity INT
);

-- Create Table: Payments
CREATE TABLE payments_list (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_date DATE DEFAULT CURRENT_DATE,
    amount DECIMAL(10, 2),
    payment_method VARCHAR(50)
);

-- Sample Data
INSERT INTO menu_list (item_name, price, category) VALUES
('Paneer Tikka', 220.00, 'Starter'),
('Butter Naan', 40.00, 'Bread'),
('Chicken Biryani', 280.00, 'Main Course'),
('Gulab Jamun', 60.00, 'Dessert');

INSERT INTO customers_list (name, phone, email) VALUES
('Ravi Sharma', '9876543210', 'ravi@example.com'),
('Priya Mehta', '9123456780', 'priya@example.com');

INSERT INTO orders_list (customer_id, payment_status) VALUES
(1, 'Paid'), (2, 'Pending');

INSERT INTO order_items_list (order_id, item_id, quantity) VALUES
(1, 1, 2), (1, 2, 3), (2, 3, 1), (2, 4, 2);

INSERT INTO payments_list (order_id, amount, payment_method) VALUES
(1, 460.00, 'Cash');

-- 1. Daily Income
SELECT SUM(amount) AS daily_income
FROM payments_list
WHERE payment_date = CURRENT_DATE;

-- 2. Most Popular Dishes
SELECT m.item_name, SUM(oi.quantity) AS total_ordered
FROM order_items oi
JOIN menu m ON oi.item_id = m.item_id
GROUP BY m.item_name
ORDER BY total_ordered DESC;

-- 3. Pending Payments
SELECT o.order_id, c.name, o.order_date
FROM orders_list o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.payment_status = 'Pending';

-- 4. Top Customers by Spend
SELECT c.name, SUM(p.amount) AS total_spent
FROM payments_list p
JOIN orders_list o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- 5. Revenue by Day
SELECT payment_date, SUM(amount) AS total_income
FROM payments_list
GROUP BY payment_date
ORDER BY payment_date DESC;

