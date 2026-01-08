-- =====================================================
-- FLEXIMART BUSINESS INTELLIGENCE QUERIES
-- =====================================================
-- Database: fleximart
-- Author: Vaditi Aditi
-- Date: 2025-01-08
-- =====================================================

USE fleximart;

-- =====================================================
-- Query 1: Customer Purchase History
-- =====================================================
-- Business Question: Show customers who placed 2+ orders 
-- and spent more than ₹5,000 total
-- =====================================================

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM 
    customers c
INNER JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email
HAVING 
    COUNT(DISTINCT o.order_id) >= 2 
    AND SUM(o.total_amount) > 5000
ORDER BY 
    total_spent DESC;


-- =====================================================
-- Query 2: Product Sales Analysis
-- =====================================================
-- Business Question: Show category performance with 
-- revenue over ₹10,000
-- =====================================================

SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS num_products,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.subtotal) AS total_revenue
FROM 
    products p
INNER JOIN 
    order_items oi ON p.product_id = oi.product_id
GROUP BY 
    p.category
HAVING 
    SUM(oi.subtotal) > 10000
ORDER BY 
    total_revenue DESC;


-- =====================================================
-- Query 3: Monthly Sales Trend (2024)
-- =====================================================
-- Business Question: Show monthly sales with running 
-- total (cumulative revenue)
-- =====================================================

-- Version 1: Using Window Function (Recommended)
SELECT 
    MONTHNAME(o.order_date) AS month_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS monthly_revenue,
    SUM(SUM(o.total_amount)) OVER (ORDER BY MONTH(o.order_date)) AS cumulative_revenue
FROM 
    orders o
WHERE 
    YEAR(o.order_date) = 2024
GROUP BY 
    MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY 
    MONTH(o.order_date);

