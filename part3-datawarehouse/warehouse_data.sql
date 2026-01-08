USE fleximart_dw;

-- =====================================================
-- 1. POPULATE dim_date (30 dates: January-February 2024)
-- =====================================================

INSERT INTO dim_date (date_key, full_date, day_of_week, day_of_month, month, month_name, quarter, year, is_weekend) VALUES
-- January 2024 (15 dates)
(20240101, '2024-01-01', 'Monday', 1, 1, 'January', 'Q1', 2024, FALSE),
(20240102, '2024-01-02', 'Tuesday', 2, 1, 'January', 'Q1', 2024, FALSE),
(20240103, '2024-01-03', 'Wednesday', 3, 1, 'January', 'Q1', 2024, FALSE),
(20240104, '2024-01-04', 'Thursday', 4, 1, 'January', 'Q1', 2024, FALSE),
(20240105, '2024-01-05', 'Friday', 5, 1, 'January', 'Q1', 2024, FALSE),
(20240106, '2024-01-06', 'Saturday', 6, 1, 'January', 'Q1', 2024, TRUE),
(20240107, '2024-01-07', 'Sunday', 7, 1, 'January', 'Q1', 2024, TRUE),
(20240108, '2024-01-08', 'Monday', 8, 1, 'January', 'Q1', 2024, FALSE),
(20240109, '2024-01-09', 'Tuesday', 9, 1, 'January', 'Q1', 2024, FALSE),
(20240110, '2024-01-10', 'Wednesday', 10, 1, 'January', 'Q1', 2024, FALSE),
(20240111, '2024-01-11', 'Thursday', 11, 1, 'January', 'Q1', 2024, FALSE),
(20240112, '2024-01-12', 'Friday', 12, 1, 'January', 'Q1', 2024, FALSE),
(20240113, '2024-01-13', 'Saturday', 13, 1, 'January', 'Q1', 2024, TRUE),
(20240114, '2024-01-14', 'Sunday', 14, 1, 'January', 'Q1', 2024, TRUE),
(20240115, '2024-01-15', 'Monday', 15, 1, 'January', 'Q1', 2024, FALSE),

-- February 2024 (15 dates)
(20240201, '2024-02-01', 'Thursday', 1, 2, 'February', 'Q1', 2024, FALSE),
(20240202, '2024-02-02', 'Friday', 2, 2, 'February', 'Q1', 2024, FALSE),
(20240203, '2024-02-03', 'Saturday', 3, 2, 'February', 'Q1', 2024, TRUE),
(20240204, '2024-02-04', 'Sunday', 4, 2, 'February', 'Q1', 2024, TRUE),
(20240205, '2024-02-05', 'Monday', 5, 2, 'February', 'Q1', 2024, FALSE),
(20240206, '2024-02-06', 'Tuesday', 6, 2, 'February', 'Q1', 2024, FALSE),
(20240207, '2024-02-07', 'Wednesday', 7, 2, 'February', 'Q1', 2024, FALSE),
(20240208, '2024-02-08', 'Thursday', 8, 2, 'February', 'Q1', 2024, FALSE),
(20240209, '2024-02-09', 'Friday', 9, 2, 'February', 'Q1', 2024, FALSE),
(20240210, '2024-02-10', 'Saturday', 10, 2, 'February', 'Q1', 2024, TRUE),
(20240211, '2024-02-11', 'Sunday', 11, 2, 'February', 'Q1', 2024, TRUE),
(20240212, '2024-02-12', 'Monday', 12, 2, 'February', 'Q1', 2024, FALSE),
(20240213, '2024-02-13', 'Tuesday', 13, 2, 'February', 'Q1', 2024, FALSE),
(20240214, '2024-02-14', 'Wednesday', 14, 2, 'February', 'Q1', 2024, FALSE),
(20240215, '2024-02-15', 'Thursday', 15, 2, 'February', 'Q1', 2024, FALSE);

-- =====================================================
-- 2. POPULATE dim_product (15 products, 3 categories)
-- =====================================================

INSERT INTO dim_product (product_id, product_name, category, subcategory, unit_price) VALUES
-- Electronics (6 products)
('ELEC001', 'Samsung Galaxy S21', 'Electronics', 'Smartphones', 79999.00),
('ELEC002', 'iPhone 15 Pro', 'Electronics', 'Smartphones', 134900.00),
('ELEC003', 'Dell Inspiron Laptop', 'Electronics', 'Computers', 45999.00),
('ELEC004', 'Sony WH-1000XM5 Headphones', 'Electronics', 'Audio', 29990.00),
('ELEC005', 'Apple Watch Series 9', 'Electronics', 'Wearables', 41900.00),
('ELEC006', 'Canon EOS M50 Camera', 'Electronics', 'Cameras', 55999.00),

