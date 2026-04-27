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

-- INTENT (events)
product_events AS (
    SELECT
        product_id,
        COUNT(*) FILTER (WHERE event_type = 'view') AS views_count,
        COUNT(*) FILTER (WHERE event_type = 'cart') AS cart_adds,
        COUNT(*) FILTER (WHERE event_type = 'wishlist') AS wishlist_adds
    FROM events
    GROUP BY product_id
),

-- SALES (order_items = truth)
product_sales AS (
    SELECT
        product_id,
        COUNT(DISTINCT order_id) AS orders_count,
        SUM(quantity) AS units_sold,
        SUM(item_total) AS revenue
    FROM order_items
    GROUP BY product_id
),

-- REVIEWS (aggregated)
product_reviews AS (
    SELECT
        product_id,
        COUNT(*) AS reviews_count,
        AVG(rating) AS review_avg_rating
    FROM reviews
    GROUP BY product_id
)

SELECT
    pb.product_id,
    pb.product_name,
    pb.category,
    pb.brand,
    pb.price,

    -- PRODUCT QUALITY (catalog)
    pb.product_rating,

    -- BEHAVIOR (demand)
    COALESCE(pe.views_count, 0) AS views_count,
    COALESCE(pe.cart_adds, 0) AS cart_adds,
    COALESCE(pe.wishlist_adds, 0) AS wishlist_adds,

    -- SALES (real)
    COALESCE(ps.orders_count, 0) AS orders_count,
    COALESCE(ps.units_sold, 0) AS units_sold,
    COALESCE(ps.revenue, 0) AS revenue,

    -- REVIEWS (user feedback)
    COALESCE(pr.reviews_count, 0) AS reviews_count,
    pr.review_avg_rating

FROM product_base pb

LEFT JOIN product_events pe
    ON pb.product_id = pe.product_id

LEFT JOIN product_sales ps
    ON pb.product_id = ps.product_id

LEFT JOIN product_reviews pr
    ON pb.product_id = pr.product_id;