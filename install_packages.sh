# install wget
brew install wget

# install csvkit to transform Excel files to csv
brew install csvkit

# install csvs-to-sqlite to convert csv files to SQLite database
pip3 install csvs-to-sqlite

# install PostgreSQL
brew install postgresql

# ensure the PostgreSQL is running
brew services start postgresql

# install pgloader to transform SQLite database to a PostgreSQL database
brew install --HEAD pgloader
