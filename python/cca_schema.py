"""
Create a schema for community_areas SparkDataFrame
"""

# load necessary modules ----
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
