-- Verify row counts across all three tables and status breakdown

SELECT COUNT(*) AS dark_stores_count FROM dark_stores;
-- Result: 13

SELECT COUNT(*) AS hour_bands_count FROM hour_bands;
-- Result: 17

SELECT COUNT(*) AS orders_count FROM orders;
-- Result: 6000

SELECT status, COUNT(*) AS status_count
FROM orders
GROUP BY status;
-- Result: Cancelled = 384, Delivered = 5616
