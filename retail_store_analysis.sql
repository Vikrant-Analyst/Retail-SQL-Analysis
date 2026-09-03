-- ============================================================
-- RETAIL STORE SQL ANALYSIS
-- Portfolio version of the SQL mini project
--
-- IMPORTANT: Data INSERT statements have been intentionally
-- excluded from this portfolio version.
-- ============================================================

-- ============================================================
-- 1. DATABASE & SCHEMA SETUP
-- ============================================================
CREATE SCHEMA retail_store_db;
USE retail_store_db;

-- ============================================================
-- 2. TABLE DEFINITIONS
-- ============================================================
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL DEFAULT 0,
    added_on DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending',
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE SET NULL
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    item_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid > 0),
    method VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE
);

CREATE TABLE product_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

-- Schema refinement used in the original project.
ALTER TABLE product_reviews
MODIFY COLUMN review_date DATETIME DEFAULT CURRENT_TIMESTAMP;

-- ============================================================
-- 3. ANALYTICAL QUERIES
-- ============================================================

-- Level 1: Basics --

-- 1. Retrieve customer names and emails for email marketing. 
SELECT name, email FROM customers;

-- 2. View complete product catalog with all available details. 
SELECT * FROM products;

-- 3. List all unique product categories. 
SELECT DISTINCT category FROM products;

-- 4. Show all products priced above ₹1,000. 
SELECT * FROM products WHERE price > 1000;

-- 5. Display products within a mid-range price bracket (₹2,000 to ₹5,000). 
SELECT * FROM products WHERE price BETWEEN 2000 AND 5000;

-- 6. Fetch data for specific customer IDs (e.g., from loyalty program list). 
SELECT * FROM customers WHERE customer_id IN (1, 3, 5);

-- 7. Identify customers whose names start with the letter 'A'. 
SELECT * FROM customers WHERE name LIKE 'A%';

-- 8. List electronics products priced under ₹3,000. 
SELECT * FROM products WHERE category = 'Electronics' AND price < 3000;

-- 9. Display product names and prices in descending order of price.
SELECT name, price FROM products ORDER BY price DESC;

-- 10. Display product names and prices, sorted by price (DESC) and then by name (ASC). 
SELECT name, price FROM products ORDER BY price DESC, name ASC;

-- Level 2: Filtering and Formatting -- 

-- 1. Retrieve orders where customer information is missing. 
SELECT * FROM orders WHERE customer_id IS NULL;

-- 2. Display customer names and emails using column aliases for frontend readability. 
SELECT name AS Customer_Full_Name, email AS Primary_Email_Address FROM customers;

-- 3. Calculate total value per item ordered by multiplying quantity and item price. 
SELECT order_item_id, order_id, product_id, quantity, item_price, (quantity * item_price) AS line_item_total FROM order_items;

-- 4. Combine customer name and phone number in a single column (Data Cleaning in Action). 
SELECT CONCAT(name, ' (', REGEXP_REPLACE(phone, '[^0-9x]', ''), ')') AS clean_customer_contact FROM customers;

-- 5. Extract only the date part from order timestamps for date-wise reporting. 
SELECT order_id, customer_id, order_date, DATE(order_date) AS clean_order_date FROM orders;

-- 6. List products that do not have any stock left. 
SELECT * FROM products WHERE stock_quantity = 0;

-- Level 3: Aggregations --

-- 1. Count the total number of orders placed. 
SELECT COUNT(*) AS total_orders_placed FROM orders;

-- 2. Calculate the total revenue collected from all orders. 
SELECT SUM(total_amount) AS total_revenue FROM orders;

-- 3. Calculate the average order value.
SELECT AVG(total_amount) AS avg_order_value FROM orders;

-- 4. Count the number of customers who have placed at least one order. 
SELECT COUNT(DISTINCT customer_id) AS active_customer_count FROM orders WHERE customer_id IS NOT NULL;

-- 5. Find the number of orders placed by each customer. 
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id GROUP BY c.customer_id, c.name;

-- 6. Find total sales amount made by each customer. 
SELECT c.customer_id, c.name, COALESCE(SUM(o.total_amount), 0.00) AS total_spent FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id GROUP BY c.customer_id, c.name;

-- 7. List the number of products sold per category. 
SELECT p.category, SUM(oi.quantity) AS total_units_sold FROM products p INNER JOIN order_items oi ON p.product_id = oi.product_id GROUP BY p.category;

