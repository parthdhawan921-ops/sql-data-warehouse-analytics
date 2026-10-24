# Analytics: SQL Exploratory Data Analysis

> Part of the [SQL Data Warehouse & Analytics Project](../README.md). These **MySQL 8.0+** scripts run on the Gold layer (`gold.dim_customers`, `gold.dim_products`, `gold.fact_sales`) built by the warehouse in [`../scripts/`](../scripts/). They turn customer, product, and sales data into business insights using advanced SQL.

## 📌 Overview

This module is organized as a progression from basic database exploration to reusable customer and product reporting. The analysis covers:

- Database and dimension exploration
- Date-range and magnitude analysis
- KPI and business-measure analysis
- Product and customer ranking
- Change-over-time and cumulative analysis
- Performance analysis
- Customer and product segmentation
- Part-to-whole analysis
- Reusable customer and product reports

## 🎯 Objectives

- Explore the structure and quality of the analytical dataset.
- Understand sales, customer, and product behavior.
- Calculate business KPIs and supporting measures.
- Identify top and bottom-performing products and customers.
- Analyze trends over time and year-over-year performance.
- Segment customers and products using business rules.
- Create reusable reporting views for downstream analysis.

## 🛠️ Tech Stack

- **MySQL 8.0+**
- SQL
- Common Table Expressions (CTEs)
- Window Functions
- Views

## 📊 Key Analysis Areas

| Area | Focus |
|---|---|
| Database Exploration | Tables, schema structure, and available data |
| Dimensions | Customer and product attributes |
| Date Analysis | Available date ranges and time coverage |
| Measures | Sales, orders, customers, products, and average price |
| Magnitude | Business metrics by relevant dimensions |
| Ranking | Top/bottom customers and products |
| Trends | Changes over time and YoY performance |
| Cumulative Analysis | Running totals and cumulative contribution |
| Segmentation | Customer and product business segments |
| Part-to-Whole | Contribution of categories/products to overall results |
| Reporting | Customer and product reporting datasets |

## 🗂️ Project Structure

```text
analytics/
│
├── scripts/
│   ├── 01_database_exploration.sql
│   ├── 02_dimensions_exploration.sql
│   ├── 03_date_range_exploration.sql
│   ├── 04_measures_exploration.sql
│   ├── 05_magnitude_analysis.sql
│   ├── 06_ranking_analysis.sql
│   ├── 07_change_over_time_analysis.sql
│   ├── 08_cumulative_analysis.sql
│   ├── 09_performance_analysis.sql
│   ├── 10_data_segmentation.sql
│   ├── 11_part_to_whole_analysis.sql
│   ├── 12_report_customers.sql
│   └── 13_report_products.sql
│
├── LICENSE
└── README.md
```

## ▶️ How to Use

1. Install **MySQL 8.0+** and connect using MySQL Workbench or another SQL client.
2. Build the warehouse first (Bronze → Silver → Gold) by following the [Getting Started](../README.md#-getting-started) steps in the root README.
3. Run the scripts in numerical order.
4. Review the result sets and adapt filters/groupings for additional analysis.
5. Use the reporting scripts as reusable starting points for customer and product analysis.

## 🧠 SQL Concepts Demonstrated

`JOIN` · `GROUP BY` · `CASE` · `CTE` · `WINDOW FUNCTIONS` · `RANK` · `LAG` · `SUM() OVER()` · `AVG() OVER()` · `TIMESTAMPDIFF()` · `CREATE VIEW`

## 📈 Business Questions Answered

Examples of questions addressed by this module include:

- What are the overall sales and order KPIs?
- Which products and customers contribute the most revenue?
- How does performance change over time?
- Which products or customers are growing or declining?
- What is the cumulative contribution of products/categories?
- How can customers and products be segmented using business rules?
- What reusable datasets can support customer and product reporting?

## 👨‍💻 Author

**Parth Dhawan**  
Data Analytics | SQL | MySQL | Power BI | Excel
