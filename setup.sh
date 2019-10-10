# Setup: 
# install necessary packages and configures your environment for psql & pyspark

# install necessary packages ----
# note: takes about 3-5 minutes
sh bash/01_install_packages.sh

# download chicago data sets -----
# note: takes about 5-10 minutes
sh bash/02_create_chicago_database.sh

# download JDBC Driver and create local variables needed to run pyspark ----
# note: takes about ~1 minute
sh bash/03_jdbc_driver.sh

# reload shell environment ----
source ~/.bash_profile

# create and switch into the psypark-env conda environment ----
sh bash/04_create_pyspark_env.sh
