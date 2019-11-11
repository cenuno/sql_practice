/*
    Author:     Cristian E. Nuno
    Date:       November 9, 2019
    Purpose:    Identify the top 10 community areas that 
                have the highest number of crimes in 2019.
    Note:       This data set contains arrests so we're using arrests
                as a proxy for criminal activity across the city.
*/

-- Before we answer the question, let's get some context:
-- count the number of records in the crimes table
SELECT COUNT(*) AS count_num_records
FROM crimes_2019;

-- count the number of unique ID values 
-- note: see this SO post for why I'm counting uniques this way: 
--       https://stackoverflow.com/a/14732410/7954106
SELECT COUNT(*) AS count_unique_id
FROM (
    SELECT DISTINCT id
    FROM crimes_2019
    ) AS temp;

-- count the number of unique Case Number values
SELECT COUNT(*) AS count_unique_case_num
FROM (
    SELECT DISTINCT "Case Number"
    FROM crimes_2019
    ) AS temp;

/*
    Conclusion: there is one record per id value, meaning that one Case Number
                may have multiple records (i.e. multiple arrests)

    Now we can move forward with identifying the top 10 communities by crime
*/
SELECT community_areas.community AS cca_name,
        crimes_2019."Community Area" AS cca_num, 
        COUNT(crimes_2019.id) AS num_arrests
FROM crimes_2019
-- for each arrest, grab its corresponding community area text
LEFT JOIN community_areas
    ON crimes_2019."Community Area" = community_areas.area_numbe
GROUP BY cca_name, cca_num
ORDER BY num_arrests DESC
LIMIT 10;
