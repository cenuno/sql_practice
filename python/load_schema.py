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