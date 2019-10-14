"""
An introduction to using pyspark to load data from .csv and psql
and using SparkDataFrames and SQL to perform a query
"""

# load necessary modules ----
from python.cca_schema import schema
import os
from pyspark import SparkConf
from pyspark.sql.session import SparkSession
from matplotlib import pyplot as plt

# create configuration ----
# note: as long as your ~/.bash_profile contains $PYSPARK_SUBMIT_ARGS
#       none of the configuration code down below is necessary

# add driver path
psql_jar_path = os.getenv("PSQL_JAR")

# create configuration object with appropriate modifications
conf = SparkConf()
conf.set("spark.jars", psql_jar_path)
conf.set("spark.executor.extraClassPath", psql_jar_path)
conf.set("spark.driver.extraClassPath", psql_jar_path)

# create spark session ----
spark = (
    SparkSession.builder
    # Sets the Spark master URL to connect to, such as "local" to run locally
    .master("local[1]")
    # Sets a name for the application, which will be shown in the Spark web UI
    .appName("Python Spark SQL example")
    # use configuration options
    .config(conf=conf)
    # Gets an existing :class:SparkSession or, if there is no existing one,
    # creates a new one based on the options set in this builder
    .getOrCreate()
)

print("Successfully create spark session")

# load necessary data ----

# load IL job data at the census block level
# note: IL job counts are from 2017
jobs_df = (
    spark.read
    .format("jdbc")
    .option("url", "jdbc:postgresql:///chicago")
    .option("dbtable", "il_wac_s000_jt00_2017")
    .load()
)

# load 2010 IL census block to 2010 IL census tract crosswalk data
xwalk_df = (
    spark.read
    .format("jdbc")
    .option("url", "jdbc:postgresql:///chicago")
    .option("dbtable", "il_xwalk")
    .load()
)

# load 2010 Chicago census tract data
ct_df = (
    spark.read
    .format("jdbc")
    .option("url", "jdbc:postgresql:///chicago")
    .option("dbtable", "census_tracts_2010")
    .load()
)

# load current Chicago community area data
cca_df = spark.read.csv(path="raw_data/community_areas.csv",
                        schema=schema,
                        sep=",",
                        header=False)  # header is supplied in schema

# take a glimpse into the data ----
jobs_df.show(n=5, truncate=True, vertical=True)
xwalk_df.show(n=5, truncate=True, vertical=True)
ct_df.show(n=5, truncate=True, vertical=True)
cca_df.show(n=5, truncate=True, vertical=True)

# register the DataFrames as a SQL temporary views ----
jobs_df.createOrReplaceTempView("jobs")
xwalk_df.createOrReplaceTempView("xwalk")
ct_df.createOrReplaceTempView("ct")
cca_df.createOrReplaceTempView("cca")

# count the number of jobs in each community area ----

# Layer of geography:
# many census blocks -> one census tract
# many census tracts -> one community area
# many community areas -> one City of Chicago
# (note: 46826 blocks -> 801 tracts -> 77 community areas -> 1 city)

# Logic:
# to do this, we need to mark the community area each
# Chicago census block resides in and
# then identify the number of jobs in each census block

query = """
SELECT cca.community,
    SUM(jobs.c000) AS num_jobs
FROM xwalk
JOIN ct
    ON xwalk.trct = ct.geoid10
JOIN cca
    ON ct.commarea = cca.area_numbe
JOIN jobs
    ON xwalk.tabblk2010 = jobs.w_geocode
GROUP BY community
ORDER BY num_jobs DESC
"""

# execute query
jobs_cca = spark.sql(query)

# display results
jobs_cca.show(n=5, truncate=True, vertical=True)

# convert SparkDataFrame to Pandas DataFrame ----
jobs_cca_df = jobs_cca.toPandas()

print(jobs_cca_df.head())

# visualize top ten CCAs by number of jobs ----
plt.barh(y=jobs_cca_df["community"][0:9],
         width=jobs_cca_df["num_jobs"][0:9])
plt.title("Top 10 Community Areas by Number of Jobs, 2017")
plt.xlabel("Total number of Jobs")
plt.ylabel("Chicago community areas")
plt.tight_layout()

# export plot as PNG ----
plt.savefig("visuals/top_ccas_by_jobs.png",
            dpi=200,
            bbox_inches="tight")

# stop session ----
spark.stop()
