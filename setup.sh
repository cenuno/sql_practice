#!/bin/bash

# Setup: 
# install necessary packages and configures your environment for psql & pyspark

# install necessary packages ----
# note: takes about 5-10 minutes
sh bash/01_install_packages.sh | tee -a log/01_install_log.txt

# download chicago data sets -----
# note: takes about 5-10 minutes
sh bash/02_create_chicago_database.sh | tee -a log/02_data_log.txt

# download JDBC Driver and create local variables needed to run pyspark ----
# note: takes about ~1 minute
sh bash/03_spark_config.sh | tee -a log/03_spark_config_log.txt

# reload shell environment ----
source ~/.bash_profile
