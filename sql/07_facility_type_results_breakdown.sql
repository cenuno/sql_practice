/*
    Author:     Cristian E. Nuno
    Date:       November 10, 2019
    Purpose:    By Facility Type, what is the percentage breakdown (i.e. 0-1) 
                of results for all food establishments over time
    Note:       For each set of "Facility Type" values, we want to count
                the number of records per "result". 
                Each set of "Facility Type" - "result" combination will have
                be a portion of the total "Facility Type" count, as seen in the
                "count", "total" and "pct" columns.
*/
-- for more information on window functions, see: https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS
SELECT  "Facility Type",
        results,
        COUNT(results) AS count,
        SUM(COUNT(results)) OVER(PARTITION BY "Facility Type") AS total,
        ROUND(
            (
                COUNT(results) / 
                SUM(COUNT(results)) OVER(PARTITION BY "Facility Type")
            ) * 100,
            2) AS pct
FROM food_inspections
GROUP BY "Facility Type", results
ORDER BY "Facility Type", pct DESC;
