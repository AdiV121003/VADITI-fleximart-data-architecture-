# FlexiMart Data Architecture Project

**Student Name:** V ADITI
**Student ID:** bitsom_ba_25071754
**Email:** aditi.vande@gmail.com
**Date:** 07-01-2026

## Project Overview

I have created a full data engineering project for fleximart. I built:

✅ ETL pipeline (Python + MySQL)
✅ NoSQL analysis (MongoDB)
✅ Star schema data warehouse
✅ Business intelligence queries

## Repository Structure
├── part1-database-etl/
│   ├── etl_pipeline.py
│   ├── schema_documentation.md
│   ├── business_queries.sql
│   └── data_quality_report.txt
├── part2-nosql/
│   ├── nosql_analysis.md
│   ├── mongodb_operations.js
│   └── products_catalog.json
├── part3-datawarehouse/
│   ├── star_schema_design.md
│   ├── warehouse_schema.sql
│   ├── warehouse_data.sql
│   └── analytics_queries.sql
└── README.md

## Technologies Used

- Python 3.x, pandas, mysql-connector-python
- MySQL 8.0 / PostgreSQL 14
- MongoDB 6.0

## Setup Instructions

### Database Setup

```bash
# Create databases
mysql -u root -p -e "CREATE DATABASE fleximart;"
mysql -u root -p -e "CREATE DATABASE fleximart_dw;"

# Run Part 1 - ETL Pipeline
python part1-database-etl/etl_pipeline.py

# Run Part 1 - Business Queries
mysql -u root -p fleximart < part1-database-etl/business_queries.sql

# Run Part 3 - Data Warehouse
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_schema.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/warehouse_data.sql
mysql -u root -p fleximart_dw < part3-datawarehouse/analytics_queries.sql


### MongoDB Setup

mongosh < part2-nosql/mongodb_operations.js

## Key Learnings
I learnt how to automate the process of extracting data from CSV files, transforming it and loading it into SQL database. 
I learnt how to work with MySQL workbench
I learnt how to work with non-structured data like JSON files and how to connect and work with mongodb compass
I learnt how to create star schema etc. 

## Challenges Faced

1. CSV data issues vs database schema. Manually transformed some files

