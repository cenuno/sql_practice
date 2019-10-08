-- find the top ten community areas with the most jobs

/* 
Layer of geography:
many census blocks -> one census tract
many census tracts -> one community area
many community areas -> one City of Chicago
(note: 46826 blocks -> 801 tracts -> 77 community areas -> 1 city)

Logic:
to do this, we need to mark the community area each 
Chicago census block resides in and
then identify the number of jobs in each census block
*/
SELECT community_areas.community,
    SUM(il_wac_s000_jt00_2017.c000) AS num_jobs
FROM il_xwalk
JOIN census_tracts_2010
    ON il_xwalk.trct = census_tracts_2010.geoid10
JOIN community_areas
    ON census_tracts_2010.commarea = community_areas.area_numbe
JOIN il_wac_s000_jt00_2017
    ON il_xwalk.tabblk2010 = il_wac_s000_jt00_2017.w_geocode
GROUP BY community
ORDER BY community;
