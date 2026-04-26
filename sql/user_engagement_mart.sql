WITH user_events AS (
    SELECT
        user_id,

        -- behavior signals
        COUNT(*) FILTER (WHERE event_type = 'view') AS views_count,
        COUNT(*) FILTER (WHERE event_type = 'cart') AS cart_adds,
        COUNT(*) FILTER (WHERE event_type = 'wishlist') AS wishlist_adds,
        COUNT(*) FILTER (WHERE event_type = 'purchase') AS purchase_events,

        -- activity
        COUNT(DISTINCT DATE(event_timestamp)) AS active_days,

        -- timeline
        MIN(event_timestamp::date) AS first_activity,
        MAX(event_timestamp::date) AS last_activity

    FROM events
    GROUP BY user_id
)

SELECT
    u.user_id,

    -- BEHAVIOR SIGNALS ONLY
    COALESCE(e.views_count, 0) AS views_count,
    COALESCE(e.cart_adds, 0) AS cart_adds,
    COALESCE(e.wishlist_adds, 0) AS wishlist_adds,
    COALESCE(e.purchase_events, 0) AS purchase_events,

    COALESCE(e.active_days, 0) AS active_days,

    e.first_activity,
    e.last_activity

FROM users u

LEFT JOIN user_events e
    ON u.user_id = e.user_id;