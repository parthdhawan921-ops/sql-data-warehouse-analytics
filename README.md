# SQL Data Warehouse & Analytics Project — MySQL

> An end-to-end, portfolio-grade SQL project built with **MySQL 8.0+**: a **Bronze → Silver → Gold (Medallion)** data warehouse transforms raw CRM and ERP data into a reporting-ready **Star Schema**, and an **exploratory data analysis (EDA) layer** turns that Star Schema into business insights and reusable reports.

## 📌 Project Overview

This project covers the full journey from raw files to insights in two parts:

**CSV source data → Bronze (raw) → Silver (cleaned) → Gold (business-ready) → SQL analytics / BI**

1. **Data Warehouse** (`scripts/`, `tests/`, `docs/`) — builds the Gold layer, which exposes analytical views for **customers, products, and sales**.
2. **Data Analytics** (`analytics/`) — 13 progressive SQL analyses that run directly on the Gold layer, from database exploration to segmentation and reusable customer/product report views.

## 🎯 Objectives

- Design a layered SQL data warehouse using the Medallion Architecture.
- Load and preserve raw source data in the Bronze layer.
- Clean, standardize, validate, and integrate data in the Silver layer.
- Build business-ready dimensional and fact views in the Gold layer.
- Apply a Star Schema suitable for analytical reporting.
- Add SQL-based data quality checks across the warehouse.
- Explore and analyze the Gold layer to answer business questions with advanced SQL.
- Publish reusable customer and product reporting views.

## 🏗️ Architecture

```text
CRM / ERP CSVs
      │
      ▼
🥉 Bronze — Raw source data
      │
      ▼
🥈 Silver — Cleaned & standardized data
      │
      ▼
🥇 Gold — Business-ready analytical views
      │
      ├──────────────► BI / Dashboards
      └──────────────► 📊 SQL Analytics (analytics/)
                         │
                         ▼
                  gold.report_customers
                  gold.report_products
```

### Bronze
Raw data loaded with minimal transformation, preserving source values for traceability and reprocessing.

### Silver
Cleans and standardizes source data, handles duplicates and invalid values, and integrates CRM/ERP datasets into consistent analytical structures.

### Gold
Provides business-ready views organized as a Star Schema:

- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`

The Gold dimension views use generated surrogate keys, while the sales fact view connects transactional records to customer and product dimensions.

## 📊 Analytical Model

| Object | Type | Purpose |
|---|---|---|
| `dim_customers` | Dimension | Customer attributes such as name, country, gender, marital status, and birthdate |
| `dim_products` | Dimension | Product, category, subcategory, cost, product line, and start-date attributes |
| `fact_sales` | Fact | Orders, dates, customers, products, sales amount, quantity, and price |

## 📊 Data Analytics (EDA)

The [`analytics/`](analytics/) folder contains the exploratory data analysis built on top of the Gold layer. Scripts are numbered and meant to be run in order:

| # | Script | Focus |
|---|---|---|
| 01 | `01_database_exploration.sql` | Tables, schema structure, and available data |
| 02 | `02_dimensions_exploration.sql` | Customer and product attributes |
| 03 | `03_date_range_exploration.sql` | Available date ranges and time coverage |
| 04 | `04_measures_exploration.sql` | Sales, orders, customers, products, and average price KPIs |
| 05 | `05_magnitude_analysis.sql` | Business metrics by relevant dimensions |
| 06 | `06_ranking_analysis.sql` | Top/bottom customers and products |
| 07 | `07_change_over_time_analysis.sql` | Trends over time |
| 08 | `08_cumulative_analysis.sql` | Running totals and moving averages |
| 09 | `09_performance_analysis.sql` | YoY and vs-average performance |
| 10 | `10_data_segmentation.sql` | Customer and product segments |
| 11 | `11_part_to_whole_analysis.sql` | Category contribution to overall sales |
| 12 | `12_report_customers.sql` | Creates the `gold.report_customers` view |
| 13 | `13_report_products.sql` | Creates the `gold.report_products` view |

See [`analytics/README.md`](analytics/README.md) for the business questions answered and SQL concepts used.

## 📚 Documentation

Detailed project documentation is available in the [`docs/`](docs/) directory:

- [`data_layers.md`](docs/data_layers.md) — Bronze, Silver, and Gold responsibilities and workflow
- [`data_warehouse_architecture.md`](docs/data_warehouse_architecture.md) — warehouse architecture and layer design
- [`data_flow.md`](docs/data_flow.md) — source-to-Gold data lineage
- [`data_model.md`](docs/data_model.md) — CRM/ERP integration and table relationships
- [`data_catalog.md`](docs/data_catalog.md) — analytical objects and business definitions
- [`sales_star_schema.md`](docs/sales_star_schema.md) — Gold sales Star Schema and relationships

> The original visual architecture and data-model diagrams can also be kept in this `docs/` area as PDF references.

## ✅ Data Quality

Validation scripts cover:

- Duplicate key detection
- NULL checks
- Data consistency
- Invalid date checks
- Standardization checks
- Referential integrity between fact and dimension data

## 🛠️ Tech Stack

- **MySQL 8.0+**
- **SQL**
- **MySQL Workbench**
- **CTEs, window functions, and views** for analytics
- **CSV**
- **Power BI** for downstream reporting

## 📂 Repository Structure

```text
sql-data-warehouse-project/
│
├── analytics/                # SQL exploratory data analysis on the Gold layer
│   ├── scripts/              # 01–13 numbered analysis & reporting scripts
│   ├── LICENSE
│   └── README.md
│
├── datasets/
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   └── source_erp/
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── tests/
├── docs/
├── LICENSE
└── README.md
```

## ▶️ How to Run

### 1. Prerequisites

Install **MySQL 8.0+** and a SQL client such as **MySQL Workbench**.

### 2. Run Bronze

Execute the Bronze DDL and loading procedure:

```text
scripts/bronze/ddl_bronze.sql
scripts/bronze/proc_load_bronze.sql
```

### 3. Run Silver

Execute the Silver DDL and loading procedure:

```text
scripts/silver/ddl_silver.sql
scripts/silver/proc_load_silver.sql
```

### 4. Run Gold

Execute:

```text
scripts/gold/ddl_gold.sql
```

### 5. Validate

Run the checks in:

```text
tests/quality_check_silver.sql
tests/quality_check_gold.sql
```

### 6. Run the Analytics

With the Gold layer in place, run the EDA scripts in numerical order:

```text
analytics/scripts/01_database_exploration.sql
...
analytics/scripts/13_report_products.sql
```

Scripts 12 and 13 create the `gold.report_customers` and `gold.report_products` views.

## 🔍 Skills Demonstrated

- SQL data transformation
- ETL pipeline design
- Data cleansing and standardization
- Dimensional modeling
- Star Schema design
- Surrogate key generation
- Data quality validation
- CRM + ERP data integration
- BI-ready data preparation
- Exploratory data analysis with CTEs and window functions
- Ranking, trend, cumulative, and performance analysis
- Customer and product segmentation

## 📈 Reporting Use Cases

The Gold model supports analysis of:

- Customer demographics and distribution
- Product and category performance
- Sales volume and revenue
- Order trends over time
- Customer-to-product purchasing relationships

## 📄 License

This project is intended for educational and portfolio purposes. The data warehouse is distributed under the root [`LICENSE`](LICENSE) (MIT); the `analytics/` folder keeps its original [`LICENSE`](analytics/LICENSE) (GPL-3.0).
