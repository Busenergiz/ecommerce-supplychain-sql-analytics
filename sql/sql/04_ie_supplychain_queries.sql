-- 1. ABC Inventory Classification (Pareto Principle 80/15/5)
-- Categorizes stock by cumulative revenue contribution.
WITH product_revenues AS (
    SELECT
        p.product_id,
        p.product_name,
        p.stock_quantity,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.stock_quantity
),
cumulative_calc AS (
    SELECT
        product_id,
        product_name,
        stock_quantity,
        total_revenue,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC) AS running_total_revenue,
        SUM(total_revenue) OVER () AS grand_total_revenue
    FROM product_revenues
)
SELECT
    product_id,
    product_name,
    stock_quantity,
    total_revenue,
    ROUND((running_total_revenue / grand_total_revenue) * 100, 2) AS cumulative_revenue_pct,
    CASE
        WHEN (running_total_revenue / grand_total_revenue) <= 0.70 THEN 'Class A (High Value / Critical)'
        WHEN (running_total_revenue / grand_total_revenue) <= 0.90 THEN 'Class B (Moderate Value)'
        ELSE 'Class C (Low Value / High Volume)'
    END AS abc_class
FROM cumulative_calc
ORDER BY total_revenue DESC;


-- 2. Stockout Risk & Reorder Point (ROP) Monitoring
-- Flags products whose current inventory is below the safety threshold.
SELECT
    p.product_id,
    p.product_name,
    s.supplier_name,
    s.reliability_score AS supplier_score,
    p.stock_quantity AS current_stock,
    p.reorder_point,
    (p.reorder_point - p.stock_quantity) AS recommended_reorder_units,
    CASE
        WHEN p.stock_quantity = 0 THEN 'CRITICAL: Out of Stock'
        WHEN p.stock_quantity < p.reorder_point THEN 'WARNING: Below Reorder Point'
        ELSE 'OPTIMAL: Stock Level Healthy'
    END AS inventory_status
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.stock_quantity < p.reorder_point
ORDER BY recommended_reorder_units DESC;


-- 3. Carrier Logistics SLA & Fulfillment Lead Time Analysis
-- Measures shipping dispatch efficiency and delivery duration per carrier.
SELECT
    carrier_name,
    COUNT(shipment_id) AS total_shipments,
    ROUND(AVG(EXTRACT(EPOCH FROM (shipped_date - o.order_date))/3600), 2) AS avg_fulfillment_hours,
    ROUND(AVG(EXTRACT(EPOCH FROM (delivery_date - shipped_date))/86400), 2) AS avg_transit_days,
    ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM shipments sh
JOIN orders o ON sh.order_id = o.order_id
WHERE sh.delivery_date IS NOT NULL
GROUP BY carrier_name
ORDER BY avg_transit_days ASC;
