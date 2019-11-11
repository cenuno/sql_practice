/*
    Author:     Cristian E. Nuno
    Date:       November 9, 2019
    Purpose:    Count the number of 2017 jobs in each community area
    Note:       This requires a conceptual understanding of U.S. geography:
                many census blocks -> one census tract
                many census tracts -> one community area
                many community areas -> one City of Chicago
                (note: 46826 blocks -> 801 tracts -> 77 community areas -> 1 city)
                
                To answer this question, we need to mark the community area each 
                Chicago census block resides in and
                then identify the number of jobs in each census block
*/
DROP TABLE IF EXISTS jobs_by_cca;

CREATE TABLE jobs_by_cca AS (
    SELECT community_areas.community AS cca_name,
            SUM(il_jobs_2017.c000) AS num_jobs_2017
    FROM il_xwalk
    -- Limit geographic crosswalk records to those found in Chicago
    INNER JOIN census_tracts_2010
        ON il_xwalk.trct = census_tracts_2010.geoid10
    -- Obtain the community area name
    LEFT JOIN community_areas
        ON census_tracts_2010.commarea_n = community_areas.area_numbe
    -- Obtain job data to only those found in Chicago census tracts
    -- note: since some census blocks don't have employment, we're dropping them
    INNER JOIN il_jobs_2017
        ON il_xwalk.tabblk2010::TEXT = il_jobs_2017.w_geocode
    GROUP BY cca_name
    ORDER BY num_jobs_2017 DESC
);
