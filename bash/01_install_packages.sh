#!/bin/bash

echo "Start installing necessary packages at $(date)"

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
# for more info, see: https://github.com/AdoptOpenJDK/homebrew-openjdk#adoptopenjdk---homebrew-tap
brew cask install adoptopenjdk

# install the scala programming language
# for more info, see: https://formulae.brew.sh/formula/scala
if test ! $(which scala); then
    echo "Installing scala..."
    brew install scala
fi

# install java8
# for more info, see: https://github.com/AdoptOpenJDK/homebrew-openjdk/issues/106
brew cask install homebrew/cask-versions/adoptopenjdk8

# install apache spark
# for more info, see: https://formulae.brew.sh/formula/apache-spark
brew install apache-spark

# install hadoop in case you wish to use other types of clusters
# for more info, see: https://formulae.brew.sh/formula/hadoop
if test ! $(which hadoop); then
    echo "Installing hadoop..."
    brew install hadoop
fi

# install suite of command-line tools for converting to and working with CSV
brew install csvkit

# Check for PostgreSQL; install if we don't have it
# for more info, see: https://formulae.brew.sh/formula/postgresql
if test ! $(which postgres); then
    echo "Installing PostgreSQL..."
    brew install postgresql
fi

# start PostgreSQL services
echo "Ensuring PostgreSQL services are running..."
brew services start postgresql

echo "Finished installing necessary packages at $(date)"
