# Archive

This directory will store files that are not immediately relevant to the project.

* [`intro_pyspark.py`](intro_pyspark.py) contains extra code necessary to import the JDBC driver. 
    + Note that this differs from [`python/intro_pyspark`](..python/intro_pyspark.py) that relies on the variable `PYSPARK_SUBMIT_ARGS` to call the JDBC driver location each time `pyspark`/`python` is used in the Terminal.
* [`ride_share_analysis.py`](ride_share_analysis.py) contains code used to import the Chicago Transportation Network Providers data set.
