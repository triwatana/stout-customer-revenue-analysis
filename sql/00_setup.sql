-- Loads the raw CSV, standardizes the columns, and creates the customer-year base table for all 10 metric queries.


-- Raw load
CREATE OR REPLACE TABLE orders_raw AS
SELECT *
FROM read_csv_auto('data/raw/customer_orders.csv', header = true);


-- Cleaned order: standardized names and types, blank emails removed
CREATE OR REPLACE TABLE orders_clean AS
SELECT
    LOWER(TRIM(customer_email)) AS customer_email,
    CAST(net_revenue AS DECIMAL(18, 2)) AS net_revenue,
    CAST(year AS INTEGER) AS order_year
FROM orders_raw
WHERE customer_email IS NOT NULL
    AND TRIM(customer_email) <> '';


-- Create the base table: one row per customer per year
CREATE OR REPLACE TABLE customer_year AS
SELECT
    customer_email,
    order_year,
    SUM(net_revenue) AS revenue,
    COUNT(*) AS order_rows
FROM orders_clean
GROUP BY customer_email, order_year;