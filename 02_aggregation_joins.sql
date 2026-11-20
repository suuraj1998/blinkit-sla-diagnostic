-- (a) Overall compliance (<= 10) vs strict (< 10)
SELECT ROUND(SUM(within_sla) * 100.0 / COUNT(delivery_minutes), 2) AS overall_compliance_le_10
FROM orders;

SELECT ROUND(COUNT(*) * 100.0 / (SELECT COUNT(delivery_minutes) FROM orders), 2) AS overall_compliance_lt_10
FROM orders
WHERE delivery_minutes < 10;

-- (b) Compliance by city
SELECT d.city,
       COUNT(o.delivery_minutes) AS delivered_orders,
       ROUND(SUM(o.within_sla) * 100.0 / COUNT(o.delivery_minutes), 2) AS compliance_pct
FROM orders o
INNER JOIN dark_stores d ON o.store_id = d.store_id
GROUP BY d.city
ORDER BY compliance_pct ASC;

-- (b) Compliance by cluster
SELECT d.cluster,
       COUNT(o.delivery_minutes) AS delivered_orders,
       ROUND(SUM(o.within_sla) * 100.0 / COUNT(o.delivery_minutes), 2) AS compliance_pct
FROM orders o
INNER JOIN dark_stores d ON o.store_id = d.store_id
GROUP BY d.cluster
ORDER BY compliance_pct ASC;

-- (c) Compliance by hour band
SELECT h.band,
       COUNT(o.delivery_minutes) AS delivered_orders,
       ROUND(SUM(o.within_sla) * 100.0 / COUNT(o.delivery_minutes), 2) AS compliance_pct
FROM orders o
INNER JOIN hour_bands h ON STRFTIME('%H', o.order_ts) = h.hour_text
GROUP BY h.band
ORDER BY compliance_pct ASC;

-- (d) Compliance by category (more than 1000 delivered orders)
SELECT category,
       COUNT(delivery_minutes) AS delivered_orders,
       ROUND(SUM(within_sla) * 100.0 / COUNT(delivery_minutes), 2) AS compliance_pct
FROM orders
GROUP BY category
HAVING COUNT(delivery_minutes) > 1000
ORDER BY compliance_pct ASC;

-- (e) LEFT JOIN of dark_stores to orders (unused store surfaces first)
SELECT d.store_id,
       d.store_name,
       d.city,
       d.cluster,
       COUNT(o.order_id) AS orders_handled
FROM dark_stores d
LEFT JOIN orders o ON d.store_id = o.store_id
GROUP BY d.store_id, d.store_name, d.city, d.cluster
ORDER BY orders_handled ASC, d.store_id ASC;
