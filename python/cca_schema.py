"""
Create a schema for community_areas SparkDataFrame
"""

# load necessary modules ----
from pyspark.sql.session import SparkSession
from pyspark.sql.types import (
    IntegerType,
    StringType,
    StructField,
    StructType
)

# construct schema ----
# store column names in one string
column_names = """the_geom
perimeter
area
comarea_
comarea_id
area_numbe
community
area_num_1
shape_area
shape_len"""

 # partion non-string type column types
int_fields = set(["area_numbe"])

# for each column name, assign it a specific type
explict_columns = [StructField(name, IntegerType())
                   if name in int_fields
                   else StructField(name, StringType())
                   for name in column_names.split("\n")]

# store schema
schema = StructType(explict_columns)
