/*
===============================================================================
Purpose
===============================================================================
This script loads raw data from the source CRM and ERP CSV files into the
Bronze layer of the data warehouse.

The script performs the following actions:
    - Truncates the existing Bronze tables to prevent duplicate records.
    - Loads fresh data from the source CSV files using LOAD DATA LOCAL INFILE.
    - Preserves the source data in the Bronze layer for further processing
      and transformation in the Silver layer.

WARNING:
Running this script will remove all existing data from the Bronze tables
before reloading the source data.
===============================================================================
*/

-- =============================================
-- LOAD CRM CUSTOMER
-- =============================================

TRUNCATE TABLE bronze.crm_cust_info;

LOAD DATA LOCAL INFILE
'datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =============================================
-- LOAD CRM PRODUCT
-- =============================================

TRUNCATE TABLE bronze.crm_prd_info;

LOAD DATA LOCAL INFILE
'datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =============================================
-- LOAD CRM SALES
-- =============================================

TRUNCATE TABLE bronze.crm_sales_details;

LOAD DATA LOCAL INFILE
'datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =============================================
-- LOAD ERP CUSTOMER
-- =============================================

TRUNCATE TABLE bronze.erp_cust_az12;

LOAD DATA LOCAL INFILE
'datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =============================================
-- LOAD ERP LOCATION
-- =============================================

TRUNCATE TABLE bronze.erp_loc_a101;

LOAD DATA LOCAL INFILE
'datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- =============================================
-- LOAD ERP PRODUCT CATEGORY
-- =============================================

TRUNCATE TABLE bronze.erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE
'datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
