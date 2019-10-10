# download the jar for PostgreSQL JDBC Driver 42.1.1 directly from the Maven repository
# note: the .jar file will be placed into the appropriate jars/ directory
wget -P /usr/local/Cellar/apache-spark/2.4.4/libexec/jars http://central.maven.org/maven2/org/postgresql/postgresql/42.1.1/postgresql-42.1.1.jar

# modify ~/.bash_profile to include necessary variables ----
echo "\n# === Added by https://github.com/cenuno/sql_practice/ ===\n" \
>> ~/.bash_profile

# add variable that connects pyspark to proper JDBC driver to ~/.bash_profile
psql_jar_comment="# setup the class path for the JDBC Driver (i.e. for spark to connect to psql)"
psql_jar_var="export PSQL_JAR=/usr/local/Cellar/apache-spark/2.4.4/libexec/jars/postgresql-42.1.1.jar"
echo "${psql_jar_comment}\n${psql_jar_var}" >> ~/.bash_profile

# add variable that establishes the JDBC connection each time pyspark is used
# to ~/.bash_profile
pyspark_arg_comment="\n# use the class path for the JDBC Driver each time we use pyspark"
pyspark_arg_var="export PYSPARK_SUBMIT_ARGS='--driver-class-path $PSQL_JAR --jars $PSQL_JAR pyspark-shell'"
echo "${pyspark_arg_comment}\n${pyspark_arg_var}" >> ~/.bash_profile

echo "\n# === End of additions by https://github.com/cenuno/sql_practice/ ===\n" \
>> ~/.bash_profile
