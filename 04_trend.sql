-- (a) Daily compliance for all 28 days
SELECT order_date,
       COUNT(delivery_minutes) AS delivered_orders,
       ROUND(SUM(within_sla) * 100.0 / COUNT(delivery_minutes), 2) AS compliance_pct
FROM orders
WHERE delivery_minutes IS NOT NULL
GROUP BY order_date
ORDER BY order_date ASC;

-- (b) First 7 days vs Last 7 days overall compliance
SELECT 'First 7 Days (2026-10-05 to 2026-10-11)' AS period,
       ROUND(SUM(within_sla) * 100.0 / COUNT(delivery_minutes), 2) AS compliance_pct
FROM orders
WHERE order_date BETWEEN '2026-10-05' AND '2026-10-11'
UNION ALL
SELECT 'Last 7 Days (2026-10-26 to 2026-11-01)' AS period,
       ROUND(SUM(within_sla) * 100.0 / COUNT(delivery_minutes), 2) AS compliance_pct
FROM orders
WHERE order_date BETWEEN '2026-10-26' AND '2026-11-01';
