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

# start spark session ----
spark = (
    SparkSession.builder
    .master("local[1]")
    .appName("Python Spark SQL example")
    .getOrCreate()
)

# load community area data from the PSQL chicago database ----
com_area_df = (
    spark.read
    .format("jdbc")
    .option("url", "jdbc:postgresql:///chicago")
    .option("dbtable", "community_areas")
    .load()
)

# show the data ----
com_area_df.show(n=5, truncate=True, vertical=True)

# show schema ----
com_area_df.printSchema()