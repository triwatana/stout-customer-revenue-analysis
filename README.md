# stout-customer-revenue-analysis

=== Data quality checks ===
┌──────────┬────────────┐
│ raw_rows │ clean_rows │
│  int64   │   int64    │
├──────────┼────────────┤
│   685927 │     685927 │
└──────────┴────────────┘

┌────────────┬──────────────┬───────────┐
│ null_email │ null_revenue │ null_year │
│   int64    │    int64     │   int64   │
├────────────┼──────────────┼───────────┤
│          0 │            0 │         0 │
└────────────┴──────────────┴───────────┘

┌────────────────────────┬───────────────────────┬─────────────────────┬───────────────────────┐
│ emails_with_whitespace │ emails_with_uppercase │ distinct_raw_emails │ distinct_clean_emails │
│         int64          │         int64         │        int64        │         int64         │
├────────────────────────┼───────────────────────┼─────────────────────┼───────────────────────┤
│                 270214 │                     0 │              604618 │                541634 │
└────────────────────────┴───────────────────────┴─────────────────────┴───────────────────────┘

┌───────────────────┬───────────────────────┐
│ zero_revenue_rows │ negative_revenue_rows │
│       int64       │         int64         │
├───────────────────┼───────────────────────┤
│                 0 │                     0 │
└───────────────────┴───────────────────────┘

┌────────────┬────────────┬───────────┬───────────────┬───────────────┬───────────────┐
│ order_year │ order_rows │ customers │    revenue    │  min_revenue  │  max_revenue  │
│   int32    │   int64    │   int64   │ decimal(38,2) │ decimal(18,2) │ decimal(18,2) │
├────────────┼────────────┼───────────┼───────────────┼───────────────┼───────────────┤
│       2015 │     231294 │    231294 │   29036749.19 │          1.00 │        250.00 │
│       2016 │     204646 │    204646 │   25730943.59 │          1.00 │        250.00 │
│       2017 │     249987 │    249987 │   31417495.03 │          1.00 │        250.00 │
└────────────┴────────────┴───────────┴───────────────┴───────────────┴───────────────┘

┌───────────────────────────────────┐
│ customer_years_with_multiple_rows │
│               int64               │
├───────────────────────────────────┤
│                                 0 │
└───────────────────────────────────┘

┌────────────────┐
│ duplicate_rows │
│     int64      │
├────────────────┤
│              0 │
└────────────────┘


=== 01_total_revenue ===
 order_year  total_revenue
       2015    29036749.19
       2016    25730943.59
       2017    31417495.03

=== 02_new_customer_revenue ===
 order_year  new_customer_revenue
       2016           17206366.90
       2017           21769213.01

=== 03_existing_customer_growth ===
 order_year  existing_customer_growth
       2016                  39043.65
       2017                  63857.06

=== 04_revenue_lost_attrition ===
 order_year  revenue_lost_attrition
       2016             20551216.15
       2017             16146518.63

=== 05_existing_customer_revenue_current ===
 order_year  existing_customer_revenue_current
       2016                         8524576.69
       2017                         9648282.02

=== 06_existing_customer_revenue_prior ===
 order_year  existing_customer_revenue_prior
       2016                       8485533.04
       2017                       9584424.96

=== 07_total_customers_current ===
 order_year  total_customers_current
       2015                   231294
       2016                   204646
       2017                   249987

=== 08_total_customers_previous ===
 order_year  total_customers_previous
       2016                    231294
       2017                    204646

=== 09_new_customers ===
 order_year  new_customers
       2016         136891
       2017         173449

=== 10_lost_customers ===
 order_year  lost_customers
       2016          163539
       2017          128108