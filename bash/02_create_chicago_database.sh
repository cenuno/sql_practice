#!/bin/bash

echo "Start downloading data at $(date)"

# bash function used to retrieve the absolute file path of a file as a string
# note: thank you to peterh's answer on SO 
#       https://stackoverflow.com/a/21188136
get_str_abs_filename() {
  # $1 : relative filename
  echo "'$(cd "$(dirname "$1")" && pwd)/$(basename "$1")'"
}

# download 2017 IL jobs data
wget https://lehd.ces.census.gov/data/lodes/LODES7/il/wac/il_wac_S000_JT00_2017.csv.gz

# decompress the 2017 IL jobs data
# note: this will delete the original .csv.gz file
gunzip il_wac_S000_JT00_2017.csv.gz

# download 2017 IL jobs geographic crosswalk file
wget https://lehd.ces.census.gov/data/lodes/LODES7/il/il_xwalk.csv.gz

# decompress the 2017 IL jobs crosswalk file
# note: this will delete the original .csv.gz file
gunzip il_xwalk.csv.gz

# download CPS SY1819 profiles
wget https://github.com/cenuno/exploring_chicago_data/raw/master/write_data/cps_sy1819_cca.csv

# download CPS dropout data
wget -O raw_cps_dropout_rate_2011_2019.xls https://cps.edu/Performance/Documents/DataFiles/Metrics_CohortGraduationDropoutAdjusted_SchoolLevel_2011to2019.xls

# move the files into the correct location
mv *.csv raw_cps_dropout_rate_2011_2019.xls raw_data/

# transform the second sheet into a .csv file
# note: due to the way the .xls file is organized, there are redundant
#       column names. Ignore the warning messages.
in2csv raw_data/raw_cps_dropout_rate_2011_2019.xls --sheet="School 5 Year Cohort Rates" \
--skip-lines=2 | csvcut -c 1,2,3,4,5,6,7,8,9,10,11,12 \
> raw_data/raw_cps_dropout_rate_2011_2019.csv

# transform the dropout rate data from wide to long
python python/reshape_dropout.py

# download Chicago 2019 crimes
wget -O crimes_2019.csv https://data.cityofchicago.org/api/views/w98m-zvie/rows.csv?accessType=DOWNLOAD

# download 2010 chicago census tracts
wget -O census_tracts_2010.csv https://data.cityofchicago.org/api/views/74p9-q2aq/rows.csv?accessType=DOWNLOAD

# download current chicago community areas
wget -O community_areas.csv https://data.cityofchicago.org/api/views/igwz-8jzy/rows.csv?accessType=DOWNLOAD

# download chicago food inspection file
wget -O food_inspections.csv https://data.cityofchicago.org/api/views/4ijn-s7e5/rows.csv?accessType=DOWNLOAD

# move the files into the correct location
mv *.csv raw_data/

# store the absolute file paths of the .csv files that we'll import into PostgreSQL
export CENSUS_TRACT_PATH=$(get_str_abs_filename "raw_data/census_tracts_2010.csv")
export COMM_AREA_PATH=$(get_str_abs_filename "raw_data/community_areas.csv")
export CPS_DROPOUT_PATH=$(get_str_abs_filename "write_data/clean_cps_dropout_rate_2011_2019.csv")
export CPS_SY1819_PATH=$(get_str_abs_filename "raw_data/cps_sy1819_cca.csv")
export CRIME_PATH=$(get_str_abs_filename "raw_data/crimes_2019.csv")
export FOOD_PATH=$(get_str_abs_filename "raw_data/food_inspections.csv")
export IL_JOBS_PATH=$(get_str_abs_filename "raw_data/il_wac_S000_JT00_2017.csv")
export IL_XWALK_PATH=$(get_str_abs_filename "raw_data/il_xwalk.csv")

# create a new psql database
createdb chicago

# import the csv files into the opportunity_youth database
# note: great tutorial on bash & psql found here
#       https://www.manniwood.com/postgresql_and_bash_stuff/index.html
psql \
    --dbname=chicago \
    --file=sql/import_csv.sql \
    --set CENSUS_TRACT_PATH=$CENSUS_TRACT_PATH \
    --set COMM_AREA_PATH=$COMM_AREA_PATH \
    --set CPS_DROPOUT_PATH=$CPS_DROPOUT_PATH \
    --set CPS_SY1819_PATH=$CPS_SY1819_PATH \
    --set CRIME_PATH=$CRIME_PATH \
    --set FOOD_PATH=$FOOD_PATH \
    --set IL_JOBS_PATH=$IL_JOBS_PATH \
    --set IL_XWALK_PATH=$IL_XWALK_PATH \
    --echo-all

echo "Finished downloading data at $(date)"
