DROP TABLE IF EXISTS popular_schools;

-- Count the the number of schools in each community area but only keep
-- the most popular primary_category in each community area
CREATE TABLE popular_schools
AS (
  SELECT DISTINCT ON (community)
         community,
         primary_category,
         COUNT(primary_category) AS count
  FROM cps_sy1819_cca
  WHERE community IS NOT NULL
    AND community != '2004-09-01'
  GROUP BY community, primary_category
  ORDER BY community, count DESC
);

-- Confirm that there are only 77 records, one per community area
SELECT COUNT(*) FROM popular_schools;
