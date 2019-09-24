// Running SQL Queries Programmatically

// reads a data frame and infers schema
val df = (
  spark.read
  .format("csv")
  .option("header", "true")
  .load("raw_data/cps_sy1819_cca.csv")
  // cast student_count_total as an integer
  .withColumn("student_count_total",
              $"student_count_total" cast "Int")
)

// Register the DataFrame as a SQL temporary view
df.createOrReplaceTempView("cps")

// run SQL queries programmatically and returns the result as a DataFrame
val sqlDF = spark.sql("SELECT * FROM cps LIMIT 2")

// display results
sqlDF.show(numRows = 2, truncate = 20, vertical = true)

// count how many schools by chicago community area (CCA)
val community = spark.sql("""
  SELECT community, COUNT(school_id) AS count
  FROM cps
  WHERE community IS NOT NULL
  GROUP BY community
  ORDER BY count DESC""")

// export school count as csv
/*
  Note: notice that the file path is a directory and not a .csv file
        this directory contains many .csv files, each one a piece of the
        entire spark data frame.

        this requires us to bundle them together ourselves
        via a system package like csvstack (from csvkit) where we manually
        stack the partioned .csv files ontop on one another to form one
        comprehensive .csv file

        ```bash
        # stack partioned .csv files into one
        csvstack --filenames sy19_school_count_by_cca/*.csv > sy19_school_count_by_cca.csv
        ```

  Note: Spark does come with a helper function (coalace) that moves all the
        partioned files into one; however, that assumes the output file
        can be read in memory which is never a guarantee.

        For more on this, please see this excellent Medium article:
        https://medium.com/@mrpowers/managing-spark-partitions-with-coalesce-and-repartition-4050c57ad5c4#.36o8a7b5j

        and this Stack Overflow post:
        https://stackoverflow.com/questions/31610971/spark-repartition-vs-coalesce

        P.S. this is also good:
        https://stackoverflow.com/a/38323127/7954106
*/
(community.write
  .option("header", "true")
  .csv("write_data/sy19_school_count_by_cca"))

// count each school type for each community area
val popular_schools = spark.sql("""
  SELECT community,
         primary_category,
         COUNT(primary_category) AS count
  FROM cps
  WHERE community IS NOT NULL
    AND community != '2004-09-01'
  GROUP BY community, primary_category
  ORDER BY community, count DESC
  """)

// alternatively, you can import sql tables directly into spark!
val jdbcDF = (
  spark.read
  .format("jdbc")
  .option("url", "jdbc:postgresql:///chicago")
  .option("dbtable", "cps_sy1819_cca")
  .load()
)

// from here, you can use SQL commands or dataframe operations!
// note: notice the use of $ sign notation without the need to import spark.implicits._
(jdbcDF.select("school_id", "short_name", "student_count_total")
 .filter($"student_count_total" > 1000)
 .show())




