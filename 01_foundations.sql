-- (a) WHERE: stores in Mumbai
SELECT store_id, store_name, city, cluster
FROM dark_stores
WHERE city = 'Mumbai';

-- (b) DISTINCT: list of clusters
SELECT DISTINCT cluster
FROM dark_stores
ORDER BY cluster;

-- (c) LIKE with %: stores whose name starts with Powai
SELECT store_id, store_name, city, cluster
FROM dark_stores
WHERE store_name LIKE 'Powai%';

-- (d) ORDER BY + LIMIT: 5 slowest orders by delivery_minutes DESC, ties broken by order_id ASC
SELECT order_id, store_id, order_date, category, delivery_minutes
FROM orders
WHERE delivery_minutes IS NOT NULL
ORDER BY delivery_minutes DESC, order_id ASC
LIMIT 5;

-- (e) BETWEEN: orders delivered in 11 to 15 minutes inclusive
SELECT COUNT(*) AS orders_11_to_15_min
FROM orders
WHERE delivery_minutes BETWEEN 11 AND 15;

-- (f) IS NULL: orders with no delivery time
SELECT COUNT(*) AS orders_without_delivery_time
FROM orders
WHERE delivery_minutes IS NULL;

-- (g) Temporary column with alias: minutes over SLA for delivered orders
SELECT order_id, delivery_minutes, delivery_minutes - 10 AS minutes_over_sla
FROM orders
WHERE delivery_minutes IS NOT NULL
LIMIT 10;
