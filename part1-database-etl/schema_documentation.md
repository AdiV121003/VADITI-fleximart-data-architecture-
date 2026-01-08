# Fleximart Database Schema Documentation

## 1. Entity-Relationship Description

### ENTITY: customers
**Purpose:** Stores customer information for all registered users in the Fleximart system.

**Attributes:**
- `customer_id` (INT, Primary Key): Unique identifier for each customer
- `first_name` (VARCHAR(50), NOT NULL): Customer's first name
- `last_name` (VARCHAR(50), NOT NULL): Customer's last name
- `email` (VARCHAR(100), UNIQUE, NOT NULL): Customer's email address for contact and authentication
- `phone` (VARCHAR(20)): Customer's phone number in standardized format (+91-XXXXXXXXXX)
- `city` (VARCHAR(50)): Customer's city of residence
- `registration_date` (DATE): Date when customer registered on the platform

**Relationships:**
- One customer can place MANY orders (1:M relationship with orders table)
- Foreign Key: Referenced by `orders.customer_id`

---

### ENTITY: products
**Purpose:** Stores product catalog information including pricing and inventory.

**Attributes:**
- `product_id` (INT, Primary Key): Unique identifier for each product
- `product_name` (VARCHAR(100), NOT NULL): Name of the product
- `category` (VARCHAR(50), NOT NULL): Product category (e.g., Electronics, Clothing)
- `price` (DECIMAL(10,2), NOT NULL): Current price of the product
- `stock_quantity` (INT, DEFAULT 0): Available inventory quantity

**Relationships:**
- One product can appear in MANY order items (1:M relationship with order_items table)
- Foreign Key: Referenced by `order_items.product_id`

---

### ENTITY: orders
**Purpose:** Stores order header information including customer, date, and total amount.

**Attributes:**
- `order_id` (INT, Primary Key): Unique identifier for each order
- `customer_id` (INT, NOT NULL, Foreign Key): References the customer who placed the order
- `order_date` (DATE, NOT NULL): Date when the order was placed
- `total_amount` (DECIMAL(10,2), NOT NULL): Total amount of the order (sum of all items)
- `status` (VARCHAR(20), DEFAULT 'Pending'): Current order status (Pending, Completed, Cancelled, etc.)

**Relationships:**
- MANY orders belong to ONE customer (M:1 relationship with customers table)
- One order contains MANY order items (1:M relationship with order_items table)
- Foreign Key: `customer_id` references `customers.customer_id`
- Foreign Key: Referenced by `order_items.order_id`

---

### ENTITY: order_items
**Purpose:** Stores individual line items for each order, representing products purchased.

**Attributes:**
- `order_item_id` (INT, Primary Key): Unique identifier for each order line item
- `order_id` (INT, NOT NULL, Foreign Key): References the parent order
- `product_id` (INT, NOT NULL, Foreign Key): References the product being purchased
- `quantity` (INT, NOT NULL): Number of units of this product in the order
- `unit_price` (DECIMAL(10,2), NOT NULL): Price per unit at the time of purchase
- `subtotal` (DECIMAL(10,2), NOT NULL): Total price for this line item (quantity × unit_price)

**Relationships:**
- MANY order items belong to ONE order (M:1 relationship with orders table)
- MANY order items reference ONE product (M:1 relationship with products table)
- Foreign Key: `order_id` references `orders.order_id`
- Foreign Key: `product_id` references `products.product_id`

---

## 2. Normalization Explanation

### Third Normal Form (3NF) Compliance

This database design satisfies all requirements of Third Normal Form (3NF), which requires:
1. Being in Second Normal Form (2NF)
2. Having no transitive dependencies (non-key attributes must depend only on the primary key)

**Functional Dependencies:**

**Customers table:**
- customer_id → first_name, last_name, email, phone, city, registration_date
- All attributes depend solely on customer_id (no transitive dependencies)

**Products table:**
- product_id → product_name, category, price, stock_quantity
- All attributes depend solely on product_id (no transitive dependencies)

**Orders table:**
- order_id → customer_id, order_date, total_amount, status
- All attributes depend solely on order_id (no transitive dependencies)

**Order_items table:**
- order_item_id → order_id, product_id, quantity, unit_price, subtotal
- All attributes depend solely on order_item_id (no transitive dependencies)

**Avoiding Anomalies:**

**Update Anomalies:** The design prevents update anomalies by storing each piece of information in only one place. For example, customer information is stored only in the customers table. If a customer changes their address, we update one row in one table, not multiple rows across multiple tables.

**Insert Anomalies:** The design allows entities to exist independently. We can add a new customer without requiring them to place an order immediately. Similarly, we can add new products to the catalog without any orders referencing them.

**Delete Anomalies:** When deleting records, we don't lose unrelated information. If we delete an order, we don't lose customer information because customer data is stored independently. The order_items table provides granular control - we can delete individual items without affecting the order header or product catalog.

The separation of orders and order_items demonstrates proper normalization: order-level information (customer, date, total) is stored once in the orders table, while item-level details (product, quantity, price) are stored in order_items. This eliminates redundancy and ensures data integrity through foreign key constraints.

---

## 3. Sample Data Representation

### Customers Table Sample Data

1	Rahul	Sharma	rahul.sharma@gmail.com	    +91-9876543210	Bangalore	2023-01-15
2	Priya	Patel	priya.patel@yahoo.com	    +91-9988776655	Mumbai	    2023-02-20
4	Sneha	Reddy	sneha.reddy@gmail.com	    +91-9123456789	Hyderabad	
5	Vikram	Singh	vikram.singh@outlook.com	+91-9988112233	Chennai	    2023-05-22
6	Anjali	Mehta	anjali.mehta@gmail.com	    +91-9876543210	Bangalore	2023-06-18

### Products Table Sample Data

1	Samsung Galaxy S21	Electronics	45999	150
2	Nike Running Shoes	Fashion	    3499	80
4	Levi's Jeans	    Fashion	    2999	120
5	Sony Headphones	    Electronics	1999	200
6	Organic Almonds	    Groceries	899	    0

### Orders Table Sample Data

1	1	2024-01-15	45999	Completed
2	2	2024-01-16	5998	Completed
5	5	2024-01-20	1950	Completed
6	6	2024-01-22	12999	Complete 
9	9	2024-01-28	4599	Cancelled

### Order_Items Table Sample Data

1	1	1	1	45999	45999
2	2	4	2	2999	5998
4	5	9	3	650	1950
5	6	12	1	12999	12999
7	9	11	1	4599	4599
---
