// reads a data frame and infers schema
val df = (
  spark.read
  .format("csv")
  .option("header", "true")
  .load("raw_data/cps_sy1819_cca.csv")
)

/* display the first two records nicely
https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.Dataset@show(numRows:Int,truncate:Int):Unit
*/
df.show(numRows = 2, truncate = 20, vertical = true)
