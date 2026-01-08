# Data Warehouse - FlexiMart Project 🚀
---
Hey! This part of the assignment explores modern database architectures beyond traditional SQL.


### 🏢 Data Warehouse (Star Schema)

**The Problem:** The CEO wants to know "What were our Electronics sales in Q1?" but joining 5 normalized tables is slow and confusing.

**The Solution:** Star schema! One central fact table surrounded by dimension tables.

**Files:**
- `star_schema_design.md` - Complete design doc (fact table + 3 dimension tables)
- `warehouse_schema.sql` - Table definitions
- `warehouse_data.sql` - 40 realistic transactions (weekends have higher sales!)
- `analytics_queries.sql` - 3 business intelligence queries


---
**Star Schema (Data Warehouse):**
- ✅ Great for: Analytics, reporting, business intelligence
- ❌ Not great for: Real-time transactions, frequent updates

## How To Run
### Data Warehouse:
1. Open MySQL Workbench
2. Run `warehouse_schema.sql` (creates tables)
3. Run `warehouse_data.sql` (loads data)
4. Run `analytics_queries.sql` (see the magic!)
