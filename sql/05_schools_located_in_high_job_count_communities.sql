/*
    Author:     Cristian E. Nuno
    Date:       November 9, 2019
    Purpose:    Identify the schools that are located in community areas 
                that have the highest number of jobs in 2017.
    Note:       This question is vague. After looking at the distribution of
                jobs per community area, I'll leave say "highest number" means
                more than 100K jobs per community area.
*/
DROP TABLE IF EXISTS school_cca_jobs;

CREATE TABLE school_cca_jobs AS (
    SELECT *
    FROM (
        SELECT  cps.school_id,
                cps.long_name,
                cps.primary_category,
                cps.overall_rating,
                cps.classification_description,
                CASE WHEN jobs.num_jobs_2017 >= 100000 THEN 1 
                    ELSE 0 
                    END AS high_employment_cca,
                jobs.num_jobs_2017
        FROM cps_sy1819_cca AS cps
        LEFT JOIN jobs_by_cca AS jobs
            ON cps.community = jobs.cca_name
    ) AS schools
    WHERE high_employment_cca = 1
);

-- Check the overall_rating count for these CPS schools in high employment areas
-- TODO: add pct of total (https://stackoverflow.com/questions/6489848/percent-to-total-in-postgresql-without-subquery)
SELECT overall_rating, COUNT(overall_rating) AS count
FROM school_cca_jobs
GROUP BY overall_rating
ORDER BY overall_rating;

-- Compare it to the distribution against all CPS schools

