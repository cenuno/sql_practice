# SQL Practice

This repository is meant to help users practice their SQL skills using Python,
PostgreSQL, and Scala! The three really come together nicely using Apache Spark.

## Requirement

This project assumes you are using bash version no older than `3.2.57(1)-release`. You may encounter errors with the [`bash/03_spark_config.sh`](bash/03_spark_config.sh). One common error is that your older version of bash requires `-e` to active line breaks within a string being used with `echo` commands.

## Getting Started

Please run the following bash commands after you have forked and clone the `sql_practice` repo:

```bash
# install necessary packages and configures your environment for psql & pyspark
sh setup.sh
```

## `pyspark-env`

This project relies on you using the [`environment.yml`](environment.yml) file to recreate the `pyspark-env` conda environment. To do so, please run the following commands:

```bash
# create pyspark-env environment from the environment.yml file
conda env create -f environment.yml

# activate (switch into) the pyspark-env conda environment
conda activate pyspark-env

# make pyspark-env available to you as a kernel in jupyter
python -m ipykernel install --user --name pyspark-env --display-name "pyspark-env"
```


## `chicago` Database

The `02_create_chicago_database.sh` script creates both a `write_data/chicago.db` and `postgresql:///chicago` database to be used with either SQLite or PostgreSQL.

Here is more information regarding the different tables that make up the `chicago` database:

| **Table Name** | **Description** | **Documentation** |
| :------------: | :-------------: | :---------------: |
| `census_tracts_2010` | 2010 [census tracts](https://libguides.lib.msu.edu/tracts) boundaries in Chicago, IL. | https://data.cityofchicago.org/Facilities-Geographic-Boundaries/Boundaries-Census-Tracts-2010/5jrd-6zik |
| `community_areas` | Current 77 Chicago [community areas (CCAs)](https://en.wikipedia.org/wiki/Community_areas_in_Chicago). _Note: these 77 CCAs are well-defined, static, and do not overlap. Census data are tied to the CCAs, and they serve as the basis for a variety of urban planning initiatives on both the local and regional levels._ | https://data.cityofchicago.org/Facilities-Geographic-Boundaries/Boundaries-Community-Areas-current-/cauq-8yn6 |
| `cps_dropout_rate_2011_2019` | The [five-year cohort dropout rate](https://cps.edu/Performance/Documents/DataFiles/FiveYearDropoutFactSheet.pdf) follows a group of students who enter Chicago Public Schools (CPS) high schools as freshmen and calculates the percent of these students who drop out within five years after their freshman year. This table contains the dropout rates for each school year from 2011 to 2019. _Note: unfortunately, some schools have been closed since 2011. To verify if a school is closed, please check the `status_as_of_2019` column._ | [CPS Data](https://cps.edu/SchoolData/Pages/SchoolData.aspx) and [Source](https://cps.edu/Performance/Documents/DataFiles/Metrics_CohortGraduationDropoutAdjusted_SchoolLevel_2011to2019.xls)|
| `cps_sy1819_cca` | School profile information for all schools in the Chicago Public School district for the school year 2018-2019. | https://data.cityofchicago.org/Education/Chicago-Public-Schools-School-Profile-Information-/kh4r-387c |
| `crimes_2019` | This dataset reflects reported incidents of crime (with the exception of murders where data exists for each victim) for the year 2019. | https://data.cityofchicago.org/Public-Safety/Crimes-2019/w98m-zvie |
| `food_inspections` | This information is derived from inspections of restaurants and other food establishments in Chicago from January 1, 2010 to the present. Inspections are performed by staff from the Chicago Department of Public Health’s Food Protection Program using a standardized procedure. The results of the inspection are inputted into a database, then reviewed and approved by a State of Illinois Licensed Environmental Health Practitioner (LEHP). | https://data.cityofchicago.org/Health-Human-Services/Food-Inspections/4ijn-s7e5/data |
| `il_wac_s000_jt00_2017` | [Workplace Area Characteristic](https://lehd.ces.census.gov/data/lodes/LODES7/LODESTechDoc7.4.pdf) data for IL in 2017 that counts the total number of jobs for workers in all jobs by Census Block. | [LEHD Data](https://lehd.ces.census.gov/data/) & [IL 2017 WAC Data](https://lehd.ces.census.gov/data/lodes/LODES7/il/wac/il_wac_S000_JT00_2017.csv.gz) |
| `il_xwalk` | [Geographic crosswalk](https://lehd.ces.census.gov/data/lodes/LODES7/LODESTechDoc7.4.pdf) data used to help aggregate census blocks up to census tracts, zip codes, counties, and states. | [LEHD Data](https://lehd.ces.census.gov/data/) & [IL 2017 Geographic Crosswalk Data](https://lehd.ces.census.gov/data/lodes/LODES7/il/il_xwalk.csv.gz) |

### Transportation Network Providers - Trips ~20GB Data Set

Most examples rely on the data sets found in [`bash/02_create_chicago_database.sh`](bash/02_create_chicago_database.sh). A few, however, rely on the ~20GB data set containing [ride share trips](https://data.cityofchicago.org/Transportation/Transportation-Network-Providers-Trips/m6dm-c72p/data) within the City of Chicago.

All trips, starting November 2018, reported by Transportation Network Providers (sometimes called rideshare companies) to the City of Chicago as part of routine reporting required by ordinance. Census Tracts are suppressed in some cases, and times are rounded to the nearest 15 minutes. Fares are rounded to the nearest $2.50 and tips are rounded to the nearest $1.00.

For more information regarding privacy of this data set, please see [here](http://dev.cityofchicago.org/open%20data/data%20portal/2019/04/12/tnp-taxi-privacy.html).

#### Download Data

To download the data, set aside about ~1.5 hours to download the file using the 
following command:

```bash
sh bash/04_ride_share_data.sh
```

## Questions

1. In the `cps_dropout_rate_2011_2019` table, count how many records appear for each `school_year`. _Note: it is helpful to include the `school_year` column and to order the results by it as well._

2. Identify the schools and their community area whose dropout rate in school year 2019 is greater than or equal to 25 percent.

3. Identify the top 10 community areas that have the highest number of crimes in 2019.

4. Count the number of 2017 jobs in each community area.

5. Identify the schools that are located in community areas that have the highest number of jobs in 2017.

6. Count how many schools, by `overall_rating`, are located in community areas where the number of crimes is higher than the median number of crimes.

7. By `Facility Type`, what is the percentage breakdown (i.e. 0-1) of `results` for all food establishments over time. _Note: be sure to include all unique values in the `results` column._
    + Bonus: include both the the percentage breakdown and the total number of food establishments per `Facility Type`.

