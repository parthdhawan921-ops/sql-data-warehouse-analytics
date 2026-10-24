/*
===============================================================================
Purpose
===============================================================================
This script loads cleansed and standardized data from the Bronze layer into
the Silver layer of the data warehouse.

The script performs the following actions:
    - Truncates the existing Silver tables to prevent duplicate records.
    - Cleans and validates source data from the Bronze layer.
    - Removes duplicate records and retains the latest valid records.
    - Standardizes text values, formats, and categorical data.
    - Corrects invalid or missing values where applicable.
    - Derives additional business attributes required for analytics.
    - Loads the transformed data into the Silver layer.

The Silver layer stores validated, standardized, and enriched data that
serves as the foundation for the Gold layer and analytical reporting.

WARNING:
Running this script will remove all existing data from the Silver tables
before reloading the transformed data from the Bronze layer.
===============================================================================
*/

-- ============================================
-- Query 1: CRM Customer Information
-- ============================================
TRUNCATE TABLE silver.crm_cust_info;

INSERT INTO silver.crm_cust_info (
    cst_id, cst_key, cst_firstname, cst_lastname,
    cst_marital_status, cst_gndr, cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname),
    TRIM(cst_lastname),
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        ELSE 'n/a'
    END,
    cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
    FROM bronze.crm_cust_info
) t
WHERE rn = 1
  AND cst_id IS NOT NULL
  AND cst_id <> 0;

-- ============================================
-- Query 2: CRM Product Information
-- ============================================
TRUNCATE TABLE silver.crm_prd_info;

INSERT INTO silver.crm_prd_info (
    prd_id, cat_id, prd_key, prd_nm,
    prd_cost, prd_line, prd_start_dt, prd_end_dt
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_'),
    SUBSTRING(prd_key,7),
    prd_nm,
    IFNULL(prd_cost,0),
    CASE
        WHEN UPPER(TRIM(prd_line))='M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line))='R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line))='S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line))='T' THEN 'Touring'
        ELSE 'n/a'
    END,
    CAST(prd_start_dt AS DATE),
    CAST(
        DATE_SUB(
            LEAD(prd_start_dt) OVER(
                PARTITION BY prd_key
                ORDER BY prd_start_dt
            ),
            INTERVAL 1 DAY
        ) AS DATE
    )
FROM bronze.crm_prd_info;

-- ============================================
-- Query 3: CRM Sales Details
-- ============================================
TRUNCATE TABLE silver.crm_sales_details;

INSERT INTO silver.crm_sales_details (
    sls_ord_num,sls_prd_key,sls_cust_id,
    sls_order_dt,sls_ship_dt,sls_due_dt,
    sls_sales,sls_quantity,sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    CASE
        WHEN sls_order_dt=0 OR LENGTH(CAST(sls_order_dt AS CHAR))<>8
        THEN NULL
        ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR),'%Y%m%d')
    END,

    CASE
        WHEN sls_ship_dt=0 OR LENGTH(CAST(sls_ship_dt AS CHAR))<>8
        THEN NULL
        ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR),'%Y%m%d')
    END,

    CASE
        WHEN sls_due_dt=0 OR LENGTH(CAST(sls_due_dt AS CHAR))<>8
        THEN NULL
        ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR),'%Y%m%d')
    END,

    CASE
        -- Recalculate only when a usable price exists: empty CSV prices load
        -- as 0 in MySQL, and recalculating from them would zero out sales.
        WHEN (sls_sales IS NULL
          OR sls_sales<=0
          OR sls_sales<>sls_quantity*ABS(sls_price))
         AND NULLIF(sls_price,0) IS NOT NULL
        THEN sls_quantity*ABS(sls_price)
        ELSE sls_sales
    END,

    sls_quantity,

    CASE
        WHEN sls_price IS NULL OR sls_price<=0
        THEN sls_sales/NULLIF(sls_quantity,0)
        ELSE sls_price
    END

FROM bronze.crm_sales_details;

-- ============================================
-- Query 4: ERP Customer
-- ============================================
TRUNCATE TABLE silver.erp_cust_az12;

INSERT INTO silver.erp_cust_az12 (cid,bdate,gen)
SELECT
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4)
        ELSE cid
    END,
    CASE
        WHEN bdate>NOW() THEN NULL
        ELSE bdate
    END,
    CASE
        WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
        ELSE 'n/a'
    END
FROM bronze.erp_cust_az12;

-- ============================================
-- Query 5: ERP Location
-- ============================================
TRUNCATE TABLE silver.erp_loc_a101;

INSERT INTO silver.erp_loc_a101 (cid,cntry)
SELECT
    REPLACE(cid,'-',''),
    CASE
        WHEN TRIM(cntry)='DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
        WHEN TRIM(cntry)='' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END
FROM bronze.erp_loc_a101;

-- ============================================
-- Query 6: ERP Product Categories
-- ============================================
TRUNCATE TABLE silver.erp_px_cat_g1v2;

INSERT INTO silver.erp_px_cat_g1v2 (
    id,cat,subcat,maintenance
)
SELECT
    id,
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2;
