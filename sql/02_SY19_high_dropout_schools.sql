/*
    Author:     Cristian E. Nuno
    Date:       November 9, 2019
    Purpose:    ID the schools & their community areas where the dropout rate 
                in school year 2019 is greater than or equal to 25 percent.
*/

SELECT dropout.*, cps.community
FROM cps_dropout_rate_2011_2019 AS dropout
-- for each school, get its corresponding community area from another table
LEFT JOIN cps_sy1819_cca AS cps
    ON dropout.school_id = cps.school_id
WHERE dropout.school_year = '2019' AND
        dropout.dropout_rate >= 25;
