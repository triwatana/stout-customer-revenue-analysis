/* ============================================================================
   01 | Total Revenue (Current Year)
   ----------------------------------------------------------------------------
   Description : Sum of all net revenue for the current year.
   Source      : customer_year (one row per customer per year)
   Output      : order_year, total_revenue
   Grain       : One row per year (all years, including the first)
   Notes       : Net revenue includes refunds/negatives.
   ============================================================================ */

SELECT
    order_year,
    SUM(revenue) AS total_revenue
FROM customer_year
GROUP BY order_year
ORDER BY order_year;


