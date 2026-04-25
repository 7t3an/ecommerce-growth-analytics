SELECT
    user_id,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_spent,
    COUNT(DISTINCT DATE(order_date)) AS active_days,
    AVG(total_amount) AS avg_order_value
FROM orders
GROUP BY user_id;