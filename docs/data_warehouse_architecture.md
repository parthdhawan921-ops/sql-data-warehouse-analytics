# Data Warehouse Architecture

## Overview

The warehouse follows a **Bronze → Silver → Gold** architecture.

```text
CRM / ERP CSV Files
        │
        ▼
   Bronze Layer
   Raw Data / Tables
        │
        ▼
   Silver Layer
   Cleaned & Standardized Tables
        │
        ▼
    Gold Layer
    Business-Ready Views
        │
        ▼
BI & Reporting / Ad-Hoc SQL / Analytics
```

## Layers

### Bronze
- Object type: Tables
- Load: Batch processing with full load (truncate & insert)
- Transformation: None; data is retained as-is
- Purpose: Raw data ingestion and traceability

### Silver
- Object type: Tables
- Load: Batch processing with full load (truncate & insert)
- Transformations: Data cleansing, standardization, normalization, derived columns, and data enrichment
- Purpose: Prepare clean and standardized data for analysis

### Gold
- Object type: Views
- Load: No separate load step
- Transformations: Data integration, aggregation, and business logic
- Data models: Star Schema, flat tables, and aggregated objects
- Purpose: Provide business-ready data for reporting and analytics

## Consumers

The Gold layer is designed to support:

- BI & Reporting
- Ad-hoc SQL queries
- Analytics and downstream analytical use cases
