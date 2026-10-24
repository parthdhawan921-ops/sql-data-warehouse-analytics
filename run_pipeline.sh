#!/usr/bin/env bash
# Builds the full warehouse (Bronze -> Silver -> Gold), runs the quality
# checks, and runs every analytics script in order.
#
# Usage (from the repository root):
#   ./run_pipeline.sh [mysql client options]
#   e.g. ./run_pipeline.sh -u root -p
set -euo pipefail

cd "$(dirname "$0")"

run() {
    echo ">> $1" >&2
    mysql --local-infile=1 "${MYSQL_ARGS[@]}" < "$1"
}

MYSQL_ARGS=("$@")

# 1. Schemas
run scripts/init_database.sql

# 2. Warehouse layers
run scripts/bronze/ddl_bronze.sql
run scripts/bronze/proc_load_bronze.sql
run scripts/silver/ddl_silver.sql
run scripts/silver/proc_load_silver.sql
run scripts/gold/ddl_gold.sql

# 3. Data quality checks
run tests/quality_check_silver.sql > /dev/null
run tests/quality_check_gold.sql > /dev/null

# 4. Analytics
for script in analytics/scripts/*.sql; do
    run "$script" > /dev/null
done

echo "Pipeline completed successfully."
