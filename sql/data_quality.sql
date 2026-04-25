-- USERS TABLE
-- Missing user_id
SELECT *
FROM users
WHERE user_id IS NULL;

-- Duplicate users
SELECT user_id, COUNT(*)
FROM users
GROUP BY user_id
HAVING COUNT(*) > 1;

--Users without orders (integrity check)
SELECT *
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.user_id IS NULL;

--Users dataset sanity
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT user_id) AS unique_users
FROM users;



-- ORDERS TABLE
--Negative revenue
SELECT *
FROM orders
WHERE total_amount < 0;

--Missing critical fields
SELECT *
FROM orders
WHERE order_id IS NULL 
   OR user_id IS NULL 
   OR order_date IS NULL;

--Future orders (data anomaly)
SELECT *
FROM orders
WHERE order_date > CURRENT_DATE;

--Outliers
SELECT *
FROM orders
WHERE total_amount > 10000;

--Duplicate order_id
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

--Order date range
SELECT 
    MIN(order_date),
    MAX(order_date)
FROM orders;

--Logical duplicates
SELECT user_id, order_date, total_amount, COUNT(*)
FROM orders
GROUP BY user_id, order_date, total_amount
HAVING COUNT(*) > 1;



-- ORDER ITEMS TABLE
--Invalid quantity
SELECT *
FROM order_items
WHERE quantity <= 0;

--Price mismatch validation
SELECT *
FROM order_items
WHERE item_total != quantity * item_price;

--Orphan order_items (no order)
SELECT *
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

--Orphan products
SELECT *
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;



-- REVIEWS TABLE
--Orphan reviews
SELECT *
FROM reviews r
LEFT JOIN products p ON r.product_id = p.product_id
WHERE p.product_id IS NULL;

--Invalid ratings
SELECT *
FROM reviews
WHERE rating < 1 OR rating > 5;



-- EVENTS TABLE
--Unique event types (schema sanity)
SELECT DISTINCT event_type
FROM events;

--Event distribution (frequency)
SELECT event_type, COUNT(*)
FROM events
GROUP BY event_type;
