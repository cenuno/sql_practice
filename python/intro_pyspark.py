# load necessary modules ----
import pandas as pd
from pyspark.context import SparkContext
from pyspark.sql.session import SparkSession
from pyspark.sql.types import (
    BooleanType,
    NumericType,
    StringType,
    StructField,
    StructType,
    TimestampType
)
from pyspark.sql.functions import (
    from_unixtime,
    unix_timestamp,
    to_timestamp
)

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

num_fields = set(["trip_seconds", "trip_miles", "fare",
                  "tip", "additional_charges", "trip_total",
                  "trips_pooled"])

ts_fields = set(["trip_start_timestamp", "trip_end_timestamp"])

# for each column name, assign it a specific type
fields = [StructField(field_name, BooleanType())
          if field_name in bool_fields
          # else StructField(field_name, TimestampType())
          # if field_name in ts_fields
          # else StructField(field_name, NumericType())
          # if field_name in num_fields
          else StructField(field_name, StringType())
          for field_name in schemaString.split("\n")]

# store schema
schema = StructType(fields)

# start spark session ----
sc = SparkContext.getOrCreate()
spark = SparkSession(sc)

# load necessary data ----
ride_share_df = (
    spark.read.csv(path="raw_data/rideshare_2018_2019.csv",
                   schema=schema,
                   sep=",",
                   header=False)
    # convert strings to timestamp
    .withColumn("trip_start_timestamp",
                to_timestamp("trip_start", format="MM/dd/yyyy hh:mm:ss aa")
    )
    .withColumn("trip_end_timestamp",
                to_timestamp("trip_end", format="MM/dd/yyyy hh:mm:ss aa")
    )
)

# show data ----
ride_share_df.show(n=5, truncate=True, vertical=True)

# show schema ----
ride_share_df.printSchema()

# count the historical number of dropoffs and pickups per community area ----

# stop spark session ----
sc.stop()
