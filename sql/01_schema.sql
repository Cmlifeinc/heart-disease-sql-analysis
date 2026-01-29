-- ============================================
-- File: 01_schema.sql
-- Purpose: Explore database structure and table schema
-- ============================================

-- List all tables in the database
SELECT name
FROM sqlite_master
WHERE type = 'table';

-- Inspect the schema of the heart_disease table
PRAGMA table_info(heart_disease);

-- View the full CREATE TABLE statement
SELECT sql
FROM sqlite_master
WHERE type = 'table'
AND name = 'heart_disease';

-- Preview first 5 rows
SELECT *
FROM heart_disease
LIMIT 5;