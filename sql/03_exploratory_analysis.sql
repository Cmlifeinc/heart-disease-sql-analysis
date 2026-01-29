-- ============================================
-- File: 03_exploratory_analysis.sql
-- Purpose: Exploratory analysis (EDA)
-- Target values: 'Absence' and 'Presence'
-- ============================================

-- 1) Overall dataset size + prevalence (% Presence)
SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN "Heart Disease" = 'Presence' THEN 1 ELSE 0 END) AS presence_count,
  SUM(CASE WHEN "Heart Disease" = 'Absence' THEN 1 ELSE 0 END) AS absence_count,
  ROUND(100.0 * SUM(CASE WHEN "Heart Disease" = 'Presence' THEN 1 ELSE 0 END) / COUNT(*), 2) AS presence_rate_pct
FROM heart_disease;

-- 2) Sex distribution (helps you interpret the encoding)
SELECT
  sex,
  COUNT(*) AS n
FROM heart_disease
GROUP BY sex
ORDER BY sex;

-- 3) Presence rate by sex
SELECT
  sex,
  COUNT(*) AS total,
  SUM(CASE WHEN "Heart Disease" = 'Presence' THEN 1 ELSE 0 END) AS presence_count,
  ROUND(100.0 * SUM(CASE WHEN "Heart Disease" = 'Presence' THEN 1 ELSE 0 END) / COUNT(*), 2) AS presence_rate_pct
FROM heart_disease
GROUP BY sex
ORDER BY presence_rate_pct DESC;

-- 4) Compare averages: Presence vs Absence
SELECT
  "Heart Disease" AS status,
  COUNT(*) AS n,
  ROUND(AVG(age), 1) AS avg_age,
  ROUND(AVG(bp), 1) AS avg_bp,
  ROUND(AVG(cholesterol), 1) AS avg_cholesterol,
  ROUND(AVG("Max HR"), 1) AS avg_max_hr
FROM heart_disease
GROUP BY "Heart Disease"
ORDER BY status;

-- ============================================
-- Age band analysis
-- ============================================

-- 5) Create age bands and calculate Presence rate
WITH age_bands AS (
  SELECT
    CASE
      WHEN age < 40 THEN '<40'
      WHEN age BETWEEN 40 AND 49 THEN '40-49'
      WHEN age BETWEEN 50 AND 59 THEN '50-59'
      WHEN age BETWEEN 60 AND 69 THEN '60-69'
      ELSE '70+'
    END AS age_band,
    "Heart Disease" AS status
  FROM heart_disease
)
SELECT
  age_band,
  COUNT(*) AS n,
  SUM(CASE WHEN status = 'Presence' THEN 1 ELSE 0 END) AS presence_count,
  ROUND(
    100.0 * SUM(CASE WHEN status = 'Presence' THEN 1 ELSE 0 END) / COUNT(*),
    2
  ) AS presence_rate_pct
FROM age_bands
GROUP BY age_band
ORDER BY
  CASE age_band
    WHEN '<40' THEN 1
    WHEN '40-49' THEN 2
    WHEN '50-59' THEN 3
    WHEN '60-69' THEN 4
    ELSE 5
  END;