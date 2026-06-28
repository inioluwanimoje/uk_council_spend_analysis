# Leeds City Council Spend Analysis

A SQL analytics project using real, publicly available spend data from **Leeds City Council**, demonstrating audit-style data quality checks, vendor concentration analysis, trend monitoring, and anomaly detection — the kind of analysis a finance or risk team would use to scope a review.

This project was built as part of a career transition from **auditing to data analytics**, applying audit techniques (completeness testing, control gap detection, risk-based sampling) directly in SQL.

---

## Objective

Profile Leeds City Council's published spend data (transactions over £500), identify supplier concentration risk, track monthly spending trends, flag anomalous transactions, and produce a department-level risk summary suitable for a finance committee.

---

## Dataset

- **Source:** Leeds City Council spend transparency data (publicly published)
- **Period covered:** January 2026 – March 2026 (with a small number of stray entries from September–December 2025 — see Data Quality Notes)
- **Volume:** 384,035 transactions
- **Total spend:** £2,070,307,773.76
- **Unique suppliers:** 9,374
- **Unique departments:** 113

---

## Key Findings

**1. No missing data on core fields**
A completeness check across supplier, department, amount, and payment date returned **zero NULLs** on all four fields — the dataset is well-maintained at the field level. (Data quality issues that did surface were about *format and scale*, not missing values — see notes below.)

**2. Spend is highly fragmented across suppliers**
Despite 9,374 unique suppliers, no single supplier dominates total spend:
| Supplier | Total Spend | % of Total Spend |
|---|---|---|
| Housing Benefit | £127,297,609.26 | 6.15% |
| Bradford Metropolitan Council | £109,490,450.65 | 4.93% |
| West Yorkshire Combined Authority | £96,122,532.25 | 4.64% |
| The Secretary of State | £90,174,815.00 | 4.36% |
| Foster Care – BACS | £62,702,458.20 | 3.03% |

The top 5 suppliers together account for under 25% of total spend — low concentration risk at the top end, though this is partly because statutory payments (Housing Benefit, central government transfers) sit alongside genuine third-party vendors in the same field.

**3. Spend scales sharply through the financial year**
Monthly totals show a clear ramp into the new financial year:
| Month | Transactions | Total Spend |
|---|---|---|
| 2025-11 | 8,951 | £2,868,704.18 |
| 2025-12 | 50,896 | £11,858,889.80 |
| 2026-01 | 118,382 | £603,487,134.43 |
| 2026-02 | 116,350 | £706,835,386.40 |
| 2026-03 | 89,450 | £745,257,774.15 |

The jump from December to January (roughly 50x in spend) is the single most striking pattern in the data. This aligns with the UK local government financial year, which runs to 31 March — Jan–March is year-end, when councils clear outstanding commitments and process payments tied to the government funding settlement (typically confirmed in early February ahead of a full council budget vote in late February). See Data Quality Notes for sourcing.

**4. Anomaly flags surfaced thousands of transactions worth a closer look**
Using a CASE-based flagging system (missing supplier, refund/negative, high value >£100k, round number), the highest-priority flags were dominated by small negative-value transactions (refunds/adjustments), with the largest of these concentrated in Social Work & Social Care Services and Climate, Energy & Green Spaces.

**5. Every department exceeded the "High" risk threshold**
Using risk-tier bands of >£5m (High), >£1m (Medium), all 113 departments returned in the executive summary were classified as **High** risk by total spend — for example:
| Department | Transactions | Total Spend | Flag Rate |
|---|---|---|---|
| Social Care | 69,757 | £463,838,800.39 | 2.0% |
| Social Work & Social Care Services | 30,598 | £369,738,430.03 | 6.5% |
| Finance | 1,286 | £310,359,681.36 | 10.7% |
| Government Grants & Parish Precepts | 16 | £144,279,707.00 | **100.0%** |
| Welfare and Benefits | 541 | £129,967,649.39 | 13.7% |

**Note on risk tiers:** the £1m/£5m thresholds were designed for a generic council dataset and don't discriminate well at Leeds's actual scale (department totals range from ~£21m to ~£464m). Every department clears "High" by a wide margin. **This is a known limitation, kept deliberately rather than adjusted after seeing the results** — recalibrated thresholds (e.g. >£200m High, >£50m Medium) would be a more meaningful next iteration.

One result stands out regardless of threshold: **Government Grants & Parish Precepts has only 16 transactions, but 100% of them are flagged** — this is the kind of low-volume, high-flag-rate department that would be a priority sample in a real audit, independent of total spend.

---

## Data Quality Notes

- **No NULLs found** on department, supplier, amount, or payment date.
- **One supplier value reads "REDACTED PERSONAL DATA"** — this is Leeds Council's own redaction of individual payees (common for safeguarding-sensitive payments like foster care or adult social care), not a data error.
- **A handful of transactions (6 rows) appear dated September 2025**, with a small negative total spend (-£115.20) — likely backdated adjustments or refunds rather than genuine activity in that month. Excluded from headline trend commentary but retained in the underlying data.
- **The Dec 2025 → Jan 2026 spend jump (~50x)** corresponds to UK local government year-end timing. Local authority financial years run to 31 March, and the final quarter (Jan–Mar) typically sees concentrated payment activity as councils clear commitments and process grant-related payments ahead of close. Leeds's 2026/27 government funding settlement was confirmed on 9 February 2026, with the council's own budget debated and voted on 25 February 2026 — both falling inside this window. This is a structural pattern across UK councils, not a data error specific to this dataset.
- **Statutory/transfer payments** (Housing Benefit, central government grants) appear in the same `supplier` field as commercial vendors — a real analysis distinguishing "payments to third-party vendors" from "statutory transfers" would need a category flag, which this raw dataset doesn't provide.

---

## Techniques Used

- Data completeness profiling (NULL detection across all key fields via `CASE WHEN` + `SUM`)
- CTEs (Common Table Expressions) for layered, readable logic
- Window functions (`LAG()`) for month-on-month change calculation
- Conditional logic (`CASE WHEN`) for both anomaly flagging and risk-tier classification
- Aggregation and grouping (`GROUP BY`, `SUM`, `COUNT`, `AVG`) at supplier and department level
- Conditional `ORDER BY` for risk-based result prioritisation

---

## Tools

MySQL 8.0, MySQL Workbench

## Data Source

Leeds City Council spend transparency data (published in line with the UK Local Government Transparency Code)

## What I'd Do Next

- Recalibrate risk-tier thresholds to Leeds's actual spend distribution rather than generic bands
- Separate statutory/transfer payments from third-party vendor payments before repeating supplier concentration analysis
- Extend the dataset beyond Jan–March to see whether spend normalises outside year-end, confirming the financial-year-timing explanation with a full 12-month view
- Visualise the executive summary (Task 5) as a Power BI dashboard for non-technical stakeholders
