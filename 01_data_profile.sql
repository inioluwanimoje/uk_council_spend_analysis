SELECT
  COUNT(*)                          AS total_transactions,
  MIN(payment_date)                 AS earliest_date,
  MAX(payment_date)                 AS latest_date,
  COUNT(DISTINCT supplier)          AS unique_suppliers,
  COUNT(DISTINCT department)        AS unique_departments,
  SUM(amount)                       AS total_spend,
  SUM(CASE WHEN supplier     IS NULL THEN 1 ELSE 0 END) AS null_supplier,
  SUM(CASE WHEN department   IS NULL THEN 1 ELSE 0 END) AS null_department,
  SUM(CASE WHEN amount       IS NULL THEN 1 ELSE 0 END) AS null_amount,
  SUM(CASE WHEN payment_date IS NULL THEN 1 ELSE 0 END) AS null_date
FROM council_spend;