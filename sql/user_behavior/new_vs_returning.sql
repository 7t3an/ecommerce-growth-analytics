SELECT
    u.user_id,
    COUNT(o.order_id) AS total_orders,
    CASE 
        WHEN COUNT(o.order_id) = 0 THEN 'no_purchase'
        WHEN COUNT(o.order_id) = 1 THEN 'new'
        ELSE 'returning'
    END AS user_type
FROM users u
LEFT JOIN orders o
    ON u.user_id = o.user_id
GROUP BY u.user_id;