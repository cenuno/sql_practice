#!/bin/bash

echo "Start installing necessary packages"

# Check for xcode-select; install if we don't have it
# for more information, see: https://help.apple.com/xcode/mac/current/#/devc8c2a6be1
if test ! $(which xcode-select); then 
    echo "Installing xcode-select..."
    xcode-select --install
fi

# Check for Homebrew; install if we don't have it
# for more information, see: https://brew.sh/
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Check for wget; install if we don't have it
# for more info, see: https://formulae.brew.sh/formula/wget
if test ! $(which wget); then
    echo "Installing wget..."
    brew install wget
fi

# Check for unzip; install if we don't have it
# for more info, see: https://formulae.brew.sh/formula/unzip
if test ! $(which unzip); then
    echo "Installing unzip..."
    brew install unzip
fi

# Check for anaconda; install if we don't have it
# for more info, see: https://formulae.brew.sh/cask/anaconda
if test ! $(which conda); then
    echo "Installing anaconda..."
    brew cask install anaconda
fi

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

# install hadoop in case you wish to use other types of clusters
brew install hadoop

# install suite of command-line tools for converting to and working with CSV
brew install csvkit

# install csvs-to-sqlite to convert csv files to SQLite database
pip3 install csvs-to-sqlite

# Check for PostgreSQL; install if we don't have it
# for more info, see: https://formulae.brew.sh/formula/postgresql
if test ! $(which postgres); then
    echo "Installing PostgreSQL..."
    brew install postgresql
fi

# start PostgreSQL services
echo "Ensuring PostgreSQL services are running..."
brew services start postgresql

# install pgloader to transform SQLite database to a PostgreSQL database
brew install --HEAD pgloader

echo "Finished installing necessary packages"
