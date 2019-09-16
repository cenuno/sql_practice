-- how many records per school year
SELECT school_year, COUNT(school_year)
FROM cps_dropout_rate_2011_2019
GROUP BY school_year
ORDER BY school_year;