-- Fashion (5 products)
('FASH001', 'Nike Air Max Shoes', 'Fashion', 'Footwear', 8999.00),
('FASH002', 'Levi\'s 511 Jeans', 'Fashion', 'Clothing', 3499.00),
('FASH003', 'Adidas Sports T-Shirt', 'Fashion', 'Clothing', 1299.00),
('FASH004', 'Puma Running Shoes', 'Fashion', 'Footwear', 4999.00),
('FASH005', 'Allen Solly Formal Shirt', 'Fashion', 'Clothing', 1899.00),

-- Home & Kitchen (4 products)
('HOME001', 'Philips Air Fryer', 'Home', 'Appliances', 8499.00),
('HOME002', 'Prestige Induction Cooktop', 'Home', 'Appliances', 2799.00),
('HOME003', 'Amazon Echo Dot', 'Home', 'Smart Home', 4499.00),
('HOME004', 'Cello Water Bottle Set', 'Home', 'Kitchenware', 599.00);

-- =====================================================
-- 3. POPULATE dim_customer (12 customers, 4 cities)
-- =====================================================

INSERT INTO dim_customer (customer_id, customer_name, city, state, customer_segment) VALUES
-- Mumbai customers (3)
('C001', 'Rahul Sharma', 'Mumbai', 'Maharashtra', 'VIP'),
('C002', 'Priya Patel', 'Mumbai', 'Maharashtra', 'Regular'),
('C003', 'Amit Kumar', 'Mumbai', 'Maharashtra', 'Regular'),

-- Bangalore customers (3)
('C004', 'Sneha Reddy', 'Bangalore', 'Karnataka', 'VIP'),
('C005', 'Vikram Singh', 'Bangalore', 'Karnataka', 'Regular'),
('C006', 'Anjali Mehta', 'Bangalore', 'Karnataka', 'New'),

-- Delhi customers (3)
('C007', 'Rohan Gupta', 'Delhi', 'Delhi', 'VIP'),
('C008', 'Kavya Iyer', 'Delhi', 'Delhi', 'Regular'),
('C009', 'Arjun Nair', 'Delhi', 'Delhi', 'Regular'),

-- Hyderabad customers (3)
('C010', 'Deepa Rao', 'Hyderabad', 'Telangana', 'Regular'),
('C011', 'Karthik Krishnan', 'Hyderabad', 'Telangana', 'New'),
('C012', 'Meera Desai', 'Hyderabad', 'Telangana', 'VIP');

-- =====================================================
-- 4. POPULATE fact_sales (40 transactions)
-- =====================================================
-- Pattern: Higher sales on weekends, varied quantities
-- VIP customers buy expensive products
-- =====================================================

INSERT INTO fact_sales (date_key, product_key, customer_key, quantity_sold, unit_price, discount_amount, total_amount) VALUES
-- Week 1 (Jan 1-7) - New Year sales
(20240101, 1, 1, 1, 79999.00, 5000.00, 74999.00),        -- Rahul buys Samsung
(20240102, 3, 2, 1, 45999.00, 2000.00, 43999.00),        -- Priya buys Laptop
(20240103, 7, 3, 2, 8999.00, 500.00, 17498.00),          -- Amit buys 2 Nike shoes
(20240104, 11, 4, 1, 8499.00, 0.00, 8499.00),            -- Sneha buys Air Fryer
(20240105, 8, 5, 1, 3499.00, 0.00, 3499.00),             -- Vikram buys Jeans
(20240106, 2, 7, 1, 134900.00, 10000.00, 124900.00),     -- Rohan buys iPhone (Weekend - VIP)
(20240106, 4, 1, 1, 29990.00, 2000.00, 27990.00),        -- Rahul buys Headphones (Weekend)
(20240107, 5, 4, 1, 41900.00, 3000.00, 38900.00),        -- Sneha buys Apple Watch (Weekend)
(20240107, 6, 12, 1, 55999.00, 5000.00, 50999.00),       -- Meera buys Camera (Weekend - VIP)

-- Week 2 (Jan 8-14)
(20240108, 9, 6, 2, 1299.00, 0.00, 2598.00),             -- Anjali buys 2 T-shirts
(20240109, 10, 8, 1, 4999.00, 500.00, 4499.00),          -- Kavya buys Puma shoes
(20240110, 12, 9, 1, 2799.00, 0.00, 2799.00),            -- Arjun buys Induction
(20240111, 14, 10, 3, 599.00, 0.00, 1797.00),            -- Deepa buys 3 Water bottles
(20240112, 13, 11, 1, 4499.00, 0.00, 4499.00),           -- Karthik buys Echo Dot
(20240113, 1, 8, 1, 79999.00, 8000.00, 71999.00),        -- Kavya buys Samsung (Weekend)
(20240113, 7, 2, 1, 8999.00, 1000.00, 7999.00),          -- Priya buys Nike (Weekend)
(20240114, 3, 7, 1, 45999.00, 5000.00, 40999.00),        -- Rohan buys Laptop (Weekend)
(20240114, 5, 12, 1, 41900.00, 4000.00, 37900.00),       -- Meera buys Apple Watch (Weekend)

