WITH reference AS (
    SELECT
        MAX(event_timestamp::date) AS reference_date
    FROM events
),

ordered_orders AS (
    SELECT
        user_id,
        order_date,
        total_amount,
        LAG(order_date) OVER (
            PARTITION BY user_id
            ORDER BY order_date
        ) AS prev_order_date
    FROM orders
),

order_intervals AS (
    SELECT
        user_id,
        (order_date - prev_order_date) AS days_between
    FROM ordered_orders
    WHERE prev_order_date IS NOT NULL
),

user_intervals AS (
    SELECT
        user_id,
        AVG(days_between) AS avg_days_between_orders
    FROM order_intervals
    GROUP BY user_id
),

user_orders AS (
    SELECT
        user_id,

        COUNT(*) AS total_orders,
        SUM(total_amount) AS total_spent,
        AVG(total_amount) AS avg_order_value,
        MAX(total_amount) AS max_order_value,

        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order

    FROM orders
    GROUP BY user_id
),

user_events AS (
    SELECT
        user_id,

        COUNT(*) FILTER (WHERE event_type = 'view') AS views_count,
        COUNT(*) FILTER (WHERE event_type = 'cart') AS cart_adds,
        COUNT(*) FILTER (WHERE event_type = 'wishlist') AS wishlist_adds,

        COUNT(DISTINCT DATE(event_timestamp)) AS active_days

    FROM events
    GROUP BY user_id
)

SELECT
    u.user_id,

    -- revenue
    o.total_orders,
    o.total_spent,
    o.avg_order_value,
    o.max_order_value,
    o.first_order,
    o.last_order,

    -- recency
    CASE
        WHEN o.last_order IS NOT NULL
            THEN (r.reference_date - o.last_order)
        ELSE NULL
    END AS days_since_last_order,

    e.active_days,
    e.views_count,
    e.cart_adds,
    e.wishlist_adds,

    CASE
        WHEN e.active_days > 0
            THEN e.views_count::float / e.active_days
        ELSE NULL
    END AS views_per_active_day,

    CASE
        WHEN e.views_count > 0
            THEN e.cart_adds::float / e.views_count
        ELSE NULL
    END AS view_to_cart_rate,

    CASE
        WHEN e.views_count > 0
            THEN e.wishlist_adds::float / e.views_count
        ELSE NULL
    END AS view_to_wishlist_rate,

    --frequency
    ui.avg_days_between_orders

FROM users u

LEFT JOIN user_orders o
    ON u.user_id = o.user_id

LEFT JOIN user_events e
    ON u.user_id = e.user_id

LEFT JOIN user_intervals ui
    ON u.user_id = ui.user_id

CROSS JOIN reference r;