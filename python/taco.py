# load necessary modules ----
import cca_schema
from pyspark.sql.session import SparkSession

print("Successfully load imports")

# create spark session ----
spark = (
    SparkSession.builder
    .master("local[1]")
    .appName("Python Spark SQL example")
    .getOrCreate()
)

print("Successfully create spark session")
