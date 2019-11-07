/*
 Author:    Cristian E. Nuno
 Purpose:   Import Chicago CSV files into PostgreSQL tables
 Date:      November 7, 2019
*/

-- Drop any existing tables
DROP TABLE IF EXISTS census_tracts_2010;
DROP TABLE IF EXISTS community_areas;
DROP TABLE IF EXISTS cps_dropout_rate_2011_2019;
DROP TABLE IF EXISTS cps_sy1819_cca;
DROP TABLE IF EXISTS crimes_2019;
DROP TABLE IF EXISTS food_inspections;
DROP TABLE IF EXISTS il_jobs_2017;
DROP TABLE IF EXISTS il_geo_xwalk;

-- Create skeleton table for Chicago census tracts
CREATE TABLE census_tracts_2010 (
    the_geom TEXT,
    statefp10  BIGINT,
    countyfp10 BIGINT,
    tractce10  BIGINT,
    geoid10 BIGINT,
    name10 REAL, 
    namelsad10 TEXT,  
    commarea BIGINT,
    commarea_n BIGINT,
    notes TEXT
);

-- Create skeleton table for Chicago community areas
CREATE TABLE community_areas (
    the_geom TEXT,
    perimeter BIGINT,
    area BIGINT,
    comarea_ BIGINT,
    comarea_id BIGINT,
    area_numbe BIGINT,
    community TEXT,
    area_num_1 BIGINT,
    shape_area REAL,
    shape_len REAL
);

-- Create skeleton table for Chicago Public Schools historical dropout rates
CREATE TABLE cps_dropout_rate_2011_2019 (
    school_id BIGINT, 
    school_name TEXT, 
    status_as_of_2019 TEXT, 
    school_year BIGINT, 
    dropout_rate REAL 
);

-- Create skeleton table for Chicago Public Schools SY1819 profile 
CREATE TABLE cps_sy1819_cca (
    school_id  BIGINT,
    legacy_unit_id BIGINT,
    finance_id BIGINT,
    short_name TEXT,
    long_name TEXT,
    primary_category TEXT,
    is_high_school BOOLEAN,
    is_middle_school BOOLEAN,
    is_elementary_school BOOLEAN,
    is_pre_school BOOLEAN,
    summary TEXT,
    administrator_title TEXT,
    administrator TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip BIGINT,
    phone TEXT,
    fax TEXT,
    cps_school_profile TEXT,
    website TEXT,
    facebook TEXT,
    twitter TEXT,
    youtube TEXT,
    pinterest TEXT,
    attendance_boundaries BOOLEAN,
    grades_offered_all TEXT,
    grades_offered TEXT,
    student_count_total BIGINT,
    student_count_low_income BIGINT,
    student_count_special_ed BIGINT,
    student_count_english_learners BIGINT,
    student_count_black BIGINT,
    student_count_hispanic BIGINT,
    student_count_white BIGINT,
    student_count_asian BIGINT,
    student_count_native_american BIGINT,
    student_count_other_ethnicity BIGINT,
    student_count_asian_pacific_islander BIGINT,
    student_count_multi BIGINT,
    student_count_hawaiian_pacific_islander BIGINT,
    student_count_ethnicity_not_available BIGINT,
    statistics_description TEXT,
    demographic_description TEXT,
    dress_code BOOLEAN,
    prek_school_day TEXT,
    kindergarten_school_day TEXT,
    school_hours TEXT,
    freshman_start_end_time TEXT,
    after_school_hours TEXT,
    earliest_drop_off_time TEXT,
    classroom_languages TEXT,
    bilingual_services TEXT,
    refugee_services TEXT,
    title_1_eligible TEXT,
    preschool_inclusive TEXT,
    preschool_instructional TEXT,
    significantly_modified TEXT,
    hard_of_hearing TEXT,
    visual_impairments TEXT,
    transportation_bus TEXT,
    transportation_el TEXT,
    transportation_metra TEXT,
    school_latitude REAL,
    school_longitude REAL,
    college_enrollment_rate_school TEXT,
    college_enrollment_rate_mean REAL,
    graduation_rate_school TEXT,
    graduation_rate_mean REAL,
    overall_rating TEXT,
    rating_status TEXT,
    rating_statement TEXT,
    classification_type TEXT,
    classification_description TEXT,
    school_year TEXT,
    network TEXT,
    is_gocps_participant BOOLEAN,
    is_gocps_prek BOOLEAN,
    is_gocps_elementary TEXT,
    is_gocps_high_school TEXT,
    open_for_enrollment_date DATE,
    community TEXT
);

-- Create skeleton table for 2019 Chicago crimes
CREATE TABLE crimes_2019 (
    id BIGINT,
    "Case Number" TEXT,
    date TEXT,
    block TEXT,
    iucr TEXT,
    "Primary Type"TEXT,
    description TEXT,
    "Location Description" TEXT,
    arrest BOOLEAN,
    domestic BOOLEAN,
    beat BIGINT,
    district BIGINT,
    ward BIGINT,
    "Community Area" BIGINT,
    "FBI Code" TEXT,
    "X Coordinate" BIGINT,
    "Y Coordinate" BIGINT,
    "year" BIGINT,
    "Updated On" TEXT,
    latitude REAL,
    longitude REAL,
    "location" TEXT
);

