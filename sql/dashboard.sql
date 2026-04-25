-- Data Quality Summary Metrics
SELECT
  'users' AS table_name,
  COUNT(*) AS total_records,
  SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_count,
  0 AS invalid_count,
  0 AS orphan_count
FROM users

UNION ALL

SELECT
  'orders' AS table_name,
  COUNT(*) AS total_records,
  SUM(CASE WHEN user_id IS NULL OR order_date IS NULL THEN 1 ELSE 0 END),
  SUM(CASE WHEN total_amount < 0 THEN 1 ELSE 0 END),
  0
FROM orders

UNION ALL

SELECT
  'order_items' AS table_name,
  COUNT(*) AS total_records,
  0,
  SUM(CASE WHEN quantity <= 0 OR item_total != quantity * item_price THEN 1 ELSE 0 END),
  SUM(CASE WHEN order_id IS NULL OR product_id IS NULL THEN 1 ELSE 0 END)
FROM order_items;