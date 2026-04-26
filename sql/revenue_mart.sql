WITH reference AS (
    SELECT
        MAX(event_timestamp::date) AS reference_date
    FROM events
),

user_orders AS (
    SELECT
        user_id,

        COUNT(*) AS total_orders,
        SUM(total_amount) AS total_spent,

        AVG(total_amount) AS avg_order_value,
        MAX(total_amount) AS max_order_value,
        MIN(total_amount) AS min_order_value,

        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order

    FROM orders
    GROUP BY user_id
)

SELECT
    u.user_id,

    -- REVENUE CORE
    COALESCE(o.total_orders, 0) AS total_orders,
    COALESCE(o.total_spent, 0) AS total_spent,

    -- IMPORTANT: NULL for non-buyers
    o.avg_order_value AS avg_order_value,
	o.min_order_value AS min_order_value,
    o.max_order_value AS max_order_value,

    o.first_order,
    o.last_order,

    -- LIFETIME METRICS
    CASE
        WHEN o.first_order IS NOT NULL
        THEN (o.last_order - o.first_order)
        ELSE NULL
    END AS customer_lifetime_days,
	
    -- RECENCY (dataset-based)
    CASE
        WHEN o.last_order IS NOT NULL
        THEN (r.reference_date - o.last_order)
        ELSE NULL
    END AS days_since_last_order

FROM users u

LEFT JOIN user_orders o
    ON u.user_id = o.user_id

CROSS JOIN reference r;