-- Create skeleton table for Chicago food inspections
CREATE TABLE food_inspections (
    "Inspection ID" BIGINT,
    "DBA Name" TEXT,
    "AKA Name" TEXT,
    "License #" BIGINT,
    "Facility Type" TEXT,
    risk TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    zip BIGINT,
    "Inspection Date" TEXT,
    "Inspection Type" TEXT,
    results TEXT,
    violations TEXT,
    latitude REAL,
    longitude REAL,
    "location" TEXT
);

-- Create skeleton table for Illinois 2017 jobs by census block
CREATE TABLE il_jobs_2017 (
    w_geocode CHAR(15),
    C000 INTEGER,
    CA01 INTEGER,
    CA02 INTEGER,
    CA03 INTEGER,
    CE01 INTEGER,
    CE02 INTEGER,
    CE03 INTEGER,
    CNS01 INTEGER,
    CNS02 INTEGER,
    CNS03 INTEGER,
    CNS04 INTEGER,
    CNS05 INTEGER,
    CNS06 INTEGER,
    CNS07 INTEGER,
    CNS08 INTEGER,
    CNS09 INTEGER,
    CNS10 INTEGER,
    CNS11 INTEGER,
    CNS12 INTEGER,
    CNS13 INTEGER,
    CNS14 INTEGER,
    CNS15 INTEGER,
    CNS16 INTEGER,
    CNS17 INTEGER,
    CNS18 INTEGER,
    CNS19 INTEGER,
    CNS20 INTEGER,
    CR01 INTEGER,
    CR02 INTEGER,
    CR03 INTEGER,
    CR04 INTEGER,
    CR05 INTEGER,
    CR07 INTEGER,
    CT01 INTEGER,
    CT02 INTEGER,
    CD01 INTEGER,
    CD02 INTEGER,
    CD03 INTEGER,
    CD04 INTEGER,
    CS01 INTEGER,
    CS02 INTEGER,
    CFA01 INTEGER,
    CFA02 INTEGER,
    CFA03 INTEGER,
    CFA04 INTEGER,
    CFA05 INTEGER,
    CFS01 INTEGER,
    CFS02 INTEGER,
    CFS03 INTEGER,
    CFS04 INTEGER,
    CFS05 INTEGER,
    createdate DATE
);

-- Create skeleton table for Illinois 2017 jobs geographic crosswalk
CREATE TABLE il_geo_xwalk (
    tabblk2010 CHAR(15),
    st CHAR(2),
    stusps CHAR(2),
    stname CHAR(100),
    cty CHAR(5),
    ctyname CHAR(100),
    trct CHAR(11),
    trctname CHAR(100),
    bgrp CHAR(12),
    bgrpname CHAR(100),
    cbsa CHAR(5),
    cbsaname CHAR(100),
    zcta CHAR(5),
    zctaname CHAR(100),
    stplc CHAR(7),
    stplcname CHAR(100),
    ctycsub CHAR(10),
    ctycsubname CHAR(100),
    stcd116 CHAR(4),
    stcd116name CHAR(100),
    stsldl CHAR(5),
    stsldlname CHAR(100),
    stsldu CHAR(5),
    stslduname CHAR(100),
    stschool CHAR(7),
    stschoolname CHAR(100),
    stsecon CHAR(7),
    dtseconname CHAR(100),
    trib CHAR(5),
    tribname CHAR(100),
    tsub CHAR(7),
    tsubname CHAR(100),
    stanrc CHAR(7),
    stanrcname CHAR(100),
    necta CHAR(5),
    nectname CHAR(100),
    mil CHAR(22),
    milname CHAR(100),
    stwib CHAR(8),
    stwibname CHAR(100),
    blklatdd NUMERIC,
    blklondd NUMERIC,
    createdate DATE
);

-- Copy the CSV contents of each file and place it into the appropriate table
COPY census_tracts_2010
FROM :CENSUS_TRACT_PATH
DELIMITER ',' CSV HEADER;

COPY community_areas
FROM :COMM_AREA_PATH
DELIMITER ',' CSV HEADER;

COPY cps_dropout_rate_2011_2019
FROM :CPS_DROPOUT_PATH
DELIMITER ',' CSV HEADER;

COPY cps_sy1819_cca
FROM :CPS_SY1819_PATH
DELIMITER ',' CSV HEADER;

COPY crimes_2019
FROM :CRIME_PATH
DELIMITER ',' CSV HEADER;

COPY food_inspections
FROM :FOOD_PATH
DELIMITER ',' CSV HEADER;

COPY il_jobs_2017
FROM :IL_JOBS_PATH
DELIMITER ',' CSV HEADER;

COPY il_geo_xwalk
FROM :IL_XWALK_PATH
DELIMITER ',' CSV HEADER;
