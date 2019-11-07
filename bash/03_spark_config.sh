#!/bin/bash

echo "Start configuring your machine to the proper spark settings by directly modifying your ~/.bash_profile at $(date)"

# download the jar for PostgreSQL JDBC Driver 42.1.1 directly from the Maven repository
# note: the .jar file will be placed into the appropriate jars/ directory
wget -P /usr/local/Cellar/apache-spark/2.4.4/libexec/jars http://central.maven.org/maven2/org/postgresql/postgresql/42.1.1/postgresql-42.1.1.jar

# modify ~/.bash_profile to include necessary variables ----
echo "\n# === Added by https://github.com/cenuno/sql_practice/ ===\n" \
>> ~/.bash_profile

# add variable that connects pyspark to proper JDBC driver
psql_jar_comment="# setup the class path for the JDBC Driver (i.e. for spark to connect to psql)"
psql_jar_var="export PSQL_JAR=/usr/local/Cellar/apache-spark/2.4.4/libexec/jars/postgresql-42.1.1.jar"
echo "${psql_jar_comment}\n${psql_jar_var}" >> ~/.bash_profile

# add variable that establishes the JDBC connection each time pyspark is used
pyspark_arg_comment="\n# use the class path for the JDBC Driver each time we use pyspark"
pyspark_arg_var="export PYSPARK_SUBMIT_ARGS='--conf spark.executor.extraClassPath=$PSQL_JAR --driver-class-path $PSQL_JAR --jars $PSQL_JAR pyspark-shell'"
echo "${pyspark_arg_comment}\n${pyspark_arg_var}" >> ~/.bash_profile

# add variable that makes Java 1.8 your default Java Virtual Machine
java_home_comment="\n# make Java 1.8 your default Java Virtual Machine"
java_home_var="export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)"
echo "${java_home_comment}\n${java_home_var}" >> ~/.bash_profile

# add variable that declares where to locate Spark
spark_home_comment="\n# locate spark home"
spark_home_var="export SPARK_HOME=/usr/local/Cellar/apache-spark/2.4.4/libexec"
echo "${spark_home_comment}\n${spark_home_var}" >> ~/.bash_profile

# add PySpark to PYTHONPATH
py_path_comment="\n# add PySpark to PYTHONPATH"
py_path_var="export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH"
echo "${py_path_comment}\n${py_path_var}" >> ~/.bash_profile

# mark the end of additions to ~/.bash_profile
echo "\n# === End of additions by https://github.com/cenuno/sql_practice/ ===\n" \
>> ~/.bash_profile

echo "Finished configuring your machine to the proper spark settings by directly modifying your ~/.bash_profile at $(date)"
