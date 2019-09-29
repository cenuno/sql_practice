# Scala

This directory will store all [`.scala`](https://docs.scala-lang.org/tour/tour-of-scala.html) files relevant for this project.

## Note

We're using `.scala` to perform advanced analytics with [Apache Spark](https://spark.apache.org/docs/latest/index.html) (2.4.4). These notes are inspired by the [namesake book](https://github.com/sryza/aas#advanced-analytics-with-spark-source-code) written by Sandy Ryza, Uri Laserson, Sean Owen and Josh Wills.

So far, these notes plan on using the [Spark Standalone Manager](https://spark.apache.org/docs/latest/cluster-overview.html). For more discussion on which cluster type is right for you, see [this great Stack Overflow post](https://stackoverflow.com/a/34657719/7954106).

Be sure to install the following via [`brew`](https://brew.sh/) in the [Terminal](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac):

_Note: all of the commands down below can also be found in the
`install_packages.sh` in the project directory._

```bash
# upgrade all brew packages & update homebrew
brew upgrade && brew update

# install open source implementation of the Java Platform, Standard Edition
brew cask install adoptopenjdk

# install the scala programming language
brew install scala

# install java8
brew cask install homebrew/cask-versions/adoptopenjdk8

# install apache spark
brew install apache-spark

# install hadoop
# note: in case you wish to use other types of clusters
brew install hadoop
```

### Launching Spark from the Terminal

```bash
spark-shell --master local[1]
```

For greater detail on `spark-shell`, please see this [online book](https://jaceklaskowski.gitbooks.io/mastering-apache-spark/spark-shell.html).

### Exporting Spark DataFrames as CSV Files

The following `scala` command produces a directory:

```scala
(community.write
  .option("header", "true")
  .csv("write_data/sy19_school_count_by_cca"))
```

This is counter-intuitive since the  `.csv` command itself implies that
the output will be a single `.csv` file. However, this directory contains many 
`.csv` files, each one a piece of the entire spark data frame.

This requires us to bundle them together ourselves via a system package 
(such as [`csvkit`](https://csvkit.readthedocs.io/en/latest/index.html)) 
where we manually stack the partioned `.csv` files ontop one another 
to form a singluar `.csv` file:

```bash
# stack partioned .csv files into one
csvstack --filenames sy19_school_count_by_cca/*.csv > sy19_school_count_by_cca.csv
```

Spark does come with a helper function (coalace) that moves all the
partioned files into one; however, that assumes the output file can be read 
in memory which is never a guarantee.

For more on this, please see this excellent [Medium](https://medium.com/@mrpowers/managing-spark-partitions-with-coalesce-and-repartition-4050c57ad5c4#.36o8a7b5j) 
article these two Stack Overflow post:

* https://stackoverflow.com/questions/31610971/spark-repartition-vs-coalesce
* https://stackoverflow.com/a/38323127/7954106
