# Customer Revenue Analysis

Year-over-year analysis of 3 years of customer orders (2015–2017): revenue composition, new vs. existing customer behavior, attrition, and retention.

## Links

- **Tableau Dashboard:** [dashboard](https://public.tableau.com/app/profile/tri.watanasuparp5651/viz/StoutCaseStudy_17956479612840/Dashboard)
- **Repo:** [this repository](https://github.com/triwatana/stout-customer-revenue-analysis)

## Repo Structure

```
sql/      10 metric queries (01–10) + setup, data quality, and summary
python/   run_analysis.py — loads data, runs checks and queries, exports CSVs
data/     raw/ (input CSV), output/ (query results for Tableau)
```

## How to Run

```bash
python -m venv .venv
source .venv/bin/activate
pip install duckdb pandas
python python/run_analysis.py
```

Outputs land in `data/output/`, one CSV per query plus `11_yearly_summary.csv`, the Tableau data source.

## Assumptions

- "Prior year" = the calendar year immediately before (e.g., 2017 compares to 2016).
- The first year (2015) has no prior year; comparison metrics are excluded or shown as N/A.
- A customer who skips a year and returns later counts as "new" on return, per the case study's definition.
- Emails are trimmed and lowercased before matching, so formatting differences don't split one customer into two.

## Data Quality Notes

- 685,927 rows, no nulls, no zero/negative revenue, no duplicate rows, no multiple rows per customer-year.
- **39% of raw emails had leading/trailing whitespace.** Left uncleaned, this would double-count ~63,000 customers and overstate new/lost customer counts by 6–8%. Fixed by trimming and lowercasing all emails before analysis.

## Validation

`11_yearly_summary.sql` reconciles every metric against two identities, both of which check out to 0 for 2016 and 2017:

- Revenue: Total Current = Total Prior + New + Existing Growth − Attrition Lost
- Customers: Customers Current = Customers Prior + New − Lost

## Key Insights

1. **Attrition drove the 2016 dip; 2017 reversed it.** Revenue fell to $25.7M in 2016 as attrition ($20.6M) outpaced new revenue ($17.2M). In 2017, new revenue ($21.8M) overtook attrition ($16.1M), pushing revenue to a 3-year high of $31.4M.
2. **Growth comes from new customers, not existing ones spending more.** Existing customer growth added just $39K–$64K a year — negligible next to $17–22M swings from new and lost customers.
3. **Retention rose but stays low.** 29.3% (2016) → 37.4% (2017). Still, roughly 6 in 10 customers don't return the following year.
4. **Spend per customer is flat**, at $125.5–$125.7 across all 3 years. Revenue changes come entirely from customer count, not deeper spending.
5. **Data cleaning mattered:** see Data Quality Notes above.
