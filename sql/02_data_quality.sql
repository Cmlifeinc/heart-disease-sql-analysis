-- ============================================
-- File: 02_data_quality.sql
-- Purpose: Basic data quality checks (nulls, ranges, target validity)
-- ============================================

-- 1) Row count
SELECT COUNT(*) AS total_rows
FROM heart_disease;

-- 2) Target distribution (adjust values if your target isn't 0/1)
SELECT "Heart Disease" AS heart_disease_flag, COUNT(*) AS n
FROM heart_disease
GROUP BY "Heart Disease"
ORDER BY n DESC;

-- 3) Check for NULLs in key columns
SELECT
  SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
  SUM(CASE WHEN sex IS NULL THEN 1 ELSE 0 END) AS null_sex,
  SUM(CASE WHEN bp IS NULL THEN 1 ELSE 0 END) AS null_bp,
  SUM(CASE WHEN cholesterol IS NULL THEN 1 ELSE 0 END) AS null_cholesterol,
  SUM(CASE WHEN "Max HR" IS NULL THEN 1 ELSE 0 END) AS null_max_hr,
  SUM(CASE WHEN "Heart Disease" IS NULL THEN 1 ELSE 0 END) AS null_heart_disease
FROM heart_disease;

-- 4) Min/Max range checks (helps spot impossible values)
SELECT
  MIN(age) AS min_age, MAX(age) AS max_age,
  MIN(bp) AS min_bp, MAX(bp) AS max_bp,
  MIN(cholesterol) AS min_chol, MAX(cholesterol) AS max_chol,
  MIN("Max HR") AS min_max_hr, MAX("Max HR") AS max_max_hr
FROM heart_disease;

-- 5) Look for suspicious zeros (common data issue)
SELECT
  SUM(CASE WHEN age = 0 THEN 1 ELSE 0 END) AS age_is_zero,
  SUM(CASE WHEN bp = 0 THEN 1 ELSE 0 END) AS bp_is_zero,
  SUM(CASE WHEN cholesterol = 0 THEN 1 ELSE 0 END) AS cholesterol_is_zero,
  SUM(CASE WHEN "Max HR" = 0 THEN 1 ELSE 0 END) AS max_hr_is_zero
FROM heart_disease;

-- 6) Duplicate row check (basic)
-- If your dataset has an ID column, use that instead.
SELECT COUNT(*) - COUNT(DISTINCT age || '-' || sex || '-' || bp || '-' || cholesterol || '-' || "Max HR" || '-' || "Heart Disease") AS possible_duplicate_rows
FROM heart_disease;

-- 7) Quick sample of any rows with obvious issues (edit thresholds if needed)
SELECT *
FROM heart_disease
WHERE age <= 0
   OR age > 120
   OR bp <= 0
   OR bp > 300
   OR cholesterol <= 0
   OR cholesterol > 1000
   OR "Max HR" <= 0
   OR "Max HR" > 300
LIMIT 25;