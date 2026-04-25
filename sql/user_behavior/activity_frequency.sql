SELECT
    user_id,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT DATE(order_date)) AS active_days,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    COUNT(*) * 1.0 / NULLIF(COUNT(DISTINCT DATE(order_date)), 0) AS orders_per_active_day
FROM orders
GROUP BY user_id;