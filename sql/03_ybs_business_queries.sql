-- 1. RFM (Recency, Frequency, Monetary) Customer Segmentation
-- Segments customers based on their last purchase, order count, and total spend.
WITH rfm_metrics AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.city,
        CURRENT_DATE - MAX(o.order_date::DATE) AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency_orders,
        COALESCE(SUM(o.total_amount), 0) AS monetary_spend
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
),
rfm_scores AS (
    SELECT 
        customer_id,
        customer_name,
        city,
        recency_days,
        frequency_orders,
        monetary_spend,
        NTILE(3) OVER (ORDER BY recency_days ASC) AS r_score,
        NTILE(3) OVER (ORDER BY frequency_orders DESC) AS f_score,
        NTILE(3) OVER (ORDER BY monetary_spend DESC) AS m_score
    FROM rfm_metrics
)
SELECT 
    customer_id,
    customer_name,
    city,
    recency_days,
    frequency_orders,
    monetary_spend,
    CASE 
        WHEN (r_score = 3 AND f_score = 3) OR m_score = 3 THEN 'Top VIP Customer'
        WHEN r_score >= 2 AND f_score >= 2 THEN 'Loyal Customer'
        WHEN r_score = 1 AND f_score >= 2 THEN 'At Risk / Churn Candidate'
        ELSE 'Infrequent Shopper'
    END AS customer_segment
FROM rfm_scores
ORDER BY monetary_spend DESC;


-- 2. Category Profitability & Target Margin Achievement Rate
-- Compares actual gross margins against target category margin rates.
SELECT 
    cat.category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders_involved,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
    ROUND(SUM(oi.quantity * (oi.unit_price - p.unit_cost)), 2) AS gross_profit,
    ROUND((SUM(oi.quantity * (oi.unit_price - p.unit_cost)) / NULLIF(SUM(oi.quantity * oi.unit_price), 0)) * 100, 2) AS actual_margin_pct,
    cat.target_margin_rate * 100 AS target_margin_pct
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY cat.category_id, cat.category_name, cat.target_margin_rate
ORDER BY gross_profit DESC;


-- 3. Cross-Selling / Market Basket Association (Self-Join)
-- Identifies which pairs of products are most frequently purchased together in the same order.
SELECT 
    p1.product_name AS primary_product,
    p2.product_name AS associated_product,
    COUNT(*) AS times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name
ORDER BY times_bought_together DESC;
