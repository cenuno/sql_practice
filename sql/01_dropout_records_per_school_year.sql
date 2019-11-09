/*
    Author:     Cristian E. Nuno
    Date:       November 9, 2019
    Purpose:    Count how many schools provided dropout info per school year
*/

SELECT school_year, COUNT(school_year) AS count
FROM cps_dropout_rate_2011_2019
GROUP BY school_year
ORDER BY school_year;
