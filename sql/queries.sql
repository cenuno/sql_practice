-- how many records per school year
SELECT school_year, COUNT(school_year) 
FROM cps_dropout_rate_2011_2019 
GROUP BY school_year 
ORDER BY school_year;

-- CPS schools with d/o >= 25% during SY19
SELECT profile.school_id, profile.community, dropout.*
FROM cps_sy1819_cca AS profile
JOIN cps_dropout_rate_2011_2019 AS dropout
ON profile.school_id = dropout.school_id
WHERE dropout.dropout_rate >= 25 AND dropout.school_year = 2019;

-- Top 10 community areas in terms of number of crimes, 2019
SELECT COUNT(id) AS count, "Community Area" AS cca 
FROM crimes_2019 
GROUP BY cca 
ORDER BY count DESC 
LIMIT 10; 
