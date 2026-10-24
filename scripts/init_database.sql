/*
===============================================================================
Purpose
===============================================================================
This script creates the schemas for the three layers of the data warehouse.

In MySQL, a schema is a database, so each layer is created as its own
database:
    - bronze : raw data loaded from the source CSV files
    - silver : cleaned, standardized, and integrated data
    - gold   : business-ready Star Schema views for reporting and analytics

Run this script once, before any other script in the project.

NOTE:
The schemas are created only if they do not already exist, so running this
script again will not delete any data.
===============================================================================
*/

CREATE DATABASE IF NOT EXISTS bronze;
CREATE DATABASE IF NOT EXISTS silver;
CREATE DATABASE IF NOT EXISTS gold;