-- Week 3 (Jan 15 - Feb 4)
(20240115, 11, 5, 1, 8499.00, 500.00, 7999.00),          -- Vikram buys Air Fryer
(20240201, 8, 3, 2, 3499.00, 500.00, 6498.00),           -- Amit buys 2 Jeans
(20240202, 10, 6, 1, 4999.00, 0.00, 4999.00),            -- Anjali buys Puma shoes
(20240203, 2, 4, 1, 134900.00, 15000.00, 119900.00),     -- Sneha buys iPhone (Weekend - VIP)
(20240203, 4, 1, 1, 29990.00, 3000.00, 26990.00),        -- Rahul buys Headphones (Weekend)
(20240204, 6, 7, 1, 55999.00, 6000.00, 49999.00),        -- Rohan buys Camera (Weekend - VIP)
(20240204, 9, 9, 3, 1299.00, 100.00, 3797.00),           -- Arjun buys 3 T-shirts (Weekend)

-- Week 4 (Feb 5-11)
(20240205, 12, 10, 1, 2799.00, 0.00, 2799.00),           -- Deepa buys Induction
(20240206, 13, 11, 2, 4499.00, 500.00, 8498.00),         -- Karthik buys 2 Echo Dots
(20240207, 14, 2, 5, 599.00, 0.00, 2995.00),             -- Priya buys 5 Water bottles
(20240208, 7, 8, 1, 8999.00, 1000.00, 7999.00),          -- Kavya buys Nike shoes
(20240209, 11, 5, 1, 8499.00, 0.00, 8499.00),            -- Vikram buys Air Fryer
(20240210, 1, 12, 1, 79999.00, 10000.00, 69999.00),      -- Meera buys Samsung (Weekend - VIP)
(20240210, 3, 4, 1, 45999.00, 5000.00, 40999.00),        -- Sneha buys Laptop (Weekend)
(20240211, 5, 7, 1, 41900.00, 5000.00, 36900.00),        -- Rohan buys Apple Watch (Weekend)
(20240211, 2, 1, 1, 134900.00, 20000.00, 114900.00),     -- Rahul buys iPhone (Weekend - huge discount)

-- Week 5 (Feb 12-15) - Valentine's Week
(20240212, 8, 3, 1, 3499.00, 0.00, 3499.00),             -- Amit buys Jeans
(20240213, 9, 6, 2, 1299.00, 200.00, 2398.00),           -- Anjali buys 2 T-shirts
(20240214, 10, 9, 2, 4999.00, 1000.00, 8998.00),         -- Arjun buys 2 Puma (Valentine's)
(20240214, 7, 8, 2, 8999.00, 2000.00, 15998.00),         -- Kavya buys 2 Nike (Valentine's)
(20240215, 4, 2, 1, 29990.00, 2000.00, 27990.00),        -- Priya buys Headphones
(20240215, 6, 12, 1, 55999.00, 7000.00, 48999.00);       -- Meera buys Camera (VIP discount)

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Count records in each table
SELECT 'dim_date' AS table_name, COUNT(*) AS record_count FROM dim_date
UNION ALL
SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM fact_sales;

-- Expected Output:
-- dim_date: 30 records
-- dim_product: 15 records
-- dim_customer: 12 records
-- fact_sales: 40 records

-- =====================================================
-- SAMPLE ANALYTICAL QUERIES
-- =====================================================

-- 1. Total sales by category
SELECT 
    p.category,
    SUM(f.total_amount) AS total_revenue,
    COUNT(*) AS num_transactions
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 2. Weekend vs Weekday sales comparison
SELECT 
    CASE WHEN d.is_weekend THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(*) AS num_transactions,
    SUM(f.total_amount) AS total_revenue,
    AVG(f.total_amount) AS avg_transaction_value
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.is_weekend;

-- 3. Top 5 customers by spending
SELECT 
    c.customer_name,
    c.city,
    c.customer_segment,
    SUM(f.total_amount) AS total_spent,
    COUNT(*) AS num_purchases
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_name, c.city, c.customer_segment
ORDER BY total_spent DESC
LIMIT 5;

-- 4. Monthly sales trend
SELECT 
    d.month_name,
    COUNT(*) AS num_transactions,
    SUM(f.total_amount) AS monthly_revenue,
    AVG(f.total_amount) AS avg_order_value
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.month, d.month_name
ORDER BY d.month;

-- 5. Product performance (top 5 products)
SELECT 
    p.product_name,
    p.category,
    SUM(f.quantity_sold) AS units_sold,
    SUM(f.total_amount) AS revenue
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.product_name, p.category
ORDER BY revenue DESC
LIMIT 5;
