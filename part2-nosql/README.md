# NoSQL - FlexiMart Project 🚀

Hey! This part of the assignment explores modern database architectures beyond traditional SQL.

## What's Inside?

## NoSQL (MongoDB)

**The Problem:** FlexiMart wants to sell everything from laptops to shoes to books. But how do you store products that all have different attributes in a rigid SQL table?

**The Solution:** MongoDB! Each product gets its own flexible JSON structure.

**Files:**
- `nosql_analysis.md` - Why MongoDB makes sense (and when it doesn't)
- `mongodb_operations.js` - 5 practical queries (finding products, calculating ratings, etc.)
- `products_catalog.json` - Sample product data across Electronics and Fashion

**Cool stuff in here:** 
- Products with custom attributes (laptops have RAM, shoes have size)
- Nested reviews inside products (no messy JOINs!)
- Aggregation pipelines for analytics


## Key Learnings

**MongoDB (NoSQL):**
- ✅ Great for: Flexible schemas, rapid development, scaling horizontally
- ❌ Not great for: Complex transactions, strong consistency requirements


**Best approach?** Use both! MongoDB for the product catalog, MySQL for orders/payments, Star Schema for analytics. That's what real companies do! 🎯

---

## How to Run

### MongoDB:
1. Install MongoDB Compass
2. Import `products_catalog.json`
3. Run queries from `mongodb_operations.js'


