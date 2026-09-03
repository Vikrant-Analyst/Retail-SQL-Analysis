# Retail SQL Analysis

A business-focused SQL analysis project built around a relational retail store database. The project contains **42 SQL queries across six levels**, progressing from basic filtering to multi-table joins, subqueries, and set operations.

## Project Overview

This project demonstrates how SQL can be used to answer practical business questions from a retail database.

The database includes six related tables:

- Customers
- Products
- Orders
- Order Items
- Payments
- Product Reviews

The analysis covers customer activity, product pricing, sales, order behavior, payments, inventory, and customer engagement.

## Database Structure

The project works with a relational schema connecting customers, orders, products, order items, payments, and product reviews.

### Main Relationships

- Customers → Orders
- Orders → Order Items
- Products → Order Items
- Orders → Payments
- Products → Product Reviews
- Customers → Product Reviews

## SQL Topics Covered

### Level 1 — Basics

- SELECT
- DISTINCT
- WHERE
- IN
- BETWEEN
- LIKE
- ORDER BY
- Sorting and filtering

### Level 2 — Filtering & Formatting

- NULL handling
- Column aliases
- Calculated fields
- CONCAT()
- DATE()
- Conditional filtering

### Level 3 — Aggregations

- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()
- GROUP BY
- Aggregated customer and product analysis

### Level 4 — Joins

- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- Multi-table joins
- Customer, order, product, and payment analysis

### Level 5 — Subqueries

- Scalar subqueries
- Subqueries with IN
- Correlated subqueries
- Above-average analysis
- Customer-level comparisons
- Highest-value order analysis

### Level 6 — Set Operations

- UNION
- Combining customer activity across different sources
- Intersection-style analysis using subquery logic

## Business Questions Explored

The project answers questions such as:

- Which customers can be targeted for email marketing?
- Which products are priced above specific thresholds?
- How many orders has each customer placed?
- How much has each customer spent?
- Which product categories sell the most units?
- What is the average order value?
- What payment methods are being used?
- Which customers have placed orders and written reviews?
- Which products are priced above the overall average?
- Which orders are above a customer's own average order value?
- What is the highest-value order for each customer?

## Key SQL Techniques Demonstrated

The project particularly helped develop practical understanding of:

- Choosing between WHERE and HAVING
- Understanding INNER JOIN vs LEFT JOIN
- Combining information across multiple related tables
- Using aggregate functions for business reporting
- Writing correlated subqueries
- Handling missing relationships
- Using SQL to translate business questions into data queries

## Data & Reproducibility Note

This project was completed as part of my **Career247 Data Analytics course**.

The original course dataset and data-loading statements are **not included in this repository**.

The repository focuses on the SQL analysis and query logic developed during the project.

## Project Structure

Retail-SQL-Analysis/

├── retail_store_analysis.sql  
└── README.md

## Learning Context

This project is part of my data analytics learning journey and demonstrates my practical use of SQL for relational data analysis and business-oriented problem solving.

## Future Improvements

- Add more advanced window-function analysis
- Build a retail KPI reporting layer
- Connect the SQL outputs to Power BI
- Add time-based sales analysis
- Develop customer and product performance dashboards
