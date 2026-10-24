# SQL Data Warehouse & Analytics Project

[![CI](https://github.com/parthdhawan921-ops/sql-data-warehouse-project/actions/workflows/ci.yml/badge.svg)](https://github.com/parthdhawan921-ops/sql-data-warehouse-project/actions/workflows/ci.yml)
![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-336791)
![Architecture](https://img.shields.io/badge/Architecture-Medallion-CD7F32)

An end-to-end analytics project built entirely in **MySQL 8.0+**. Raw CRM and ERP exports are integrated into a **Medallion data warehouse (Bronze → Silver → Gold)** and modelled as a **Star Schema**. The Star Schema then feeds a set of **SQL analyses** that answer business questions and publish reusable customer and product reports.

```text
CSV sources ──► 🥉 Bronze ──► 🥈 Silver ──► 🥇 Gold (Star Schema) ──► 📊 Analytics & Reports ──► BI
  CRM + ERP      raw data      cleaned       dim_customers              13 SQL scripts            Power BI
                                             dim_products               report_customers
                                             fact_sales                 report_products
```

---

## 📑 Table of Contents

- [Highlights](#-highlights)
- [Architecture](#️-architecture)
- [Data Model](#-data-model)
- [Analytics](#-analytics)
- [Key Insights](#-key-insights)
- [Data Quality](#-data-quality)
- [Getting Started](#-getting-started)
- [Repository Structure](#-repository-structure)
- [Documentation](#-documentation)
- [Skills Demonstrated](#-skills-demonstrated)
- [Author](#-author)
- [License](#-license)

---

## ✨ Highlights

- **6 source files from 2 systems** (CRM and ERP), about 116K rows, integrated into one analytical model.
- **3-layer Medallion architecture** with clear responsibilities for each layer.
- **Star Schema** with surrogate keys: 18,484 customers, 295 products, and 60,398 sales lines.
- **13 progressive analytics scripts**, from database exploration to segmentation and reporting views.
- **Automated data quality checks** for keys, NULLs, standardization, dates, and business rules.
- **One-command build** (`./run_pipeline.sh`), verified on every push by GitHub Actions against MySQL 8.0.

---

## 🏗️ Architecture

| Layer | Object type | Load strategy | Transformations | Consumers |
|---|---|---|---|---|
| 🥉 **Bronze** | Tables | Full load (truncate & insert) from CSV | None: data is kept as delivered by the source | Silver layer |
| 🥈 **Silver** | Tables | Full load (truncate & insert) from Bronze | Deduplication, trimming, standardization, invalid-value handling, derived columns | Gold layer |
| 🥇 **Gold** | Views | No load step (always reflects Silver) | Data integration, business logic, surrogate keys, Star Schema | Analytics, BI, ad-hoc SQL |

**Source systems**

| System | Files | Content |
|---|---|---|
| CRM | `cust_info.csv`, `prd_info.csv`, `sales_details.csv` | Customers, product history, sales transactions |
| ERP | `CUST_AZ12.csv`, `LOC_A101.csv`, `PX_CAT_G1V2.csv` | Customer birthdate & gender, customer country, product categories |

---

## 🌟 Data Model

The Gold layer exposes a sales **Star Schema**:

```text
                            ┌──────────────────────┐
                            │ gold.dim_customers   │
                            │ customer_key (PK)    │
                            └──────────┬───────────┘
                                       │ 1
                                       │
                                       │ *
┌──────────────────────┐ 1          * ┌┴────────────────────┐
│ gold.dim_products    │──────────────│ gold.fact_sales     │
│ product_key (PK)     │              │ order_number        │
└──────────────────────┘              │ product_key (FK)    │
                                      │ customer_key (FK)   │
                                      │ order/ship/due date │
                                      │ sales_amount        │
                                      │ quantity, price     │
                                      └─────────────────────┘
```

| Object | Type | Grain / Purpose |
|---|---|---|
| `gold.dim_customers` | Dimension | One row per customer: name, country, gender, marital status, birthdate |
| `gold.dim_products` | Dimension | One row per current product: category, subcategory, cost, product line |
| `gold.fact_sales` | Fact | One row per order line: dates, quantity, price, sales amount |

Full column definitions are in the [data catalog](docs/data_catalog.md).

---

## 📊 Analytics

The [`analytics/`](analytics/) module runs on the Gold layer. Scripts are numbered and build on each other:

| # | Script | Question it answers | Key techniques |
|---|---|---|---|
| 01 | [Database exploration](analytics/scripts/01_database_exploration.sql) | What tables and columns exist? | `INFORMATION_SCHEMA` |
| 02 | [Dimensions exploration](analytics/scripts/02_dimensions_exploration.sql) | Which countries, categories, and products are there? | `DISTINCT` |
| 03 | [Date range exploration](analytics/scripts/03_date_range_exploration.sql) | What time span does the data cover? | `MIN`/`MAX`, `TIMESTAMPDIFF` |
| 04 | [Measures exploration](analytics/scripts/04_measures_exploration.sql) | What are the headline KPIs? | Aggregates, `UNION ALL` |
| 05 | [Magnitude analysis](analytics/scripts/05_magnitude_analysis.sql) | How do metrics break down by dimension? | `GROUP BY`, joins |
| 06 | [Ranking analysis](analytics/scripts/06_ranking_analysis.sql) | Who are the top and bottom performers? | `RANK()`, `LIMIT` |
| 07 | [Change over time](analytics/scripts/07_change_over_time_analysis.sql) | How do sales trend by year and month? | `YEAR`, `DATE_FORMAT` |
| 08 | [Cumulative analysis](analytics/scripts/08_cumulative_analysis.sql) | What are the running totals and moving averages? | `SUM() OVER`, `AVG() OVER` |
| 09 | [Performance analysis](analytics/scripts/09_performance_analysis.sql) | How does each product compare year over year and to its average? | `LAG()`, CTEs |
| 10 | [Data segmentation](analytics/scripts/10_data_segmentation.sql) | How do customers and products group into segments? | `CASE`, CTEs |
| 11 | [Part-to-whole](analytics/scripts/11_part_to_whole_analysis.sql) | Which categories drive revenue? | Window shares |
| 12 | [Customer report](analytics/scripts/12_report_customers.sql) | Creates `gold.report_customers`: segments, recency, AOV, monthly spend | View, CTEs |
| 13 | [Product report](analytics/scripts/13_report_products.sql) | Creates `gold.report_products`: performance tiers, recency, monthly revenue | View, CTEs |

See the [analytics README](analytics/README.md) for details.

---

## 💡 Key Insights

Results from running the analytics on the included dataset:

| Metric | Value |
|---|---|
| Total sales | **$29.36M** |
| Orders | **27,659** |
| Units sold | **60,423** |
| Customers | **18,484** |
| Products with sales | **130** of 295 in catalogue |
| Order history | Dec 2010 – Jan 2014 |

- **Bikes generate 96.5% of revenue.** Accessories (2.4%) and Clothing (1.2%) are minor revenue lines.
- **80% of customers are "New"** (less than 12 months of history). Only about 1,600 are **VIP** (12+ months and over $5,000 spent), so retention is the biggest growth opportunity.
- **The product catalogue is skewed toward low-cost items**: 110 products cost under $100, while 39 cost over $1,000.

---

## ✅ Data Quality

Quality checks live in [`tests/`](tests/) and follow an **"Expectation: No Results"** convention: each query returns only rows that violate a rule.

| Check | Layer |
|---|---|
| Primary key uniqueness and NULLs | Silver |
| Unwanted leading/trailing spaces | Silver |
| Standardized categorical values (gender, marital status, country, product line, maintenance) | Silver |
| Invalid dates and order → ship → due date ordering | Silver |
| Business rule: `sales = quantity × price`, with no NULL or negative values | Silver |
| Surrogate key uniqueness | Gold |
| Fact-to-dimension referential integrity | Gold |

The Gold checks return no rows and are enforced in CI. The Silver birthdate check intentionally reports a few very old customers (born before 1924): these are kept as valid but unusual source values.

---

## 🚀 Getting Started

### Prerequisites

- **MySQL 8.0+** with `LOCAL INFILE` enabled (used to load the CSVs)
- A SQL client: the `mysql` command line or **MySQL Workbench**

```sql
-- Run once as an admin user
SET GLOBAL local_infile = 1;
```

### Option A: one command (MySQL CLI)

From the repository root:

```bash
./run_pipeline.sh -u root -p
```

This creates the schemas, builds Bronze → Silver → Gold, runs the quality checks, and runs every analytics script.

### Option B: step by step (MySQL Workbench or CLI)

Run the scripts in this order:

| Step | Script(s) |
|---|---|
| 1. Create schemas | `scripts/init_database.sql` |
| 2. Bronze | `scripts/bronze/ddl_bronze.sql` → `scripts/bronze/proc_load_bronze.sql` |
| 3. Silver | `scripts/silver/ddl_silver.sql` → `scripts/silver/proc_load_silver.sql` |
| 4. Gold | `scripts/gold/ddl_gold.sql` |
| 5. Validate | `tests/quality_check_silver.sql`, `tests/quality_check_gold.sql` |
| 6. Analyze | `analytics/scripts/01_…` through `13_…`, in order |

> **Note:** `proc_load_bronze.sql` uses paths relative to the repository root (e.g. `datasets/source_crm/cust_info.csv`). If your client starts in a different folder, as MySQL Workbench often does, replace them with absolute paths. In Workbench, also add `OPT_LOCAL_INFILE=1` under *Connection → Advanced → Others*.

---

## 📂 Repository Structure

```text
.
├── .github/workflows/ci.yml        # Builds and validates the full pipeline on MySQL 8.0
├── analytics/
│   ├── scripts/                    # 01–13 numbered EDA and reporting scripts
│   └── README.md
├── datasets/
│   ├── source_crm/                 # cust_info, prd_info, sales_details
│   └── source_erp/                 # CUST_AZ12, LOC_A101, PX_CAT_G1V2
├── docs/                           # Architecture, data flow, data model, catalog
├── scripts/
│   ├── init_database.sql           # Creates bronze, silver, gold schemas
│   ├── bronze/                     # DDL + CSV load
│   ├── silver/                     # DDL + cleansing & standardization load
│   └── gold/                       # Star Schema views
├── tests/                          # Silver and Gold quality checks
├── run_pipeline.sh                 # One-command build
├── LICENSE
└── README.md
```

---

## 📚 Documentation

| Document | Contents |
|---|---|
| [Architecture](docs/architecture.md) | High-level design of the warehouse |
| [Warehouse architecture](docs/data_warehouse_architecture.md) | Layer design, object types, and load strategy |
| [Data layers](docs/data_layers.md) | Responsibilities of Bronze, Silver, and Gold |
| [Data flow](docs/data_flow.md) | Source-to-Gold lineage |
| [Data model](docs/data_model.md) | How CRM and ERP tables relate and integrate |
| [Sales Star Schema](docs/sales_star_schema.md) | Gold model, keys, and relationships |
| [Data catalog](docs/data_catalog.md) | Column-level definitions for Gold objects |

---

## 🧠 Skills Demonstrated

| Area | Skills |
|---|---|
| **Data engineering** | ETL design, Medallion architecture, bulk CSV ingestion, full-load strategy, CRM/ERP integration |
| **Data modelling** | Dimensional modelling, Star Schema, surrogate keys, fact/dimension design |
| **Data quality** | Cleansing, standardization, deduplication, validation tests, CI enforcement |
| **Analytics** | EDA, KPI design, ranking, trend, cumulative, YoY, and part-to-whole analysis, segmentation |
| **Advanced SQL** | CTEs, window functions (`RANK`, `LAG`, `SUM/AVG OVER`), `CASE`, views, `INFORMATION_SCHEMA` |

---

## 👨‍💻 Author

**Parth Dhawan**: Data Analytics · SQL · MySQL · Power BI · Excel

---

## 📄 License

The data warehouse is released under the [MIT License](LICENSE). The `analytics/` module keeps its original [GPL-3.0 License](analytics/LICENSE).
