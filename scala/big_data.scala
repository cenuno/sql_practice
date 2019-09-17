// This import helps us use some sql functions
import org.apache.spark.sql.functions._
/*
import org.apache.spark.sql.types._

val customSchema = StructType(Array(
  StructField("Trip ID", StringType, true),
  StructField("Trip Start Timestamp", StringType, true),
  StructField("Trip End Timestamp", IntegerType, true),
  StructField("Trip Seconds", DoubleType, true)),
  StructField("project", StringType, true),
  StructField("article", StringType, true),
  StructField("requests", IntegerType, true),
  StructField("bytes_served", DoubleType, true)),
  StructField("project", StringType, true),
  StructField("article", StringType, true),
  StructField("requests", IntegerType, true),
  StructField("bytes_served", DoubleType, true)),
  StructField("project", StringType, true),
  StructField("article", StringType, true),
  StructField("requests", IntegerType, true),
  StructField("bytes_served", DoubleType, true))
)

|-- Trip ID: string (nullable = true)
 |-- Trip Start Timestamp: string (nullable = true)
 |-- Trip End Timestamp: string (nullable = true)
 |-- Trip Seconds: string (nullable = true)
 |-- Trip Miles: string (nullable = true)
 |-- Pickup Census Tract: string (nullable = true)
 |-- Dropoff Census Tract: string (nullable = true)
 |-- Pickup Community Area: string (nullable = true)
 |-- Dropoff Community Area: string (nullable = true)
 |-- Fare: string (nullable = true)
 |-- Tip: string (nullable = true)
 |-- Additional Charges: string (nullable = true)
 |-- Trip Total: string (nullable = true)
 |-- Shared Trip Authorized: string (nullable = true)
 |-- Trips Pooled: string (nullable = true)
 |-- Pickup Centroid Latitude: string (nullable = true)
 |-- Pickup Centroid Longitude: string (nullable = true)
 |-- Pickup Centroid Location: string (nullable = true)
 |-- Dropoff Centroid Latitude: string (nullable = true)
 |-- Dropoff Centroid Longitude: string (nullable = true)
 |-- Dropoff Centroid Location: string (nullable = true)
 */

// reads a data frame and infers schema
val df = (
  spark.read
  .format("csv")
  .option("header", "true")
  .load("raw_data/rideshare_2018_2019.csv")
  // cast Trip Miles as a Double
  .withColumn("Trip Miles",
              $"Trip Miles" cast "Double")
  // cast Trip Start Timestamp as a Timestamp
  .withColumn("Trip Start Timestamp",
              unix_timestamp($"Trip Start Timestamp",
                             "MM/dd/yyyy hh:mm:ss a") cast "Timestamp")
)

// display first two records in a nice format
df.show(numRows = 2, truncate = 20, vertical = true)

// Print the schema in a tree format
df.printSchema()
