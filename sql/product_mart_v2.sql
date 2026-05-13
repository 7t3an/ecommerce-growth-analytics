WITH product_base AS (
    SELECT
        product_id,
        product_name,
        category,
        brand,
        price,
        rating AS product_rating
    FROM products
),

-- BEHAVIORAL INTENT (events table)
product_events AS (
    SELECT
        product_id,
        COUNT(*) FILTER (WHERE event_type = 'view')     AS views_count,
        COUNT(*) FILTER (WHERE event_type = 'cart')     AS cart_adds,
        COUNT(*) FILTER (WHERE event_type = 'wishlist') AS wishlist_adds,

        -- purchase as tracked in events (behavioral signal, may not match orders)
        COUNT(*) FILTER (WHERE event_type = 'purchase') AS purchase_events
    FROM events
    GROUP BY product_id
),

-- ACTUAL SALES (order_items = source of truth for revenue)
product_sales AS (
    SELECT
        product_id,
        COUNT(DISTINCT order_id) AS orders_count,
        SUM(quantity)            AS units_sold,
        SUM(item_total)          AS revenue
    FROM order_items
    GROUP BY product_id
),

-- REVIEWS
product_reviews AS (
    SELECT
        product_id,
        COUNT(*)     AS reviews_count,
        AVG(rating)  AS review_avg_rating
    FROM reviews
    GROUP BY product_id
)

SELECT
    pb.product_id,
    pb.product_name,
    pb.category,
    pb.brand,
    pb.price,
    pb.product_rating,

    -- BEHAVIORAL (from events)
    COALESCE(pe.views_count,      0) AS views_count,
    COALESCE(pe.cart_adds,        0) AS cart_adds,
    COALESCE(pe.wishlist_adds,    0) AS wishlist_adds,
    COALESCE(pe.purchase_events,  0) AS purchase_events,  -- tracked purchases (events)

    -- ACTUAL SALES (from order_items)
    COALESCE(ps.orders_count, 0) AS orders_count,         -- real orders
    COALESCE(ps.units_sold,   0) AS units_sold,
    COALESCE(ps.revenue,      0) AS revenue,

    -- TRACKING GAP: difference between behavioral signal and real orders
    COALESCE(ps.orders_count, 0) - COALESCE(pe.purchase_events, 0) AS tracking_gap,

    -- REVIEWS
    COALESCE(pr.reviews_count, 0) AS reviews_count,
    pr.review_avg_rating

FROM product_base pb

LEFT JOIN product_events pe ON pb.product_id = pe.product_id
LEFT JOIN product_sales   ps ON pb.product_id = ps.product_id
LEFT JOIN product_reviews pr ON pb.product_id = pr.product_id;
