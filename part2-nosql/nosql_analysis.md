# NoSQL Analysis for FlexiMart Product Catalog

## Section A: Limitations of RDBMS 

The current relational database design faces significant challenges when handling diverse product attributes. In a traditional RDBMS like MySQL, the products table has a fixed schema with predetermined columns (product_id, product_name, category, price, stock_quantity). When products have vastly different attributes—such as laptops requiring RAM and processor specifications while shoes need size and color information—the relational model presents three critical limitations:

**1. Sparse Data Problem:** To accommodate all product types, we would need to add columns for every possible attribute (RAM, processor, size, color, author, ISBN, etc.), resulting in a table with dozens of mostly NULL values. A shoe product would have NULL values in RAM and processor columns, wasting storage space and degrading query performance.

**2. Schema Rigidity:** Each time FlexiMart introduces a new product category (e.g., furniture, electronics, groceries), database administrators must execute ALTER TABLE statements to add new columns. This requires downtime, careful migration planning, and can break existing application code that expects a specific schema structure.

**3. Complex Nested Data:** Customer reviews contain variable fields like review_text, rating, images, helpful_votes, and reviewer_replies. Storing this in a relational model requires creating separate tables (reviews, review_images, review_votes), leading to complex JOIN operations. A simple query to fetch a product with its reviews might require joining 4-5 tables, significantly impacting performance as data volume grows.

---

## Section B: NoSQL Benefits 

MongoDB addresses these limitations through three features that align perfectly with FlexiMart's diverse product catalog requirements:

**1. Flexible Schema (Schema-less Design):** MongoDB stores data as JSON-like documents, allowing each product to have its own unique structure without predefined columns. A laptop document can contain `{"RAM": "16GB", "processor": "Intel i7"}` while a shoe document contains `{"size": "10", "color": "Black"}` in the same collection. No NULL values, no wasted space—each document contains only relevant fields. Adding new product types requires no schema migration; developers simply insert documents with new attributes, and the database accepts them immediately.

**2. Embedded Documents (Nested Data):** Reviews can be stored directly within product documents as embedded arrays: `reviews: [{review_id: 1, text: "Great product!", rating: 5, images: ["url1", "url2"]}, {...}]`. This eliminates JOIN operations—fetching a product with all its reviews requires a single query instead of multiple table joins. This denormalized approach significantly improves read performance for product catalog pages where displaying products with reviews is the primary use case.

**3. Horizontal Scalability (Sharding):** As FlexiMart grows, MongoDB enables horizontal scaling by distributing data across multiple servers (sharding). Unlike MySQL which typically scales vertically (bigger servers), MongoDB can partition the product catalog by category or region across multiple machines. This distributed architecture handles millions of products and high traffic volumes by adding more commodity servers rather than investing in expensive enterprise-grade database servers.

---

## Section C: Trade-offs 

MongoDB presents two significant disadvantages for FlexiMart's product catalog:

**1. Complex Transactions and Data Integrity:** MongoDB's flexible schema sacrifices ACID transaction guarantees that MySQL provides by default. For e-commerce operations requiring strict consistency—such as processing payments, updating inventory, and creating orders atomically—MongoDB requires additional application-level logic to ensure data integrity. MySQL's foreign key constraints automatically prevent orphaned records (orders referencing deleted products), while MongoDB requires developers to manually implement these validations, increasing code complexity and potential for bugs.

**2. Data Redundancy and Update Anomalies:** Embedding reviews within product documents creates data duplication. If a customer's name changes, it must be updated in every product where they left a review, whereas in MySQL a single UPDATE on the customers table would suffice. This denormalized design trades storage efficiency and update consistency for read performance, which may not be optimal for all use cases.


