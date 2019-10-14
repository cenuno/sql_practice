"""
Using SparkDataFrames and SQL to perform a query on a 20GB file
"""

import sys
from IPython.core import ultratb
from pyspark.sql.session import SparkSession
from pyspark.sql.types import (
    BooleanType,
    FloatType,
    IntegerType,
    StringType,
    StructField,
    StructType
)
from pyspark.sql.functions import to_timestamp

# ensure error messages are color coded using IPython color schema ----
sys.excepthook = ultratb.FormattedTB(mode="Plain",
                                     color_scheme="Linux",
                                     call_pdb=False)

# construct schema ----
# store column names in one string
schemaString = """trip_id
trip_start
trip_end
trip_seconds
trip_miles
pickup_census_tract
dropoff_census_tract
pickup_community_area
dropoff_community_area
fare
tip
additional_charges
trip_total
shared_trip_authorized
trips_pooled
pickup_centroid_latitude
pickup_centroid_longitude
pickup_centroid_location
dropoff_centroid_latitude
dropoff_centroid_longitude
dropoff_centroid_location"""

# partion non-string type column types
bool_fields = set(["shared_trip_authorized"])

float_fields = set(["trip_seconds", "trip_miles", "fare",
                    "tip", "additional_charges", "trip_total"])

int_fields = set(["trips_pooled"])

# for each column name, assign it a specific type
fields = [StructField(field_name, BooleanType())
          if field_name in bool_fields
          else StructField(field_name, FloatType())
          if field_name in float_fields
          else StructField(field_name, IntegerType())
          if field_name in int_fields
          else StructField(field_name, StringType())
          for field_name in schemaString.split("\n")]

# store schema
schema = StructType(fields)

# start spark session ----
spark = (
    SparkSession.builder
    .master("local[1]")
    .appName("Python Spark SQL example")
    .getOrCreate()
)

# load necessary data ----

# load ride share data
ride_share_df = (
    spark.read.csv(path="raw_data/rideshare_2018_2019.csv",
                   schema=schema,
                   sep=",",
                   header=False)
    # convert strings to timestamp
    .withColumn(
        "trip_start_timestamp",
        to_timestamp("trip_start", format="MM/dd/yyyy hh:mm:ss aa")
        )
    .withColumn(
        "trip_end_timestamp",
        to_timestamp("trip_end", format="MM/dd/yyyy hh:mm:ss aa")
        )
)

# load community area data from the PSQL chicago database
com_area_df = (
    spark.read
    .format("jdbc")
    .option("url", "jdbc:postgresql:///chicago")
    .option("dbtable", "community_areas")
    .load()
)

# show data ----
ride_share_df.show(n=5, truncate=True, vertical=True)
com_area_df.show(n=5, truncate=True, vertical=True)

# show schema ----
com_area_df.printSchema()

# count the historical number of dropoffs and pickups per community area ----

# register the DataFrames as a SQL temporary views
ride_share_df.createOrReplaceTempView("ride_share")
com_area_df.createOrReplaceTempView("com_area")

# store query
query = """
SELECT pickup_community_area AS community_area,
       COUNT(pickup_community_area) AS pickup_count,
       COUNT(dropoff_community_area) AS dropoff_count
FROM ride_share
GROUP BY community_area
ORDER BY community_area
"""

# execute query
# sqlDF = spark.sql(query)

# display results
# sqlDF.show(n=10, truncate=True, vertical=True)

# stop spark session ----
spark.stop()
