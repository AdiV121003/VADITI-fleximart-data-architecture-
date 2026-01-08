-- FLEXIMART DATA WAREHOUSE - ANALYTICAL QUERIES
USE fleximart_dw;

-- =====================================================
-- QUERY 1: MONTHLY SALES DRILL-DOWN ANALYSIS (5 marks)
-- =====================================================
-- Business Scenario: CEO wants to see sales performance 
-- broken down by time periods (Year → Quarter → Month)
-- Demonstrates hierarchical drill-down capability
-- =====================================================

SELECT 
    d.year,
    d.quarter,
    d.month_name,
    SUM(f.total_amount) AS total_sales,
    SUM(f.quantity_sold) AS total_quantity
FROM 
    fact_sales f
INNER JOIN 
    dim_date d ON f.date_key = d.date_key
WHERE 
    d.year = 2024
GROUP BY 
    d.year, d.quarter, d.month, d.month_name
ORDER BY 
    d.year, d.month;  -- Chronological order



-- =====================================================
-- QUERY 2: PRODUCT PERFORMANCE ANALYSIS (5 marks)
-- =====================================================
-- Business Scenario: Product manager needs to identify 
-- top-performing products with revenue contribution
-- =====================================================

-- Method 1: Using Window Function (Recommended - Modern SQL)
SELECT 
    p.product_name,
    p.category,
    SUM(f.quantity_sold) AS units_sold,
    SUM(f.total_amount) AS revenue,
    CONCAT(
        ROUND(
            (SUM(f.total_amount) * 100.0 / SUM(SUM(f.total_amount)) OVER ()), 
            2
        ), 
        '%'
    ) AS revenue_percentage
FROM 
    fact_sales f
INNER JOIN 
    dim_product p ON f.product_key = p.product_key
GROUP BY 
    p.product_key, p.product_name, p.category
ORDER BY 
    revenue DESC
LIMIT 10;

-- =====================================================
-- QUERY 3: CUSTOMER SEGMENTATION ANALYSIS (5 marks)
-- =====================================================
-- Business Scenario: Marketing wants to target high-value 
-- customers with segmentation based on spending
-- Segments: High (>50,000), Medium (20,000-50,000), Low (<20,000)
-- =====================================================

-- Method 1: Using CTE (Common Table Expression) - Recommended
WITH customer_spending AS (
    -- Calculate total spending per customer
    SELECT 
        c.customer_key,
        c.customer_name,
        c.city,
        c.customer_segment AS original_segment,
        SUM(f.total_amount) AS total_spent
    FROM 
        fact_sales f
    INNER JOIN 
        dim_customer c ON f.customer_key = c.customer_key
    GROUP BY 
        c.customer_key, c.customer_name, c.city, c.customer_segment
),
customer_segments AS (
    -- Assign value segments based on spending
    SELECT 
        customer_key,
        customer_name,
        city,
        total_spent,
        CASE 
            WHEN total_spent > 50000 THEN 'High Value'
            WHEN total_spent BETWEEN 20000 AND 50000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS value_segment
    FROM customer_spending
)
-- Aggregate by segment
SELECT 
    value_segment AS customer_segment,
    COUNT(*) AS customer_count,
    SUM(total_spent) AS total_revenue,
    ROUND(AVG(total_spent), 2) AS avg_revenue_per_customer
FROM 
    customer_segments
GROUP BY 
    value_segment
ORDER BY 
    CASE value_segment
        WHEN 'High Value' THEN 1
        WHEN 'Medium Value' THEN 2
        WHEN 'Low Value' THEN 3
    END;
