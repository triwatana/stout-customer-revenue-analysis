-- Checks to run before analysis.


-- Row counts: raw vs. cleaned (difference = rows dropped for blank emails)
SELECT
    (SELECT COUNT(*) FROM orders_raw) AS raw_rows,
    (SELECT COUNT(*) FROM orders_clean) AS clean_rows;

-- Nulls per column
SELECT
    COUNT(*) FILTER (WHERE customer_email IS NULL) AS null_email,
    COUNT(*) FILTER (WHERE net_revenue IS NULL) AS null_revenue,
    COUNT(*) FILTER (WHERE year IS NULL) AS null_year
FROM orders_raw;

-- Email formatting (difference = customers that would be double-counted)
SELECT
    COUNT(*) FILTER (WHERE customer_email <> TRIM(customer_email)) AS emails_with_whitespace,
    COUNT(*) FILTER (WHERE customer_email <> LOWER(customer_email)) AS emails_with_uppercase,
    COUNT(DISTINCT customer_email) AS distinct_raw_emails,
    COUNT(DISTINCT LOWER(TRIM(customer_email))) AS distinct_clean_emails
FROM orders_raw;

-- Zero or negative revenue rows (refunds/returns?)
SELECT 
    COUNT(*) FILTER (WHERE net_revenue = 0) AS zero_revenue_rows,
    COUNT(*) FILTER (WHERE net_revenue < 0) AS negative_revenue_rows
FROM orders_clean;

-- Rows, customers, and revenue range by year
SELECT 
    order_year,
    COUNT(*) AS order_rows,
    COUNT(DISTINCT customer_email) AS customers,
    SUM(net_revenue) AS revenue,
    MIN(net_revenue) AS min_revenue,
    MAX(net_revenue) AS max_revenue
FROM orders_clean
GROUP BY order_year
ORDER BY order_year;

-- Customers with multiple rows in the same year
SELECT COUNT(*) AS customer_years_with_multiple_rows
FROM customer_year
WHERE order_rows > 1;

-- Exact duplicate rows (could be two real identical orders – can't tell without order ID)
SELECT COUNT(*) AS duplicate_rows
FROM (
    SELECT customer_email, net_revenue, order_year, COUNT(*) AS n
    FROM orders_clean
    GROUP BY ALL
    HAVING COUNT(*) > 1
);