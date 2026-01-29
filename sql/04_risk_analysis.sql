-- ============================================
-- File: 04_risk_analysis.sql
-- Purpose: Rule-based heart disease risk score
-- ============================================

-- Drop the view if it already exists
DROP VIEW IF EXISTS scored;

-- Create a reusable view for scoring
CREATE TEMP VIEW scored AS
SELECT
  age,
  sex,
  bp,
  cholesterol,
  "Max HR",
  "Heart Disease",

  CASE WHEN age >= 55 THEN 1 ELSE 0 END AS age_risk,
  CASE WHEN bp >= 140 THEN 1 ELSE 0 END AS bp_risk,
  CASE WHEN cholesterol >= 240 THEN 1 ELSE 0 END AS chol_risk,
  CASE WHEN "Max HR" < 120 THEN 1 ELSE 0 END AS max_hr_risk,
  CASE WHEN sex = 1 THEN 1 ELSE 0 END AS sex_risk,

  (CASE WHEN age >= 55 THEN 1 ELSE 0 END
  + CASE WHEN bp >= 140 THEN 1 ELSE 0 END
  + CASE WHEN cholesterol >= 240 THEN 1 ELSE 0 END
  + CASE WHEN "Max HR" < 120 THEN 1 ELSE 0 END
  + CASE WHEN sex = 1 THEN 1 ELSE 0 END) AS risk_score
FROM heart_disease;

-- 1) Risk score distribution
SELECT
  risk_score,
  COUNT(*) AS n
FROM scored
GROUP BY risk_score
ORDER BY risk_score;

-- 2) Heart disease rate by risk score
SELECT
  risk_score,
  COUNT(*) AS n,
  SUM(CASE WHEN "Heart Disease" = 'Presence' THEN 1 ELSE 0 END) AS presence_count,
  ROUND(100.0 * SUM(CASE WHEN "Heart Disease" = 'Presence' THEN 1 ELSE 0 END) / COUNT(*), 2) AS presence_rate_pct
FROM scored
GROUP BY risk_score
ORDER BY risk_score;

-- 3) Average vitals by risk score (sanity check)
SELECT
  risk_score,
  COUNT(*) AS n,
  ROUND(AVG(age), 1) AS avg_age,
  ROUND(AVG(bp), 1) AS avg_bp,
  ROUND(AVG(cholesterol), 1) AS avg_chol,
  ROUND(AVG("Max HR"), 1) AS avg_max_hr
FROM scored
GROUP BY risk_score
ORDER BY risk_score;

-- 4) High-risk group (score >= 4)
SELECT
  'score>=4' AS group_name,
  COUNT(*) AS n,
  SUM(CASE WHEN "Heart Disease" = 'Presence' THEN 1 ELSE 0 END) AS presence_count,
  ROUND(100.0 * SUM(CASE WHEN "Heart Disease" = 'Presence' THEN 1 ELSE 0 END) / COUNT(*), 2) AS presence_rate_pct
FROM scored
WHERE risk_score >= 4;

-- 5) Sample high-risk profiles
SELECT
  age,
  sex,
  bp,
  cholesterol,
  "Max HR",
  risk_score,
  "Heart Disease"
FROM scored
WHERE risk_score >= 4
ORDER BY risk_score DESC, age DESC
LIMIT 15;