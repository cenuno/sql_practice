# upgrade all brew packages & update homebrew
brew upgrade && brew update

# install tool used to download a local copy of a file from the Internet
brew install wget

# install open source implementation of the Java Platform, Standard Edition
brew cask install adoptopenjdk

# install the scala programming language
brew install scala

# install java8
brew cask install homebrew/cask-versions/adoptopenjdk8

# install apache spark
brew install apache-spark

# install hadoop in case you wish to use other types of clusters
brew install hadoop

# download the jar for PostgreSQL JDBC Driver 42.1.1 directly from the Maven repository
# note: the .jar file will be placed into the appropriate jars/ directory
wget -P /usr/local/Cellar/apache-spark/2.4.4/libexec/jars http://central.maven.org/maven2/org/postgresql/postgresql/42.1.1/postgresql-42.1.1.jar

# modify ~/.bash_profile to include necessary variables ----
echo -e "\n# === Added by https://github.com/cenuno/sql_practice/ ===\n" \
>> ~/.bash_profile

# add variable that connects pyspark to proper JDBC driver to ~/.bash_profile
psql_jar_comment="# setup the class path for the JDBC Driver (i.e. for spark to connect to psql)"
psql_jar_var="export PSQL_JAR=/usr/local/Cellar/apache-spark/2.4.4/libexec/jars/postgresql-42.1.1.jar"
echo -e "${psql_jar_comment}\n${psql_jar_var}" >> ~/.bash_profile

# add variable that establishes the JDBC connection each time pyspark is used
# to ~/.bash_profile
pyspark_arg_comment="\n# use the class path for the JDBC Driver each time we use pyspark"
pyspark_arg_var="export PYSPARK_SUBMIT_ARGS='--driver-class-path $PSQL_JAR --jars $PSQL_JAR pyspark-shell'"
echo -e "${pyspark_arg_comment}\n${pyspark_arg_var}" >> ~/.bash_profile

echo -e "\n# === End of additions by https://github.com/cenuno/sql_practice/ ===\n" \
>> ~/.bash_profile

# install suite of command-line tools for converting to and working with CSV
brew install csvkit

# install csvs-to-sqlite to convert csv files to SQLite database
pip3 install csvs-to-sqlite

# install PostgreSQL
brew install postgresql

# ensure the PostgreSQL is running
brew services start postgresql

# install pgloader to transform SQLite database to a PostgreSQL database
brew install --HEAD pgloader