-- 8. Find the average item price per category. 
SELECT category, AVG(price) AS avg_product_price FROM products GROUP BY category;

-- 9. Show number of orders placed per day. 
SELECT DATE(order_date) AS order_day, COUNT(order_id) AS total_orders FROM orders GROUP BY DATE(order_date) ORDER BY order_day ASC;

-- 10. List total payments received per payment method. 
SELECT method, SUM(amount_paid) AS total_collected FROM payments GROUP BY method;

-- Level 4: Multi-Table Queries (JOINS) --

-- 1. Retrieve order details along with the customer name (INNER JOIN). 
SELECT o.order_id, o.order_date, o.status, o.total_amount, c.name AS customer_name FROM orders o INNER JOIN customers c ON o.customer_id = c.customer_id;

-- 2. Get list of products that have been sold (INNER JOIN with order_items). 
SELECT DISTINCT p.product_id, p.name, p.category FROM products p INNER JOIN order_items oi ON p.product_id = oi.product_id;

-- 3. List all orders with their payment method (INNER JOIN). 
SELECT o.order_id, o.total_amount, p.payment_id, p.method AS payment_method, p.amount_paid FROM orders o INNER JOIN payments p ON o.order_id = p.order_id;

-- 4. Get list of customers and their orders (LEFT JOIN). 
SELECT c.customer_id, c.name, o.order_id, o.order_date, o.total_amount FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 5. List all products along with order item quantity (LEFT JOIN). 
SELECT p.product_id, p.name AS product_name, oi.order_id, oi.quantity FROM products p LEFT JOIN order_items oi ON p.product_id = oi.product_id;

-- 6. List all payments including those with no matching orders (RIGHT JOIN). 
SELECT p.payment_id, p.amount_paid, p.method, o.order_id, o.customer_id FROM orders o RIGHT JOIN payments p ON o.order_id = p.order_id;

-- 7. Combine data from three tables: customer, order, and payment. 
SELECT c.name AS customer_name, c.email, o.order_id, o.order_date, o.total_amount, p.method AS payment_method, p.amount_paid FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id INNER JOIN payments p ON o.order_id = p.order_id;

-- Level 5: Subqueries (Inner Queries). -- 

-- 1. List all products priced above the average product price. 
SELECT product_id, name, category, price FROM products WHERE price > (SELECT AVG(price) FROM products);

-- 2. Find customers who have placed at least one order. 
SELECT customer_id, name, email FROM customers WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders WHERE customer_id IS NOT NULL);

-- 3. Show orders whose total amount is above the average for that customer. 
SELECT o1.order_id, o1.customer_id, o1.total_amount, o1.order_date FROM orders o1 WHERE o1.total_amount > (SELECT AVG(o2.total_amount) FROM orders o2 WHERE o2.customer_id = o1.customer_id);

-- 4. Display customers who haven't placed any orders. 
SELECT customer_id, name, email FROM customers WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders WHERE customer_id IS NOT NULL);

-- 5. Show products that were never ordered. 
SELECT product_id, name, category, stock_quantity FROM products WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- 6. Show highest value order per customer. 
SELECT customer_id, MAX(total_amount) AS max_order_value FROM orders WHERE customer_id IS NOT NULL GROUP BY customer_id;

-- 7. Highest Order Per Customer (Including Names). 
SELECT c.name AS customer_name, o1.order_id, o1.total_amount AS highest_order_amount, o1.order_date FROM orders o1 INNER JOIN customers c ON o1.customer_id = c.customer_id WHERE o1.total_amount = (SELECT MAX(o2.total_amount) FROM orders o2 WHERE o2.customer_id = o1.customer_id);

-- Level 6: Set Operations. -- 

-- 1. List all customers who have either placed an order or written a product review. 

SELECT customer_id FROM orders WHERE customer_id IS NOT NULL
UNION
SELECT customer_id FROM product_reviews WHERE customer_id IS NOT NULL;

-- 2. List all customers who have placed an order as well as reviewed a product. 
SELECT DISTINCT c.customer_id, c.name, c.email FROM customers c WHERE c.customer_id IN (SELECT customer_id FROM orders) AND c.customer_id IN (SELECT customer_id FROM product_reviews);

-- ============================================================
-- NOTES
-- ============================================================
-- The original project used a provided retail-store dataset.
-- This portfolio version excludes all INSERT/DML data-loading
-- statements so the underlying dataset is not redistributed.
-- ============================================================
