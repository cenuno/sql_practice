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




