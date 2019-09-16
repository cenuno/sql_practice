-- Top 10 community areas in terms of number of crimes, 2019
SELECT COUNT(id) AS count, "Community Area" AS cca
FROM crimes_2019
GROUP BY cca
ORDER BY count DESC
LIMIT 10;
