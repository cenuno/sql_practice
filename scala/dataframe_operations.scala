// Untyped Dataset Operations (aka DataFrame Operations)

// This import is needed to use the $-notation
import spark.implicits._
// This import helps us use some sql functions
import org.apache.spark.sql.functions._

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

/* display the first two records nicely
https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.Dataset@show(numRows:Int,truncate:Int):Unit
*/
df.show(numRows = 2, truncate = 20, vertical = true)

// Print the schema in a tree format
df.printSchema()

// Select only the "short_name" column
df.select("short_name").show()

// Select all schools and the total number of students
df.select($"long_name", $"student_count_total").show()

// Select all schools and add 1000 to each total number of students
df.select($"school_id", $"long_name",
          $"student_count_total",
          $"student_count_total" + 1000).show()

// Select schools with student counts greater than or equal 500
(df.filter($"student_count_total" > 500)
 .select("school_id", "long_name", "student_count_total")
 .show())

 // count the number of school categories
 // Note: the data set needs to be cleaned. It appears values other than
 //       ES (elementary), MS (middle), and HS (high) school are found in this
 //       column.

(df.groupBy("primary_category")
 .count()
 .filter($"count" > 2)
 .sort(desc("count"))
 .show())
