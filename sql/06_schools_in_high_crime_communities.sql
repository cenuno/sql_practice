/*
    Author:     Cristian E. Nuno
    Date:       November 10, 2019
    Purpose:    Count how many schools, by overall_rating, are located in 
                community areas where the number of crimes is higher 
                than the median number of crimes.
*/

DROP TABLE IF EXISTS crimes_per_cca;
DROP TABLE IF EXISTS crimes_per_cca_median;

-- count crimes per cca and store results as table
-- note: this is nearly the same query as Q3
CREATE TABLE crimes_per_cca AS (
    SELECT  community_areas.community AS cca_name,
            crimes_2019."Community Area" AS cca_num,
            COUNT(crimes_2019.id) AS num_arrests
    FROM crimes_2019
    INNER JOIN community_areas
        ON crimes_2019."Community Area" = community_areas.area_numbe
    GROUP BY cca_name, cca_num
    ORDER BY num_arrests DESC
);

-- create the median() function
-- copying & pasting logic from here: https://wiki.postgresql.org/wiki/Aggregate_Median
CREATE OR REPLACE FUNCTION _final_median(NUMERIC[])
   RETURNS NUMERIC AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;
 
CREATE AGGREGATE median(NUMERIC) (
  SFUNC=array_append,
  STYPE=NUMERIC[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);

-- test median function
SELECT MEDIAN(num_arrests) AS med_num_arrests
FROM crimes_per_cca;

-- create a new crimes per cca table with a flag if num arrests > median arrests
CREATE TABLE crimes_per_cca_median AS (
    SELECT  *,
            CASE WHEN num_arrests > (
                SELECT MEDIAN(num_arrests) AS med_num_arrests
                FROM crimes_per_cca
            ) 
            THEN 1
            ELSE 0
            END AS more_than_med_num_arrests
    FROM crimes_per_cca
);

-- count num of schools, by overall rating, located in high crimes communities
SELECT  *,
        SUM(count) OVER() AS total,
        ROUND((count / SUM(count) OVER()) * 100, 2) AS pct
FROM (
    SELECT  overall_rating,
            COUNT(overall_rating) AS count
    FROM cps_sy1819_cca
    INNER JOIN crimes_per_cca_median
        ON cps_sy1819_cca.community = crimes_per_cca_median.cca_name
    WHERE more_than_med_num_arrests = 1
    GROUP BY overall_rating
    ORDER BY overall_rating
) AS temp;

-- Compare it to the distribution against all CPS schools
SELECT  *,
        SUM(count) OVER() AS total,
        ROUND((count / SUM(count) OVER()) * 100, 2) AS pct
FROM (
    SELECT  overall_rating,
            COUNT(overall_rating) AS count
    FROM cps_sy1819_cca
    GROUP BY overall_rating
    ORDER BY overall_rating
) AS temp;

/*
    Conclusion: the proportion of Level 2 or worse rating for schools in high
                crimes communities (48.7%) is slightly higher (42.7%) than the 
                proportion of Level 2 or worse rating for all CPS schools 
*/
